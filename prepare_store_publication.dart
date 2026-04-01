import 'dart:convert';
import 'dart:io';

const String _appName = 'Mi IP·RED';
const String _artifactSlug = 'mi-ipred';
const String _defaultSubmissionRoot = 'distribution/submissions';
const String _defaultPlayStoreRoot = 'distribution/play_store';

Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    return;
  }

  final submissionRoot =
      _readOption(args, '--submission-root') ?? _defaultSubmissionRoot;
  final playStoreRoot =
      _readOption(args, '--play-store-root') ?? _defaultPlayStoreRoot;
  final releaseTrack = _normalizeTrack(
    _readOption(args, '--release-track') ?? 'internal',
  );
  final cleanRequested = args.contains('--clean');
  final version = await _readVersion();

  final result = await _prepareStorePublicationSurface(
    version: version,
    submissionRoot: submissionRoot,
    playStoreRoot: playStoreRoot,
    releaseTrack: releaseTrack,
    cleanRequested: cleanRequested,
  );

  stdout.writeln(
    '🖼️ Surface de publicación preparado en: ${result.publicationRoot.path}',
  );
  stdout.writeln('📄 Manifest: ${result.manifestFile.path}');
  stdout.writeln('📝 Resumen: ${result.summaryFile.path}');
  stdout.writeln(
      '✅ Surface listo para ${version.asPubspecVersion} [$releaseTrack]');
}

void _printHelp() {
  stdout.writeln('''
Uso:
  dart run prepare_store_publication.dart [opciones]

Opciones:
  --submission-root=RUTA    Carpeta raíz de submission bundles (por defecto: distribution/submissions)
  --play-store-root=RUTA    Carpeta raíz Play Store (por defecto: distribution/play_store)
  --release-track=TRACK     Track operativo inicial: internal | closed | production (por defecto: internal)
  --clean                   Limpia el surface de la versión actual antes de recrearlo
  --help, -h                Muestra esta ayuda
''');
}

String? _readOption(List<String> args, String option) {
  for (final arg in args) {
    if (arg.startsWith('$option=')) {
      return arg.substring(option.length + 1).trim();
    }
  }
  return null;
}

String _normalizeTrack(String value) {
  final normalized = value.trim().toLowerCase();
  switch (normalized) {
    case 'internal':
    case 'closed':
    case 'production':
      return normalized;
    default:
      stderr.writeln(
        '❌ Track inválido: $value. Usá internal, closed o production.',
      );
      exit(1);
  }
}

