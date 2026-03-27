# 🧠 Decisions — Phase 7 Alignment

## Objective

Record the active architectural decisions that define how Mi IP·RED must be interpreted and evolved after the closure of Phase 7.2, the completion of Phase 7.3.1, and the implementation of Phase 7.3.2.

## Initial Context

Phase 7 of Mi IP·RED has progressed in layers:

- Phase 7.1 extracted feature-local controllers
- Phase 7.2 clarified ownership and state boundaries
- Phase 7.3.1 inventoried real application flows
- Phase 7.3.2 normalized session and app-context semantics

These decisions capture the baseline that must remain stable while the next subphases continue.

## Problem Statement

Without an explicit decisions document, future work could misread the current repository and incorrectly assume one of the following:

- that persisted login hint equals authenticated session
- that logout should keep clearing all storage forever
- that raw reads from `ServiceProvider` internals are the long-term shared-context contract
- that context normalization requires a new coordinator immediately

Those assumptions would be incorrect according to the current ZIP.

## Scope

These decisions govern:

- interpretation of the current runtime
- sequencing of future Phase 7.3 work
- allowed architectural moves
- prohibited shortcuts and over-reaches

They do not implement behavior on their own.

## Root Cause Analysis

The current codebase reached a point where feature-local cleanup and flow inventory already produced enough clarity to expose the next class of debt:

- shared runtime context was real
- but its semantics were still partially implicit
- and storage cleanup behavior was broader than the actual ownership of the logout path

This required a new decision set rather than stretching the previous 7.3.1 framing beyond its scope.

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
- `docs/phase7_application_layer_consolidation_7_3_2_session_app_context_normalization.md`

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

## Decision 5 — Flow Inventory Was Required Before Context Normalization

Phase 7.3.1 came before 7.3.2 on purpose.

The project first needed to map real flow ownership before normalizing the meaning of the contexts used by those flows.

That sequencing remains the correct interpretation of the current baseline.

## Decision 6 — Persisted Login Hint Is Not an Authenticated Session

The current storage abstraction only persists remembered DNI/CUIT information.

It must be interpreted as a persisted login hint.

It must not be documented or consumed as if it were a backend-validated authenticated session.

## Decision 7 — Authenticated Runtime Context Remains In-Memory and Owned by ServiceProvider

The actual authenticated runtime context continues to live in `ServiceProvider` through the in-memory authenticated user state.

That context remains owned by:

- login callback application
- runtime reset logic
- current runtime provider instance

Phase 7.3.2 did not move that ownership elsewhere.

## Decision 8 — Active Operational Context Is Distinct From “Logged In”

The active client/company context is a separate runtime concern from merely being authenticated.

It remains owned by `ServiceProvider` and is consumed downstream by features such as dashboard and billing.

That distinction must remain explicit.

## Decision 9 — Persisted Login Hint Lifecycle Must Be Symmetric

Remember-me behavior is now explicitly symmetric.

That means:

- save remembered DNI on successful login when requested
- remove remembered DNI on successful login when remember-me is disabled
- remove remembered DNI during logout cleanup

Leaving stale persisted login hints is no longer considered acceptable behavior.

## Decision 10 — Logout Cleanup Must Be Specific to Its Actual Responsibility

The dashboard logout path no longer clears all session storage blindly.

Its storage responsibility is limited to the persisted login hint it actually owns in the current architecture.

Broader storage cleanup would exceed the current semantic responsibility of logout.

## Decision 11 — ServiceProvider Remains the Runtime Source, Not the Automatic Future Coordinator

`ServiceProvider` remains:

- the backend/runtime source
- the holder of authenticated runtime context
- the holder of active operational context
- the protected communication boundary

That still does not automatically make it the place for future application coordination logic.

## Decision 12 — Shared Runtime Context May Be Read Through Explicit Accessors

Phase 7.3.2 introduced minimal read-only accessors on `ServiceProvider` for shared-context consumption.

This is now the preferred way for cross-feature consumers to read:

- authenticated user context
- active client index
- active client
- active company
- available clients

This reduces coupling without moving ownership.

## Decision 13 — Dashboard and Billing May Normalize Reads Without Owning Context

Dashboard and billing now consume normalized reads in their critical paths.

That does not change ownership.

They remain consumers of shared runtime context, not owners of it.

## Decision 14 — Startup Boundary Remains Separate

Startup readiness remains a distinct context owned by `main.dart` through `AppStartupViewState`.

Phase 7.3.2 did not merge it into storage or authenticated runtime context, and future phases must preserve that distinction unless explicitly redesigned later.

## Validation

These decisions are validated against the current ZIP because the codebase now shows all of the following:

- startup remains owned by `main.dart`
- persisted login hint now has explicit save/remove semantics
- authenticated runtime context is still materialized in `doLoginCallback()`
- active client/company context is still owned by `ServiceProvider`
- dashboard reads normalized shared-context accessors
- billing reads normalized shared-context accessors in its critical data-loading path
- logout removes remembered login hint explicitly and still resets runtime auth flow

## Release Impact

This decisions document has no direct release-facing runtime impact by itself.

Its effect is to protect future implementation choices.

## Risks

Without these decisions, the project risks:

- confusing persisted login hint with real session state
- over-designing 7.3.3 and 7.3.4
- losing visibility over context ownership
- reverting to broad storage cleanup behavior
- reintroducing raw provider-shape coupling as the implicit contract

## What it does NOT solve

This document does not by itself implement:

- backend-persisted authenticated session validation
- explicit feature interaction contracts
- minimal coordinator logic
- tests

It only fixes the current architectural interpretation.

## Conclusion

The active interpretation of Mi IP·RED is now:

1. protect runtime behavior
2. preserve feature-local controller boundaries
3. preserve state-boundary clarity from Phase 7.2
4. preserve flow inventory clarity from Phase 7.3.1
5. keep context concepts explicit and separate in Phase 7.3.2
6. use explicit shared-context reads before introducing later coordination contracts