import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    _printHelp();
    return;
  }

  final buildWeb = args.contains('--web') || !args.any(_isTargetFlag);
  final buildApk = args.contains('--apk') || !args.any(_isTargetFlag);
  final buildAab = args.contains('--aab') || !args.any(_isTargetFlag);

  final bumpRequested = args.contains('--bump');
  final gitCommitRequested = args.contains('--git-commit');
  final gitPushRequested = args.contains('--git-push');

  if (gitPushRequested && !gitCommitRequested) {
    stderr.writeln('❌ --git-push requiere también --git-commit');
    exit(1);
  }

  if (bumpRequested) {
    final updateArgs = _collectUpdateVersionArgs(args);
    stdout.writeln('🔄 Ejecutando update_version.dart ${updateArgs.join(' ')}');
    await _runCommand(['dart', 'run', 'update_version.dart', ...updateArgs]);
  } else {
    stdout.writeln('ℹ️ Se mantiene la versión actual (sin --bump).');
  }

  final version = await _readVersion();
  stdout.writeln('📦 Versión de release: ${version.asPubspecVersion}');
  stdout.writeln('🏷️ Code name: ${version.codeName}');

  if (buildWeb) {
    stdout.writeln('🌐 Compilando Web...');
    await _runCommand([
      'flutter',
      'build',
      'web',
      '--release',
      '--build-name=${version.core}',
      '--build-number=${version.build}',
    ]);
  }

  if (buildApk) {
    stdout.writeln('🤖 Compilando APK release...');
    await _runCommand([
      'flutter',
      'build',
      'apk',
      '--release',
      '--build-name=${version.core}',
      '--build-number=${version.build}',
    ]);
  }

  if (buildAab) {
    stdout.writeln('📦 Compilando App Bundle release...');
    await _runCommand([
      'flutter',
      'build',
      'appbundle',
      '--release',
      '--build-name=${version.core}',
      '--build-number=${version.build}',
    ]);
  }

  if (gitCommitRequested) {
    final branch = await _readCurrentGitBranch();

    // El commit queda opt-in para evitar cambios de historial accidentales.
    await _runCommand(['git', 'add', '-A']);
    await _runCommand([
      'git',
      'commit',
      '-m',
      'Phase 11.1 release baseline - ${version.asPubspecVersion}',
    ]);

    if (gitPushRequested) {
      await _runCommand(['git', 'push', 'origin', branch]);
    }
  } else {
    stdout.writeln('📝 Build finalizado sin commit automático.');
  }

  stdout.writeln('✅ Proceso finalizado para ${version.asPubspecVersion}');
}

bool _isTargetFlag(String arg) =>
    arg == '--web' || arg == '--apk' || arg == '--aab';

List<String> _collectUpdateVersionArgs(List<String> args) {
  final passthrough = <String>[];
  for (final arg in args) {
    if (arg == '--major' ||
        arg == '--minor' ||
        arg == '--patch' ||
        arg == '--build' ||
        arg == '--dry-run' ||
        arg.startsWith('--code-name=') ||
        arg.startsWith('--set-version=')) {
      passthrough.add(arg);
    }
  }

  if (!passthrough.any(
    (arg) =>
        arg == '--major' ||
        arg == '--minor' ||
        arg == '--patch' ||
        arg == '--build' ||
        arg.startsWith('--set-version='),
  )) {
    passthrough.add('--build');
  }

  return passthrough;
}

void _printHelp() {
  stdout.writeln('''
Uso:
  dart run build_and_commit.dart [opciones]

Targets:
  --web                 Compila Web
  --apk                 Compila Android APK release
  --aab                 Compila Android App Bundle release

Si no indicás targets, compila: Web + APK + AAB.

Versionado:
  --bump                Ejecuta update_version.dart antes de compilar
  --build               Incrementa solo build (por defecto si usás --bump)
  --patch               Incrementa patch y reinicia build a 1
  --minor               Incrementa minor y reinicia patch/build
  --major               Incrementa major y reinicia minor/patch/build
  --set-version=X.Y.Z+B Fija versión exacta
  --code-name=NOMBRE    Actualiza el code name

Git:
  --git-commit          Hace git add + git commit al final
  --git-push            Hace git push al branch actual (requiere --git-commit)

Ayuda:
  --help, -h            Muestra esta ayuda
''');
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

Future<String> _readCurrentGitBranch() async {
  final result = await Process.run('git', ['branch', '--show-current']);
  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    stderr.writeln('❌ No se pudo detectar el branch actual.');
    exit(result.exitCode);
  }

  final branch = (result.stdout as String).trim();
  if (branch.isEmpty) {
    stderr.writeln('❌ El repositorio no informó un branch actual válido.');
    exit(1);
  }
  return branch;
}

String resolveCommand(String cmd) {
  if (cmd == 'flutter' && Platform.isWindows) {
    return 'flutter.bat';
  }
  return cmd;
}

Future<void> _runCommand(List<String> cmd) async {
  final executable = resolveCommand(cmd.first);
  final process = await Process.start(
    executable,
    cmd.sublist(1),
    mode: ProcessStartMode.inheritStdio,
  );

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    stderr.writeln('❌ Error ejecutando: ${cmd.join(' ')}');
    exit(exitCode);
  }
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

  @override
  String toString() => jsonEncode(toJson());
}