Future<PublicationSurfaceResult> _prepareStorePublicationSurface({
  required VersionInfo version,
  required String submissionRoot,
  required String playStoreRoot,
  required String releaseTrack,
  required bool cleanRequested,
}) async {
  final versionSuffix = version.asPubspecVersion;
  final submissionBundleRoot =
      Directory(_joinPath(submissionRoot, versionSuffix));
  if (!await submissionBundleRoot.exists()) {
    stderr.writeln(
      '❌ No existe el submission bundle de la versión actual. Ejecutá prepare_submission_bundle.dart primero.',
    );
    exit(1);
  }

  final submissionManifest = File(
    _joinPath(
        submissionBundleRoot.path, 'submission_bundle_$versionSuffix.json'),
  );
  final submissionSummary =
      File(_joinPath(submissionBundleRoot.path, 'submission_summary.md'));

  for (final requiredFile in [submissionManifest, submissionSummary]) {
    if (!await requiredFile.exists()) {
      stderr.writeln(
        '❌ Falta archivo requerido del submission bundle: ${requiredFile.path}',
      );
      exit(1);
    }
  }

  final policyFiles = [
    File('privacy_policy.html'),
    File('privacy_policy.md'),
  ];
  for (final file in policyFiles) {
    if (!await file.exists()) {
      stderr.writeln('❌ Falta política de privacidad requerida: ${file.path}');
      exit(1);
    }
  }

  final requiredPlayStoreFiles = [
    File(_joinPath(playStoreRoot, 'release_checklist.md')),
    File(_joinPath(playStoreRoot, 'asset_requirements.md')),
    File(
        _joinPath(playStoreRoot, 'metadata', 'es-AR', 'short_description.txt')),
    File(_joinPath(playStoreRoot, 'metadata', 'es-AR', 'full_description.txt')),
    File(_joinPath(playStoreRoot, 'metadata', 'es-AR', 'release_notes.txt')),
  ];
  for (final file in requiredPlayStoreFiles) {
    if (!await file.exists()) {
      stderr.writeln('❌ Falta archivo Play Store requerido: ${file.path}');
      exit(1);
    }
  }

  final publicationRoot =
      Directory(_joinPath(playStoreRoot, 'releases', versionSuffix));
  if (cleanRequested && await publicationRoot.exists()) {
    await publicationRoot.delete(recursive: true);
  }
  await publicationRoot.create(recursive: true);

  final copiedFiles = <Map<String, Object?>>[];

  Future<void> copyFileIntoSurface({
    required File source,
    required String relativeDestination,
  }) async {
    final destination =
        File(_joinPath(publicationRoot.path, relativeDestination));
    await destination.parent.create(recursive: true);
    await source.copy(destination.path);
    copiedFiles.add({
      'sourcePath': source.path,
      'publicationPath': destination.path,
      'sizeBytes': await destination.length(),
    });
  }

  await copyFileIntoSurface(
    source: submissionManifest,
    relativeDestination: _joinPath(
      'submission',
      _basename(submissionManifest.path),
    ),
  );
  await copyFileIntoSurface(
    source: submissionSummary,
    relativeDestination: _joinPath('submission', 'submission_summary.md'),
  );
  await copyFileIntoSurface(
    source: File(_joinPath(playStoreRoot, 'release_checklist.md')),
    relativeDestination: _joinPath('play_store', 'release_checklist.md'),
  );
  await copyFileIntoSurface(
    source: File(_joinPath(playStoreRoot, 'asset_requirements.md')),
    relativeDestination: _joinPath('play_store', 'asset_requirements.md'),
  );
  await copyFileIntoSurface(
    source: File(
      _joinPath(playStoreRoot, 'metadata', 'es-AR', 'short_description.txt'),
    ),
    relativeDestination: _joinPath(
      'play_store',
      'metadata',
      'es-AR',
      'short_description.txt',
    ),
  );
  await copyFileIntoSurface(
    source: File(
      _joinPath(playStoreRoot, 'metadata', 'es-AR', 'full_description.txt'),
    ),
    relativeDestination: _joinPath(
      'play_store',
      'metadata',
      'es-AR',
      'full_description.txt',
    ),
  );
  await copyFileIntoSurface(
    source: File(
      _joinPath(playStoreRoot, 'metadata', 'es-AR', 'release_notes.txt'),
    ),
    relativeDestination: _joinPath(
      'play_store',
      'metadata',
      'es-AR',
      'release_notes.txt',
    ),
  );
  await copyFileIntoSurface(
    source: File('privacy_policy.html'),
    relativeDestination: _joinPath('policy', 'privacy_policy.html'),
  );
  await copyFileIntoSurface(
    source: File('privacy_policy.md'),
    relativeDestination: _joinPath('policy', 'privacy_policy.md'),
  );

  final assetDirectories = {
    _joinPath('android', 'phone_screenshots'): _buildAssetGuide(
      title: 'Phone Screenshots',
      version: versionSuffix,
      purpose: 'Capturas principales del teléfono para Play Console.',
      recommendedAssets: const [
        'login.png',
        'dashboard.png',
        'facturasvt.png',
        'recibosvt.png',
        'debitos_creditos.png',
      ],
    ),
    _joinPath('android', 'seven_inch_screenshots'): _buildAssetGuide(
      title: '7-inch Screenshots',
      version: versionSuffix,
      purpose: 'Capturas opcionales o requeridas para tablets de 7 pulgadas.',
      recommendedAssets: const [
        'dashboard_7in.png',
        'facturasvt_7in.png',
      ],
    ),
    _joinPath('android', 'ten_inch_screenshots'): _buildAssetGuide(
      title: '10-inch Screenshots',
      version: versionSuffix,
      purpose: 'Capturas opcionales o requeridas para tablets de 10 pulgadas.',
      recommendedAssets: const [
        'dashboard_10in.png',
        'facturasvt_10in.png',
      ],
    ),
    _joinPath('android', 'feature_graphic'): _buildAssetGuide(
      title: 'Feature Graphic',
      version: versionSuffix,
      purpose: 'Graphic principal de la ficha de Play Console.',
      recommendedAssets: const ['feature_graphic.png'],
    ),
  };

  for (final entry in assetDirectories.entries) {
    final readmeFile =
        File(_joinPath(publicationRoot.path, entry.key, 'README.md'));
    await readmeFile.parent.create(recursive: true);
    await readmeFile.writeAsString(entry.value);
  }

  for (final track in const ['internal', 'closed', 'production']) {
    final rolloutNotesFile = File(
      _joinPath(publicationRoot.path, 'rollout', track, 'rollout_notes.md'),
    );
    await rolloutNotesFile.parent.create(recursive: true);
    await rolloutNotesFile.writeAsString(
      _buildRolloutNotes(
        version: versionSuffix,
        track: track,
        isSuggestedTrack: track == releaseTrack,
      ),
    );
  }

  final summaryFile =
      File(_joinPath(publicationRoot.path, 'publication_summary.md'));
  await summaryFile.writeAsString(
    _buildPublicationSummary(
      version: version,
      publicationRoot: publicationRoot.path,
      submissionBundleRoot: submissionBundleRoot.path,
      releaseTrack: releaseTrack,
      copiedFiles: copiedFiles,
    ),
  );

  final manifestFile = File(
    _joinPath(publicationRoot.path, 'publication_surface_$versionSuffix.json'),
  );
  final payload = {
    'appName': _appName,
    'artifactSlug': _artifactSlug,
    'generatedAt': DateTime.now().toIso8601String(),
    'version': version.toJson(),
    'releaseTrack': releaseTrack,
    'publicationRoot': publicationRoot.path,
    'submissionBundleRoot': submissionBundleRoot.path,
    'copiedFiles': copiedFiles,
    'assetDirectories': assetDirectories.keys.toList(),
    'rolloutTracks': const ['internal', 'closed', 'production'],
    'policyRoot': _joinPath(publicationRoot.path, 'policy'),
  };
  await manifestFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(payload),
  );

  return PublicationSurfaceResult(
    publicationRoot: publicationRoot,
    manifestFile: manifestFile,
    summaryFile: summaryFile,
  );
}

