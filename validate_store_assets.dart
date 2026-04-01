import 'dart:convert';
import 'dart:io';

const String _appName = 'Mi IP·RED';
const String _defaultPlayStoreRoot = 'distribution/play_store';
const List<String> _allowedImageExtensions = ['.png', '.jpg', '.jpeg'];

Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    return;
  }

  final playStoreRoot =
      _readOption(args, '--play-store-root') ?? _defaultPlayStoreRoot;
  final requestedVersion = _readOption(args, '--version');
  final allowMissingOptional = args.contains('--allow-missing-optional');
  final writeReport = !args.contains('--no-write-report');
  final version = await _readVersion();

  if (requestedVersion != null &&
      requestedVersion != version.asPubspecVersion) {
    stderr.writeln(
      '❌ La versión solicitada ($requestedVersion) no coincide con la versión activa (${version.asPubspecVersion}).',
    );
    exit(1);
  }

  final result = await _validateStoreAssets(
    version: version,
    playStoreRoot: playStoreRoot,
    allowMissingOptional: allowMissingOptional,
    writeReport: writeReport,
  );

  for (final group in result.groups) {
    final icon = group.passed ? '✅' : (group.required ? '❌' : '⚠️');
    final scope = group.required ? 'requerido' : 'opcional';
    stdout.writeln(
      '$icon ${group.name}: ${group.validFiles.length} assets válidos (${group.minimumRequired} mínimo, $scope)',
    );
  }

  final statusLabel = result.status.toUpperCase();
  if (result.status == 'fail') {
    stderr.writeln(
      '❌ Asset readiness $statusLabel para ${version.asPubspecVersion}',
    );
    stderr.writeln('📁 Surface: ${result.publicationRoot.path}');
    if (writeReport) {
      stderr.writeln('📄 Manifest: ${result.manifestFile.path}');
      stderr.writeln('📝 Resumen: ${result.summaryFile.path}');
    }
    exit(1);
  }

  final icon = result.status == 'warning' ? '⚠️' : '✅';
  stdout.writeln(
    '$icon Asset readiness $statusLabel para ${version.asPubspecVersion}',
  );
  stdout.writeln('📁 Surface: ${result.publicationRoot.path}');
  if (writeReport) {
    stdout.writeln('📄 Manifest: ${result.manifestFile.path}');
    stdout.writeln('📝 Resumen: ${result.summaryFile.path}');
  }
}

