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

- feature widgets still contained business-oriented logic
- pages still coordinated backend-adjacent actions directly
- UI state and application flow decisions were still mixed together
- feature boundaries existed physically but not yet behaviorally

Phase 7 was opened to address that gap safely and incrementally.

After Phase 7.1 formal closure:

- auth extraction is complete
- dashboard extraction is complete
- billing extraction is complete
- controller directories are now real runtime boundaries
- the main presentation surfaces no longer inline the same business-adjacent orchestration they previously contained

This created the correct baseline for the next step:

- state ownership clarification
- state derivation normalization
- reduction of manual coordination spread across widgets

---

## Problem Statement

Even with Phase 7.1 completed, presentation and startup surfaces still contain state coordination responsibilities that are not yet formally normalized.

The remaining problem is no longer primarily request orchestration.

The remaining problem is ownership and coordination of state.

This appears in different forms across the current codebase:

- widget-local state representing feature lifecycle state
- manual synchronization between widget lifecycle and feature reload behavior
- direct derivation of rendering state from ServiceProvider inside presentation/runtime surfaces
- startup flow state mixed with authentication-entry state
- implicit rather than explicit boundaries between:
  - UI state
  - feature functional state
  - derived state
  - global source state

As a result:

- feature ownership is still partially implicit
- future refactors would be riskier than necessary
- widget maintenance remains harder than it should be
- future application-layer abstractions would have an unclear foundation

---

## Scope

### Included

- introduction of controller/application-layer primitives
- progressive extraction of business-adjacent logic from widgets
- preservation of existing feature presentation structure
- preparation for state architecture consolidation
- documentation alignment for Phase 7
- subphase-based incremental extraction tracking
- formal closure of Phase 7.1 after runtime validation
- formal start of Phase 7.2 focused on state coordination boundaries
- inventory and ownership classification of current state holders
- clarification of startup/auth initial boundary as part of Phase 7.2 scope

### Excluded

- backend protocol changes
- ServiceProvider redesign
- runtime flow redesign
- navigation redesign in Phase 7.1
- full state-management migration in Phase 7.1
- UI redesign
- global application service layer introduction in Phase 7.2.1
- replacing Riverpod usage patterns globally in Phase 7.2.1

---

## Root Cause Analysis

Mi IP·RED evolved under production-driven priorities.

That produced a natural sequence:

1. make runtime work
2. stabilize backend communication
3. normalize structure
4. isolate feature orchestration
5. only then normalize state coordination

This was appropriate operationally, but it left a second-order architectural residue:

- widgets stopped owning some business logic, but still own coordination logic
- startup and auth entry state remain partially mixed
- derived state is still resolved ad hoc in some runtime surfaces
- local widget state sometimes represents feature execution state rather than purely UI state
- controller extraction improved separation, but did not yet finalize ownership rules

Phase 7.2 exists to address that residue without collapsing multiple architectural concerns into a single risky rewrite.

---

## Files Affected

### New structural area introduced in Phase 7

