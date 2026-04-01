# Visual Selection Contract — Mi IP·RED

## Objetivo

Formalizar el baseline editorial y visual que debe seguir el surface versionado de Play Store a partir de Phase 13.2.

Este archivo no reemplaza `asset_requirements.md` ni `release_checklist.md`.
Los complementa con reglas de selección, orden y coherencia para el listing real.

## Regla principal

El listing no debe limitarse a “cualquier 2 screenshots válidos”.
Debe representar de forma clara y coherente la experiencia real de Mi IP·RED.

## Baseline recomendado para phone screenshots

Orden sugerido:

1. acceso / login
2. dashboard principal
3. facturas, comprobantes o billing
4. recibos, historial o surface financiera equivalente
5. datos de pago, medios de pago o código de pago si la pantalla existe en la versión activa

## Cobertura mínima esperada del set visual

Aunque el mínimo técnico de Phase 13.1 siga siendo de 2 archivos válidos, el baseline visual recomendado para store listing es:

- login
- dashboard
- al menos una surface financiera adicional

Idealmente:

- login
- dashboard
- facturas/comprobantes
- recibos/historial
- pago/código de pago

## Naming recomendado

### Phone
- `phone_01_login.png`
- `phone_02_dashboard.png`
- `phone_03_facturas.png`
- `phone_04_recibos.png`
- `phone_05_pago.png`

### 7-inch
- `tablet7_01_dashboard.png`
- `tablet7_02_facturas.png`

### 10-inch
- `tablet10_01_dashboard.png`
- `tablet10_02_facturas.png`

### Feature graphic
- `feature_graphic.png`

## Regla de coherencia con feature graphic

El feature graphic debe:

- usar branding vigente de Mi IP·RED
- ser coherente con la narrativa del set de screenshots
- no prometer capacidades que no estén presentes en la app actual
- mantenerse alineado con el AAB publicado para la misma versión

## Qué evitar

- capturas de builds anteriores mezcladas con una versión nueva
- capturas de prueba con contenido ajeno a la app
- naming arbitrario cuando ya existe baseline recomendado
- feature graphic con copy o visuales que contradigan el listing

## Relación con `validate_store_assets.dart`

Desde Phase 13.2, el validator puede emitir warnings editoriales si:

- el set phone queda por debajo del baseline recomendado
- no se detectan nombres orientados a login o dashboard
- no se detecta ninguna surface financiera adicional en phone screenshots
- el feature graphic no usa el naming recomendado

Esos warnings no reemplazan la revisión humana ni bloquean automáticamente la publicación.

## Conclusión

La función de este contrato es estabilizar el listing visual entre releases sin reabrir producto ni forzar automatizaciones prematuras.
