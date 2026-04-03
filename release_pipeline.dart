import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final config = _Config.fromArgs(args);

  if (config.showHelp) {
    _printHelp();
    exit(0);
  }

  final versionBefore = _readPubspecVersion();
  final effectiveTrack = config.releaseTrack;

  stdout.writeln('🚀 Mi IP·RED release pipeline');
  stdout.writeln('📦 Versión actual detectada: $versionBefore');
  stdout.writeln('🏪 Track objetivo: $effectiveTrack');
  stdout.writeln('⬆️ Bump de versión: ${config.bump ? 'sí' : 'no'}');
  stdout.writeln('🧪 Dry-run: ${config.dryRun ? 'sí' : 'no'}');
  stdout.writeln('');

  final steps = <_Step>[
    _Step(
      label: 'Build + commit',
      command: [
        'dart',
        'run',
        'build_and_commit.dart',
        if (config.bump) '--bump',
      ],
    ),
    _Step(
      label: 'Validate release',
      command: [
        'dart',
        'run',
        'validate_release.dart',
      ],
    ),
    _Step(
      label: 'Prepare submission bundle',
      command: [
        'dart',
        'run',
        'prepare_submission_bundle.dart',
      ],
    ),
    _Step(
      label: 'Prepare store publication',
      command: [
        'dart',
        'run',
        'prepare_store_publication.dart',
        '--release-track=$effectiveTrack',
      ],
    ),
    _Step(
      label: 'Validate store assets',
      command: [
        'dart',
        'run',
        'validate_store_assets.dart',
        if (config.allowMissingOptional) '--allow-missing-optional',
      ],
    ),
    _Step(
      label: 'Evaluate publication readiness',
      command: [
        'dart',
        'run',
        'evaluate_publication_readiness.dart',
        if (config.allowWarningStatus) '--allow-warning-status',
      ],
    ),
  ];

  if (config.dryRun) {
    stdout.writeln('📝 Dry-run activo. Comandos a ejecutar:\n');
    for (final step in steps) {
      stdout.writeln('• ${step.label}');
      stdout.writeln('  ${step.command.join(' ')}');
    }
    stdout.writeln('');
    stdout.writeln('📌 No se ejecutó ningún paso.');
    exit(0);
  }

  for (final step in steps) {
    await _runStep(step);
  }

  final versionAfter = _readPubspecVersion();

  final aabPath = _joinPath([
    'dist',
    'android',
    'aab',
    'mi-ipred-android-aab-$versionAfter.aab',
  ]);

  final releaseValidationPath = _joinPath([
    'dist',
    'release_validation_$versionAfter.json',
  ]);

  final submissionManifestPath = _joinPath([
    'distribution',
    'submissions',
    versionAfter,
    'submission_bundle_$versionAfter.json',
  ]);

  final submissionSummaryPath = _joinPath([
    'distribution',
    'submissions',
    versionAfter,
    'submission_summary.md',
  ]);

  final publicationSurfacePath = _joinPath([
    'distribution',
    'play_store',
    'releases',
    versionAfter,
    'publication_surface_$versionAfter.json',
  ]);

  final publicationSummaryPath = _joinPath([
    'distribution',
    'play_store',
    'releases',
    versionAfter,
    'publication_summary.md',
  ]);

  final assetReadinessSummaryPath = _joinPath([
    'distribution',
    'play_store',
    'releases',
    versionAfter,
    'asset_readiness_summary.md',
  ]);

  final readinessGateSummaryPath = _joinPath([
    'distribution',
    'play_store',
    'releases',
    versionAfter,
    'publication_readiness_gate_summary.md',
  ]);

  final releaseRoot = _joinPath([
    'distribution',
    'play_store',
    'releases',
    versionAfter,
  ]);

  final summaryPath = _joinPath([
    releaseRoot,
    'release_pipeline_summary.md',
  ]);

  await _writePipelineSummary(
    summaryPath: summaryPath,
    version: versionAfter,
    releaseTrack: effectiveTrack,
    bumpApplied: config.bump,
    aabPath: aabPath,
    releaseValidationPath: releaseValidationPath,
    submissionManifestPath: submissionManifestPath,
    submissionSummaryPath: submissionSummaryPath,
    publicationSurfacePath: publicationSurfacePath,
    publicationSummaryPath: publicationSummaryPath,
    assetReadinessSummaryPath: assetReadinessSummaryPath,
    readinessGateSummaryPath: readinessGateSummaryPath,
  );

  stdout.writeln('');
  stdout.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  stdout.writeln('✅ Pipeline completo finalizado');
  stdout.writeln('📦 Versión final: $versionAfter');
  stdout.writeln('🏪 Track preparado: $effectiveTrack');
  stdout.writeln('');

  if (File(aabPath).existsSync()) {
    stdout.writeln('📤 AAB listo para subir: $aabPath');
  } else {
    stdout.writeln('⚠️ No se encontró el AAB esperado: $aabPath');
  }

  stdout.writeln('');
  stdout.writeln('📄 Artefactos clave generados/verificados:');
  _printArtifactLine(releaseValidationPath);
  _printArtifactLine(submissionManifestPath);
  _printArtifactLine(submissionSummaryPath);
  _printArtifactLine(publicationSurfacePath);
  _printArtifactLine(publicationSummaryPath);
  _printArtifactLine(assetReadinessSummaryPath);
  _printArtifactLine(readinessGateSummaryPath);
  _printArtifactLine(summaryPath);

  stdout.writeln('');
  stdout.writeln('📋 Checklist previo a Play Console:');
  stdout.writeln('1) Confirmar que validate_release.dart no haya dado FAIL.');
  stdout.writeln('2) Revisar asset_readiness_summary.md.');
  stdout.writeln('3) Revisar publication_readiness_gate_summary.md.');
  stdout.writeln(
      '4) Confirmar que el estado final sea PASS o WARNING aceptable.');
  stdout.writeln('5) Verificar que el AAB corresponda a la versión esperada.');
  stdout.writeln(
      '6) Subir manualmente el AAB al track $effectiveTrack en Play Console.');

  stdout.writeln('');
  stdout.writeln('🧾 Checklist post-upload recomendado:');
  stdout.writeln('1) Confirmar que Google Play procesó correctamente el AAB.');
  stdout.writeln(
      '2) Confirmar que la versión mostrada en Play Console coincide con $versionAfter.');
  stdout.writeln('3) Confirmar que el track objetivo sea $effectiveTrack.');
  stdout.writeln(
      '4) Registrar evidencia en distribution/play_store/releases/$versionAfter/evidence/.');
  stdout.writeln('5) Guardar o actualizar capturas/recibos del upload real.');
  stdout.writeln(
      '6) Revisar si hubo warnings nuevos o bloqueos del lado de Play Console.');

  stdout.writeln('');
  stdout.writeln('📝 Resumen de pipeline: $summaryPath');
  stdout.writeln('');
  stdout.writeln('📝 Sugerencia operativa:');
  stdout.writeln(
      '- Si el gate final quedó en WARNING, documentar explícitamente por qué el warning es aceptable antes de publicar.');
  stdout.writeln(
      '- Si Play Console devuelve observaciones nuevas, registrarlas en la evidencia de la release.');
}

