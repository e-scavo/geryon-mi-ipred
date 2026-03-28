# 🧠 Decisions — Phase 7 Alignment

## Objective

Record the active architectural decisions that define how Mi IP·RED must be interpreted and evolved after the closure of Phase 7.2, the completion of Phase 7.3.1, the implementation of Phase 7.3.2, the implementation of Phase 7.3.3, and the implementation of Phase 7.3.4.

## Initial Context

Phase 7 of Mi IP·RED has progressed in layers:

- Phase 7.1 extracted feature-local controllers
- Phase 7.2 clarified ownership and state boundaries
- Phase 7.3.1 inventoried real application flows
- Phase 7.3.2 normalized session and app-context semantics
- Phase 7.3.3 froze current cross-feature meaning as explicit interaction contracts
- Phase 7.3.4 introduced a minimal application coordinator for the safest execution-level coordination concerns

These decisions capture the baseline that must remain stable while the next subphases continue.

## Problem Statement

Without an explicit decisions document, future work could misread the current repository and incorrectly assume one of the following:

- that 7.3.4 introduced a broad coordinator
- that 7.3.4 moved state ownership
- that the coordinator now owns startup/auth continuation
- that the coordinator replaced feature controllers
- that the coordinator replaced `ServiceProvider`

Those assumptions would be incorrect according to the current ZIP and the current phase baseline.

## Scope

These decisions govern:

- interpretation of the current runtime
- sequencing of future Phase 7.3 work
- allowed architectural moves
- prohibited shortcuts and over-reaches

They do not implement behavior on their own.

## Root Cause Analysis

The current codebase reached a point where feature-local cleanup, ownership clarification, flow inventory, context normalization, and contract freezing already produced enough clarity to expose the next class of debt:

- interaction meaning was explicit
- but selected execution-level coordination concerns were still more distributed than ideal

This required a new decision set rather than stretching the previous 7.3.3 framing beyond its scope.

## Files Affected

These decisions apply to:

- `lib/features/billing/**`
- `lib/features/dashboard/**`
- `lib/features/contracts/**`
- `lib/models/ServiceProvider/**`
- `lib/core/session/**`

They also govern:

- `docs/development.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_3_feature_interaction_contracts.md`
- `docs/phase7_application_layer_consolidation_7_3_4_application_coordinator_minimal.md`

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

That means documentation, refactors, and coordination work must not silently alter actual runtime semantics.

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

## Decision 6 — Context Normalization Had to Precede Contract Freezing

Phase 7.3.2 came before 7.3.3 on purpose.

The project first needed to separate:

- persisted login hint
- authenticated runtime context
- active operational context
- startup boundary context

Only after those meanings were explicit did it become safe to freeze interaction contracts built on top of them.

## Decision 7 — Contract Freezing Had to Precede Minimal Coordination

Phase 7.3.3 came before 7.3.4 on purpose.

The project first needed to freeze interaction meaning before introducing any execution-level coordination anchor.

Without that sequencing, the coordinator would have risked coordinating still-implicit semantics.

## Decision 8 — Persisted Login Hint Is Not an Authenticated Session

The current storage abstraction only persists remembered DNI/CUIT information.

It must be interpreted as a persisted login hint.

It must not be documented or consumed as if it were a backend-validated authenticated session.

## Decision 9 — Authenticated Runtime Context Remains In-Memory and Owned by ServiceProvider

The actual authenticated runtime context continues to live in `ServiceProvider` through the in-memory authenticated user state.

That context remains owned by:

- login callback application
- runtime reset logic
- current runtime provider instance

Later phases do not move that ownership elsewhere unless explicitly redesigned.

## Decision 10 — Active Operational Context Is Distinct From “Logged In”

The active client/company context is a separate runtime concern from merely being authenticated.

It remains owned by `ServiceProvider` and is consumed downstream by features such as dashboard and billing.

## Decision 11 — Persisted Login Hint Lifecycle Must Stay Symmetric

Remember-me behavior remains explicitly symmetric.

That means:

- save remembered DNI on successful login when requested
- remove remembered DNI on successful login when remember-me is disabled
- remove remembered DNI during logout cleanup

