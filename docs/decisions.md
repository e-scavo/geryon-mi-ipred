# 🧠 Decisions — Phase 7 Alignment

## Objective

Record the active architectural decisions that define how Mi IP·RED must be interpreted and evolved after the closure of Phase 7.2, the completion of Phase 7.3.1, the implementation of Phase 7.3.2, and the implementation of Phase 7.3.3.

## Initial Context

Phase 7 of Mi IP·RED has progressed in layers:

- Phase 7.1 extracted feature-local controllers
- Phase 7.2 clarified ownership and state boundaries
- Phase 7.3.1 inventoried real application flows
- Phase 7.3.2 normalized session and app-context semantics
- Phase 7.3.3 froze current cross-feature meaning as explicit interaction contracts

These decisions capture the baseline that must remain stable while the next subphases continue.

## Problem Statement

Without an explicit decisions document, future work could misread the current repository and incorrectly assume one of the following:

- that real feature interactions do not yet exist because there is no coordinator
- that current interactions are only incidental implementation details
- that introducing a coordinator can happen before freezing the current interaction meaning
- that declarative contracts should already execute runtime behavior

Those assumptions would be incorrect according to the current ZIP and the current phase baseline.

## Scope

These decisions govern:

- interpretation of the current runtime
- sequencing of future Phase 7.3 work
- allowed architectural moves
- prohibited shortcuts and over-reaches

They do not implement behavior on their own.

## Root Cause Analysis

The current codebase reached a point where feature-local cleanup, ownership clarification, flow inventory, and context normalization already produced enough clarity to expose the next class of debt:

- shared interaction meaning was real
- but it was still partially implicit
- and later phases would risk coordinating behavior whose meaning had not yet been frozen explicitly

This required a new decision set rather than stretching the previous 7.3.2 framing beyond its scope.

## Files Affected