class _Config {
  final bool bump;
  final bool showHelp;
  final bool dryRun;
  final bool allowMissingOptional;
  final bool allowWarningStatus;
  final String releaseTrack;

  const _Config({
    required this.bump,
    required this.showHelp,
    required this.dryRun,
    required this.allowMissingOptional,
    required this.allowWarningStatus,
    required this.releaseTrack,
  });

  factory _Config.fromArgs(List<String> args) {
    final bump = args.contains('--bump');
    final showHelp = args.contains('--help') || args.contains('-h');
    final dryRun = args.contains('--dry-run');
    final allowMissingOptional = args.contains('--allow-missing-optional');
    final allowWarningStatus = args.contains('--allow-warning-status');

    String releaseTrack = 'internal';
    for (final arg in args) {
      if (arg.startsWith('--release-track=')) {
        releaseTrack = arg.substring('--release-track='.length).trim();
      }
    }

    final allowedTracks = {'internal', 'closed', 'production'};
    if (!allowedTracks.contains(releaseTrack)) {
      stderr.writeln('❌ Track inválido: $releaseTrack');
      stderr.writeln('Tracks permitidos: internal, closed, production');
      exit(2);
    }

    return _Config(
      bump: bump,
      showHelp: showHelp,
      dryRun: dryRun,
      allowMissingOptional: allowMissingOptional,
      allowWarningStatus: allowWarningStatus,
      releaseTrack: releaseTrack,
    );
  }
}

class _Step {
  final String label;
  final List<String> command;

  const _Step({
    required this.label,
    required this.command,
  });
}

Future<void> _runStep(_Step step) async {
  stdout.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  stdout.writeln('▶ ${step.label}');
  stdout.writeln('\$ ${step.command.join(' ')}');
  stdout.writeln('');

  final process = await Process.start(
    step.command.first,
    step.command.sublist(1),
    runInShell: true,
    mode: ProcessStartMode.normal,
  );

  final stdoutDone = _pipeStream(process.stdout, stdout);
  final stderrDone = _pipeStream(process.stderr, stderr);
  final exitCode = await process.exitCode;

  await stdoutDone;
  await stderrDone;

  if (exitCode != 0) {
    stderr.writeln('');
    stderr.writeln('❌ Falló el paso: ${step.label}');
    stderr.writeln('🔚 Exit code: $exitCode');
    exit(exitCode);
  }

  stdout.writeln('✅ Paso completado: ${step.label}');
  stdout.writeln('');
}

Future<void> _pipeStream(Stream<List<int>> stream, IOSink sink) async {
  await for (final chunk in stream) {
    sink.write(utf8.decode(chunk));
  }
}