void _printHelp() {
  stdout.writeln('''
Uso:
  dart run validate_store_assets.dart [opciones]

Opciones:
  --play-store-root=RUTA     Carpeta raíz Play Store (por defecto: distribution/play_store)
  --version=VERSION          Fuerza la validación de una versión específica (debe coincidir con la activa)
  --allow-missing-optional   No degrada a warning la ausencia de grupos opcionales
  --no-write-report          Ejecuta la validación sin escribir reportes
  --help, -h                 Muestra esta ayuda
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

Future<AssetValidationResult> _validateStoreAssets({
  required VersionInfo version,
  required String playStoreRoot,
  required bool allowMissingOptional,
  required bool writeReport,
}) async {
  final releaseRoot = Directory(
    _joinPath(playStoreRoot, 'releases', version.asPubspecVersion),
  );
  if (!await releaseRoot.exists()) {
    stderr.writeln(
      '❌ No existe el surface versionado actual. Ejecutá prepare_store_publication.dart primero.',
    );
    exit(1);
  }

  // La configuración permanece local y explícita para no mezclar reglas por track.
  final groups = <AssetGroupDefinition>[
    AssetGroupDefinition(
      name: 'phone_screenshots',
      relativePath: _joinPath('android', 'phone_screenshots'),
      required: true,
      minimumRequired: 2,
      recommendedPattern: RegExp(r'^phone_\d{2}_[a-z0-9_\-]+\.(png|jpg|jpeg)$'),
      recommendedExample: 'phone_01_dashboard.png',
    ),
    AssetGroupDefinition(
      name: 'feature_graphic',
      relativePath: _joinPath('android', 'feature_graphic'),
      required: true,
      minimumRequired: 1,
      recommendedPattern: RegExp(r'^feature_graphic\.(png|jpg|jpeg)$'),
      recommendedExample: 'feature_graphic.png',
    ),
    AssetGroupDefinition(
      name: 'seven_inch_screenshots',
      relativePath: _joinPath('android', 'seven_inch_screenshots'),
      required: false,
      minimumRequired: 0,
      recommendedPattern:
          RegExp(r'^tablet7_\d{2}_[a-z0-9_\-]+\.(png|jpg|jpeg)$'),
      recommendedExample: 'tablet7_01_dashboard.png',
    ),
    AssetGroupDefinition(
      name: 'ten_inch_screenshots',
      relativePath: _joinPath('android', 'ten_inch_screenshots'),
      required: false,
      minimumRequired: 0,
      recommendedPattern:
          RegExp(r'^tablet10_\d{2}_[a-z0-9_\-]+\.(png|jpg|jpeg)$'),
      recommendedExample: 'tablet10_01_dashboard.png',
    ),
  ];

  final evaluatedGroups = <EvaluatedAssetGroup>[];
  final detectedValidAssets = <String>[];
  final ignoredFiles = <String>[];
  final invalidFiles = <String>[];
  final requiredFailures = <String>[];
  final warnings = <String>[];

  for (final group in groups) {
    final evaluated = await _evaluateGroup(releaseRoot, group);
    evaluatedGroups.add(evaluated);
    detectedValidAssets.addAll(
      evaluated.validFiles
          .map((file) => _joinPath(group.relativePath, _basename(file.path))),
    );
    ignoredFiles.addAll(
      evaluated.ignoredFiles
          .map((file) => _joinPath(group.relativePath, _basename(file.path))),
    );
    invalidFiles.addAll(
      evaluated.invalidFiles
          .map((file) => _joinPath(group.relativePath, _basename(file.path))),
    );

    if (!evaluated.passed && group.required) {
      requiredFailures.add(group.name);
    }
    if (!group.required && evaluated.issues.isNotEmpty) {
      warnings.addAll(evaluated.issues);
    }
    warnings.addAll(evaluated.warnings);
  }

  final hasRequiredFailure = requiredFailures.isNotEmpty;
  final hasWarnings = warnings.isNotEmpty;
  final status = hasRequiredFailure
      ? 'fail'
      : (hasWarnings && !allowMissingOptional ? 'warning' : 'pass');

  final manifestPayload = {
    'appName': _appName,
    'generatedAt': DateTime.now().toIso8601String(),
    'version': version.toJson(),
    'playStoreRoot': playStoreRoot,
    'publicationRoot': releaseRoot.path,
    'status': status,
    'requiredGroupsPassed': !hasRequiredFailure,
    'optionalGroupsPassed': warnings
        .where(
          (warning) =>
              warning.contains('seven_inch_screenshots') ||
              warning.contains('ten_inch_screenshots'),
        )
        .isEmpty,
    'allowMissingOptional': allowMissingOptional,
    'groups': evaluatedGroups.map((group) => group.toJson()).toList(),
    'summary': {
      'requiredFailures': requiredFailures,
      'warnings': warnings,
      'detectedValidAssets': detectedValidAssets,
      'ignoredFiles': ignoredFiles,
      'invalidFiles': invalidFiles,
    },
  };

  final versionSuffix = version.asPubspecVersion;
  final manifestFile = File(
    _joinPath(
      releaseRoot.path,
      'asset_readiness_manifest_$versionSuffix.json',
    ),
  );
  final latestManifestFile =
      File(_joinPath(playStoreRoot, 'asset_readiness_latest.json'));
  final summaryFile =
      File(_joinPath(releaseRoot.path, 'asset_readiness_summary.md'));

  if (writeReport) {
    await manifestFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(manifestPayload),
    );
    await latestManifestFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(manifestPayload),
    );
    await summaryFile.writeAsString(
      _buildSummary(
        version: version,
        status: status,
        evaluatedGroups: evaluatedGroups,
        detectedValidAssets: detectedValidAssets,
        ignoredFiles: ignoredFiles,
        invalidFiles: invalidFiles,
        requiredFailures: requiredFailures,
        warnings: warnings,
      ),
    );
  }

  return AssetValidationResult(
    publicationRoot: releaseRoot,
    manifestFile: manifestFile,
    summaryFile: summaryFile,
    status: status,
    groups: evaluatedGroups,
  );
}

Future<EvaluatedAssetGroup> _evaluateGroup(
  Directory releaseRoot,
  AssetGroupDefinition definition,
) async {
  final directory = Directory(
    _joinPath(releaseRoot.path, definition.relativePath),
  );
  final issues = <String>[];
  final warnings = <String>[];
  final validFiles = <File>[];
  final ignoredFiles = <FileSystemEntity>[];
  final invalidFiles = <FileSystemEntity>[];

  if (!await directory.exists()) {
    issues.add(
      'No existe el directorio requerido para ${definition.name}: ${definition.relativePath}.',
    );
    return EvaluatedAssetGroup(
      definition: definition,
      validFiles: validFiles,
      ignoredFiles: ignoredFiles,
      invalidFiles: invalidFiles,
      issues: issues,
      warnings: warnings,
      passed: false,
    );
  }

  for (final entity in directory.listSync()) {
    if (entity is! File) {
      ignoredFiles.add(entity);
      continue;
    }

    final basename = _basename(entity.path);
    final extension = _extension(basename).toLowerCase();

    if (basename.startsWith('.')) {
      ignoredFiles.add(entity);
      continue;
    }
    if (basename.toLowerCase() == 'readme.md') {
      ignoredFiles.add(entity);
      continue;
    }
    if (!_allowedImageExtensions.contains(extension)) {
      invalidFiles.add(entity);
      warnings.add(
        '${definition.name}: se ignoró ${basename} porque no tiene una extensión soportada.',
      );
      continue;
    }

    final size = await entity.length();
    if (size <= 0) {
      invalidFiles.add(entity);
      warnings.add(
        '${definition.name}: se ignoró ${basename} porque está vacío.',
      );
      continue;
    }

    validFiles.add(entity);
    if (!definition.recommendedPattern.hasMatch(basename.toLowerCase())) {
      warnings.add(
        '${definition.name}: ${basename} no sigue el naming recomendado (ejemplo: ${definition.recommendedExample}).',
      );
    }
  }

  if (validFiles.length < definition.minimumRequired) {
    issues.add(
      'Se requieren al menos ${definition.minimumRequired} assets válidos en ${definition.name} y se encontraron ${validFiles.length}.',
    );
  }

  if (!definition.required && validFiles.isEmpty) {
    warnings.add(
      '${definition.name}: todavía no contiene imágenes válidas.',
    );
  }

  return EvaluatedAssetGroup(
    definition: definition,
    validFiles: validFiles,
    ignoredFiles: ignoredFiles,
    invalidFiles: invalidFiles,
    issues: issues,
    warnings: warnings,
    passed: issues.isEmpty,
  );
}

String _buildSummary({
  required VersionInfo version,
  required String status,
  required List<EvaluatedAssetGroup> evaluatedGroups,
  required List<String> detectedValidAssets,
  required List<String> ignoredFiles,
  required List<String> invalidFiles,
  required List<String> requiredFailures,
  required List<String> warnings,
}) {
  final buffer = StringBuffer()
    ..writeln(
        '# Asset Readiness Summary — Mi IP·RED ${version.asPubspecVersion}')
    ..writeln()
    ..writeln('## Overall status')
    ..writeln(status.toUpperCase())
    ..writeln()
    ..writeln('## Required groups');

  for (final group in evaluatedGroups.where((group) => group.required)) {
    buffer.writeln(
      '- ${group.name}: ${group.passed ? 'PASS' : 'FAIL'} (${group.validFiles.length}/${group.minimumRequired})',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Optional groups');

  for (final group in evaluatedGroups.where((group) => !group.required)) {
    final label = group.validFiles.isEmpty ? 'WARNING' : 'PASS';
    buffer.writeln('- ${group.name}: $label (${group.validFiles.length})');
  }

  buffer
    ..writeln()
    ..writeln('## Detected valid assets');
  if (detectedValidAssets.isEmpty) {
    buffer.writeln('- none');
  } else {
    for (final asset in detectedValidAssets) {
      buffer.writeln('- $asset');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Ignored files');
  if (ignoredFiles.isEmpty) {
    buffer.writeln('- none');
  } else {
    for (final file in ignoredFiles) {
      buffer.writeln('- $file');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Invalid files');
  if (invalidFiles.isEmpty) {
    buffer.writeln('- none');
  } else {
    for (final file in invalidFiles) {
      buffer.writeln('- $file');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Blocking issues');
  if (requiredFailures.isEmpty) {
    buffer.writeln('- none');
  } else {
    for (final failure in requiredFailures) {
      buffer.writeln('- Missing required readiness for $failure');
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
    ..writeln(
      status == 'fail'
          ? 'Populate the required Android store assets before real Play Store upload.'
          : 'Keep the asset surface aligned with the validated release before uploading to Play Console.',
    );

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

String _basename(String path) => path.split(Platform.pathSeparator).last;

String _extension(String basename) {
  final index = basename.lastIndexOf('.');
  if (index <= 0 || index == basename.length - 1) {
    return '';
  }
  return basename.substring(index).toLowerCase();
}

class AssetValidationResult {
  final Directory publicationRoot;
  final File manifestFile;
  final File summaryFile;
  final String status;
  final List<EvaluatedAssetGroup> groups;

  const AssetValidationResult({
    required this.publicationRoot,
    required this.manifestFile,
    required this.summaryFile,
    required this.status,
    required this.groups,
  });
}

class AssetGroupDefinition {
  final String name;
  final String relativePath;
  final bool required;
  final int minimumRequired;
  final RegExp recommendedPattern;
  final String recommendedExample;

  const AssetGroupDefinition({
    required this.name,
    required this.relativePath,
    required this.required,
    required this.minimumRequired,
    required this.recommendedPattern,
    required this.recommendedExample,
  });
}

class EvaluatedAssetGroup {
  final AssetGroupDefinition definition;
  final List<File> validFiles;
  final List<FileSystemEntity> ignoredFiles;
  final List<FileSystemEntity> invalidFiles;
  final List<String> issues;
  final List<String> warnings;
  final bool passed;

  const EvaluatedAssetGroup({
    required this.definition,
    required this.validFiles,
    required this.ignoredFiles,
    required this.invalidFiles,
    required this.issues,
    required this.warnings,
    required this.passed,
  });

  String get name => definition.name;
  bool get required => definition.required;
  int get minimumRequired => definition.minimumRequired;
  String get relativePath => definition.relativePath;

  Map<String, Object?> toJson() => {
        'name': definition.name,
        'relativePath': definition.relativePath,
        'required': definition.required,
        'minimumRequired': definition.minimumRequired,
        'allowedExtensions': _allowedImageExtensions,
        'foundFiles': validFiles.map((file) => _basename(file.path)).toList(),
        'ignoredFiles':
            ignoredFiles.map((file) => _basename(file.path)).toList(),
        'invalidFiles':
            invalidFiles.map((file) => _basename(file.path)).toList(),
        'count': validFiles.length,
        'passed': passed,
        'issues': issues,
        'warnings': warnings,
        'recommendedExample': definition.recommendedExample,
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
