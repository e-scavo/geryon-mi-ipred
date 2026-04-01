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

## Artefactos esperados
- `dist/web/mi-ipred-web-<version>/`
- `dist/android/apk/mi-ipred-android-apk-<version>.apk`
- `dist/android/aab/mi-ipred-android-aab-<version>.aab`
- `dist/release_manifest_<version>.json`
- `dist/release_validation_<version>.json`
- `distribution/submissions/<version>/submission_bundle_<version>.json`
- `distribution/submissions/<version>/submission_summary.md`

## Publicación Android
- Subir el AAB versionado
- Verificar `applicationId = com.geryon.mi_ipred`
- Confirmar screenshots, descripción corta y descripción completa
- Completar assets visuales según `distribution/play_store/asset_requirements.md`
- Conservar el APK solo para distribución interna o validación local

## Cierre operativo
- Conservar el submission bundle versionado como evidencia de handoff
- No modificar a mano los artefactos ya copiados dentro del bundle final
