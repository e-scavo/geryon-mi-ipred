# 🧩 Phase 7.1.3 — Billing Extraction

---

## 🎯 Objective

Separar la lógica de aplicación actualmente embebida en `billing_widget.dart` hacia un controller específico de billing, manteniendo intacto el comportamiento visual y funcional existente, y preservando completamente el runtime actual del sistema.

---

## 🧠 Initial Context

Luego de completar Phase 7.1.1 (Auth Extraction) y Phase 7.1.2 (Dashboard Extraction), el siguiente punto lógico dentro de UI / Logic Decoupling era billing.

En el estado real del proyecto, `lib/features/billing/presentation/billing_widget.dart` seguía coordinando directamente responsabilidades como:

- generación y resolución de `threadHashID`
- creación y configuración de `GenericDataModel<TableComprobantesVTModel>`
- armado de `HeaderParamsRequest`
- armado de `threadParams`
- request de comprobantes con `filterSearchFromDropDown(...)`
- validación tipada de `rawData`
- aplicación de datos al `GenericDataModel`
- refresh ante cambio de cliente

Eso seguía colocando lógica de aplicación dentro de una widget de presentación.

---

## ❗ Problem Statement

`billing_widget.dart` no solo renderizaba UI, sino que además resolvía y ejecutaba decisiones de capa de aplicación.

Eso incluía:

- preparar el modelo de datos asociado al thread actual
- decidir cómo consultar comprobantes según el cliente activo
- traducir la respuesta del backend a una estructura lista para render
- refrescar la carga cuando cambia `cCliente`
- normalizar el contenido de la tabla

Esto provocaba:

- responsabilidades mezcladas dentro de la widget de billing
- mayor complejidad de mantenimiento
- baja reutilización de la lógica de carga
- continuidad del acoplamiento UI ↔ runtime luego de haber desacoplado auth y dashboard

---

## 📦 Scope

INCLUYE:

- creación de un controller específico de billing
- extracción de preparación del `GenericDataModel`
- extracción del armado de params de consulta
- extracción del request de comprobantes
- extracción de validación tipada de respuesta
- extracción de aplicación de resultados al modelo de datos
- extracción de normalización de filas para tabla

NO INCLUYE:

- cambio de backend
- cambio de ServiceProvider
- cambio de `SimpleTableWithScrollLimit`
- cambio de `WindowWidget`
- cambio visual
- state management global
- rediseño del lifecycle de la widget

---

## 🔍 Root Cause Analysis

Billing fue creciendo como un componente reutilizable de presentación, pero terminó absorbiendo lógica de coordinación que realmente corresponde a una capa intermedia de aplicación.

Esto ocurrió porque:

- el componente necesitaba consultar datos remotos
- el refresh dependía del cliente activo
- la respuesta debía validarse y transformarse antes del render

Resultado:

- la widget terminó mezclando render, lifecycle y request orchestration en un único lugar

---

## 📁 Files Affected

NUEVOS:

- lib/features/billing/controllers/billing_controller.dart

MODIFICADOS:

- lib/features/billing/presentation/billing_widget.dart

DOCUMENTACIÓN:

- docs/phase7_application_layer_consolidation.md
- docs/phase7_application_layer_consolidation_7_1_3_billing_extraction.md
- docs/index.md
- docs/development.md
- docs/decisions.md

SIN CAMBIOS:

- lib/core/*
- lib/shared/*
- ServiceProvider
- backend contract
- WindowWidget
- SimpleTableWithScrollLimit

---

## ⚙️ Implementation Characteristics

- se introduce `BillingController`
- el controller encapsula:
  - resolución de `threadHashID`
  - creación y configuración de `GenericDataModel<TableComprobantesVTModel>`
  - armado de params de consulta
  - request de comprobantes
  - validación de `CommonDataModelWholeMessage<TableComprobantesVTModel>`
  - carga de `cData`, `totalRecords`, `totalFilteredRecords`
  - normalización de filas para tabla

- la widget conserva:
  - `ProviderSubscription`
  - `initState`
  - `dispose`
  - detección de cambio de cliente
  - `setState`
  - loading / error UI
  - `WindowWidget`
  - `SimpleTableWithScrollLimit`

- el lifecycle visual sigue en presentación porque depende de `mounted`, `setState` y del flujo del widget

- comunicación:
  UI → BillingController → GenericDataModel / ServiceProvider

---

## ✅ Validation

Criterios:

- facturas siguen cargando correctamente
- recibos siguen cargando correctamente
- refresh por cambio de cliente sigue funcionando
- loading sigue mostrándose durante la carga
- errores siguen mostrándose en el UI actual
- render visual de billing permanece igual

Pruebas:

- login exitoso
- render de dashboard completo
- carga inicial de facturas
- carga inicial de recibos
- cambio de cliente
- refresh de facturas y recibos luego del cambio
- logout
- reingreso y nueva carga correcta

---

## 🚀 Release Impact

- reduce acoplamiento dentro de billing
- completa el tercer paso principal de desacoplamiento UI / lógica en Phase 7.1
- deja preparada la evaluación de cierre de 7.1
- no impacta a usuarios finales funcionalmente

---

## ⚠️ Risks

- alterar involuntariamente la secuencia de preparación del `GenericDataModel`
- cambiar el orden efectivo del refresh ante cambio de cliente
- introducir diferencias entre carga inicial y refresh posterior
- afectar la validación tipada de `rawData`

Mitigación:

- extracción conservadora
- ServiceProvider permanece intacto
- la widget conserva lifecycle y render
- el controller solo absorbe coordinación de datos

---

## ❌ What it does NOT solve

- no redefine state management
- no rediseña billing visualmente
- no modifica dashboard flow
- no redefine navegación
- no reemplaza `GenericDataModel`
- no introduce una arquitectura reactiva nueva para tablas

---

## 🧾 Conclusion

Phase 7.1.3 completa la extracción del flujo principal de billing hacia un controller dedicado, manteniendo la widget enfocada en lifecycle y presentación. Con esto, auth, dashboard y billing ya siguen el mismo patrón base de desacoplamiento dentro de Phase 7.1, dejando el proyecto listo para evaluar cierre de la subfase o una limpieza final mínima si todavía fuera necesaria.