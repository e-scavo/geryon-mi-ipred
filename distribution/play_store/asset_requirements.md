# Play Store Asset Requirements — Mi IP·RED

## Objetivo

Definir el inventario mínimo de assets visuales, su organización operativa y el baseline de readiness local para cada surface de publicación preparado desde Phase 12.1 y validado desde Phase 13.1.

## Surface versionado esperado

Cada versión preparada para publicación debe contar con un root propio en:

    distribution/play_store/releases/<version>/

Ese root se genera con:

    dart run prepare_store_publication.dart

## Validación operativa local

A partir de Phase 13.1, el baseline de readiness visual se valida con:

    dart run validate_store_assets.dart

Ese script no publica en Play Console ni genera imágenes.
Solo verifica que el surface versionado tenga el mínimo material visual requerido para un handoff real.

## Assets requeridos

### Android / Play Console
- Ícono de aplicación final ya incluido en la app
- Capturas de pantalla de teléfono
- Capturas de pantalla de 7 pulgadas si el track/revisión las requiere
- Capturas de pantalla de 10 pulgadas si el track/revisión las requiere
- Feature graphic
- Política de privacidad publicada y verificable si la consola la exige para el track activo

## Estructura operativa esperada

Dentro del release versionado, la estructura mínima esperada es:

- `android/phone_screenshots/`
- `android/seven_inch_screenshots/`
- `android/ten_inch_screenshots/`
- `android/feature_graphic/`
- `rollout/internal/`
- `rollout/closed/`
- `rollout/production/`

## Mínimos validados por Phase 13.1

### Requeridos
- `android/phone_screenshots/`: al menos 2 imágenes válidas (`.png`, `.jpg`, `.jpeg`)
- `android/feature_graphic/`: al menos 1 imagen válida (`.png`, `.jpg`, `.jpeg`)

### Opcionales controlados
- `android/seven_inch_screenshots/`
- `android/ten_inch_screenshots/`

Si los grupos opcionales no tienen imágenes todavía, el script lo informa como warning operativo, no como bloqueo del producto.

## Capturas sugeridas
- Login
- Dashboard principal
- FacturasVT
- RecibosVT
- DébitosVT / CréditosVT según la superficie actualmente visible
- Flujo de descarga o detalle si corresponde

## Naming recomendado
- `phone_01_login.png`
- `phone_02_dashboard.png`
- `phone_03_facturasvt.png`
- `tablet7_01_dashboard.png`
- `tablet10_01_dashboard.png`
- `feature_graphic.png`

En Phase 13.1 el naming recomendado genera advertencias si no se sigue, pero no bloquea la validación.

## Reglas operativas
- Las capturas deben corresponder a la versión exacta del AAB que se sube
- No mezclar capturas de builds anteriores con un bundle nuevo
- Mantener coherencia visual con branding Mi IP·RED
- El feature graphic debe representar la misma identidad visual que se ve en iconografía y screenshots
- Guardar los assets fuente pesados fuera del repositorio si no es necesario trackearlos en Git
- Mantener notas de rollout por track dentro del surface versionado de publicación
- Revisar `asset_readiness_summary.md` antes de un upload real a Play Console

## Artefactos generados por la validación
- `distribution/play_store/releases/<version>/asset_readiness_manifest_<version>.json`
- `distribution/play_store/releases/<version>/asset_readiness_summary.md`
- `distribution/play_store/asset_readiness_latest.json`

## Qué no cubre este archivo
- No genera screenshots automáticamente
- No publica directamente en Play Console
- No reemplaza la revisión manual previa a subir el release
- No valida todavía dimensiones exactas ni contenido visual interno de las imágenes
