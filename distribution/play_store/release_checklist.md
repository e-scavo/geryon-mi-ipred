# Release Checklist — Mi IP·RED

## Antes de compilar
- Verificar `pubspec.yaml` y `lib/config/version.dart`
- Verificar `android/key.properties` local
- Verificar branding público en `web/index.html` y `web/manifest.json`

## Build recomendado

    dart run build_and_commit.dart

## Validación explícita

    dart run validate_release.dart

## Artefactos esperados
- `dist/web/mi-ipred-web-<version>/`
- `dist/android/apk/mi-ipred-android-apk-<version>.apk`
- `dist/android/aab/mi-ipred-android-aab-<version>.aab`
- `dist/release_manifest_<version>.json`
- `dist/release_validation_<version>.json`

## Publicación Android
- Subir el AAB versionado
- Verificar `applicationId = com.geryon.mi_ipred`
- Confirmar screenshots, descripción corta y descripción completa
- Conservar el APK solo para distribución interna o validación local
