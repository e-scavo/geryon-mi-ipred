import 'dart:convert';
import 'dart:io';

const String _appName = 'Mi IP·RED';
const String _artifactSlug = 'mi-ipred';
const String _defaultDistRoot = 'dist';
const String _defaultSubmissionRoot = 'distribution/submissions';

Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    return;
  }

  final distRoot = _readOption(args, '--dist-root') ?? _defaultDistRoot;
  final submissionRoot =
      _readOption(args, '--submission-root') ?? _defaultSubmissionRoot;
  final cleanRequested = args.contains('--clean');
  final version = await _readVersion();

  final result = await _prepareSubmissionBundle(
    version: version,
    distRoot: distRoot,
    submissionRoot: submissionRoot,
    cleanRequested: cleanRequested,
  );

  stdout
      .writeln('📦 Submission bundle preparado en: ${result.bundleRoot.path}');
  stdout.writeln('📄 Manifest: ${result.bundleManifest.path}');
  stdout.writeln('📝 Resumen: ${result.summaryFile.path}');
  stdout.writeln('✅ Submission bundle listo para ${version.asPubspecVersion}');
}

void _printHelp() {
  stdout.writeln("""
Uso:
  dart run prepare_submission_bundle.dart [opciones]

Opciones:
  --dist-root=RUTA           Raíz de dist validada (por defecto: dist)
  --submission-root=RUTA     Carpeta raíz para bundles de entrega (por defecto: distribution/submissions)
  --clean                    Limpia el bundle de la versión actual antes de recrearlo
  --help, -h                 Muestra esta ayuda
""");
}

String? _readOption(List<String> args, String option) {
  for (final arg in args) {
    if (arg.startsWith('$option=')) {
      return arg.substring(option.length + 1).trim();
    }
  }
  return null;
}

