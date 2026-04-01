import 'dart:convert';
import 'dart:io';

const String _appName = 'Mi IP·RED';
const String _defaultDistRoot = 'dist';
const String _defaultSubmissionRoot = 'distribution/submissions';
const String _defaultPlayStoreRoot = 'distribution/play_store';

Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    return;
  }

  final distRoot = _readOption(args, '--dist-root') ?? _defaultDistRoot;
  final submissionRoot =
      _readOption(args, '--submission-root') ?? _defaultSubmissionRoot;
  final playStoreRoot =
      _readOption(args, '--play-store-root') ?? _defaultPlayStoreRoot;
  final requestedVersion = _readOption(args, '--version');
  final allowWarningStatus = args.contains('--allow-warning-status');
  final writeReport = !args.contains('--no-write-report');
  final version = await _readVersion();

  if (requestedVersion != null &&
      requestedVersion != version.asPubspecVersion) {
    stderr.writeln(
      '❌ La versión solicitada ($requestedVersion) no coincide con la versión activa (${version.asPubspecVersion}).',
    );
    exit(1);
  }

  final result = await _evaluatePublicationReadiness(
    version: version,
    distRoot: distRoot,
    submissionRoot: submissionRoot,
    playStoreRoot: playStoreRoot,
    allowWarningStatus: allowWarningStatus,
    writeReport: writeReport,
  );

  for (final component in result.components) {
    final icon = component.status == 'fail'
        ? '❌'
        : (component.status == 'warning' ? '⚠️' : '✅');
    stdout
        .writeln('$icon ${component.label}: ${component.status.toUpperCase()}');
  }

  final statusLabel = result.status.toUpperCase();
  final icon =
      result.status == 'fail' ? '❌' : (result.status == 'warning' ? '⚠️' : '✅');
  final sink = result.status == 'fail' ? stderr : stdout;
  sink.writeln(
    '$icon Publication readiness $statusLabel para ${version.asPubspecVersion}',
  );
  sink.writeln('📁 Surface: ${result.publicationRoot.path}');
  if (writeReport) {
    sink.writeln('📄 Manifest: ${result.manifestFile.path}');
    sink.writeln('📝 Resumen: ${result.summaryFile.path}');
  }

  if (result.status == 'fail') {
    exit(1);
  }
}

