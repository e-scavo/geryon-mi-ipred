# 🛠️ Development Guidelines

## Objective

Define the active development rules for Mi IP·RED so that future changes preserve the production runtime, respect the current architecture, and evolve the application in explicitly scoped phases.

## Initial Context

The current ZIP confirms a stable architecture with the following baseline:

- `presentation → controller → ServiceProvider`
- Phase 7.3 already closed
- Phase 7.4 completed and formally closed
- Phase 7.5 completed and formally closed
- Phase 8 opened as a new runtime-hardening phase
- Phase 8.1 documented as runtime failure surface inventory

That means the closed structural baseline of Phase 7 remains valid and must not be reopened implicitly.

## Problem Statement

Without updated rules, later work could easily overreach in one of two directions:

- continue reopening closed application-layer concerns under the old Phase 7 scope
- mix runtime reliability work with stealth rearchitecture

The current dominant risk is no longer application-layer ambiguity.

The current dominant risk is runtime hardening being performed without explicit operational scope.

## Scope

These rules apply to work touching:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/**`
- `lib/models/GeneralLoadingProgress/**`
- `lib/models/ServiceProvider/**`
- `lib/core/transport/**`
- `lib/core/session/**`
- current Phase 8 documents

These rules do not authorize:

- backend protocol redesign
- ServiceProvider replacement
- navigation redesign
- UI redesign
- broad coordinator introduction
- state-management rearchitecture

## Root Cause Analysis

Phase 7 solved the structural consolidation problem.

The current ZIP now shows a different kind of remaining concern:

- runtime-global failure boundaries
- reconnect / reboot / retry behavior
- heterogeneous failure presentation surfaces
- feature-local errors dependent on runtime-global validity
- operational sequencing hotspots

That means the repository has entered a runtime hardening stage, not a structural cleanup stage.

## Files Affected

Main files governed by the current baseline include:

- `lib/main.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/features/contracts/application_coordinator.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/ServiceProvider/init_stages_enum_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/models/ServiceProvider/login_continuation_result_model.dart`
- `lib/models/ServiceProvider/auth_requirement_model.dart`
- `lib/core/transport/geryonsocket_model.dart`
- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/core/transport/geryonsocket_model_web.dart`

## Implementation Characteristics

### 1. The architecture remains frozen

All new work must preserve:

- `presentation → controller → ServiceProvider`

That remains the active baseline.

No Phase 8 change may be justified by pretending the current architecture is still unresolved.

### 2. Runtime hardening must stay runtime-focused

Phase 8 work is allowed to harden:

- failure semantics
- retry behavior
- reconnect behavior
- reboot behavior
- operational recovery boundaries
- diagnostic signaling

Phase 8 work is not allowed to drift into:

- broad structural extraction
- new global service layers
- widget/controller responsibility inversion
- navigation flow redesign

### 3. ServiceProvider may be hardened, not replaced

ServiceProvider remains the runtime source and owner of authenticated runtime lifecycle.

It may be:

- clarified
- normalized
- hardened
- made more explicit operationally

It must not be:

- replaced
- bypassed by a new global engine
- fragmented into speculative new runtime layers

### 4. Widgets must not become recovery owners

Widgets may display failure state and trigger explicit user actions.

They must not become the place where runtime policy is invented ad hoc.

Operational policy must remain anchored in explicit runtime boundaries.

### 5. Feature-local failure versus runtime-global failure must stay explicit

All future changes must distinguish between:

- failures that only affect one feature
- failures that invalidate the current runtime continuation

This distinction is mandatory for Phase 8.

### 6. Phase 8 must proceed in explicit subphases

Recommended order:

- `8.1 — Runtime Failure Surface Inventory`
- `8.2 — Failure Boundary Normalization`
- `8.3 — Retry / Reboot / Reconnect Policy Hardening`
- `8.4 — Runtime Diagnostic & Observability Signals`
- `8.5 — Formal Closure of Phase 8`

No implementation should skip the documentary justification of the current subphase.

### 7. No hidden redesign under the label of hardening

The following remain explicitly disallowed unless the ZIP later proves a narrowly justified need:

- broad application coordinator expansion
- event-bus introduction
- global error framework replacement
- navigation replacement
- feature-state ownership redesign
- backend contract redesign

## Validation

Future work is aligned with the current baseline only if all of the following remain true:

- the architecture remains `presentation → controller → ServiceProvider`
- runtime hardening stays narrower than redesign
- feature-local logic remains outside widgets where already extracted
- ServiceProvider remains the runtime owner
- failures are analyzed before semantics are normalized
- semantics are normalized before policy is hardened
- policy is hardened before documentary closure

## Release Impact

These guidelines have no direct user-facing release impact.

They protect the repository from mixing runtime hardening with structural redesign and keep Phase 8 scoped correctly.

## Risks

If these rules are ignored, future work may:

- reopen closed Phase 7 concerns
- disguise rearchitecture as reliability work
- normalize failure behavior inconsistently
- introduce recovery logic in the wrong layer
- destabilize the current production runtime

## What it does NOT solve

This document does not itself:

- classify failures
- harden reconnect behavior
- fix runtime hotspots
- unify failure presentation
- implement observability

It only defines the rules under which that work must occur.

## Conclusion

The current development baseline is now:

- Phase 7 closed
- structural consolidation frozen
- Phase 8 active
- runtime reliability and failure semantics as the correct current scope

All future implementation must respect that boundary.