Future<SubmissionBundleResult> _prepareSubmissionBundle({
  required VersionInfo version,
  required String distRoot,
  required String submissionRoot,
  required bool cleanRequested,
}) async {
  final versionSuffix = version.asPubspecVersion;
  final distDirectory = Directory(distRoot);
  if (!await distDirectory.exists()) {
    stderr.writeln(
      '❌ No existe la raíz dist configurada. Ejecutá build_and_commit.dart y validate_release.dart primero.',
    );
    exit(1);
  }

  final releaseManifest =
      File(_joinPath(distRoot, 'release_manifest_$versionSuffix.json'));
  final releaseValidation =
      File(_joinPath(distRoot, 'release_validation_$versionSuffix.json'));

  if (!await releaseManifest.exists() || !await releaseValidation.exists()) {
    stderr.writeln(
      '❌ Faltan manifest o validation report de la versión actual en $distRoot.',
    );
    exit(1);
  }

  final keyPropertiesFile = File(_joinPath('android', 'key.properties'));
  final keystoreProperties = await _readPropertiesFile(keyPropertiesFile);
  final storeFileValue = keystoreProperties['storeFile']?.trim() ?? '';
  if (storeFileValue.isEmpty) {
    stderr.writeln('❌ android/key.properties no define storeFile.');
    exit(1);
  }

  final keystoreCandidates = _resolveKeystoreCandidates(
    keyPropertiesFile: keyPropertiesFile,
    storeFileValue: storeFileValue,
  );

  String? resolvedStoreFile;
  for (final candidate in keystoreCandidates) {
    if (await File(candidate).exists()) {
      resolvedStoreFile = candidate;
      break;
    }
  }

  if (resolvedStoreFile == null) {
    stderr.writeln(
      '❌ El keystore referenciado por android/key.properties no existe en ninguna resolución válida: $storeFileValue',
    );
    for (final candidate in keystoreCandidates) {
      stderr.writeln('   - $candidate');
    }
    exit(1);
  }

  final metadataFiles = <String>[
    _joinPath('distribution', 'play_store', 'release_checklist.md'),
    _joinPath('distribution', 'play_store', 'asset_requirements.md'),
    _joinPath(
      'distribution',
      'play_store',
      'metadata',
      'es-AR',
      'short_description.txt',
    ),
    _joinPath(
      'distribution',
      'play_store',
      'metadata',
      'es-AR',
      'full_description.txt',
    ),
    _joinPath(
      'distribution',
      'play_store',
      'metadata',
      'es-AR',
      'release_notes.txt',
    ),
  ];

  for (final metadataFile in metadataFiles) {
    if (!await File(metadataFile).exists()) {
      stderr.writeln(
        '❌ Falta archivo requerido para submission bundle: $metadataFile',
      );
      exit(1);
    }
  }

  final manifestPayload =
      jsonDecode(await releaseManifest.readAsString()) as Map<String, dynamic>;
  final artifacts = (manifestPayload['artifacts'] as List<dynamic>? ?? const [])
      .whereType<Map>()
      .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
      .toList();

  if (artifacts.isEmpty) {
    stderr.writeln(
      '❌ El release manifest no contiene artefactos para empaquetar.',
    );
    exit(1);
  }

  final bundleRoot =
      Directory(_joinPath(submissionRoot, version.asPubspecVersion));
  if (cleanRequested && await bundleRoot.exists()) {
    await bundleRoot.delete(recursive: true);
  }
  await bundleRoot.create(recursive: true);

  final copiedArtifacts = <Map<String, Object?>>[];

  for (final artifact in artifacts) {
    final target = artifact['target']?.toString() ?? 'unknown';
    final type = artifact['type']?.toString() ?? 'file';
    final sourcePath = artifact['path']?.toString() ?? '';
    if (sourcePath.isEmpty) continue;

    if (type == 'directory') {
      final destinationDir = Directory(
        _joinPath(bundleRoot.path, 'artifacts', target, _basename(sourcePath)),
      );
      await _copyDirectory(
        Directory(sourcePath),
        destinationDir,
        deleteDestinationFirst: true,
      );
      copiedArtifacts.add({
        'target': target,
        'type': 'directory',
        'sourcePath': sourcePath,
        'bundlePath': destinationDir.path,
      });
    } else {
      final destinationFile = File(
        _joinPath(bundleRoot.path, 'artifacts', target, _basename(sourcePath)),
      );
      await destinationFile.parent.create(recursive: true);
      await File(sourcePath).copy(destinationFile.path);
      copiedArtifacts.add({
        'target': target,
        'type': 'file',
        'sourcePath': sourcePath,
        'bundlePath': destinationFile.path,
        'sizeBytes': await destinationFile.length(),
      });
    }
  }

  final reportsDir = Directory(_joinPath(bundleRoot.path, 'reports'));
  await reportsDir.create(recursive: true);
  final bundleReleaseManifest =
      File(_joinPath(reportsDir.path, _basename(releaseManifest.path)));
  final bundleValidationReport =
      File(_joinPath(reportsDir.path, _basename(releaseValidation.path)));
  await releaseManifest.copy(bundleReleaseManifest.path);
  await releaseValidation.copy(bundleValidationReport.path);

  final metadataRoot = Directory(_joinPath(bundleRoot.path, 'play_store'));
  await metadataRoot.create(recursive: true);
  for (final metadataFile in metadataFiles) {
    final source = File(metadataFile);
    final relative = metadataFile.replaceFirst(
      'distribution${Platform.pathSeparator}play_store${Platform.pathSeparator}',
      '',
    );
    final destination = File(_joinPath(metadataRoot.path, relative));
    await destination.parent.create(recursive: true);
    await source.copy(destination.path);
  }

  final summaryFile = File(_joinPath(bundleRoot.path, 'submission_summary.md'));
  await summaryFile.writeAsString(
    _buildSummaryMarkdown(
      version: version,
      distRoot: distRoot,
      bundleRoot: bundleRoot.path,
      copiedArtifacts: copiedArtifacts,
      storeFile: resolvedStoreFile,
    ),
  );

  final bundlePayload = {
    'appName': _appName,
    'artifactSlug': _artifactSlug,
    'generatedAt': DateTime.now().toIso8601String(),
    'version': version.toJson(),
    'distRoot': distRoot,
    'bundleRoot': bundleRoot.path,
    'keystoreReferenced': resolvedStoreFile,
    'copiedArtifacts': copiedArtifacts,
    'reports': {
      'releaseManifest': bundleReleaseManifest.path,
      'releaseValidation': bundleValidationReport.path,
    },
    'playStoreRoot': metadataRoot.path,
  };

  final bundleManifest =
      File(_joinPath(bundleRoot.path, 'submission_bundle_$versionSuffix.json'));
  await bundleManifest.writeAsString(
    const JsonEncoder.withIndent('  ').convert(bundlePayload),
  );

  final latestBundleManifest =
      File(_joinPath(submissionRoot, 'submission_bundle_latest.json'));
  await latestBundleManifest.parent.create(recursive: true);
  await latestBundleManifest.writeAsString(
    const JsonEncoder.withIndent('  ').convert(bundlePayload),
  );

  return SubmissionBundleResult(
    bundleRoot: bundleRoot,
    bundleManifest: bundleManifest,
    summaryFile: summaryFile,
  );
}

