import 'dart:io';

Future<void> main(List<String> args) async {
  final buildWeb = args.contains('--web') ||
      (!args.contains('--web') && !args.contains('--android'));
  final buildAndroid = args.contains('--android') ||
      (!args.contains('--web') && !args.contains('--android'));
  final skipCommit = args.contains('--no-commit');

  if (!skipCommit) {
    print('🔄 Ejecutando update_version.dart...');
    await _runCommand(['dart', 'run', 'update_version.dart']);
  } else {
    print('⚠️ --no-commit activado: se omite update_version.dart');
  }

  final version = await _readVersion();
  print('📦 Versión detectada: $version');

  if (buildWeb) {
    print('🌐 Compilando Web...');
    await _runCommand(['flutter', 'build', 'web']);
  }

  if (buildAndroid) {
    print('🤖 Compilando Android...');
    await _runCommand(['flutter', 'build', 'apk']);
  }

  if (!skipCommit) {
    print('🌀 Ejecutando git add');
    await _runCommand(['git', 'add', '-A']);

    print('📥 Ejecutando git commit');
    final commitMessage = 'Commit for build creation - $version';
    await _runCommand(['git', 'commit', '-m', commitMessage]);

    print('📤 Ejecutando git push');
    await _runCommand(['git', 'push', 'origin', 'master']);
  } else {
    print('📝 Compilación realizada sin commit (--no-commit activado)');
  }

  print('✅ Proceso finalizado para versión $version');
}

Future<String> _readVersion() async {
  final versionFile = File('lib/config/version.dart');
  if (!await versionFile.exists()) {
    print('❌ No se encontró lib/config/version.dart');
    exit(1);
  }

  final content = await versionFile.readAsString();
  final versionRegExp = RegExp(
    r'vMajor\s*=\s*(\d+);.*?vMinor\s*=\s*(\d+);.*?vPatch\s*=\s*(\d+);.*?vBuild\s*=\s*(\d+);',
    dotAll: true,
  );

  final match = versionRegExp.firstMatch(content);
  if (match == null) {
    print('❌ No se pudo leer la versión desde version.dart');
    exit(1);
  }

  return '${match.group(1)}.${match.group(2)}.${match.group(3)}+${match.group(4)}';
}

// Future<void> _runCommand(List<String> cmd) async {
//   final result = await Process.run(cmd.first, cmd.sublist(1));
//   stdout.write(result.stdout);
//   stderr.write(result.stderr);
//   if (result.exitCode != 0) {
//     print('❌ Error ejecutando: ${cmd.join(" ")}');
//     exit(result.exitCode);
//   }
// }

String resolveCommand(String cmd) {
  if (cmd == 'flutter' && Platform.isWindows) {
    return 'flutter.bat'; // o ruta absoluta si no lo encuentra
  }
  return cmd;
}

Future<void> _runCommand(List<String> cmd) async {
  final executable = resolveCommand(cmd.first);
  final result = await Process.run(executable, cmd.sublist(1));
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    print('❌ Error ejecutando: ${cmd.join(" ")}');
    exit(result.exitCode);
  }
}