void _printHelp() {
  stdout.writeln('''
Uso:
  dart run evaluate_publication_readiness.dart [opciones]

Opciones:
  --version=VERSION            Fuerza la evaluación de una versión específica (debe coincidir con la activa)
  --dist-root=RUTA             Carpeta raíz de artifacts/reports (por defecto: dist)
  --submission-root=RUTA       Carpeta raíz de submission bundles (por defecto: distribution/submissions)
  --play-store-root=RUTA       Carpeta raíz Play Store (por defecto: distribution/play_store)
  --allow-warning-status       Hace explícito que WARNING sigue siendo aceptable para handoff controlado
  --no-write-report            Ejecuta la evaluación sin escribir reportes
  --help, -h                   Muestra esta ayuda
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

Future<PublicationReadinessResult> _evaluatePublicationReadiness({
  required VersionInfo version,
  required String distRoot,
  required String submissionRoot,
  required String playStoreRoot,
  required bool allowWarningStatus,
  required bool writeReport,
}) async {
  final versionSuffix = version.asPubspecVersion;
  final publicationRoot = Directory(
    _joinPath(playStoreRoot, 'releases', versionSuffix),
  );
  if (!await publicationRoot.exists()) {
    stderr.writeln(
      '❌ No existe el surface versionado actual. Ejecutá prepare_store_publication.dart primero.',
    );
    exit(1);
  }

  final releaseValidationPrimary = File(
    _joinPath(distRoot, 'release_validation_$versionSuffix.json'),
  );
  final releaseValidationFallback = File(
    _joinPath(
      submissionRoot,
      versionSuffix,
      'reports',
      'release_validation_$versionSuffix.json',
    ),
  );
  final releaseValidationFile = await releaseValidationPrimary.exists()
      ? releaseValidationPrimary
      : releaseValidationFallback;
  final releaseValidationPresent = await releaseValidationFile.exists();
  final releaseValidationJson = releaseValidationPresent
      ? await _readJsonObject(releaseValidationFile)
      : <String, Object?>{};
  final releaseValidationStatus = releaseValidationPresent
      ? _deriveReleaseValidationStatus(releaseValidationJson)
      : 'fail';

  final submissionBundleManifest = File(
    _joinPath(
      submissionRoot,
      versionSuffix,
      'submission_bundle_$versionSuffix.json',
    ),
  );
  final submissionSummary = File(
    _joinPath(submissionRoot, versionSuffix, 'submission_summary.md'),
  );
  final submissionStatus = await submissionBundleManifest.exists() &&
          await submissionSummary.exists()
      ? 'pass'
      : 'fail';

  final publicationSurfaceManifest = File(
    _joinPath(
      publicationRoot.path,
      'publication_surface_$versionSuffix.json',
    ),
  );
  final publicationSummary =
      File(_joinPath(publicationRoot.path, 'publication_summary.md'));
  final publicationSurfaceStatus = await publicationSurfaceManifest.exists() &&
          await publicationSummary.exists()
      ? 'pass'
      : 'fail';

  final assetReadinessManifest = File(
    _joinPath(
      publicationRoot.path,
      'asset_readiness_manifest_$versionSuffix.json',
    ),
  );
  final assetReadinessSummary =
      File(_joinPath(publicationRoot.path, 'asset_readiness_summary.md'));
  final assetReadinessPresent = await assetReadinessManifest.exists() &&
      await assetReadinessSummary.exists();
  final assetReadinessJson = assetReadinessPresent
      ? await _readJsonObject(assetReadinessManifest)
      : <String, Object?>{};
  final assetReadinessStatus = assetReadinessPresent
      ? _readString(assetReadinessJson, 'status', fallback: 'fail')
      : 'fail';

  final tracksRoot = Directory(_joinPath(publicationRoot.path, 'rollout'));
  final evidenceRoot = Directory(_joinPath(publicationRoot.path, 'evidence'));
  final tracksPresent = await tracksRoot.exists();
  final evidencePresent = await evidenceRoot.exists();
  final structureStatus = tracksPresent && evidencePresent ? 'pass' : 'fail';

  final components = <ReadinessComponent>[
    ReadinessComponent(
      key: 'releaseValidation',
      label: 'Release validation',
      status: releaseValidationStatus,
      present: releaseValidationPresent,
      path: releaseValidationFile.path,
    ),
    ReadinessComponent(
      key: 'submissionBundle',
      label: 'Submission bundle',
      status: submissionStatus,
      present: submissionStatus != 'fail',
      path: submissionBundleManifest.path,
    ),
    ReadinessComponent(
      key: 'publicationSurface',
      label: 'Publication surface',
      status: publicationSurfaceStatus,
      present: publicationSurfaceStatus != 'fail',
      path: publicationSurfaceManifest.path,
    ),
    ReadinessComponent(
      key: 'assetReadiness',
      label: 'Asset readiness',
      status: assetReadinessStatus,
      present: assetReadinessPresent,
      path: assetReadinessManifest.path,
    ),
    ReadinessComponent(
      key: 'publicationStructure',
      label: 'Publication structure',
      status: structureStatus,
      present: tracksPresent && evidencePresent,
      path: publicationRoot.path,
    ),
  ];

  final blockingIssues = <String>[];
  final warnings = <String>[];

  for (final component in components) {
    if (component.status == 'fail') {
      switch (component.key) {
        case 'releaseValidation':
          blockingIssues.add(
            'Release validation is missing or invalid for ${version.asPubspecVersion}.',
          );
          break;
        case 'submissionBundle':
          blockingIssues.add(
            'Submission bundle artifacts are incomplete for ${version.asPubspecVersion}.',
          );
          break;
        case 'publicationSurface':
          blockingIssues.add(
            'Publication surface artifacts are incomplete for ${version.asPubspecVersion}.',
          );
          break;
        case 'assetReadiness':
          blockingIssues.add(
            'Asset readiness is missing or failing for ${version.asPubspecVersion}.',
          );
          break;
        case 'publicationStructure':
          blockingIssues.add(
            'Publication structure is incomplete because rollout/ or evidence/ is missing.',
          );
          break;
      }
    }
  }

  if (assetReadinessStatus == 'warning') {
    warnings.add('Asset readiness remains in warning for this release.');
    warnings.addAll(_extractAssetWarnings(assetReadinessJson));
  }

  if (!tracksPresent) {
    warnings.add(
        'The publication surface does not expose rollout/ for this release.');
  }
  if (!evidencePresent) {
    warnings.add(
        'The publication surface does not expose evidence/ for this release.');
  }

  final status = blockingIssues.isNotEmpty
      ? 'fail'
      : (warnings.isNotEmpty ? 'warning' : 'pass');

  final manifestPayload = {
    'appName': _appName,
    'generatedAt': DateTime.now().toIso8601String(),
    'version': version.toJson(),
    'status': status,
    'publicationRoot': publicationRoot.path,
    'allowWarningStatus': allowWarningStatus,
    'components': {
      for (final component in components) component.key: component.toJson(),
    },
    'structure': {
      'tracksPresent': tracksPresent,
      'evidencePresent': evidencePresent,
    },
    'blockingIssues': blockingIssues,
    'warnings': warnings,
    'recommendation': _buildRecommendation(status),
  };

  final manifestFile = File(
    _joinPath(
      publicationRoot.path,
      'publication_readiness_gate_$versionSuffix.json',
    ),
  );
  final latestManifestFile =
      File(_joinPath(playStoreRoot, 'publication_readiness_latest.json'));
  final summaryFile = File(
    _joinPath(publicationRoot.path, 'publication_readiness_gate_summary.md'),
  );

  if (writeReport) {
    final encoded = const JsonEncoder.withIndent('  ').convert(manifestPayload);
    await manifestFile.writeAsString(encoded);
    await latestManifestFile.writeAsString(encoded);
    await summaryFile.writeAsString(
      _buildSummary(
        version: version,
        status: status,
        components: components,
        tracksPresent: tracksPresent,
        evidencePresent: evidencePresent,
        blockingIssues: blockingIssues,
        warnings: warnings,
      ),
    );
  }

  return PublicationReadinessResult(
    publicationRoot: publicationRoot,
    manifestFile: manifestFile,
    summaryFile: summaryFile,
    status: status,
    components: components,
  );
}

String _deriveReleaseValidationStatus(Map<String, Object?> json) {
  final checks = json['checks'];
  if (checks is! List) {
    return 'warning';
  }
  final hasFailure = checks.any((entry) {
    if (entry is! Map) {
      return false;
    }
    final passed = entry['passed'];
    return passed is bool && !passed;
  });
  return hasFailure ? 'fail' : 'pass';
}

List<String> _extractAssetWarnings(Map<String, Object?> assetReadinessJson) {
  final summary = assetReadinessJson['summary'];
  if (summary is! Map) {
    return const [];
  }
  final warnings = summary['warnings'];
  if (warnings is! List) {
    return const [];
  }
  return warnings.whereType<String>().toList();
}

Future<Map<String, Object?>> _readJsonObject(File file) async {
  final decoded = jsonDecode(await file.readAsString());
  if (decoded is! Map<String, Object?>) {
    stderr.writeln('❌ El JSON esperado no es un objeto: ${file.path}');
    exit(1);
  }
  return decoded;
}

String _readString(
  Map<String, Object?> json,
  String key, {
  required String fallback,
}) {
  final value = json[key];
  return value is String && value.isNotEmpty ? value : fallback;
}

String _buildRecommendation(String status) {
  switch (status) {
    case 'pass':
      return 'Ready for controlled Play Console publication.';
    case 'warning':
      return 'Ready for controlled Play Console publication with documented warnings.';
    default:
      return 'Do not upload this release until all blocking issues are resolved.';
  }
}

String _buildSummary({
  required VersionInfo version,
  required String status,
  required List<ReadinessComponent> components,
  required bool tracksPresent,
  required bool evidencePresent,
  required List<String> blockingIssues,
  required List<String> warnings,
}) {
  final buffer = StringBuffer()
    ..writeln(
      '# Publication Readiness Gate — Mi IP·RED ${version.asPubspecVersion}',
    )
    ..writeln()
    ..writeln('## Overall status')
    ..writeln(status.toUpperCase())
    ..writeln()
    ..writeln('## Components');

  for (final component in components) {
    buffer.writeln('- ${component.label}: ${component.status.toUpperCase()}');
  }

  buffer
    ..writeln()
    ..writeln('## Publication structure')
    ..writeln('- tracks/: ${tracksPresent ? 'PASS' : 'FAIL'}')
    ..writeln('- evidence/: ${evidencePresent ? 'PASS' : 'FAIL'}')
    ..writeln()
    ..writeln('## Blocking issues');

  if (blockingIssues.isEmpty) {
    buffer.writeln('- none');
  } else {
    for (final issue in blockingIssues) {
      buffer.writeln('- $issue');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Warnings');
  if (warnings.isEmpty) {
    buffer.writeln('- none');
  } else {
    for (final warning in warnings) {
      buffer.writeln('- $warning');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Recommendation')
    ..writeln(_buildRecommendation(status));

  return buffer.toString();
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
      '❌ pubspec.yaml y lib/config/version.dart no están sincronizados. pubspec=$pubspecVersion version.dart=$codeVersion',
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

class PublicationReadinessResult {
  final Directory publicationRoot;
  final File manifestFile;
  final File summaryFile;
  final String status;
  final List<ReadinessComponent> components;

  const PublicationReadinessResult({
    required this.publicationRoot,
    required this.manifestFile,
    required this.summaryFile,
    required this.status,
    required this.components,
  });
}

class ReadinessComponent {
  final String key;
  final String label;
  final String status;
  final bool present;
  final String path;

  const ReadinessComponent({
    required this.key,
    required this.label,
    required this.status,
    required this.present,
    required this.path,
  });

  Map<String, Object?> toJson() => {
        'present': present,
        'status': status,
        'path': path,
      };
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

  Map<String, Object> toJson() => {
        'major': major,
        'minor': minor,
        'patch': patch,
        'build': build,
        'codeName': codeName,
        'pubspecVersion': asPubspecVersion,
      };
}
