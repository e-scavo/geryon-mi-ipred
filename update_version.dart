import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    return;
  }

  final dryRun = args.contains('--dry-run');
  final explicitVersionArg = _readOption(args, '--set-version');
  final explicitCodeNameArg = _readOption(args, '--code-name');
  final bumpMode = _resolveBumpMode(args);

  final versionFile = File('lib/config/version.dart');
  final pubspecFile = File('pubspec.yaml');

  if (!await versionFile.exists()) {
    stderr.writeln('❌ No se encontró lib/config/version.dart');
    exit(1);
  }
  if (!await pubspecFile.exists()) {
    stderr.writeln('❌ No se encontró pubspec.yaml');
    exit(1);
  }

  final versionFileContent = await versionFile.readAsString();
  final pubspecContent = await pubspecFile.readAsString();

  final currentVersion = _readVersionFromVersionFile(versionFileContent);
  final pubspecVersion = _readVersionFromPubspec(pubspecContent);

  if (currentVersion.core != pubspecVersion.core ||
      currentVersion.build != pubspecVersion.build) {
    stderr.writeln(
      '❌ version.dart y pubspec.yaml no están sincronizados. '
      'version.dart=${currentVersion.asPubspecVersion} '
      'pubspec.yaml=${pubspecVersion.asPubspecVersion}',
    );
    exit(1);
  }

  final nextVersion = explicitVersionArg != null
      ? _parseSetVersion(
          explicitVersionArg,
          fallbackCodeName: explicitCodeNameArg ?? currentVersion.codeName,
        )
      : _bumpVersion(
          currentVersion,
          mode: bumpMode,
          newCodeName: explicitCodeNameArg,
        );

  stdout.writeln('📦 Versión actual: ${currentVersion.asPubspecVersion}');
  stdout.writeln('📦 Nueva versión:  ${nextVersion.asPubspecVersion}');
  stdout.writeln('🏷️ Code name:      ${nextVersion.codeName}');

  final updatedPubspec = pubspecContent.replaceFirst(
    RegExp(r'^version:\s*.+$', multiLine: true),
    'version: ${nextVersion.asPubspecVersion}',
  );

  final updatedVersionFile = _writeVersionFile(
    versionFileContent,
    nextVersion,
  );

  if (dryRun) {
    stdout.writeln('🧪 --dry-run activado: no se escribieron cambios.');
    return;
  }

  await pubspecFile.writeAsString(updatedPubspec);
  await versionFile.writeAsString(updatedVersionFile);

  stdout.writeln(
    '✅ Versionado sincronizado en pubspec.yaml y lib/config/version.dart',
  );
}

void _printHelp() {
  stdout.writeln('''
Uso:
  dart run update_version.dart [opciones]

Opciones:
  --build                Incrementa solo el build (por defecto)
  --patch                Incrementa patch y reinicia build a 1
  --minor                Incrementa minor y reinicia patch/build
  --major                Incrementa major y reinicia minor/patch/build
  --set-version=X.Y.Z+B  Define la versión exacta
  --code-name=NOMBRE     Actualiza el code name
  --dry-run              Muestra el resultado sin escribir archivos
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

String _resolveBumpMode(List<String> args) {
  if (args.contains('--major')) return 'major';
  if (args.contains('--minor')) return 'minor';
  if (args.contains('--patch')) return 'patch';
  return 'build';
}

VersionInfo _readVersionFromVersionFile(String content) {
  final major = _readRequiredInt(content, r'const\s+int\s+vMajor\s*=\s*(\d+);');
  final minor = _readRequiredInt(content, r'const\s+int\s+vMinor\s*=\s*(\d+);');
  final patch = _readRequiredInt(content, r'const\s+int\s+vPatch\s*=\s*(\d+);');
  final build = _readRequiredInt(content, r'const\s+int\s+vBuild\s*=\s*(\d+);');
  final codeName = _readRequiredString(
    content,
    r'const\s+String\s+vCodeName\s*=\s*"([^"]+)";',
  );

  return VersionInfo(
    major: major,
    minor: minor,
    patch: patch,
    build: build,
    codeName: codeName,
  );
}

VersionInfo _readVersionFromPubspec(String content) {
  final match = RegExp(
    r'^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$',
    multiLine: true,
  ).firstMatch(content);

  if (match == null) {
    stderr.writeln('❌ No se encontró un campo version: válido en pubspec.yaml');
    exit(1);
  }

  return VersionInfo(
    major: int.parse(match.group(1)!),
    minor: int.parse(match.group(2)!),
    patch: int.parse(match.group(3)!),
    build: int.parse(match.group(4)!),
    codeName: '',
  );
}

VersionInfo _parseSetVersion(
  String raw, {
  required String fallbackCodeName,
}) {
  final match = RegExp(r'^(\d+)\.(\d+)\.(\d+)\+(\d+)$').firstMatch(raw);
  if (match == null) {
    stderr.writeln('❌ --set-version debe tener formato X.Y.Z+B');
    exit(1);
  }

  return VersionInfo(
    major: int.parse(match.group(1)!),
    minor: int.parse(match.group(2)!),
    patch: int.parse(match.group(3)!),
    build: int.parse(match.group(4)!),
    codeName: fallbackCodeName,
  );
}

VersionInfo _bumpVersion(
  VersionInfo current, {
  required String mode,
  String? newCodeName,
}) {
  switch (mode) {
    case 'major':
      return VersionInfo(
        major: current.major + 1,
        minor: 0,
        patch: 0,
        build: 1,
        codeName: newCodeName ?? current.codeName,
      );
    case 'minor':
      return VersionInfo(
        major: current.major,
        minor: current.minor + 1,
        patch: 0,
        build: 1,
        codeName: newCodeName ?? current.codeName,
      );
    case 'patch':
      return VersionInfo(
        major: current.major,
        minor: current.minor,
        patch: current.patch + 1,
        build: 1,
        codeName: newCodeName ?? current.codeName,
      );
    case 'build':
      return VersionInfo(
        major: current.major,
        minor: current.minor,
        patch: current.patch,
        build: current.build + 1,
        codeName: newCodeName ?? current.codeName,
      );
    default:
      stderr.writeln('❌ Modo de bump no soportado: $mode');
      exit(1);
  }
}

String _writeVersionFile(String content, VersionInfo version) {
  return content
      .replaceFirst(
        RegExp(r'const\s+int\s+vMajor\s*=\s*\d+;'),
        'const int vMajor = ${version.major};',
      )
      .replaceFirst(
        RegExp(r'const\s+int\s+vMinor\s*=\s*\d+;'),
        'const int vMinor = ${version.minor};',
      )
      .replaceFirst(
        RegExp(r'const\s+int\s+vPatch\s*=\s*\d+;'),
        'const int vPatch = ${version.patch};',
      )
      .replaceFirst(
        RegExp(r'const\s+int\s+vBuild\s*=\s*\d+;'),
        'const int vBuild = ${version.build};',
      )
      .replaceFirst(
        RegExp(r'const\s+String\s+vCodeName\s*=\s*"[^"]+";'),
        'const String vCodeName = "${version.codeName}";',
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
}
