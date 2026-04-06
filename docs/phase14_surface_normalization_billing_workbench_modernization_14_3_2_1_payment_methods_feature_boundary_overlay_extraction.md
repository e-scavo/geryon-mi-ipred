# Phase 14.3.2.1 — Payment Methods Feature Boundary & Overlay Extraction

## Objective

Extraer la surface actual de **Payment Methods** desde `dashboard_page.dart` hacia un boundary propio dentro de `features/payment_methods`, preservando exactamente el comportamiento informativo vigente y sin introducir ninguna semántica de pago in-app.

La intención de esta subfase es resolver el primer corte estructural de 14.3.2:

- crear ownership explícito de la surface
- desacoplar el dashboard del detalle del overlay
- mantener intacto el contrato backend actual
- conservar la UX funcional existente

---

## Initial Context

Antes de esta subfase, el ZIP real mostraba que:

- el acceso a medios de pago se iniciaba desde el `InfoCard` de saldo en dashboard
- el diálogo completo vivía embebido dentro de `lib/features/dashboard/presentation/dashboard_page.dart`
- la feature todavía no tenía un boundary propio en `lib/features/payment_methods/`
- la UI seguía siendo únicamente informativa: alias, códigos de pago, código de barras textual, saldo, último pago y vencimiento mostrado
- los datos eran provistos por backend a través de `ServiceProviderLoginDataUserMessageModel`

También quedó explicitado que esta surface **no es todavía una pasarela de pago ni un flujo transaccional**, sino un punto de consulta/copia para pagar fuera de la plataforma.

---

## Problem Statement

La surface de Payment Methods existía funcionalmente, pero estaba colocada en un lugar estructural incorrecto.

Eso generaba los siguientes problemas concretos:

- `dashboard_page.dart` mezclaba responsabilidades de dashboard con responsabilidades de payment methods
- el overlay no tenía un archivo canónico propio
- el dashboard conocía el detalle completo del diálogo en vez de solo dispararlo
- no existía un boundary listo para futuras mejoras visuales o de organización

El problema resuelto en esta subfase es estrictamente estructural.

---

## Scope

Esta subfase incluye:

- creación del boundary mínimo `lib/features/payment_methods/`
- extracción del diálogo de medios de pago a un archivo propio
- creación de una route/popup dedicada para abrir el overlay
- actualización del dashboard para delegar la apertura a la nueva feature
- preservación total del contrato y del contenido funcional actual

No incluye:

- pago dentro de la app
- cambios backend
- cambio del modelo de datos de login
- rediseño visual profundo
- incorporación obligatoria de barcode visual
- eliminación de legacy no activo

---

## Root Cause Analysis

La feature de dashboard fue consolidada antes de que Payment Methods recibiera una normalización estructural propia.

Eso dejó una deuda puntual:

- la funcionalidad ya existía y estaba en uso
- pero seguía embebida donde nació inicialmente
- sin archivo propio
- sin route propia
- sin ownership explícito

Este tipo de deuda es esperable después de fases de estabilización y cierre funcional.
La subfase 14.3.2.1 corrige exactamente esa condición sin reabrir diseño de producto ni arquitectura transversal.

---

## Files Affected

### New files

- `lib/features/payment_methods/presentation/overlays/payment_methods_dialog.dart`
- `lib/features/payment_methods/presentation/overlays/payment_methods_dialog_route.dart`

### Updated files

- `lib/features/dashboard/presentation/dashboard_page.dart`

---

## Implementation Characteristics

### 1. New feature-local overlay owner

Se crea `payment_methods_dialog.dart` como owner canónico del diálogo informativo.

Ese archivo pasa a concentrar:

- título del diálogo
- render de alias y códigos
- render de saldo / último pago / vencimiento
- acción de cierre
- fallback `No disponible`

Con esto, el dashboard deja de ser el owner del detalle interno de medios de pago.

### 2. Dedicated popup route

Se crea `payment_methods_dialog_route.dart` como punto de importación estable para abrir la surface.

Esto alinea Payment Methods con el patrón ya usado en otras partes del proyecto, donde el caller no necesita conocer el detalle interno completo del overlay.

### 3. Dashboard delegation

`dashboard_page.dart` conserva el trigger `Ver medios de pago`, pero deja de construir el diálogo inline.

Ahora el dashboard:

- mantiene el botón visible en el `InfoCard` de saldo
- delega la apertura al popup route de Payment Methods
- reduce su responsabilidad a disparar la feature

### 4. Functional preservation

No se modifica la naturaleza de la surface.
Se mantiene como una pantalla/overlay de consulta informativa para pago externo.

No se incorporan:

- botones de pago real
- estados transaccionales
- provider específico
- checkout
- pasarela

### 5. Backend contract preserved

La source actual continúa siendo `ServiceProviderLoginDataUserMessageModel`.

No se alteran:

- nombres de campos
- parseo
- wiring backend
- controlador de dashboard

---

## Validation

La subfase se considera correctamente implementada si el ZIP resultante permite verificar todo lo siguiente:

- existe `lib/features/payment_methods/presentation/overlays/`
- el diálogo ya no vive inline dentro de `dashboard_page.dart`
- `dashboard_page.dart` sigue exponiendo el botón `Ver medios de pago`
- al accionar el botón, la feature abre el mismo contenido funcional ya soportado
- la surface sigue siendo solo informativa
- no se introdujo semántica de pago in-app
- el backend contract permanece intacto

No se ejecutó build local dentro de este entorno de trabajo, por lo que la validación de compilación queda delegada a tu verificación habitual sobre el proyecto real.

---

## Release Impact

No hay impacto de release, packaging ni publicación.

El impacto es exclusivamente interno a la organización del código:

- mejora ownership
- reduce acoplamiento del dashboard
- deja lista la base para las siguientes subfases de 14.3

---

## Risks

### Riesgo 1 — considerar esta surface como checkout

Podría inducir a futuras implementaciones a tratar la feature como si ya fuera transaccional.

Mitigación:
- mantener explícita la definición de surface informativa

### Riesgo 2 — sobrediseño prematuro

Podría tentarse crear demasiadas capas para una surface aún simple.

Mitigación:
- esta subfase crea solo el boundary mínimo y el overlay propio

### Riesgo 3 — cambio funcional accidental

Al extraer el diálogo podría alterarse texto, orden o fallback.

Mitigación:
- la extracción se hizo conservando el contenido actual, no rediseñándolo

---

## What it does NOT solve

Esta subfase no resuelve todavía:

- visual refresh del diálogo
- barcode renderizado como elemento visual
- posible adapter/view-data específico
- mejora de densidad o estilo del overlay
- decisión final sobre `lib/widgets/barcode_widget.dart`
- pago del servicio desde la app

Todo eso queda fuera de 14.3.2.1.

---

## Conclusion

Phase 14.3.2.1 queda implementada como el primer corte controlado de normalización estructural para Payment Methods.

El sistema mantiene exactamente la misma función observable:

- mostrar datos de pago enviados por backend
- permitir consultarlos y copiarlos
- seguir pagando fuera de la plataforma

La diferencia es que ahora esa surface deja de vivir como detalle incrustado del dashboard y pasa a tener un boundary propio, preparando el terreno para la continuación segura de 14.3.2.