String _buildSummaryMarkdown({
  required VersionInfo version,
  required String distRoot,
  required String bundleRoot,
  required List<Map<String, Object?>> copiedArtifacts,
  required String storeFile,
}) {
  final buffer = StringBuffer();
  buffer.writeln('# Submission Summary — Mi IP·RED');
  buffer.writeln();
  buffer.writeln('- Version: `${version.asPubspecVersion}`');
  buffer.writeln('- Code name: `${version.codeName}`');
  buffer.writeln('- Dist root source: `$distRoot`');
  buffer.writeln('- Bundle root: `$bundleRoot`');
  buffer.writeln('- Keystore referenced locally: `$storeFile`');
  buffer.writeln();
  buffer.writeln('## Included artifacts');
  for (final artifact in copiedArtifacts) {
    buffer.writeln('- `${artifact['target']}` → `${artifact['bundlePath']}`');
  }
  buffer.writeln();
  buffer.writeln('## Included reports');
  buffer.writeln(
    '- `reports/release_manifest_${version.asPubspecVersion}.json`',
  );
  buffer.writeln(
    '- `reports/release_validation_${version.asPubspecVersion}.json`',
  );
  buffer.writeln();
  buffer.writeln('## Included Play Store metadata');
  buffer.writeln('- `play_store/release_checklist.md`');
  buffer.writeln('- `play_store/asset_requirements.md`');
  buffer.writeln('- `play_store/metadata/es-AR/short_description.txt`');
  buffer.writeln('- `play_store/metadata/es-AR/full_description.txt`');
  buffer.writeln('- `play_store/metadata/es-AR/release_notes.txt`');
  buffer.writeln();
  buffer.writeln('## Final operator sequence');
  buffer.writeln(
    '1. Confirm `reports/release_validation_${version.asPubspecVersion}.json` is green.',
  );
  buffer.writeln(
    '2. Use the AAB inside `artifacts/aab/` for Play Console upload.',
  );
  buffer.writeln(
    '3. Use `play_store/metadata/es-AR/*` as the source for listing text.',
  );
  buffer.writeln(
    '4. Complete screenshots and feature graphic according to `play_store/asset_requirements.md`.',
  );
  buffer.writeln(
    '5. Preserve the generated bundle as the immutable handoff for this version.',
  );
  return buffer.toString();
}

Future<Map<String, String>> _readPropertiesFile(File file) async {
  if (!await file.exists()) {
    stderr.writeln('❌ Falta ${file.path}.');
    exit(1);
  }

  final lines = await file.readAsLines();
  final values = <String, String>{};
  for (final raw in lines) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#') || !line.contains('=')) {
      continue;
    }
    final index = line.indexOf('=');
    values[line.substring(0, index).trim()] = line.substring(index + 1).trim();
  }
  return values;
}

String _resolveRelativeTo(File referenceFile, String candidatePath) {
  final file = File(candidatePath);
  if (file.isAbsolute) {
    return file.path;
  }
  return referenceFile.parent.uri.resolve(candidatePath).toFilePath();
}

List<String> _resolveKeystoreCandidates({
  required File keyPropertiesFile,
  required String storeFileValue,
}) {
  final directFile = File(storeFileValue);
  if (directFile.isAbsolute) {
    return [directFile.path];
  }

  final candidates = <String>{
    _normalizePath(_resolveRelativeTo(keyPropertiesFile, storeFileValue)),
    _normalizePath(
      _resolveRelativeTo(
        File(_joinPath('android', 'app', 'build.gradle.kts')),
        storeFileValue,
      ),
    ),
    _normalizePath(File(storeFileValue).absolute.path),
  };

  return candidates.toList();
}

String _normalizePath(String path) {
  return File(path).absolute.path;
}