String _readPubspecVersion() {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) {
    stderr.writeln('❌ No se encontró pubspec.yaml en la raíz del proyecto.');
    exit(2);
  }

  final lines = file.readAsLinesSync();
  for (final rawLine in lines) {
    final line = rawLine.trim();
    if (line.startsWith('version:')) {
      final value = line.substring('version:'.length).trim();
      if (value.isNotEmpty) {
        return value;
      }
      break;
    }
  }

  stderr.writeln('❌ No se pudo detectar la versión desde pubspec.yaml.');
  exit(2);
}

String _joinPath(List<String> parts) {
  return parts.join(Platform.pathSeparator);
}

void _printArtifactLine(String path) {
  final exists = File(path).existsSync() || Directory(path).existsSync();
  stdout.writeln('${exists ? '✅' : '⚠️'} $path');
}

Future<void> _writePipelineSummary({
  required String summaryPath,
  required String version,
  required String releaseTrack,
  required bool bumpApplied,
  required String aabPath,
  required String releaseValidationPath,
  required String submissionManifestPath,
  required String submissionSummaryPath,
  required String publicationSurfacePath,
  required String publicationSummaryPath,
  required String assetReadinessSummaryPath,
  required String readinessGateSummaryPath,
}) async {
  final summaryFile = File(summaryPath);
  summaryFile.parent.createSync(recursive: true);

  final buffer = StringBuffer()
    ..writeln('# Release Pipeline Summary — Mi IP·RED $version')
    ..writeln()
    ..writeln('## Execution context')
    ..writeln('- Version: $version')
    ..writeln('- Track: $releaseTrack')
    ..writeln('- Build bump applied: ${bumpApplied ? 'yes' : 'no'}')
    ..writeln()
    ..writeln('## Expected upload artifact')
    ..writeln('- `${_normalizePathForMarkdown(aabPath)}`')
    ..writeln()
    ..writeln('## Key generated or validated artifacts')
    ..writeln('- `${_normalizePathForMarkdown(releaseValidationPath)}`')
    ..writeln('- `${_normalizePathForMarkdown(submissionManifestPath)}`')
    ..writeln('- `${_normalizePathForMarkdown(submissionSummaryPath)}`')
    ..writeln('- `${_normalizePathForMarkdown(publicationSurfacePath)}`')
    ..writeln('- `${_normalizePathForMarkdown(publicationSummaryPath)}`')
    ..writeln('- `${_normalizePathForMarkdown(assetReadinessSummaryPath)}`')
    ..writeln('- `${_normalizePathForMarkdown(readinessGateSummaryPath)}`')
    ..writeln()
    ..writeln('## Pre-upload checklist')
    ..writeln('- Confirm `validate_release.dart` completed without FAIL.')
    ..writeln('- Review `asset_readiness_summary.md`.')
    ..writeln('- Review `publication_readiness_gate_summary.md`.')
    ..writeln(
        '- Confirm the final publication status is PASS or an accepted WARNING.')
    ..writeln('- Verify the AAB version matches the intended release.')
    ..writeln(
        '- Upload the AAB manually to the `$releaseTrack` track in Play Console.')
    ..writeln()
    ..writeln('## Post-upload checklist')
    ..writeln('- Confirm Play Console processed the AAB successfully.')
    ..writeln('- Confirm the visible version matches `$version`.')
    ..writeln('- Confirm the selected track is `$releaseTrack`.')
    ..writeln(
        '- Register upload evidence under `distribution/play_store/releases/$version/evidence/`.')
    ..writeln('- Save receipts or screenshots of the real upload.')
    ..writeln('- Record any new warnings or blockers returned by Play Console.')
    ..writeln()
    ..writeln('## Operational note')
    ..writeln(
        '- If the final gate remains in WARNING, document why the warning is acceptable before publishing.')
    ..writeln(
        '- If Play Console introduces new issues, treat them as release evidence and register them with the current release artifacts.');

  await summaryFile.writeAsString(buffer.toString());
}

String _normalizePathForMarkdown(String path) {
  return path.replaceAll('\\', '/');
}

void _printHelp() {
  stdout.writeln('Mi IP·RED release pipeline');
  stdout.writeln('');
  stdout.writeln('Uso:');
  stdout.writeln('  dart run release_pipeline.dart [opciones]');
  stdout.writeln('');
  stdout.writeln('Opciones:');
  stdout.writeln(
      '  --bump                    Incrementa el build antes de compilar.');
  stdout.writeln('  --release-track=TRACK     internal | closed | production');
  stdout.writeln(
      '  --allow-missing-optional  Pasa esta opción a validate_store_assets.dart.');
  stdout.writeln(
      '  --allow-warning-status    Pasa esta opción a evaluate_publication_readiness.dart.');
  stdout.writeln(
      '  --dry-run                 Muestra los comandos sin ejecutarlos.');
  stdout.writeln('  --help, -h                Muestra esta ayuda.');
  stdout.writeln('');
  stdout.writeln('Ejemplos:');
  stdout.writeln('  dart run release_pipeline.dart --bump');
  stdout.writeln(
      '  dart run release_pipeline.dart --bump --release-track=internal');
  stdout.writeln('  dart run release_pipeline.dart --dry-run --bump');
}