## Decision 12 — Logout Cleanup Must Stay Specific to Its Actual Responsibility

The logout path continues removing only the persisted login hint it actually owns.

Broader storage cleanup would exceed the current semantic responsibility of logout.

## Decision 13 — ServiceProvider Remains the Runtime Source, Not the Coordinator

`ServiceProvider` remains:

- the backend/runtime source
- the holder of authenticated runtime context
- the holder of active operational context
- the protected communication boundary

The coordinator introduced in 7.3.4 does not replace it and does not absorb its ownership.

## Decision 14 — Shared Runtime Context May Continue to Be Read Through Explicit Accessors

The normalized read-only accessors on `ServiceProvider` remain the preferred way for cross-feature consumers to read shared runtime context.

This reduces coupling without moving ownership.

## Decision 15 — Declarative Contracts Remain Declarative

The contract layer introduced in 7.3.3 remains:

- declarative
- lightweight
- non-executing
- non-owning
- non-reactive

It still must not be reinterpreted as a coordinator or runtime engine.

## Decision 16 — The 7.3.4 Coordinator Is Minimal and Narrow by Design

The coordinator introduced in 7.3.4 is intentionally limited to the safest currently justified concerns:

- billing downstream refresh coordination
- logout reset coordination

It does not coordinate:

- startup/auth continuation
- routing
- navigation
- global feature orchestration
- event-driven runtime behavior

## Decision 17 — The Coordinator Does Not Move Ownership

The existence of the coordinator does not transfer ownership.

Examples:

- billing downstream coordination does not make the coordinator owner of billing feature state
- logout reset coordination does not make the coordinator owner of authenticated runtime context
- the coordinator does not become owner of widget lifecycle
- the coordinator does not become owner of backend flow

## Decision 18 — Billing Widget No Longer Remains the Main Semantic Home of Downstream Coordination

`billing_widget.dart` still owns:

- rendering
- lifecycle
- listener attachment
- widget-local state updates

But the semantic rule of when billing should bootstrap or react to active client change is now anchored in the coordinator rather than remaining primarily inline in the widget.

## Decision 19 — Dashboard Still Produces Intent, but Logout Reset Coordination Is Now Centralized Narrowly

Dashboard remains the producer of logout intent.

The app-level transition semantics of logout execution are now anchored in the minimal coordinator.

This does not make dashboard owner of runtime reset, nor does it make the coordinator owner of dashboard state.

## Decision 20 — Startup/Auth Remains Out of Scope for 7.3.4

The current startup/auth/runtime continuation path remains intentionally untouched in 7.3.4.

That surface is broader and more sensitive than the currently safe coordination targets.

## Validation

These decisions are validated against the current ZIP because the codebase now shows all of the following:

- startup/auth remains untouched
- billing downstream coordination now uses a narrow coordinator surface
- logout reset now uses a narrow coordinator surface
- ServiceProvider still owns runtime context and runtime reset
- feature controllers remain feature-local
- no broad coordination infrastructure was introduced

## Release Impact

This decisions document has no direct release-facing runtime impact by itself.

Its effect is to protect future implementation choices and to keep the coordinator scope honest.

## Risks

Without these decisions, the project risks:

- over-expanding the coordinator scope
- confusing the coordinator with a global orchestration layer
- moving ownership accidentally
- pulling startup/auth into the coordinator prematurely
- reintroducing distributed semantics into widgets after extracting them

## What it does NOT solve

This document does not by itself implement:

- startup/auth coordinator redesign
- event-driven runtime architecture
- backend-persisted authenticated session validation
- automated flow-level coordination tests

It only fixes the current architectural interpretation.

## Conclusion

The active interpretation of Mi IP·RED is now:

1. protect runtime behavior
2. preserve feature-local controller boundaries
3. preserve state-boundary clarity from Phase 7.2
4. preserve flow inventory clarity from Phase 7.3.1
5. preserve context semantics from Phase 7.3.2
6. preserve declarative interaction contracts from Phase 7.3.3
7. anchor only the narrowest safe execution-level coordination concerns through a minimal coordinator in Phase 7.3.4