String _buildAssetGuide({
  required String title,
  required String version,
  required String purpose,
  required List<String> recommendedAssets,
}) {
  final buffer = StringBuffer()
    ..writeln('# $title — Mi IP·RED')
    ..writeln()
    ..writeln('Versión objetivo: `$version`')
    ..writeln()
    ..writeln(purpose)
    ..writeln()
    ..writeln('## Archivos sugeridos');

  for (final asset in recommendedAssets) {
    buffer.writeln('- `$asset`');
  }

  buffer
    ..writeln()
    ..writeln('## Reglas')
    ..writeln(
      '- Mantener coherencia visual con el AAB validado para esta misma versión.',
    )
    ..writeln(
      '- No mezclar assets de otra versión dentro de este directorio.',
    )
    ..writeln(
      '- Si los binarios son pesados, conservar la fuente maestra fuera de Git y copiar aquí solo lo necesario para el handoff operativo.',
    );

  return buffer.toString();
}

String _buildRolloutNotes({
  required String version,
  required String track,
  required bool isSuggestedTrack,
}) {
  final trackLabel = track.toUpperCase();
  return '''# Rollout Notes — $trackLabel

Versión objetivo: `$version`

Track sugerido al generar el surface: `${isSuggestedTrack ? 'sí' : 'no'}`

## Validaciones recomendadas
- Confirmar que el AAB cargado corresponde al submission bundle de esta misma versión.
- Confirmar que screenshots, feature graphic y metadata corresponden a esta misma versión.
- Registrar aquí notas de revisión, observaciones del upload y estado del rollout.
''';
}