- lib/features/*/controllers/

### Existing areas progressively affected

- lib/features/*/presentation/*
- lib/main.dart
- docs/index.md
- docs/development.md
- docs/decisions.md
- docs/phase7_application_layer_consolidation.md
- docs/phase7_application_layer_consolidation_7_1_1_auth_extraction.md
- docs/phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md
- docs/phase7_application_layer_consolidation_7_1_3_billing_extraction.md
- docs/phase7_application_layer_consolidation_7_2_1_feature_state_inventory.md

### Residual document resolved at formal closure

- docs/phase7_application_layer_consolidation_7_1_ui_logic_decoupling.md

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
- no state-management redesign
- controller introduction remains feature-local

Implemented and validated subphases:

- 7.1.1 — Auth extraction
- 7.1.2 — Dashboard extraction
- 7.1.3 — Billing extraction

Formal status:

- Phase 7.1 is closed

Closure meaning:

- auth no longer performs application coordination inline in the widget
- dashboard no longer performs customer/session coordination inline in the widget
- billing no longer performs request preparation and backend-facing data shaping inline in the widget
- the original UI / Logic Decoupling objective has been achieved for the main authenticated runtime surface

---

### Phase 7.2 — State Coordination Boundaries

Goal:

- clarify what is local widget state vs application state
- reduce ad-hoc state coordination inside presentation widgets
- normalize derived state boundaries
- prepare future abstractions without altering runtime behavior

Characteristics:

- still conservative
- must preserve current Riverpod runtime behavior
- must not redesign ServiceProvider
- must not redesign navigation
- must not migrate the app to a new state-management model
- must remain reversible and feature-local where possible

Important scope clarification derived from the real ZIP state:

Phase 7.2 is not limited to feature widgets only.

It must also include the startup/auth initial boundary, because the current runtime still distributes initial-state decisions across:

- lib/main.dart
- auth presentation
- session persistence
- ServiceProvider-backed runtime state

This makes the correct operational label for the phase:

- State Coordination Boundaries
- including Auth + Startup Initial Boundary Cleanup

Validated subphase structure:

- 7.2.1 — Feature State Inventory & Ownership Definition
- 7.2.2 — Billing State Boundary Consolidation
- 7.2.3 — Dashboard State Derivation Normalization
- 7.2.4 — Auth & Startup Initial State Boundary Cleanup
- 7.2.5 — Formal Closure of Phase 7.2

Current formal status:

- Phase 7.2 started
- 7.2.1 is the first safe step
- no runtime modification is required for 7.2.1
- 7.2.1 exists to freeze ownership before moving responsibilities

---

### Phase 7.3 — Feature Encapsulation Reinforcement

Goal:

- make feature directories behaviorally coherent, not only structurally coherent
- reduce cross-feature knowledge leakage

Characteristics:

- move feature-owned orchestration closer to feature boundaries
- avoid presentation widgets reaching too deeply into generic runtime primitives

Status:

- not started

---

### Phase 7.4 — Navigation / Flow Normalization Preparation

Goal:

- document and prepare route/flow ownership boundaries
- identify where login, dashboard, logout, and customer-switch behavior should live

Characteristics:

- preparatory in nature unless runtime-safe centralization is possible
- must remain compatible with current app startup flow

Status:

- not started

---

## Validation

### Phase 7.1 validation already completed

Validated behaviors from the prior closure baseline:

- login popup rendering
- login request flow
- login failure behavior
- login success behavior
- dashboard rendering
- customer switching
- billing load
- billing rendering
- logout

### Phase 7.2.1 validation target

Because 7.2.1 is documentation-first and code-neutral, validation for this subphase is architectural/documental consistency validation:

- the inventory must reflect real code
- ownership categories must match actual runtime usage
- no behavior must change
- no file ownership must be assumed without code evidence
- the next subphase order must be justified by real risk, not by preference

### Real ownership hotspots identified in the current ZIP baseline

Auth presentation:

- widget still coordinates initial autologin preparation
- widget-local loading currently mixes UI feedback with feature bootstrap state

Dashboard:

- controller resolves derived state directly from ServiceProvider-backed runtime data
- feature derivation exists, but boundary formalization is still incomplete

Billing:

- widget still owns the largest concentration of manual state coordination
- listenManual, local reload coordination, client-change tracking, and functional flags remain spread in presentation

Startup:

- app initialization state still participates in auth-entry flow decisions
- startup state and auth boundary are not yet fully explicit

---

## Release Impact

Phase 7.2.1 has no release-impacting runtime change.

Impact is limited to:

- architectural clarity
- ownership documentation
- safer sequencing for subsequent subphases
- reduced risk of incorrect state movement in future steps

This step exists specifically to avoid unsafe refactors in the next implementation subphases.

---

## Risks

### Main risk if this phase is skipped

Moving state boundaries without a formal inventory could cause:

- runtime regressions
- duplicated ownership
- hidden coupling between widget lifecycle and feature logic
- false assumptions about what belongs to ServiceProvider vs feature-local coordination
- accidental startup/auth regressions

### Risk inside Phase 7.2 itself

- overcorrecting toward a full state-management redesign
- pushing global abstractions too early
- moving too much state out of widgets without distinguishing UI state from feature functional state
- mixing navigation cleanup with state boundary cleanup

### Mitigation

- inventory first
- move only one boundary family at a time
- prioritize the most manual and widget-heavy coordination hotspot first
- preserve current runtime contract at every step

---

## What it does NOT solve

Phase 7 as a whole does not yet solve:

- a global application service architecture
- a complete state-management unification model
- navigation ownership centralization
- replacement of ServiceProvider as the global runtime source
- full startup flow redesign
- complete lifecycle-state normalization for all future features

Phase 7.2.1 specifically does not solve:

- billing state consolidation yet
- dashboard derivation normalization yet
- auth/startup boundary cleanup yet

It only defines and freezes the real ownership map needed before those steps.

---

## Conclusion

Phase 7 remains structurally coherent and operationally safe.

Phase 7.1 is fully complete and formally closed.

The next correct move is not a blind implementation change, but a controlled ownership-definition step.

The real codebase now shows a second-layer debt:

- request orchestration has been extracted
- state coordination boundaries are still partially implicit

For that reason, Phase 7.2 starts with 7.2.1:

- Feature State Inventory & Ownership Definition

This is the correct low-risk starting point because it turns implicit coordination into explicit architecture before any runtime-facing consolidation is attempted.