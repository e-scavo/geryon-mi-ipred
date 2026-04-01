import 'dart:convert';
import 'dart:io';

const String _appName = 'Mi IP·RED';
const String _artifactSlug = 'mi-ipred';
const String _defaultDistRoot = 'dist';

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
  final cleanDistRequested = args.contains('--clean-dist');
  final skipValidationRequested = args.contains('--skip-release-validation');
  final validationOnlyRequested = args.contains('--validate-release-only');
  final prepareSubmissionRequested =
      args.contains('--prepare-submission-bundle');
  final prepareSubmissionOnlyRequested =
      args.contains('--prepare-submission-only');
  final submissionRoot =
      _readOption(args, '--submission-root') ?? 'distribution/submissions';
  final distRoot = _readOption(args, '--dist-root') ?? _defaultDistRoot;

  if (prepareSubmissionOnlyRequested && validationOnlyRequested) {
    stderr.writeln(
        '❌ --prepare-submission-only no puede combinarse con --validate-release-only');
    exit(1);
  }

  if (validationOnlyRequested) {
    stdout
        .writeln('🔎 Ejecutando solo validación de release sobre $distRoot...');
    await _runCommand([
      'dart',
      'run',
      'validate_release.dart',
      '--dist-root=$distRoot',
    ]);
    return;
  }

  if (prepareSubmissionOnlyRequested) {
    stdout
        .writeln('📦 Preparando solo el submission bundle sobre $distRoot...');
    await _runCommand([
      'dart',
      'run',
      'prepare_submission_bundle.dart',
      '--dist-root=$distRoot',
      '--submission-root=$submissionRoot',
    ]);
    return;
  }

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

  final releaseResult = await _prepareDistArtifacts(
    version: version,
    buildWeb: buildWeb,
    buildApk: buildApk,
    buildAab: buildAab,
    distRoot: distRoot,
    cleanDistRequested: cleanDistRequested,
  );

  if (!skipValidationRequested) {
    stdout.writeln('🔎 Ejecutando validación de release...');
    await _runCommand([
      'dart',
      'run',
      'validate_release.dart',
      '--dist-root=$distRoot',
    ]);
  } else {
    stdout.writeln(
        '⚠️ Validación de release omitida por --skip-release-validation.');
  }

  if (prepareSubmissionRequested) {
    stdout.writeln('📦 Preparando submission bundle...');
    await _runCommand([
      'dart',
      'run',
      'prepare_submission_bundle.dart',
      '--dist-root=$distRoot',
      '--submission-root=$submissionRoot',
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
      'Phase 11.4 final release operations baseline - ${version.asPubspecVersion}',
    ]);

    if (gitPushRequested) {
      await _runCommand(['git', 'push', 'origin', branch]);
    }
  } else {
    stdout.writeln('📝 Build finalizado sin commit automático.');
  }

  stdout.writeln('📁 Dist principal: ${releaseResult.distRoot.path}');
  stdout.writeln('📄 Manifest: ${releaseResult.manifestFile.path}');
  stdout.writeln('✅ Proceso finalizado para ${version.asPubspecVersion}');
}

bool _isTargetFlag(String arg) =>
    arg == '--web' || arg == '--apk' || arg == '--aab';

String? _readOption(List<String> args, String option) {
  for (final arg in args) {
    if (arg.startsWith('$option=')) {
      return arg.substring(option.length + 1).trim();
    }
  }
  return null;
}

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
  --web                    Compila Web
  --apk                    Compila Android APK release
  --aab                    Compila Android App Bundle release

Si no indicás targets, compila: Web + APK + AAB.

Versionado:
  --bump                   Ejecuta update_version.dart antes de compilar
  --build                  Incrementa solo build (por defecto si usás --bump)
  --patch                  Incrementa patch y reinicia build a 1
  --minor                  Incrementa minor y reinicia patch/build
  --major                  Incrementa major y reinicia minor/patch/build
  --set-version=X.Y.Z+B    Fija versión exacta
  --code-name=NOMBRE       Actualiza el code name

Packaging / dist:
  --clean-dist             Limpia solo los artefactos de la versión actual antes de copiar
  --dist-root=RUTA         Cambia la carpeta destino (por defecto: dist)
  --skip-release-validation Omite la validación automática de release al final
  --validate-release-only  Solo valida una salida ya generada sin compilar
  --prepare-submission-bundle Prepara el handoff final al terminar el build
  --prepare-submission-only Solo arma el handoff final desde un dist ya validado
  --submission-root=RUTA   Cambia la carpeta de bundles finales (por defecto: distribution/submissions)

