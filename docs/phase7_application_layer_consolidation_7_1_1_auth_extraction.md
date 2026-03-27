# 🧩 Phase 7.1.1 — Auth Extraction

---

## 🎯 Objective

Separar la lógica de negocio del flujo de autenticación actualmente embebida en la capa de presentación hacia una capa intermedia de controladores, manteniendo el comportamiento actual intacto y sin introducir cambios en el flujo de datos existente.

---

## 🧠 Initial Context

Luego de completar Phase 6 (Presentation Structure Cleanup), la estructura visual de la aplicación quedó ordenada y coherente. Sin embargo, el login seguía concentrando responsabilidades de capa de aplicación dentro de la UI, entre ellas:

- preparación de autologin
- validación de input
- coordinación con ServiceProvider
- persistencia de DNI recordado
- interpretación del resultado para la pantalla

Esto convertía a `login_widget.dart` en una pantalla con lógica de negocio mezclada con render.

---

## ❗ Problem Statement

La pantalla de login contenía lógica que no debía seguir viviendo en la UI:

- lectura de sesión recordada
- decisión de autologin
- normalización del DNI
- request de login
- decisión de persistir el DNI
- traducción del resultado a un formato consumible por presentación

Esto provocaba:

- acoplamiento innecesario entre UI y runtime
- menor reutilización
- dificultad para validar la lógica por separado
- base débil para continuar con extracción en otras features

---

## 📦 Scope

INCLUYE:

- creación de un controller específico de auth
- extracción de la lógica de autologin
- extracción de validación básica de input
- extracción de request login
- extracción de persistencia de sesión recordada

NO INCLUYE:

- cambio de estado global
- cambio de backend
- refactor de ServiceProvider
- rediseño visual
- cambio de navegación global

---

## 🔍 Root Cause Analysis

La pantalla de autenticación evolucionó como entry point funcional del sistema.

Esa evolución hizo que la UI terminara asumiendo responsabilidades que corresponden a una capa intermedia de aplicación:

- preparar estado inicial
- decidir cuándo disparar login
- traducir outcomes del backend a resultados de uso de UI

Resultado:

- pantalla de login híbrida entre vista y lógica de aplicación

---

## 📁 Files Affected

NUEVOS:

- lib/features/auth/controllers/login_controller.dart

MODIFICADOS:

- lib/features/auth/presentation/login_widget.dart

DOCUMENTACIÓN:

- docs/phase7_application_layer_consolidation.md
- docs/phase7_application_layer_consolidation_7_1_1_auth_extraction.md

SIN CAMBIOS:

- lib/core/*
- lib/shared/*
- ServiceProvider
- backend contract

---

## ⚙️ Implementation Characteristics

- se introduce `LoginController`
- el controller encapsula:
  - lectura de DNI guardado
  - preparación del autologin
  - validación del input
  - disparo del login
  - persistencia de DNI recordado
  - normalización del resultado hacia presentación

- la widget conserva:
  - render
  - `TextEditingController`
  - `SnackBar`
  - animación de shake
  - `Navigator.pop`
  - lifecycle UI

- no se introduce aún state management global

- comunicación:
  UI → LoginController → ServiceProvider / SessionStorage

---

## ✅ Validation

Criterios:

- comportamiento visual idéntico
- autologin sigue funcionando
- request backend sin cambios
- mensajes de error intactos
- navegación intacta

Pruebas:

- login con DNI vacío
- login válido
- login inválido
- persistencia de recordarme
- reapertura con autologin

---

## 🚀 Release Impact

- mejora la mantenibilidad de auth
- reduce acoplamiento de login
- prepara Phase 7.1.2 sin tocar runtime productivo
- no impacta a usuarios finales

---

## ⚠️ Risks

- error en sincronización entre autologin y lifecycle UI
- pérdida accidental de persistencia recordarme
- cambio involuntario en mensajes de error

Mitigación:

- extracción mínima
- widget conserva feedback visual
- ServiceProvider no se modifica

---

## ❌ What it does NOT solve

- no unifica state management
- no encapsula dashboard
- no encapsula billing
- no redefine navegación
- no cambia arquitectura global

---

## 🧾 Conclusion

Phase 7.1.1 establece el patrón inicial de extracción segura dentro de Phase 7. El login deja de concentrar lógica de aplicación dentro de la UI y pasa a delegar en un controller específico, sin alterar backend, runtime ni experiencia final.