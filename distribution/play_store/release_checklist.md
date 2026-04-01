# Release Checklist — Mi IP·RED

## Antes de compilar
- Verificar `pubspec.yaml` y `lib/config/version.dart`
- Verificar `android/key.properties` local
- Verificar branding público en `web/index.html` y `web/manifest.json`
- Confirmar que el keystore referenciado por `storeFile` existe realmente en el entorno local

## Build recomendado

    dart run build_and_commit.dart

## Validación explícita

    dart run validate_release.dart

## Bundle final de submission

    dart run prepare_submission_bundle.dart

## Surface versionado de publicación

    dart run prepare_store_publication.dart --release-track=internal

## Readiness visual del surface versionado

    dart run validate_store_assets.dart

## Contrato visual complementario

- Revisar `distribution/play_store/visual_selection_contract.md`
- Confirmar que el set phone represente login + dashboard + al menos una surface financiera adicional
- Confirmar que el feature graphic siga la misma narrativa visual del release

## Artefactos esperados
- `dist/web/mi-ipred-web-<version>/`
- `dist/android/apk/mi-ipred-android-apk-<version>.apk`
- `dist/android/aab/mi-ipred-android-aab-<version>.aab`
- `dist/release_manifest_<version>.json`
- `dist/release_validation_<version>.json`
- `distribution/submissions/<version>/submission_bundle_<version>.json`
- `distribution/submissions/<version>/submission_summary.md`
- `distribution/play_store/releases/<version>/publication_surface_<version>.json`
- `distribution/play_store/releases/<version>/publication_summary.md`
- `distribution/play_store/releases/<version>/rollout/active_track.md`
- `distribution/play_store/releases/<version>/rollout/track_matrix.md`
- `distribution/play_store/releases/<version>/publication_ledger.md`
- `distribution/play_store/releases/<version>/automation/automation_boundary_matrix.md`
- `distribution/play_store/releases/<version>/automation/assisted_steps.md`
- `distribution/play_store/releases/<version>/automation/manual_required_steps.md`
- `distribution/play_store/releases/<version>/automation/change_guardrails.md`
- `distribution/play_store/releases/<version>/evidence/<track>/upload_receipt.md`
- `distribution/play_store/releases/<version>/evidence/<track>/post_upload_validation.md`
- `distribution/play_store/releases/<version>/evidence/<track>/promotion_decision.md`
- `distribution/play_store/releases/<version>/asset_readiness_manifest_<version>.json`
- `distribution/play_store/releases/<version>/asset_readiness_summary.md`
- `distribution/play_store/asset_readiness_latest.json`

## Publicación Android
- Subir el AAB versionado
- Verificar `applicationId = com.geryon.mi_ipred`
- Confirmar screenshots, descripción corta y descripción completa
- Completar assets visuales según `distribution/play_store/asset_requirements.md`
- Preparar el surface versionado de publicación antes de cargar assets y notas de rollout
- Ejecutar `dart run validate_store_assets.dart` después de cargar screenshots y feature graphic
- Revisar que el summary de readiness no tenga faltantes requeridos antes del upload real
- Revisar warnings de consistencia visual antes de considerar cerrado el listing
- Confirmar que el set de phone screenshots no sea solo mínimo técnico si la publicación ya va a exposición real
- Conservar el APK solo para distribución interna o validación local

## Contrato operativo por track

### Internal
- Generar o refrescar el surface con `--release-track=internal`
- Completar `rollout/internal/track_checklist.md`
- Registrar observaciones iniciales en `rollout/internal/evidence_template.md`
- Completar `evidence/internal/upload_receipt.md` después del upload
- Completar `evidence/internal/post_upload_validation.md` con el resultado real del smoke test
- Registrar decisión en `evidence/internal/promotion_decision.md` antes de promover a `closed`
- Confirmar que `asset_readiness_summary.md` no tenga faltantes requeridos para la versión subida

### Closed
- Regenerar o revisar el surface con `--release-track=closed`
- Confirmar que `internal` quedó sin bloqueantes
- Completar `rollout/closed/track_checklist.md`
- Completar `evidence/closed/upload_receipt.md` después del upload
- Completar `evidence/closed/post_upload_validation.md` con el resultado de la audiencia acotada
- Registrar audiencia objetivo, notas de validación y decisión de promoción en `evidence/closed/promotion_decision.md`
- Confirmar que no se mezclaron assets visuales de otra versión en el mismo surface

### Production
- Regenerar o revisar el surface con `--release-track=production`
- Confirmar que `closed` quedó aprobado sin bloqueantes relevantes
- Completar `rollout/production/track_checklist.md`
- Completar `evidence/production/upload_receipt.md` después del upload
- Completar `evidence/production/post_upload_validation.md` con el resultado real del rollout productivo
- Registrar decisión final de publicación y observaciones de rollout en `evidence/production/promotion_decision.md`
- Verificar que el baseline visual validado siga correspondiendo al AAB promovido

## Cierre operativo
- Conservar el submission bundle versionado como evidencia de handoff
- Conservar el publication surface versionado como evidencia de preparación para rollout
- Completar `publication_ledger.md` con el resumen final de la versión
- No modificar a mano los artefactos ya copiados dentro del bundle final
- Usar los archivos de `rollout/` y `evidence/` como contrato documental mínimo antes de mover la versión al siguiente track
- Conservar `asset_readiness_manifest_<version>.json` como evidencia local del baseline visual validado

## Automation boundary
- Consider `distribution/play_store/releases/<version>/automation/automation_boundary_matrix.md` the source of truth for what is automatic, assisted, or manual-required
- Do not treat generated files as permission to upload, promote, or publish automatically
- Preserve explicit human approval for Play Console upload, track promotion, and production go/no-go