String _buildPublicationSummary({
  required VersionInfo version,
  required String publicationRoot,
  required String submissionBundleRoot,
  required String releaseTrack,
  required List<Map<String, Object?>> copiedFiles,
}) {
  final buffer = StringBuffer()
    ..writeln('# Publication Summary — Mi IP·RED')
    ..writeln()
    ..writeln('- Versión: `${version.asPubspecVersion}`')
    ..writeln('- Track inicial sugerido: `$releaseTrack`')
    ..writeln('- Submission bundle fuente: `$submissionBundleRoot`')
    ..writeln('- Surface de publicación: `$publicationRoot`')
    ..writeln()
    ..writeln('## Archivos copiados');

  for (final file in copiedFiles) {
    buffer.writeln('- `${file['publicationPath']}`');
  }

  buffer
    ..writeln()
    ..writeln('## Directorios operativos generados')
    ..writeln('- `android/phone_screenshots/`')
    ..writeln('- `android/seven_inch_screenshots/`')
    ..writeln('- `android/ten_inch_screenshots/`')
    ..writeln('- `android/feature_graphic/`')
    ..writeln('- `rollout/internal/`')
    ..writeln('- `rollout/closed/`')
    ..writeln('- `rollout/production/`');

  return buffer.toString();
}

String _joinPath(
  String part1, [
  String? part2,
  String? part3,
  String? part4,
]) {
  final parts = [part1, part2, part3, part4]
      .whereType<String>()
      .where((part) => part.isNotEmpty)
      .toList();
  return parts.join(Platform.pathSeparator);
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final index = normalized.lastIndexOf('/');
  return index == -1 ? normalized : normalized.substring(index + 1);
}

Future<VersionInfo> _readVersion() async {
  final pubspec = File('pubspec.yaml');
  if (!await pubspec.exists()) {
    stderr.writeln('❌ No se encontró pubspec.yaml');
    exit(1);
  }

  final lines = await pubspec.readAsLines();
  for (final rawLine in lines) {
    final line = rawLine.trim();
    if (!line.startsWith('version:')) continue;
    final value = line.substring('version:'.length).trim();
    return VersionInfo.parse(value);
  }

  stderr.writeln('❌ No se encontró la versión en pubspec.yaml');
  exit(1);
}

class PublicationSurfaceResult {
  PublicationSurfaceResult({
    required this.publicationRoot,
    required this.manifestFile,
    required this.summaryFile,
  });

  final Directory publicationRoot;
  final File manifestFile;
  final File summaryFile;
}

class VersionInfo {
  VersionInfo({
    required this.major,
    required this.minor,
    required this.patch,
    required this.build,
    required this.codeName,
  });

  factory VersionInfo.parse(String value) {
    final normalized = value.trim();
    final versionAndBuild = normalized.split('+');
    if (versionAndBuild.length != 2) {
      stderr.writeln('❌ Versión inválida en pubspec.yaml: $value');
      exit(1);
    }

    final versionParts = versionAndBuild.first.split('.');
    if (versionParts.length != 3) {
      stderr.writeln('❌ Versión semántica inválida en pubspec.yaml: $value');
      exit(1);
    }

    return VersionInfo(
      major: int.parse(versionParts[0]),
      minor: int.parse(versionParts[1]),
      patch: int.parse(versionParts[2]),
      build: int.parse(versionAndBuild[1]),
      codeName: _readCodeNameSync() ?? 'sin-codename',
    );
  }

  final int major;
  final int minor;
  final int patch;
  final int build;
  final String codeName;

  String get core => '$major.$minor.$patch';
  String get asPubspecVersion => '$core+$build';

  Map<String, Object?> toJson() {
    return {
      'major': major,
      'minor': minor,
      'patch': patch,
      'build': build,
      'codeName': codeName,
      'core': core,
      'pubspec': asPubspecVersion,
    };
  }
}

String? _readCodeNameSync() {
  final versionFile = File(_joinPath('lib', 'config', 'version.dart'));
  if (!versionFile.existsSync()) {
    return null;
  }

  final content = versionFile.readAsStringSync();
  final match = RegExp(
    r'const String vCodeName = "([^"]+)";',
  ).firstMatch(content);
  return match?.group(1);
}
