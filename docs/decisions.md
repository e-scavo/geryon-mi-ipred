# 🧠 Decisions — Phase 7 Alignment

## Objective

Record the active architectural decisions that define how Mi IP·RED must be interpreted and evolved after the closure of Phase 7.2 and the full formal closure of Phase 7.3.

## Initial Context

Phase 7 of Mi IP·RED progressed in layers:

- Phase 7.1 extracted feature-local controllers
- Phase 7.2 clarified ownership and state boundaries
- Phase 7.3.1 inventoried real application flows
- Phase 7.3.2 normalized session and app-context semantics
- Phase 7.3.3 froze current cross-feature meaning as explicit interaction contracts
- Phase 7.3.4 introduced a minimal application coordinator for the safest execution-level coordination concerns
- Phase 7.3.5 now closes the full 7.3 block formally

These decisions capture the resulting stable baseline.

## Problem Statement

Without an explicit decisions document after formal closure, future work could misread the current repository and incorrectly assume one of the following:

- that Phase 7.3 is still open
- that the minimal coordinator is unfinished broad infrastructure
- that ownership moved during 7.3
- that startup/auth should now automatically be absorbed by the coordinator
- that 7.3 should keep growing instead of being closed

Those assumptions would be incorrect according to the current ZIP and the current phase baseline.

## Scope

These decisions govern:

- interpretation of the current runtime
- sequencing of future work after Phase 7.3
- allowed architectural moves
- prohibited shortcuts and over-reaches

They do not implement behavior on their own.

## Root Cause Analysis

The codebase reached a point where feature-local cleanup, ownership clarification, flow inventory, context normalization, contract freezing, and minimal coordination anchoring already produced enough clarity to resolve the coordination concerns that justified Phase 7.3.

That means the remaining need is not more implementation inside 7.3.

The remaining need is to freeze the outcome correctly and prevent scope drift.

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
- `docs/phase7_application_layer_consolidation_7_3_5_formal_closure.md`

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

All later work must preserve these behaviors unless a future phase explicitly and safely changes them.

## Decision 2 — Structural and Application-Layer Work Must Not Imply Silent Behavioral Change

Phase 7 was a consolidation phase, not a runtime redesign phase.

That remains the correct interpretation of its outcomes.

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

That classification remains valid and closed as the current baseline.

## Decision 5 — Flow Inventory, Context Normalization, Contract Freezing, and Minimal Coordination Were Sequential On Purpose

The order of Phase 7.3 was intentional:

1. flow inventory
2. context normalization
3. contract freezing
4. minimal coordination anchoring

This sequencing remains the correct interpretation of the phase.

## Decision 6 — Persisted Login Hint Is Not an Authenticated Session

The current storage abstraction only persists remembered DNI/CUIT information.

It remains a persisted login hint, not a backend-validated authenticated session.

## Decision 7 — Authenticated Runtime Context Remains In-Memory and Owned by ServiceProvider

The actual authenticated runtime context continues to live in `ServiceProvider`.

That ownership did not move during Phase 7.3.

## Decision 8 — Active Operational Context Is Distinct From “Logged In”

The active client/company context remains a separate runtime concern from merely being authenticated.

It remains owned by `ServiceProvider` and consumed downstream by features such as dashboard and billing.

## Decision 9 — Persisted Login Hint Lifecycle Must Stay Symmetric

Remember-me behavior remains explicitly symmetric.

That means:

- save remembered DNI on successful login when requested
- remove remembered DNI on successful login when remember-me is disabled
- remove remembered DNI during logout cleanup

## Decision 10 — Logout Cleanup Must Stay Specific to Its Actual Responsibility

The logout path continues removing only the persisted login hint it actually owns.

Broader storage cleanup would exceed the current semantic responsibility of logout.

## Decision 11 — ServiceProvider Remains the Runtime Source, Not the Coordinator

`ServiceProvider` remains:

- the backend/runtime source
- the holder of authenticated runtime context
- the holder of active operational context
- the protected communication boundary

The coordinator introduced in 7.3.4 does not replace it and does not absorb its ownership.

## Decision 12 — Shared Runtime Context May Continue to Be Read Through Explicit Accessors

The normalized read-only accessors on `ServiceProvider` remain the preferred way for cross-feature consumers to read shared runtime context.

## Decision 13 — Declarative Contracts Remain Declarative

The contract layer introduced in 7.3.3 remains:

- declarative
- lightweight
- non-executing
- non-owning
- non-reactive

It must not be reinterpreted as a coordinator or runtime engine.

## Decision 14 — The Minimal Coordinator Is Closed as a Narrow Solution, Not an Open Broad Program

The coordinator introduced in 7.3.4 is intentionally limited to the safest currently justified concerns:

- billing downstream refresh coordination
- logout reset coordination

This is a completed narrow solution, not the beginning of an automatically broadening coordinator program.

## Decision 15 — The Coordinator Does Not Move Ownership

The existence of the coordinator does not transfer ownership.

Examples:

- billing downstream coordination does not make the coordinator owner of billing feature state
- logout reset coordination does not make the coordinator owner of authenticated runtime context
- the coordinator does not become owner of widget lifecycle
- the coordinator does not become owner of backend flow

## Decision 16 — Startup/Auth Remains Out of Scope for the Minimal Coordinator

The current startup/auth/runtime continuation path remains intentionally untouched by the minimal coordinator.

That boundary remains outside the closed scope of Phase 7.3.

## Decision 17 — Billing Widget No Longer Remains the Main Semantic Home of Downstream Coordination

`billing_widget.dart` still owns:

- rendering
- lifecycle
- listener attachment
- widget-local state updates

But the semantic rule of when billing should bootstrap or react to active client change is now anchored in the coordinator rather than remaining primarily inline in the widget.

## Decision 18 — Dashboard Still Produces Intent, but Logout Reset Coordination Is Now Narrowly Anchored

Dashboard remains the producer of logout intent.

The app-level transition semantics of logout execution are now anchored in the minimal coordinator.

This does not make dashboard owner of runtime reset, nor does it make the coordinator owner of dashboard state.

## Decision 19 — Phase 7.3 Is Now Formally Closed

The current ZIP confirms that the practical and architectural objective of Phase 7.3 has been achieved.

Therefore:

- Phase 7.3 is complete
- its outcomes are frozen as the active baseline
- future work must start from this baseline instead of extending 7.3 artificially

## Validation

These decisions are validated against the current ZIP because the codebase now shows all of the following:

- flow inventory exists
- context normalization exists
- contract baseline exists
- minimal coordinator exists
- runtime behavior remains materially unchanged
- ownership remains materially unchanged
- no broad coordinator or hidden re-architecture was introduced

## Release Impact

This decisions document has no direct release-facing runtime impact by itself.

Its effect is to protect future implementation choices and keep the post-7.3 baseline stable.

## Risks

Without these decisions, the project risks:

- reopening already-closed coordination concerns
- over-expanding the coordinator scope
- confusing the coordinator with a global orchestration layer
- losing clarity over ownership
- extending 7.3 indefinitely

## What it does NOT solve

This document does not by itself implement:

- startup/auth coordinator redesign
- event-driven runtime architecture
- backend-persisted authenticated session validation
- automated flow-level coordination tests

Those remain outside the closed scope of Phase 7.3.

## Conclusion

The active interpretation of Mi IP·RED is now:

1. protect runtime behavior
2. preserve feature-local controller boundaries
3. preserve state-boundary clarity from Phase 7.2
4. preserve the full coordination baseline completed in Phase 7.3
5. treat Phase 7.3 as formally closed and stable