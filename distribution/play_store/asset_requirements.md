# Play Store Asset Requirements — Mi IP·RED

## Objetivo

Definir el inventario mínimo de assets visuales y su organización operativa para cada surface de publicación preparado en Phase 12.1.

## Surface versionado esperado

Cada versión preparada para publicación debe contar con un root propio en:

    distribution/play_store/releases/<version>/

Ese root se genera con:

    dart run prepare_store_publication.dart

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

## Capturas sugeridas
- Login
- Dashboard principal
- FacturasVT
- RecibosVT
- DébitosVT / CréditosVT según la superficie actualmente visible
- Flujo de descarga o detalle si corresponde

## Reglas operativas
- Las capturas deben corresponder a la versión exacta del AAB que se sube
- No mezclar capturas de builds anteriores con un bundle nuevo
- Mantener coherencia visual con branding Mi IP·RED
- El feature graphic debe representar la misma identidad visual que se ve en iconografía y screenshots
- Guardar los assets fuente pesados fuera del repositorio si no es necesario trackearlos en Git
- Mantener notas de rollout por track dentro del surface versionado de publicación

## Qué no cubre este archivo
- No genera screenshots automáticamente
- No publica directamente en Play Console
- No reemplaza la revisión manual previa a subir el release