Git:
  --git-commit             Hace git add + git commit al final
  --git-push               Hace git push al branch actual (requiere --git-commit)

Ayuda:
  --help, -h               Muestra esta ayuda
''');
}

Future<ReleaseResult> _prepareDistArtifacts({
  required VersionInfo version,
  required bool buildWeb,
  required bool buildApk,
  required bool buildAab,
  required String distRoot,
  required bool cleanDistRequested,
}) async {
  final root = Directory(distRoot);
  await root.create(recursive: true);

  final releaseWebDir = Directory(
    _joinPath(
        distRoot, 'web', '$_artifactSlug-web-${version.asPubspecVersion}'),
  );
  final releaseApkDir = Directory(_joinPath(distRoot, 'android', 'apk'));
  final releaseAabDir = Directory(_joinPath(distRoot, 'android', 'aab'));

  final createdArtifacts = <Map<String, Object?>>[];

  if (buildWeb) {
    final sourceWebDir = Directory(_joinPath('build', 'web'));
    if (!await sourceWebDir.exists()) {
      stderr.writeln('❌ No se encontró build/web para estructurar artefactos.');
      exit(1);
    }

    if (cleanDistRequested && await releaseWebDir.exists()) {
      await releaseWebDir.delete(recursive: true);
    }

    // Se copia la web ya compilada a una carpeta versionada y predecible.
    await _copyDirectory(sourceWebDir, releaseWebDir,
        deleteDestinationFirst: true);
    createdArtifacts.add({
      'target': 'web',
      'type': 'directory',
      'path': releaseWebDir.path,
    });
    stdout.writeln('📦 Web estructurada en: ${releaseWebDir.path}');
  }

  if (buildApk) {
    final sourceApk = File(
      _joinPath('build', 'app', 'outputs', 'flutter-apk', 'app-release.apk'),
    );
    if (!await sourceApk.exists()) {
      stderr.writeln('❌ No se encontró el APK release generado.');
      exit(1);
    }

    await releaseApkDir.create(recursive: true);
    final distApk = File(
      _joinPath(
        releaseApkDir.path,
        '$_artifactSlug-android-apk-${version.asPubspecVersion}.apk',
      ),
    );
    if (cleanDistRequested && await distApk.exists()) {
      await distApk.delete();
    }
    await sourceApk.copy(distApk.path);
    createdArtifacts.add({
      'target': 'apk',
      'type': 'file',
      'path': distApk.path,
      'sizeBytes': await distApk.length(),
    });
    stdout.writeln('📦 APK estructurado en: ${distApk.path}');
  }

  if (buildAab) {
    final sourceAab = File(
      _joinPath(
          'build', 'app', 'outputs', 'bundle', 'release', 'app-release.aab'),
    );
    if (!await sourceAab.exists()) {
      stderr.writeln('❌ No se encontró el App Bundle release generado.');
      exit(1);
    }

    await releaseAabDir.create(recursive: true);
    final distAab = File(
      _joinPath(
        releaseAabDir.path,
        '$_artifactSlug-android-aab-${version.asPubspecVersion}.aab',
      ),
    );
    if (cleanDistRequested && await distAab.exists()) {
      await distAab.delete();
    }
    await sourceAab.copy(distAab.path);
    createdArtifacts.add({
      'target': 'aab',
      'type': 'file',
      'path': distAab.path,
      'sizeBytes': await distAab.length(),
    });
    stdout.writeln('📦 AAB estructurado en: ${distAab.path}');
  }

  final manifestPayload = {
    'appName': _appName,
    'artifactSlug': _artifactSlug,
    'version': version.toJson(),
    'generatedAt': DateTime.now().toIso8601String(),
    'distRoot': root.path,
    'artifacts': createdArtifacts,
  };

  final manifestFile = File(
    _joinPath(distRoot, 'release_manifest_${version.asPubspecVersion}.json'),
  );
  await manifestFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(manifestPayload),
  );

  final latestManifestFile =
      File(_joinPath(distRoot, 'release_manifest_latest.json'));
  await latestManifestFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(manifestPayload),
  );

  return ReleaseResult(distRoot: root, manifestFile: manifestFile);
}

Future<void> _copyDirectory(
  Directory source,
  Directory destination, {
  bool deleteDestinationFirst = false,
}) async {
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

class ReleaseResult {
  final Directory distRoot;
  final File manifestFile;

  const ReleaseResult({
    required this.distRoot,
    required this.manifestFile,
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

  @override
  String toString() => jsonEncode(toJson());
}
