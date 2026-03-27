# 🧠 Decisions — Phase 7 Alignment

## Objective

Record the active architectural decisions that define how Mi IP·RED must be interpreted and evolved after the closure of Phase 7.2 and the opening of Phase 7.3.

## Initial Context

Phase 7 of Mi IP·RED has not been a single one-step refactor.

It has progressed in layers:

- Phase 7.1 extracted feature-local controllers
- Phase 7.2 clarified ownership and state boundaries
- Phase 7.3 now begins documenting and normalizing application-flow coordination

These decisions capture the baseline that must remain stable while the next subphases continue.

## Problem Statement

Without an explicit decisions document, future work could misread the current repository and incorrectly assume one of the following:

- that Phase 7 is still mainly about more state cleanup
- that ServiceProvider should now become a global app coordinator
- that cross-feature coordination does not exist because it lacks a dedicated coordinator
- that distributed coordination can be abstracted safely without first inventorying it

Those assumptions would be incorrect according to the current ZIP.

## Scope

These decisions govern:

- interpretation of the current runtime
- sequencing of future Phase 7.3 work
- allowed architectural moves
- prohibited shortcuts and over-reaches

They do not implement behavior on their own.

## Root Cause Analysis

The current codebase reached a point where feature-local cleanup has already produced enough clarity to expose a new class of debt:

- real runtime flows still span multiple surfaces
- feature interaction is real but partially implicit
- downstream behavior is triggered through runtime context propagation rather than explicit contracts

This required a new decision set rather than continuing to extend the old Phase 7.2 framing.

## Files Affected

These decisions apply to:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/models/ServiceProvider/**`
- `lib/core/session/**`

They also govern:

- `docs/development.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`

## Implementation Characteristics

## Decision 1 — Preserve Backend Flow as Immutable Constraint

The backend communication model remains the highest-priority invariant.

This includes:

- handshake lifecycle
- token negotiation
- tracked request flow
- callback processing
- backend status validation
- login request semantics

All Phase 7.3 work must preserve these behaviors.

## Decision 2 — Structural and Application-Layer Work Must Not Imply Silent Behavioral Change

Phase 7 is a consolidation phase, not a runtime redesign phase.

That means documentation, refactors, and later coordination work must not silently alter actual runtime semantics.

## Decision 3 — Controllers Remain Feature-Local Boundaries

Phase 7.1 established controllers as feature-local application boundaries.

That remains the correct model.

Controllers are still the correct place for:

- feature-local orchestration
- feature-local state transitions
- feature-local derived-state rules

## Decision 4 — State Ownership Clarified in Phase 7.2 Remains Frozen as Baseline

Phase 7.2 clarified the distinction between:

- UI state
- feature functional state
- derived state
- global source state

That classification remains valid and should not be reopened casually inside Phase 7.3.

## Decision 5 — Transitional Mechanisms Preserved in Earlier Phases Remain Intentional

The current code still contains mechanisms such as:

- `ref.watch(notifierServiceProvider)` in dashboard
- `listenManual(...)` in billing
- startup-boundary logic in `main.dart`
- login-popup triggering inside `ServiceProvider`

These are not automatically mistakes.

They are conservative compatibility decisions aligned with runtime preservation.

## Decision 6 — Dashboard Uses Explicit Source-to-Derived Resolution

Dashboard derivation now flows through:

- `DashboardSourceState`
- `DashboardResolvedState`

That is the correct current dashboard interpretation.

Dashboard consumes runtime source state and derives render-ready feature state from it.

## Decision 7 — Billing Owns Feature State But Not Global Client Context

Billing owns its feature-local load lifecycle.

It does not own the global active client.

Billing reacts to client changes through the runtime source.

This remains the intended current arrangement.

## Decision 8 — Auth and Startup Boundaries Were Correctly Split but Remain Connected

The current app distinguishes:

- startup boundary completion
- login bootstrap state
- login submit state

That distinction was necessary and remains valid.

However, the runtime still connects those surfaces through real application flows, which is why Phase 7.3 exists.

## Decision 9 — Phase 7.2 Is Formally Closed

The current ZIP confirms that Phase 7.2 has already reached formal closure.

Future work must not keep extending it artificially.

## Decision 10 — Phase 7.3 Begins From Coordination, Not More State Cleanup

The strongest next architectural concern visible in the ZIP is not additional feature-local state cleanup.

It is:

- application-flow sequencing
- session/runtime transition ownership
- feature interaction visibility
- reduction of implicit controller coupling

Therefore, Phase 7.3 correctly begins as a coordination-focused phase.

## Decision 11 — Flow Inventory Must Precede Contracts or Coordinators

Before introducing:

- feature interaction contracts
- session/app-context normalization
- a minimal application coordinator

the project must first inventory the real flows already present in code.

This is why `7.3.1` is the correct first step.

## Decision 12 — Distributed Coordination Is Still Real Coordination

The current app already has cross-feature coordination even though it does not yet have a dedicated coordinator.

Examples verified in the ZIP include:

- startup → backend status → auth decision
- login success → authenticated runtime context → dashboard render
- dashboard client selection → runtime client mutation → billing reload
- logout → session clear → runtime reset → backend status fallback

The absence of a coordinator does not mean the absence of coordination.

## Decision 13 — ServiceProvider Remains the Runtime Source, Not the Automatic Future Coordinator

ServiceProvider remains:

- the backend/runtime source
- the holder of authenticated user context
- the holder of active client context
- the protected communication boundary

That does not automatically make it the correct place for all future app-flow coordination logic.

## Decision 14 — Downstream Reactions Must Stay Visible

A user action in one feature may trigger downstream effects in another feature.

That is already true in the real code.

Those dependencies must remain visible and documented rather than hidden under vague global refresh behavior.

## Decision 15 — Session Persistence, Authenticated User, Active Client, and Startup Readiness Are Distinct Concepts

The current runtime contains several related but non-equivalent concepts:

- saved DNI in `SessionStorage`
- authenticated user in `ServiceProvider.loggedUser`
- active client in `loggedUser.cCliente`
- provider readiness in `ServiceProvider.isReady`
- startup boundary completion in `AppStartupViewState`

They must not be collapsed into one unnamed concept before a dedicated normalization subphase.

## Validation

These decisions are validated against the current ZIP because the codebase shows all of the following:

- startup remains owned by `main.dart`
- login decision bridge remains in `ServiceProvider`
- authenticated runtime context is materialized in `doLoginCallback()`
- dashboard drives active-client changes
- billing reacts to client changes via runtime-source listening
- logout clears persisted session data and resets auth flow

## Release Impact

This decisions document has no direct release-facing runtime impact.

Its effect is to protect future implementation choices.

## Risks

Without these decisions, the project risks:

- over-designing Phase 7.3
- misusing ServiceProvider
- losing visibility over feature interaction
- reopening already-closed ownership problems
- introducing abstractions without proving the real need first

## What it does NOT solve

This document does not by itself implement:

- session/app-context normalization
- interaction contracts
- minimal coordinator logic
- tests

It only fixes the current architectural interpretation.

## Conclusion

The active interpretation of Mi IP·RED is now:

1. protect runtime behavior
2. preserve feature-local controller boundaries
3. preserve state-boundary clarity from Phase 7.2
4. treat flow coordination as the next explicit concern
5. inventory real flows before introducing new abstractions