Future<void> _copyDirectory(
  Directory source,
  Directory destination, {
  bool deleteDestinationFirst = false,
}) async {
  if (!await source.exists()) {
    stderr.writeln(
      '❌ No existe el directorio origen requerido: ${source.path}',
    );
    exit(1);
  }

  if (deleteDestinationFirst && await destination.exists()) {
    await destination.delete(recursive: true);
  }

  await destination.create(recursive: true);

  await for (final entity in source.list(recursive: false)) {
    final newPath = _joinPath(destination.path, _basename(entity.path));
    if (entity is Directory) {
      await _copyDirectory(entity, Directory(newPath));
    } else if (entity is File) {
      await File(newPath).create(recursive: true);
      await entity.copy(newPath);
    }
  }
}

String _joinPath(
  String part1, [
  String? part2,
  String? part3,
  String? part4,
  String? part5,
  String? part6,
]) {
  final parts = [part1, part2, part3, part4, part5, part6]
      .whereType<String>()
      .where((part) => part.isNotEmpty)
      .toList();
  return parts.join(Platform.pathSeparator);
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final parts = normalized.split('/');
  return parts.isEmpty ? path : parts.last;
}

Future<VersionInfo> _readVersion() async {
  final versionFile = File('lib/config/version.dart');
  final pubspecFile = File('pubspec.yaml');

  if (!await versionFile.exists() || !await pubspecFile.exists()) {
    stderr
        .writeln('❌ No se encontraron los archivos de versionado requeridos.');
    exit(1);
  }

  final versionContent = await versionFile.readAsString();
  final pubspecContent = await pubspecFile.readAsString();

  final major =
      _readRequiredInt(versionContent, r'const\s+int\s+vMajor\s*=\s*(\d+);');
  final minor =
      _readRequiredInt(versionContent, r'const\s+int\s+vMinor\s*=\s*(\d+);');
  final patch =
      _readRequiredInt(versionContent, r'const\s+int\s+vPatch\s*=\s*(\d+);');
  final build =
      _readRequiredInt(versionContent, r'const\s+int\s+vBuild\s*=\s*(\d+);');
  final codeName = _readRequiredString(
    versionContent,
    r'const\s+String\s+vCodeName\s*=\s*"([^"]+)";',
  );

  final pubspecMatch = RegExp(
    r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$',
    multiLine: true,
  ).firstMatch(pubspecContent);

  if (pubspecMatch == null) {
    stderr.writeln('❌ No se pudo leer version: desde pubspec.yaml');
    exit(1);
  }

  final pubspecVersion =
      '${pubspecMatch.group(1)}.${pubspecMatch.group(2)}.${pubspecMatch.group(3)}+${pubspecMatch.group(4)}';
  final codeVersion = '$major.$minor.$patch+$build';

  if (pubspecVersion != codeVersion) {
    stderr.writeln(
      '❌ pubspec.yaml y lib/config/version.dart no están sincronizados. '
      'pubspec=$pubspecVersion version.dart=$codeVersion',
    );
    exit(1);
  }

  return VersionInfo(
    major: major,
    minor: minor,
    patch: patch,
    build: build,
    codeName: codeName,
  );
}

int _readRequiredInt(String content, String pattern) {
  final match = RegExp(pattern).firstMatch(content);
  if (match == null) {
    stderr.writeln('❌ No se pudo leer patrón requerido: $pattern');
    exit(1);
  }
  return int.parse(match.group(1)!);
}

String _readRequiredString(String content, String pattern) {
  final match = RegExp(pattern).firstMatch(content);
  if (match == null) {
    stderr.writeln('❌ No se pudo leer patrón requerido: $pattern');
    exit(1);
  }
  return match.group(1)!;
}

class SubmissionBundleResult {
  final Directory bundleRoot;
  final File bundleManifest;
  final File summaryFile;

  const SubmissionBundleResult({
    required this.bundleRoot,
    required this.bundleManifest,
    required this.summaryFile,
  });
}

class VersionInfo {
  final int major;
  final int minor;
  final int patch;
  final int build;
  final String codeName;

  const VersionInfo({
    required this.major,
    required this.minor,
    required this.patch,
    required this.build,
    required this.codeName,
  });

  String get core => '$major.$minor.$patch';

  String get asPubspecVersion => '$core+$build';

  Map<String, Object?> toJson() => {
        'major': major,
        'minor': minor,
        'patch': patch,
        'build': build,
        'core': core,
        'pubspec': asPubspecVersion,
        'codeName': codeName,
      };
}
