# 🧩 Phase 7.1.2 — Dashboard Extraction

---

## 🎯 Objective

Separar la lógica de aplicación actualmente embebida en `dashboard_page.dart` hacia un controller específico de dashboard, manteniendo intacto el comportamiento visual y funcional existente, y preservando completamente el runtime actual del sistema.

---

## 🧠 Initial Context

Luego de completar Phase 7.1.1 (Auth Extraction), el siguiente punto lógico y seguro dentro de UI / Logic Decoupling era dashboard.

En el estado real del proyecto, `lib/features/dashboard/presentation/dashboard_page.dart` seguía coordinando directamente responsabilidades como:

- resolución del usuario logueado
- resolución del cliente activo
- armado de opciones para selección de cliente
- cambio de cliente
- logout orchestration
- preparación de datos auxiliares para título y acciones del `AppBar`

Esto seguía colocando lógica de aplicación dentro de una widget de presentación.

---

## ❗ Problem Statement

`dashboard_page.dart` no solo renderizaba UI, sino que además resolvía y ejecutaba decisiones de capa de aplicación.

Eso incluía:

- leer `loggedUser`
- decidir qué cliente era el activo
- traducir el cliente actual a un display name presentable
- construir la lista de clientes disponibles
- coordinar cambio de cliente
- limpiar sesión y disparar logout

Esto provocaba:

- responsabilidades mezcladas en la widget principal del dashboard
- mayor dificultad para mantenimiento
- duplicación potencial futura si otras vistas necesitaran la misma lógica
- continuidad del acoplamiento UI ↔ runtime luego de haber desacoplado auth

---

## 📦 Scope

INCLUYE:

- creación de un controller específico de dashboard
- extracción de resolución de cliente activo
- extracción de display name de cliente
- extracción de lista de opciones de cliente
- extracción de acción de cambio de cliente
- extracción de logout orchestration

NO INCLUYE:

- cambio de backend
- cambio de ServiceProvider
- cambio de billing
- cambio de navegación
- cambio visual
- state management global

---

## 🔍 Root Cause Analysis

Dashboard es la pantalla principal del usuario y fue evolucionando como punto central de interacción.

Eso hizo que la widget terminara absorbiendo responsabilidades que, aunque cercanas a la experiencia visual, pertenecen realmente a una capa de coordinación de aplicación.

Resultado:

- la pantalla principal mezclaba render con decisiones operativas del runtime del usuario logueado

---

## 📁 Files Affected

NUEVOS:

- lib/features/dashboard/controllers/dashboard_controller.dart

MODIFICADOS:

- lib/features/dashboard/presentation/dashboard_page.dart

DOCUMENTACIÓN:

- docs/phase7_application_layer_consolidation.md
- docs/phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md
- docs/index.md
- docs/development.md
- docs/decisions.md

SIN CAMBIOS:

- lib/core/*
- lib/shared/*
- ServiceProvider
- backend contract
- billing widget logic

---

## ⚙️ Implementation Characteristics

- se introduce `DashboardController`
- el controller encapsula:
  - resolución de `loggedUser`
  - resolución de cliente activo
  - normalización del nombre visible del cliente
  - construcción de opciones de selección de cliente
  - `selectClient(...)`
  - `logout(...)`

- la widget conserva:
  - render de `Scaffold`
  - construcción del `AppBar`
  - `PopupMenuButton`
  - `AlertDialog`
  - render de tarjetas informativas
  - render de `BillingWidget`

- el diálogo de métodos de pago continúa en presentación porque es estrictamente UI

- comunicación:
  UI → DashboardController → ServiceProvider / SessionStorage

---

## ✅ Validation

Criterios:

- dashboard sigue renderizando igual
- cliente activo sigue resolviéndose correctamente
- selector de cliente sigue funcionando
- logout sigue limpiando sesión y disparando salida
- facturas y recibos siguen visibles
- diálogo de métodos de pago sigue funcionando

Pruebas:

- login exitoso
- render de dashboard
- selección de otro cliente
- cambio visual del cliente actual
- logout
- acceso a facturas / recibos
- apertura y cierre del diálogo “Mostrar cómo pagar”

---

## 🚀 Release Impact

- reduce acoplamiento en la pantalla principal de usuario
- deja dashboard alineado con el patrón ya iniciado en auth
- prepara el terreno para 7.1.3 sin tocar backend
- no impacta a usuarios finales funcionalmente

---

## ⚠️ Risks

- alterar involuntariamente la semántica del cliente activo
- modificar el orden efectivo de logout
- generar diferencias entre web y mobile en el `AppBar`

Mitigación:

- extracción conservadora
- ServiceProvider permanece intacto
- la widget conserva la construcción visual
- el controller solo absorbe coordinación de aplicación

---

## ❌ What it does NOT solve

- no desacopla billing todavía
- no introduce state management global
- no redefine navegación
- no cambia layout ni theming
- no convierte dashboard en una pantalla totalmente state-driven

---

## 🧾 Conclusion

Phase 7.1.2 continúa correctamente la subfase 7.1 extrayendo la lógica de coordinación del dashboard hacia un controller dedicado. Con esto, la pantalla principal queda más enfocada en presentación y menos en decisiones operativas, sin alterar runtime, backend ni comportamiento observable.