These decisions apply to:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/**`
- `lib/models/ServiceProvider/**`
- `lib/core/session/**`

They also govern:

- `docs/development.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`
- `docs/phase7_application_layer_consolidation_7_3_2_session_app_context_normalization.md`
- `docs/phase7_application_layer_consolidation_7_3_3_feature_interaction_contracts.md`

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

## Decision 5 — Flow Inventory Had to Precede Context Normalization

Phase 7.3.1 came before 7.3.2 on purpose.

The project first needed to map real flow ownership before normalizing the meaning of the contexts used by those flows.

That sequencing remains the correct interpretation of the current baseline.

## Decision 6 — Context Normalization Had to Precede Contract Freezing

Phase 7.3.2 came before 7.3.3 on purpose.

The project first needed to separate:

- persisted login hint
- authenticated runtime context
- active operational context
- startup boundary context

Only after those meanings were explicit did it become safe to freeze interaction contracts built on top of them.

## Decision 7 — Persisted Login Hint Is Not an Authenticated Session

The current storage abstraction only persists remembered DNI/CUIT information.

It must be interpreted as a persisted login hint.

It must not be documented or consumed as if it were a backend-validated authenticated session.

## Decision 8 — Authenticated Runtime Context Remains In-Memory and Owned by ServiceProvider

The actual authenticated runtime context continues to live in `ServiceProvider` through the in-memory authenticated user state.

That context remains owned by:

- login callback application
- runtime reset logic
- current runtime provider instance

Later phases do not move that ownership elsewhere unless explicitly redesigned.

## Decision 9 — Active Operational Context Is Distinct From “Logged In”

The active client/company context is a separate runtime concern from merely being authenticated.

It remains owned by `ServiceProvider` and is consumed downstream by features such as dashboard and billing.

That distinction must remain explicit.

## Decision 10 — Persisted Login Hint Lifecycle Must Stay Symmetric

Remember-me behavior remains explicitly symmetric.

That means:

- save remembered DNI on successful login when requested
- remove remembered DNI on successful login when remember-me is disabled
- remove remembered DNI during logout cleanup

Leaving stale persisted login hints is no longer considered acceptable behavior.

## Decision 11 — Logout Cleanup Must Stay Specific to Its Actual Responsibility

The dashboard logout path no longer clears all session storage blindly.

Its storage responsibility is limited to the persisted login hint it actually owns in the current architecture.

Broader storage cleanup would exceed the current semantic responsibility of logout.

## Decision 12 — ServiceProvider Remains the Runtime Source, Not the Automatic Future Coordinator

`ServiceProvider` remains:

- the backend/runtime source
- the holder of authenticated runtime context
- the holder of active operational context
- the protected communication boundary

That still does not automatically make it the place for future application coordination logic.

## Decision 13 — Shared Runtime Context May Be Read Through Explicit Accessors

The normalized read-only accessors on `ServiceProvider` remain the preferred way for cross-feature consumers to read:

- authenticated user context
- active client index
- active client
- active company
- available clients

This reduces coupling without moving ownership.

## Decision 14 — Real Feature Interactions Now Exist as Explicit Declarative Contracts

Phase 7.3.3 now freezes the current interaction meaning through explicit declarative contracts.

At minimum, the active contract baseline includes:

- active client change
- logout reset
- auth resolution
- shared runtime context read

These contracts document real current architecture.
They are not theoretical placeholders.

## Decision 15 — Declarative Contracts Are Not a Runtime Engine

The current contract layer is intentionally:

- declarative
- lightweight
- non-executing
- non-owning
- non-reactive

It must not be reinterpreted as:

- a coordinator
- an event bus
- a runtime dispatcher
- a state-management abstraction

If later phases need execution-layer coordination, that must be introduced explicitly and separately.

## Decision 16 — Contracts Do Not Move Ownership

The existence of a contract does not transfer ownership.

Examples:

- active client change contract does not make dashboard own billing state
- logout reset contract does not make dashboard own runtime reset
- auth resolution contract does not make auth UI own startup boundary
- shared runtime context read contract does not make consumers owners of provider state

Contracts describe interaction meaning across existing boundaries.

## Decision 17 — Dashboard and Billing Remain Consumers, Not Cross-Owners

Dashboard remains the producer of active client change and logout intent.

Billing remains a downstream consumer of active client context changes.

Neither feature becomes owner of the other feature’s state or lifecycle.

## Decision 18 — Startup Boundary Remains Separate

Startup readiness remains a distinct context owned by `main.dart` through `AppStartupViewState`.

Later phases must preserve that distinction unless explicitly redesigned.

## Validation

These decisions are validated against the current ZIP because the codebase now shows all of the following:

- startup remains owned by `main.dart`
- persisted login hint remains explicit and narrow
- authenticated runtime context is still materialized in `doLoginCallback()`
- active client/company context is still owned by `ServiceProvider`
- dashboard and billing continue to consume shared runtime context without becoming owners
- the current interaction meaning can now be frozen through declarative contracts without changing runtime behavior

## Release Impact

This decisions document has no direct release-facing runtime impact by itself.

Its effect is to protect future implementation choices.

## Risks

Without these decisions, the project risks:

- introducing coordinator logic before freezing contract meaning
- confusing declarative contracts with executable infrastructure
- losing visibility over cross-feature semantics
- regressing to raw mechanics without explicit interaction meaning
- reintroducing vague ownership assumptions

## What it does NOT solve

This document does not by itself implement:

- minimal application coordinator logic
- event-driven architecture
- backend-persisted authenticated session validation
- automated flow-level contract tests

It only fixes the current architectural interpretation.

## Conclusion

The active interpretation of Mi IP·RED is now:

1. protect runtime behavior
2. preserve feature-local controller boundaries
3. preserve state-boundary clarity from Phase 7.2
4. preserve flow inventory clarity from Phase 7.3.1
5. preserve context semantics from Phase 7.3.2
6. freeze real cross-feature meaning through declarative contracts in Phase 7.3.3 before introducing later coordination mechanisms