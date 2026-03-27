# 🧩 Phase 7.1 — UI / Logic Decoupling

---

## 🎯 Objective

Separar la lógica de negocio actualmente embebida en la capa de presentación (`pages/`) hacia una capa intermedia de controladores (Controllers / ViewModels), manteniendo el comportamiento actual intacto y sin introducir cambios en el flujo de datos existente.

---

## 🧠 Initial Context

Luego de completar Phase 6 (Presentation Structure Cleanup), la estructura visual de la aplicación se encuentra ordenada y coherente. Sin embargo, aún persiste acoplamiento entre:

- UI (Widgets / Pages)
- lógica de negocio
- manejo de estado local

Esto genera:

- baja reutilización
- dificultad de testing
- complejidad al escalar nuevas features

---

## ❗ Problem Statement

Las páginas (`lib/pages/*`) contienen:

- llamadas directas a ServiceProvider
- parsing de datos
- lógica condicional de negocio
- manejo de estado imperativo

Esto provoca:

- violación de separación de responsabilidades
- dificultad de mantenimiento
- duplicación de lógica en múltiples páginas

---

## 📦 Scope

INCLUYE:

- creación de capa Controller / ViewModel
- migración progresiva de lógica fuera de pages
- mantener UI como capa puramente declarativa

NO INCLUYE:

- cambio de estado global
- introducción de nuevos frameworks
- refactor de ServiceProvider
- cambios en backend

---

## 🔍 Root Cause Analysis

La evolución incremental del proyecto llevó a:

- crecimiento directo sobre UI
- falta inicial de patrón de estado
- urgencia por funcionalidad sobre arquitectura

Resultado:

- lógica distribuida sin capa intermedia

---

## 📁 Files Affected

NUEVOS:

- lib/features/*/controllers/
- lib/features/*/viewmodels/

MODIFICADOS:

- lib/pages/* (extracción de lógica)

SIN CAMBIOS:

- lib/core/*
- lib/shared/*
- ServiceProvider

---

## ⚙️ Implementation Characteristics

- Controllers encapsulan:
  - llamadas a ServiceProvider
  - transformación de datos
  - lógica de negocio

- Pages pasan a:
  - renderizar estado
  - delegar acciones

- No se introduce aún un sistema de estado global

- Comunicación:
  UI → Controller → ServiceProvider

---

## ✅ Validation

Criterios:

- comportamiento visual idéntico
- requests backend sin cambios
- logs equivalentes
- navegación intacta

Pruebas:

- login
- dashboard
- acciones principales

---

## 🚀 Release Impact

- mejora mantenibilidad
- facilita próximas fases (state, features)
- no impacta usuarios finales

---

## ⚠️ Risks

- duplicación temporal de lógica durante migración
- errores si no se respeta delegación completa

Mitigación:

- migración incremental por pantalla
- validación por feature

---

## ❌ What it does NOT solve

- no unifica state management
- no define navegación
- no reorganiza completamente features

---

## 🧾 Conclusion

Phase 7.1 establece la base para una arquitectura escalable desacoplando UI de lógica, sin introducir riesgos ni cambios en runtime. Es el paso necesario previo a la consolidación de estado y features en las siguientes subfases.