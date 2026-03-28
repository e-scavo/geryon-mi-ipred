# 🧩 Phase 7 — Application Layer Consolidation

## Objective

Consolidate the application layer of Mi IP·RED by progressively clarifying feature boundaries, runtime ownership, cross-feature contracts, minimal coordination points, and the startup/auth continuation bridge while preserving the current production runtime.

## Initial Context

Mi IP·RED already worked before Phase 7, but still contained application-layer ambiguity around controller ownership, state boundaries, feature interaction, and startup/runtime continuation.

The current ZIP confirms the following progression:

- Phase 7.1 completed
- Phase 7.2 completed and formally closed
- Phase 7.3 completed and formally closed
- Phase 7.4 opened as a narrow startup/auth continuation hardening phase

At the current baseline:

- `presentation → controller → ServiceProvider` remains the active architecture
- `ServiceProvider` remains the runtime source for authenticated context
- startup continuation still depends on popup-based readiness flow
- the remaining narrow work focuses on auth requirement and continuation semantics

## Problem Statement

By the time Phase 7.3 closed, broad application coordination had already been clarified and bounded.

What remained was not a generic architecture issue, but one sensitive runtime bridge:

- startup
- backend status
- auth requirement
- login popup entry
- authenticated continuation

Phase 7.4 exists to harden that bridge incrementally.

## Scope

Phase 7 includes:

- controller extraction
- feature/state boundary clarification
- application-flow inventory
- session/app-context normalization
- feature interaction contracts
- minimal application coordinator
- startup/auth continuation hardening

Phase 7 does not include:

- backend redesign
- ServiceProvider replacement
- global application services
- event bus
- navigation redesign
- UI redesign
- state-management replacement

## Root Cause Analysis

The project needed to mature in a safe order:

1. preserve runtime behavior
2. clarify where application logic belongs
3. inventory real flows instead of assuming them
4. freeze interaction semantics
5. anchor only the narrowest safe coordination concerns
6. return to the remaining startup/auth continuation bridge

That is exactly the order the current ZIP reflects.

## Files Affected

Phase 7 work spans the following relevant areas:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/**`
- `lib/models/GeneralLoadingProgress/**`
- `lib/models/ServiceProvider/**`
- `lib/core/session/**`

Main documentation surfaces include:

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- all `docs/phase7_application_layer_consolidation_*.md`

## Implementation Characteristics

### Phase 7.1 — Feature Controller Extraction

Completed:

- `7.1.1 — Auth extraction`
- `7.1.2 — Dashboard extraction`
- `7.1.3 — Billing extraction`

Main result:

- widgets stopped carrying feature-orchestration logic directly
- feature-local controllers became the primary application boundary

### Phase 7.2 — State Boundary Clarification

Completed:

- `7.2.1 — Feature State Inventory & Ownership Definition`
- `7.2.2 — Billing State Boundary Consolidation`
- `7.2.3 — Dashboard State Derivation Normalization`
- `7.2.4 — Auth & Startup Initial State Boundary Cleanup`
- `7.2.5 — Formal Closure of Phase 7.2`

Main result:

- clearer ownership between UI state, feature state, derived state, and runtime state

### Phase 7.3 — Application Flow and Minimal Coordination Closure

Completed:

- `7.3.1 — Application Flow Inventory`
- `7.3.2 — Session & App Context Normalization`
- `7.3.3 — Feature Interaction Contracts`
- `7.3.4 — Application Coordinator (mínimo)`
- `7.3.5 — Formal Closure of Phase 7.3`

Main result:

- real flow semantics were documented
- shared runtime context meaning was normalized
- only the narrowest safe coordination concerns were retained

### Phase 7.4 — Startup/Auth Continuation Boundary Hardening

Current completed subphases:

- `7.4.1 — Startup/Auth Continuation Inventory`
- `7.4.2 — Auth Requirement Boundary Normalization`

#### 7.4.1 Outcome

Confirmed that the remaining sensitive block was still the startup/auth continuation bridge itself.

#### 7.4.2 Outcome

Normalized auth requirement through an explicit local model:

- `ServiceProviderAuthRequirementKind`
- `ServiceProviderAuthRequirement`

Also introduced:

- `ServiceProvider.evaluateAuthRequirement()` as the semantic source
- transitional mapping back to legacy `ErrorHandler` behavior
- removal of direct magic-code branching from `_handleBackendStatusSuccessFlow(...)`

This phase did **not** redesign popup ownership, startup boundary ownership, or login widget behavior.

## Validation

The Phase 7 baseline remains valid only if all of the following still hold:

- startup still completes correctly
- login popup still appears in the expected cases
- authenticated runtime context still lives in `ServiceProvider`
- billing refresh flow remains intact
- logout reset flow remains intact
- minimal coordinator remains narrow and unchanged

## Release Impact

Phase 7.4.2 has low intended release impact from the user perspective.

Its purpose is semantic hardening, not visible UX redesign.

## Risks

The main risk in late Phase 7 work is overreaching.

Incorrect follow-up work could:

- reopen Phase 7.3 implicitly
- broaden coordinator scope without justification
- redesign ServiceProvider too early
- confuse login hint persistence with authenticated runtime persistence

## What it does NOT solve

Phase 7, even after 7.4.2, does not yet solve:

- explicit login continuation contracts
- unified startup/logout auth continuation abstraction
- popup ownership relocation
- backend-persisted authenticated session validation

## Conclusion

Phase 7 remains a conservative application-layer consolidation phase.

The current ZIP confirms:

- Phase 7.1 closed
- Phase 7.2 closed
- Phase 7.3 closed
- Phase 7.4 active
- `7.4.2` completed as auth-requirement boundary normalization

The next safe target is:

- `Phase 7.4.3 — Login Resolution Continuation Contract`