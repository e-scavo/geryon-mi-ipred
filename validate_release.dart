import 'dart:convert';
import 'dart:io';

const String _appName = 'Mi IP·RED';
const String _expectedApplicationId = 'com.geryon.mi_ipred';
const String _defaultDistRoot = 'dist';

Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    return;
  }

  final distRoot = _readOption(args, '--dist-root') ?? _defaultDistRoot;
  final version = await _readVersion();
  final writeReport = !args.contains('--no-write-report');

  final report = await _validateReleaseReadiness(
    version: version,
    distRoot: distRoot,
    writeReport: writeReport,
  );

  stdout.writeln('✅ Validación de release OK para ${version.asPubspecVersion}');
  stdout.writeln('📁 Dist principal: ${report.distRoot.path}');
  stdout.writeln('📄 Reporte: ${report.reportFile.path}');
}

void _printHelp() {
  stdout.writeln('''
Uso:
  dart run validate_release.dart [opciones]

Opciones:
  --dist-root=RUTA       Valida una raíz de distribución específica (por defecto: dist)
  --no-write-report      Ejecuta la validación sin escribir reportes
  --help, -h             Muestra esta ayuda
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

Future<ValidationResult> _validateReleaseReadiness({
  required VersionInfo version,
  required String distRoot,
  required bool writeReport,
}) async {
  final checks = <Map<String, Object?>>[];

  Future<void> addCheck(
    String name,
    Future<bool> Function() fn, {
    String? successDetail,
    String? failureDetail,
  }) async {
    final passed = await fn();
    if (!passed) {
      stderr.writeln('❌ $name');
      if (failureDetail != null && failureDetail.isNotEmpty) {
        stderr.writeln('   $failureDetail');
      }
      exit(1);
    }

    stdout.writeln('✅ $name');
    checks.add({
      'name': name,
      'passed': true,
      'detail': successDetail ?? '',
    });
  }

  await addCheck(
    'pubspec.yaml y version.dart siguen sincronizados',
    () async => true,
    successDetail: version.asPubspecVersion,
  );

  await addCheck(
    'web/manifest.json expone branding de Mi IP·RED',
    () async {
      final file = File(_joinPath('web', 'manifest.json'));
      if (!await file.exists()) return false;
      final payload =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return payload['name'] == _appName &&
          payload['short_name'] == _appName &&
          (payload['description'] as String?)?.contains('Mi IP·RED') == true;
    },
    successDetail: 'branding y descripción actualizados',
    failureDetail:
        'El manifest web no refleja el branding de publicación esperado.',
  );

  await addCheck(
    'web/index.html expone metadata pública alineada',
    () async {
      final file = File(_joinPath('web', 'index.html'));
      if (!await file.exists()) return false;
      final content = await file.readAsString();
      return content.contains('<title>Mi IP·RED</title>') &&
          content.contains('apple-mobile-web-app-title" content="Mi IP·RED"') &&
          content.contains('Portal de clientes Mi IP·RED');
    },
    successDetail: 'title, apple title y description actualizados',
    failureDetail: 'index.html todavía contiene metadata genérica.',
  );

  await addCheck(
    'android/app/build.gradle.kts mantiene applicationId productivo',
    () async {
      final file = File(_joinPath('android', 'app', 'build.gradle.kts'));
      if (!await file.exists()) return false;
      final content = await file.readAsString();
      return content.contains('applicationId = "$_expectedApplicationId"') &&
          content
              .contains('signingConfig = signingConfigs.getByName("release")');
    },
    successDetail: _expectedApplicationId,
    failureDetail:
        'Gradle no refleja el applicationId o signingConfig esperados para release.',
  );

  await addCheck(
    'android/key.properties local sigue disponible',
    () async {
      final file = File(_joinPath('android', 'key.properties'));
      if (!await file.exists()) return false;
      final lines = await file.readAsLines();
      final data = <String, String>{};
      for (final raw in lines) {
        final line = raw.trim();
        if (line.isEmpty || line.startsWith('#') || !line.contains('=')) {
          continue;
        }
        final index = line.indexOf('=');
        data[line.substring(0, index).trim()] =
            line.substring(index + 1).trim();
      }
      return data['storeFile']?.isNotEmpty == true &&
          data['storePassword']?.isNotEmpty == true &&
          data['keyAlias']?.isNotEmpty == true &&
          data['keyPassword']?.isNotEmpty == true;
    },
    successDetail: 'campos requeridos presentes',
    failureDetail:
        'Falta android/key.properties o alguno de sus campos obligatorios.',
  );

  await addCheck(
    'android/key.properties.example documenta el contrato local',
    () async => File(_joinPath('android', 'key.properties.example')).exists(),
    successDetail: 'plantilla lista para nuevos entornos',
    failureDetail: 'Falta la plantilla local de key.properties.',
  );

  final releaseDistRoot = Directory(distRoot);
  await addCheck(
    'la raíz dist/release configurada existe',
    () async => releaseDistRoot.exists(),
    successDetail: releaseDistRoot.path,
    failureDetail:
        'La raíz indicada todavía no existe. Ejecutá build_and_commit.dart primero.',
  );

  final versionSuffix = version.asPubspecVersion;
  final manifestFile =
      File(_joinPath(distRoot, 'release_manifest_$versionSuffix.json'));

  await addCheck(
    'manifest de release presente para la versión actual',
    () async => manifestFile.exists(),
    successDetail: manifestFile.path,
    failureDetail: 'Falta el manifest de release para la versión actual.',
  );

  final manifestPayload =
      jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
  final manifestArtifacts = (manifestPayload['artifacts'] as List<dynamic>? ??
          const [])
      .whereType<Map>()
      .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
      .toList();

  if (manifestArtifacts.isEmpty) {
    stderr.writeln(
        '❌ El manifest de release no contiene artefactos para validar.');
    exit(1);
  }

  for (final artifact in manifestArtifacts) {
    final path = artifact['path']?.toString() ?? '';
    final type = artifact['type']?.toString() ?? 'file';
    final exists = type == 'directory'
        ? await Directory(path).exists()
        : await File(path).exists();
    await addCheck(
      'artefacto esperado presente: $path',
      () async => exists,
      successDetail: path,
      failureDetail: 'Falta el artefacto esperado informado por el manifest.',
    );
  }

  final reportPayload = {
    'appName': _appName,
    'applicationId': _expectedApplicationId,
    'version': version.toJson(),
    'generatedAt': DateTime.now().toIso8601String(),
    'distRoot': releaseDistRoot.path,
    'checks': checks,
  };

  final reportFile =
      File(_joinPath(distRoot, 'release_validation_$versionSuffix.json'));
  final latestReportFile =
      File(_joinPath(distRoot, 'release_validation_latest.json'));

  if (writeReport) {
    await reportFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(reportPayload),
    );
    await latestReportFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(reportPayload),
    );
  }

  return ValidationResult(distRoot: releaseDistRoot, reportFile: reportFile);
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

class ValidationResult {
  final Directory distRoot;
  final File reportFile;

  const ValidationResult({
    required this.distRoot,
    required this.reportFile,
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

  Map<String, Object> toJson() => {
        'major': major,
        'minor': minor,
        'patch': patch,
        'build': build,
        'codeName': codeName,
        'pubspecVersion': asPubspecVersion,
      };
}
