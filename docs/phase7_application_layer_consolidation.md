# 🧩 Phase 7 — Application Layer Consolidation

## Objective

Consolidate the application layer of Mi IP·RED by progressively separating presentation from business interaction logic, introducing an explicit controller layer, and preparing the codebase for future state and navigation normalization without altering backend behavior or the existing runtime contract.

---

## Initial Context

After Phase 6 completion:

- presentation structure is normalized
- shared UI and feature UI are clearly separated
- canonical import paths are active
- ServiceProvider remains stable and protected
- runtime behavior is preserved in production

However, structural normalization alone did not fully solve the next architectural debt layer:

- feature widgets still contain business-oriented logic
- pages still coordinate backend-adjacent actions directly
- UI state and application flow decisions are still mixed together
- feature boundaries exist physically but not yet behaviorally

This means the repository is now visually ordered, but the application layer still needs behavioral consolidation.

---

## Problem Statement

The current system has a normalized presentation structure, but presentation widgets still perform responsibilities that belong to an intermediate application layer.

Examples of these responsibilities include:

- login orchestration
- autologin preparation
- request triggering
- response interpretation
- error translation for UI decisions
- client-sensitive reload coordination

As a result:

- widgets are harder to maintain
- business-adjacent logic is harder to test
- future state unification would be risky
- feature growth would continue increasing coupling

---

## Scope

### Included

- introduction of controller/application-layer primitives
- progressive extraction of business-adjacent logic from widgets
- preservation of existing feature presentation structure
- preparation for state architecture consolidation
- documentation alignment for Phase 7

### Excluded

- backend protocol changes
- ServiceProvider redesign
- runtime flow redesign
- navigation redesign in the first subphase
- full state-management migration in the first subphase
- UI redesign

---

## Root Cause Analysis

Mi IP·RED evolved under production-driven priorities.

That produced a natural sequence:

1. make runtime work
2. stabilize backend communication
3. normalize structure
4. only then isolate responsibilities

This was appropriate operationally, but it left an architectural residue:

- widgets became execution coordinators
- feature screens accumulated direct backend interaction details
- local UI state started representing application state
- responsibility boundaries remained implicit instead of explicit

Now that Phase 6 established structural clarity, Phase 7 can safely address responsibility clarity.

---

## Files Affected

### New structural area introduced in Phase 7

- lib/features/*/controllers/

### Existing areas progressively affected

- lib/features/*/presentation/*
- docs/index.md
- docs/development.md
- docs/decisions.md
- docs/phase7_application_layer_consolidation.md

### Protected areas

- lib/core/*
- lib/models/ServiceProvider/*
- backend contract-related models

---

## Implementation Characteristics

Phase 7 is intentionally incremental and risk-aware.

### Phase 7.1 — UI / Logic Decoupling

Goal:

- extract business-adjacent logic from widgets into controllers
- keep widgets focused on rendering and interaction delegation

Characteristics:

- no backend behavior changes
- no protocol changes
- no ServiceProvider public behavior changes
- no navigation redesign

Initial safe target:

- authentication presentation logic

---

### Phase 7.2 — State Coordination Boundaries

Goal:

- clarify what is local widget state vs application state
- reduce ad-hoc state coordination inside presentation widgets

Characteristics:

- still conservative
- may introduce feature-level state abstractions
- must preserve current Riverpod runtime behavior

---

### Phase 7.3 — Feature Encapsulation Reinforcement

Goal:

- make feature directories behaviorally coherent, not only structurally coherent
- reduce cross-feature knowledge leakage

Characteristics:

- move feature-owned orchestration closer to feature boundaries
- avoid presentation widgets reaching too deeply into generic runtime primitives

---

### Phase 7.4 — Navigation / Flow Normalization Preparation

Goal:

- document and prepare route/flow ownership boundaries
- identify where login, dashboard, logout, and customer-switch behavior should live

Characteristics:

- preparatory in nature unless runtime-safe centralization is possible
- must remain compatible with current app startup flow

---

## Validation

Validation for Phase 7 must remain runtime-first.

Mandatory checks for each subphase:

- application startup
- initial loading flow
- login flow success
- login flow failure
- autologin behavior
- dashboard rendering
- billing rendering
- customer switch behavior
- logout behavior
- return to initial state

Additional Phase 7-specific checks:

- widgets no longer duplicate business-adjacent logic removed to controllers
- extracted controllers do not introduce UI rendering concerns
- no backend request semantics are modified
- canonical feature imports remain coherent

---

## Release Impact

Expected user-facing impact:

- none functionally
- zero protocol impact
- zero backend dependency changes

Expected engineering impact:

- lower UI coupling
- clearer ownership of orchestration logic
- safer base for future state and navigation work
- improved maintainability and testability

---

## Risks

Main risks:

- extracting logic too aggressively
- moving logic that is still tightly lifecycle-dependent
- accidentally changing runtime ordering
- introducing controller abstractions that are too generic too early

Mitigation strategy:

- one safe feature entry point first
- keep ServiceProvider untouched
- preserve widget lifecycle decisions where necessary
- validate after each extraction

---

## What it does NOT solve

Phase 7 does not immediately solve:

- complete state-management redesign
- domain-layer formalization
- navigation architecture replacement
- session persistence redesign
- backend abstraction replacement
- visual redesign

Those may be addressed later, but only once controller extraction is proven safe.

---

## Conclusion

Phase 7 is the next logical step after Phase 6.

Phase 6 clarified where presentation lives.
Phase 7 clarifies what presentation should and should not do.

By introducing a conservative application/controller layer and extracting business-adjacent logic progressively, Mi IP·RED can continue evolving without risking the production runtime already stabilized in earlier phases.