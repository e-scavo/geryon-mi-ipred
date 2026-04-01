import 'dart:convert';
import 'dart:io';

const String _appName = 'Mi IP·RED';
const String _artifactSlug = 'mi-ipred';
const String _defaultSubmissionRoot = 'distribution/submissions';
const String _defaultPlayStoreRoot = 'distribution/play_store';
const List<String> _supportedTracks = ['internal', 'closed', 'production'];

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
    '✅ Surface listo para ${version.asPubspecVersion} [$releaseTrack]',
  );
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
      submissionBundleRoot.path,
      'submission_bundle_$versionSuffix.json',
    ),
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
      _joinPath(playStoreRoot, 'metadata', 'es-AR', 'short_description.txt'),
    ),
    File(
      _joinPath(playStoreRoot, 'metadata', 'es-AR', 'full_description.txt'),
    ),
    File(
      _joinPath(playStoreRoot, 'metadata', 'es-AR', 'release_notes.txt'),
    ),
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
  final generatedRolloutFiles = <Map<String, Object?>>[];
  final generatedEvidenceFiles = <Map<String, Object?>>[];
  final generatedAutomationFiles = <Map<String, Object?>>[];

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

  Future<void> writeGeneratedRolloutFile({
    required String relativeDestination,
    required String content,
  }) async {
    final destination =
        File(_joinPath(publicationRoot.path, relativeDestination));
    await destination.parent.create(recursive: true);
    await destination.writeAsString(content);
    generatedRolloutFiles.add({
      'publicationPath': destination.path,
      'sizeBytes': await destination.length(),
    });
  }

  Future<void> writeGeneratedEvidenceFile({
    required String relativeDestination,
    required String content,
  }) async {
    final destination =
        File(_joinPath(publicationRoot.path, relativeDestination));
    await destination.parent.create(recursive: true);
    await destination.writeAsString(content);
    generatedEvidenceFiles.add({
      'publicationPath': destination.path,
      'sizeBytes': await destination.length(),
    });
  }

  Future<void> writeGeneratedAutomationFile({
    required String relativeDestination,
    required String content,
  }) async {
    final destination =
        File(_joinPath(publicationRoot.path, relativeDestination));
    await destination.parent.create(recursive: true);
    await destination.writeAsString(content);
    generatedAutomationFiles.add({
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

  final trackContracts = <String, Map<String, String>>{};
  final trackEvidenceContracts = <String, Map<String, String>>{};
  for (final track in _supportedTracks) {
    final rolloutNotesRelative =
        _joinPath('rollout', track, 'rollout_notes.md');
    final checklistRelative = _joinPath('rollout', track, 'track_checklist.md');
    final promotionGateRelative =
        _joinPath('rollout', track, 'promotion_gate.md');
    final evidenceTemplateRelative =
        _joinPath('rollout', track, 'evidence_template.md');

    await writeGeneratedRolloutFile(
      relativeDestination: rolloutNotesRelative,
      content: _buildRolloutNotes(
        version: versionSuffix,
        track: track,
        isSuggestedTrack: track == releaseTrack,
      ),
    );
    await writeGeneratedRolloutFile(
      relativeDestination: checklistRelative,
      content: _buildTrackChecklist(
        version: versionSuffix,
        track: track,
        isSuggestedTrack: track == releaseTrack,
      ),
    );
    await writeGeneratedRolloutFile(
      relativeDestination: promotionGateRelative,
      content: _buildPromotionGate(
        version: versionSuffix,
        track: track,
      ),
    );
    await writeGeneratedRolloutFile(
      relativeDestination: evidenceTemplateRelative,
      content: _buildEvidenceTemplate(
        version: versionSuffix,
        track: track,
      ),
    );

    final uploadReceiptRelative =
        _joinPath('evidence', track, 'upload_receipt.md');
    final postUploadValidationRelative =
        _joinPath('evidence', track, 'post_upload_validation.md');
    final promotionDecisionRelative =
        _joinPath('evidence', track, 'promotion_decision.md');

    await writeGeneratedEvidenceFile(
      relativeDestination: uploadReceiptRelative,
      content: _buildUploadReceipt(
        version: versionSuffix,
        track: track,
        isSuggestedTrack: track == releaseTrack,
      ),
    );
    await writeGeneratedEvidenceFile(
      relativeDestination: postUploadValidationRelative,
      content: _buildPostUploadValidation(
        version: versionSuffix,
        track: track,
      ),
    );
    await writeGeneratedEvidenceFile(
      relativeDestination: promotionDecisionRelative,
      content: _buildPromotionDecision(
        version: versionSuffix,
        track: track,
      ),
    );

    trackContracts[track] = {
      'rolloutNotes': _joinPath(publicationRoot.path, rolloutNotesRelative),
      'trackChecklist': _joinPath(publicationRoot.path, checklistRelative),
      'promotionGate': _joinPath(publicationRoot.path, promotionGateRelative),
      'evidenceTemplate':
          _joinPath(publicationRoot.path, evidenceTemplateRelative),
    };
    trackEvidenceContracts[track] = {
      'uploadReceipt': _joinPath(publicationRoot.path, uploadReceiptRelative),
      'postUploadValidation':
          _joinPath(publicationRoot.path, postUploadValidationRelative),
      'promotionDecision':
          _joinPath(publicationRoot.path, promotionDecisionRelative),
    };
  }

  await writeGeneratedRolloutFile(
    relativeDestination: _joinPath('rollout', 'active_track.md'),
    content: _buildActiveTrackSummary(
      version: versionSuffix,
      releaseTrack: releaseTrack,
    ),
  );
  await writeGeneratedRolloutFile(
    relativeDestination: _joinPath('rollout', 'track_matrix.md'),
    content: _buildTrackMatrix(version: versionSuffix),
  );
  await writeGeneratedEvidenceFile(
    relativeDestination: 'publication_ledger.md',
    content: _buildPublicationLedger(
      version: versionSuffix,
      releaseTrack: releaseTrack,
      publicationRoot: publicationRoot.path,
      trackEvidenceContracts: trackEvidenceContracts,
    ),
  );

  final automationContracts = {
    'matrix': _joinPath(
        publicationRoot.path, 'automation', 'automation_boundary_matrix.md'),
    'assistedSteps':
        _joinPath(publicationRoot.path, 'automation', 'assisted_steps.md'),
    'manualRequiredSteps': _joinPath(
        publicationRoot.path, 'automation', 'manual_required_steps.md'),
    'changeGuardrails':
        _joinPath(publicationRoot.path, 'automation', 'change_guardrails.md'),
  };

  await writeGeneratedAutomationFile(
    relativeDestination:
        _joinPath('automation', 'automation_boundary_matrix.md'),
    content: _buildAutomationBoundaryMatrix(version: versionSuffix),
  );
  await writeGeneratedAutomationFile(
    relativeDestination: _joinPath('automation', 'assisted_steps.md'),
    content:
        _buildAssistedSteps(version: versionSuffix, releaseTrack: releaseTrack),
  );
  await writeGeneratedAutomationFile(
    relativeDestination: _joinPath('automation', 'manual_required_steps.md'),
    content: _buildManualRequiredSteps(version: versionSuffix),
  );
  await writeGeneratedAutomationFile(
    relativeDestination: _joinPath('automation', 'change_guardrails.md'),
    content: _buildChangeGuardrails(version: versionSuffix),
  );

  final summaryFile =
      File(_joinPath(publicationRoot.path, 'publication_summary.md'));
  await summaryFile.writeAsString(
    _buildPublicationSummary(
      version: version,
      publicationRoot: publicationRoot.path,
      submissionBundleRoot: submissionBundleRoot.path,
      releaseTrack: releaseTrack,
      copiedFiles: copiedFiles,
      generatedRolloutFiles: generatedRolloutFiles,
      generatedEvidenceFiles: generatedEvidenceFiles,
      generatedAutomationFiles: generatedAutomationFiles,
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
    'rolloutTracks': _supportedTracks,
    'policyRoot': _joinPath(publicationRoot.path, 'policy'),
    'rolloutRoot': _joinPath(publicationRoot.path, 'rollout'),
    'evidenceRoot': _joinPath(publicationRoot.path, 'evidence'),
    'automationRoot': _joinPath(publicationRoot.path, 'automation'),
    'publicationLedgerFile':
        _joinPath(publicationRoot.path, 'publication_ledger.md'),
    'activeTrackFile':
        _joinPath(publicationRoot.path, 'rollout', 'active_track.md'),
    'trackMatrixFile':
        _joinPath(publicationRoot.path, 'rollout', 'track_matrix.md'),
    'generatedRolloutFiles': generatedRolloutFiles,
    'generatedEvidenceFiles': generatedEvidenceFiles,
    'generatedAutomationFiles': generatedAutomationFiles,
    'trackContracts': trackContracts,
    'trackEvidenceContracts': trackEvidenceContracts,
    'automationContracts': automationContracts,
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

String _buildTrackChecklist({
  required String version,
  required String track,
  required bool isSuggestedTrack,
}) {
  final config = _trackConfigs[track]!;
  final buffer = StringBuffer()
    ..writeln('# Track Checklist — ${config.label}')
    ..writeln()
    ..writeln('Versión objetivo: `$version`')
    ..writeln(
      'Track sugerido al generar el surface: `${isSuggestedTrack ? 'sí' : 'no'}`',
    )
    ..writeln()
    ..writeln('## Objetivo del track')
    ..writeln(config.objective)
    ..writeln()
    ..writeln('## Checklist operativo');

  for (final item in config.checklistItems) {
    buffer.writeln('- [ ] $item');
  }

  if (config.nextTrackLabel != null) {
    buffer
      ..writeln()
      ..writeln('## Próximo track esperado')
      ..writeln('- `${config.nextTrackLabel}`');
  }

  return buffer.toString();
}

String _buildPromotionGate({
  required String version,
  required String track,
}) {
  final config = _trackConfigs[track]!;
  final buffer = StringBuffer()
    ..writeln('# Promotion Gate — ${config.label}')
    ..writeln()
    ..writeln('Versión objetivo: `$version`')
    ..writeln();

  if (config.nextTrackLabel == null) {
    buffer
      ..writeln('## Estado')
      ..writeln('- Este es el track final de publicación.')
      ..writeln()
      ..writeln('## Condiciones mínimas para quedar cerrado')
      ..writeln(
        '- Metadata, assets y política verificados en la consola productiva.',
      )
      ..writeln(
        '- Registro final del rollout completado en `evidence_template.md`.',
      )
      ..writeln(
        '- Sin bloqueantes relevantes posteriores al inicio del rollout.',
      )
      ..writeln('- Decisión final de publicación documentada por el operador.');
    return buffer.toString();
  }

  buffer
    ..writeln('## Promoción esperada')
    ..writeln('- `${config.label}` → `${config.nextTrackLabel}`')
    ..writeln()
    ..writeln('## Gate mínimo antes de promover');

  for (final item in config.promotionGateItems) {
    buffer.writeln('- [ ] $item');
  }

  return buffer.toString();
}

String _buildEvidenceTemplate({
  required String version,
  required String track,
}) {
  final config = _trackConfigs[track]!;
  return '''# Evidence Template — ${config.label}

Versión objetivo: `$version`
Track: `${config.id}`

## Registro operativo
- Fecha de upload:
- Operador:
- Consola / cuenta:
- Estado del release:

## Validación realizada
- Alcance del test / audiencia:
- Assets revisados:
- Metadata revisada:
- Observaciones:

## Decisión
- ¿Aprobado para continuar?:
- Próximo track esperado: `${config.nextTrackLabel ?? 'cierre final'}`
- Bloqueantes detectados:
''';
}

String _buildUploadReceipt({
  required String version,
  required String track,
  required bool isSuggestedTrack,
}) {
  final config = _trackConfigs[track]!;
  return '''# Upload Receipt — ${config.label}

Versión objetivo: `$version`
Track: `${config.id}`
Track sugerido al generar el surface: `${isSuggestedTrack ? 'sí' : 'no'}`

## Registro de upload
- Fecha y hora:
- Operador:
- Consola / cuenta:
- País o audiencia objetivo:
- Nombre visible del release:
- Estado inicial observado en consola:

## Artefacto publicado
- AAB utilizado:
- Submission bundle asociado:
- Metadata asociada:
- Assets asociados:

## Observaciones iniciales
- Notas del upload:
- Incidentes inmediatos:
''';
}

String _buildPostUploadValidation({
  required String version,
  required String track,
}) {
  final config = _trackConfigs[track]!;
  return '''# Post-Upload Validation — ${config.label}

Versión objetivo: `$version`
Track: `${config.id}`

## Estado observado
- Fecha y hora de validación:
- Operador:
- Estado del release en consola:
- ¿Procesado sin errores?:

## Validación funcional
- Alcance validado:
- Smoke test ejecutado:
- Resultado:
- Bloqueantes detectados:
- Incidentes menores:

## Validación de publicación
- Assets visibles correctos:
- Metadata visible correcta:
- Política y enlaces correctos:
- Notas del release correctas:

## Próximo paso sugerido
- Acción recomendada:
- Justificación:
- Próximo track esperado: `${config.nextTrackLabel ?? 'cierre final'}`
''';
}

String _buildPromotionDecision({
  required String version,
  required String track,
}) {
  final config = _trackConfigs[track]!;
  return '''# Promotion Decision — ${config.label}

Versión objetivo: `$version`
Track: `${config.id}`

## Decisión
- Fecha:
- Responsable:
- Resultado final: `approved` | `blocked` | `hold`
- Próximo track: `${config.nextTrackLabel ?? 'cierre final'}`

## Fundamentos
- Evidencia revisada:
- Bloqueantes:
- Riesgos residuales:
- Comentarios del responsable:
''';
}

String _buildActiveTrackSummary({
  required String version,
  required String releaseTrack,
}) {
  final config = _trackConfigs[releaseTrack]!;
  return '''# Active Track — Mi IP·RED

Versión objetivo: `$version`
Track activo sugerido: `${config.id}`
Etiqueta: `${config.label}`

## Recordatorio operativo
- Revisar `rollout/${config.id}/track_checklist.md` antes de publicar.
- Completar `rollout/${config.id}/evidence_template.md` durante el upload y la validación.
- Completar `evidence/${config.id}/upload_receipt.md` y `evidence/${config.id}/post_upload_validation.md` después del upload.
- Registrar la decisión final en `evidence/${config.id}/promotion_decision.md` antes de avanzar al siguiente track.
''';
}

String _buildTrackMatrix({
  required String version,
}) {
  final buffer = StringBuffer()
    ..writeln('# Track Matrix — Mi IP·RED')
    ..writeln()
    ..writeln('Versión objetivo: `$version`')
    ..writeln()
    ..writeln('## Secuencia esperada')
    ..writeln('- `internal` → `closed` → `production`')
    ..writeln()
    ..writeln('## Resumen por track');

  for (final track in _supportedTracks) {
    final config = _trackConfigs[track]!;
    buffer
      ..writeln()
      ..writeln('### ${config.label}')
      ..writeln('- Objetivo: ${config.objective}')
      ..writeln('- Próximo track: `${config.nextTrackLabel ?? 'cierre final'}`')
      ..writeln('- Checklist: `rollout/$track/track_checklist.md`')
      ..writeln('- Gate: `rollout/$track/promotion_gate.md`')
      ..writeln('- Evidencia previa: `rollout/$track/evidence_template.md`')
      ..writeln(
          '- Evidencia posterior: `evidence/$track/post_upload_validation.md`')
      ..writeln('- Decisión: `evidence/$track/promotion_decision.md`');
  }

  return buffer.toString();
}

String _buildPublicationLedger({
  required String version,
  required String releaseTrack,
  required String publicationRoot,
  required Map<String, Map<String, String>> trackEvidenceContracts,
}) {
  final buffer = StringBuffer()
    ..writeln('# Publication Ledger — Mi IP·RED')
    ..writeln()
    ..writeln('Versión objetivo: `$version`')
    ..writeln('Track activo sugerido: `$releaseTrack`')
    ..writeln('Surface de publicación: `$publicationRoot`')
    ..writeln()
    ..writeln('## Estado general')
    ..writeln('- Fecha de última actualización:')
    ..writeln('- Operador responsable:')
    ..writeln('- Estado general de publicación:')
    ..writeln('- Observaciones globales:')
    ..writeln()
    ..writeln('## Evidencia por track');

  for (final track in _supportedTracks) {
    final evidence = trackEvidenceContracts[track]!;
    buffer
      ..writeln()
      ..writeln('### ${track.toUpperCase()}')
      ..writeln('- Upload receipt: `${evidence['uploadReceipt']}`')
      ..writeln(
        '- Post-upload validation: `${evidence['postUploadValidation']}`',
      )
      ..writeln('- Promotion decision: `${evidence['promotionDecision']}`')
      ..writeln('- Estado resumido:');
  }

  buffer
    ..writeln()
    ..writeln('## Cierre')
    ..writeln('- ¿La versión quedó cerrada?:')
    ..writeln('- Fecha de cierre:')
    ..writeln('- Comentario final:');

  return buffer.toString();
}

String _buildPublicationSummary({
  required VersionInfo version,
  required String publicationRoot,
  required String submissionBundleRoot,
  required String releaseTrack,
  required List<Map<String, Object?>> copiedFiles,
  required List<Map<String, Object?>> generatedRolloutFiles,
  required List<Map<String, Object?>> generatedEvidenceFiles,
  required List<Map<String, Object?>> generatedAutomationFiles,
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
    ..writeln('- `rollout/production/`')
    ..writeln('- `evidence/internal/`')
    ..writeln('- `evidence/closed/`')
    ..writeln('- `evidence/production/`')
    ..writeln('- `automation/`')
    ..writeln()
    ..writeln('## Contrato operativo de rollout generado');

  for (final file in generatedRolloutFiles) {
    buffer.writeln('- `${file['publicationPath']}`');
  }

  buffer
    ..writeln()
    ..writeln('## Evidencia post-upload generada');

  for (final file in generatedEvidenceFiles) {
    buffer.writeln('- `${file['publicationPath']}`');
  }

  buffer
    ..writeln()
    ..writeln('## Boundary de automatización generado');

  for (final file in generatedAutomationFiles) {
    buffer.writeln('- `${file['publicationPath']}`');
  }

  return buffer.toString();
}

String _buildAutomationBoundaryMatrix({
  required String version,
}) {
  return '''# Automation Boundary Matrix — Mi IP·RED

Versión objetivo: `$version`

## Clasificación

### Automatic
- Validación local de versión y artefactos (`validate_release.dart`)
- Generación del submission bundle (`prepare_submission_bundle.dart`)
- Generación del publication surface (`prepare_store_publication.dart`)
- Generación de scaffolding de rollout, evidencia y ledger

### Assisted
- Preparación de metadata y assets dentro del surface versionado
- Registro manual sobre plantillas ya generadas por track
- Consolidación del handoff operativo por versión

### Manual-required
- Upload real a Play Console
- Selección de audiencia/testers
- Revisión visual de listing y assets
- Promoción entre tracks
- Aprobación final para production

## Regla principal
La automatización del repositorio puede preparar, validar y documentar.
No puede decidir ni ejecutar por sí sola la publicación real.
''';
}

String _buildAssistedSteps({
  required String version,
  required String releaseTrack,
}) {
  return '''# Assisted Steps — Mi IP·RED

Versión objetivo: `$version`
Track inicialmente sugerido: `$releaseTrack`

## Uso esperado
- Generar el surface versionado para esta release.
- Completar metadata, assets y evidencia dentro de los archivos generados.
- Usar el checklist y la matriz de tracks como soporte operativo.
- Mantener la decisión final de upload y promoción bajo control humano.

## Señal de uso correcto
Los scripts dejan la versión mejor preparada y mejor documentada.
Los scripts no cambian por sí mismos el estado remoto del release en Play Console.
''';
}

String _buildManualRequiredSteps({
  required String version,
}) {
  return '''# Manual Required Steps — Mi IP·RED

Versión objetivo: `$version`

## Acciones que deben seguir siendo manuales
- Ingresar a Play Console con la cuenta correcta
- Cargar el AAB en el track correspondiente
- Verificar screenshots, feature graphic, descripción y política visibles
- Confirmar audiencia del track
- Decidir promoción a `closed` o `production`
- Autorizar el go/no-go productivo

## Prohibición operativa
No asumir que un manifest, summary o ledger generado equivale a aprobación de publicación.
''';
}

String _buildChangeGuardrails({
  required String version,
}) {
  return '''# Change Guardrails — Mi IP·RED

Versión objetivo: `$version`

## Guardrails
- No agregar automatización que requiera credenciales remotas de publicación sin una fase nueva explícita.
- No automatizar promociones entre tracks usando solo evidencia local.
- No automatizar publicación a production usando únicamente validaciones del repositorio.
- No modificar el comportamiento funcional de la app como parte de tooling de publicación.

## Criterio de evolución
Cualquier automatización futura debe seguir siendo repository-assisted hasta que exista una fase dedicada que redefina de forma segura ese límite.
''';
}

String _joinPath(
  String part1, [
  String? part2,
  String? part3,
  String? part4,
  String? part5,
]) {
  final parts = [part1, part2, part3, part4, part5]
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

class _TrackConfig {
  const _TrackConfig({
    required this.id,
    required this.label,
    required this.objective,
    required this.checklistItems,
    required this.promotionGateItems,
    this.nextTrackLabel,
  });

  final String id;
  final String label;
  final String objective;
  final List<String> checklistItems;
  final List<String> promotionGateItems;
  final String? nextTrackLabel;
}

const Map<String, _TrackConfig> _trackConfigs = {
  'internal': _TrackConfig(
    id: 'internal',
    label: 'INTERNAL',
    objective:
        'Validar rápidamente el release con alcance controlado antes de exponerlo a un grupo más amplio.',
    checklistItems: [
      'El AAB del submission bundle coincide con esta versión.',
      'La metadata principal fue revisada para esta versión.',
      'Las capturas mínimas y el feature graphic ya tienen ubicación definida dentro del surface.',
      'La validación funcional básica no muestra bloqueantes para testers internos.',
      'Las notas iniciales del upload quedaron registradas en el template de evidencia.',
    ],
    promotionGateItems: [
      'Internal finalizado sin bloqueantes severos.',
      'Smoke test básico aprobado por el operador responsable.',
      'Metadata y assets ya no dependen de cambios urgentes.',
      'La decisión de promover a closed quedó documentada en la evidencia.',
    ],
    nextTrackLabel: 'CLOSED',
  ),
  'closed': _TrackConfig(
    id: 'closed',
    label: 'CLOSED',
    objective:
        'Validar el release con audiencia acotada y criterios más cercanos a producción.',
    checklistItems: [
      'Internal quedó aprobado y documentado.',
      'La audiencia de closed está definida.',
      'Release notes y metadata final fueron revisadas para este track.',
      'No hay bloqueantes funcionales relevantes pendientes.',
      'La evidencia del track refleja observaciones y decisión de promoción.',
    ],
    promotionGateItems: [
      'Closed finalizado sin hallazgos bloqueantes.',
      'Assets, política y metadata están listos para producción.',
      'La decisión de promover a production quedó documentada.',
      'El operador responsable aprobó el paso al track productivo.',
    ],
    nextTrackLabel: 'PRODUCTION',
  ),
  'production': _TrackConfig(
    id: 'production',
    label: 'PRODUCTION',
    objective:
        'Cerrar la publicación real con el conjunto final de metadata, assets y decisión operativa.',
    checklistItems: [
      'Closed quedó aprobado y documentado.',
      'El AAB productivo coincide con el bundle validado de esta versión.',
      'Assets, metadata y política quedaron alineados en consola.',
      'La decisión final de publicación fue revisada por el responsable.',
      'La evidencia productiva quedó asentada dentro del surface.',
    ],
    promotionGateItems: [
      'No aplica promoción adicional: este es el track final.',
    ],
  ),
};
