# 🧠 Decisions — Phase 7 Alignment

## Objective

Record the active architectural decisions that define how Mi IP·RED must be interpreted and evolved after the formal closure of Phase 7.3 and the opening of Phase 7.4.

## Initial Context

Phase 7 progressed in layers:

- Phase 7.1 extracted feature-local controllers
- Phase 7.2 clarified ownership and state boundaries
- Phase 7.3 inventoried flows, normalized context meaning, froze interaction contracts, introduced a minimal coordinator, and closed formally
- Phase 7.4 now begins with an inventory of the startup/auth continuation boundary

These decisions capture the resulting stable baseline.

## Problem Statement

Without explicit decisions after opening 7.4, future work could incorrectly assume:

- that 7.3 should be reopened
- that startup/auth automatically belongs inside the existing coordinator
- that ServiceProvider should be broadly redesigned now
- that login popup UI is the main structural problem
- that persisted DNI/CUIT acts as a persistent authenticated session

Those assumptions would be incorrect according to the current ZIP.

## Scope

These decisions govern:

- interpretation of the current runtime
- sequencing of future work after 7.3 closure
- allowed moves during 7.4
- prohibited shortcuts and over-reaches

They do not implement behavior on their own.

## Root Cause Analysis

The codebase already has enough clarity in all surrounding areas to inspect the startup/auth continuation block safely.

That means the remaining need is no longer broad coordination work.

The remaining need is to make the meaning of that boundary more explicit without breaking the runtime.

## Files Affected

These decisions apply to:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/models/GeneralLoadingProgress/**`
- `lib/models/ServiceProvider/**`
- `lib/core/session/**`

They also govern:

- `docs/development.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_4_1_startup_auth_continuation_inventory.md`

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

## Decision 2 — Phase 7.3 Remains Closed

The opening of Phase 7.4 does not reopen 7.3.

The minimal coordinator, contracts, and context-normalization work remain closed baseline work.

## Decision 3 — Controllers Remain Feature-Local Boundaries

Controllers remain the correct home for feature-local orchestration and feature-local state transitions.

Phase 7.4 does not change that.

## Decision 4 — Persisted Login Hint Is Not an Authenticated Session

Stored DNI/CUIT remains:

- a remembered login hint
- bootstrap input for possible auto-submit

It is not a backend-authenticated persistent session.

## Decision 5 — Authenticated Runtime Context Remains In-Memory and Owned by ServiceProvider

The actual authenticated runtime context continues to live in `ServiceProvider`.

This ownership does not move during 7.4.

## Decision 6 — Startup Boundary Remains Owned by `main.dart`

`main.dart` continues owning startup-boundary completion state.

That ownership remains distinct from auth feature state and from ServiceProvider runtime ownership.

## Decision 7 — The Current Auth Requirement Meaning Is Too Implicit to Remain the Long-Term Baseline

The current ZIP shows auth requirement being expressed through special return codes such as:

- `-1000`
- `-1001`
- `-1002`

That behavior is currently accepted as real baseline behavior.

But it is not the preferred long-term semantic boundary.

Therefore, normalizing auth requirement meaning is a valid next step.

## Decision 8 — ServiceProvider Is Still the Runtime Source, Not the Final Home of All Auth-Orchestration Meaning

The current ZIP shows ServiceProvider both:

- owning authenticated runtime context
- triggering login popup entry through navigator

That is accepted as the current baseline.

But it should not automatically be treated as the ideal permanent semantic distribution.

## Decision 9 — Startup/Auth Must Be Hardened Before Any Broader Coordinator Move Is Considered

The next safe order is:

1. inventory
2. auth requirement normalization
3. continuation contract
4. only then re-evaluate whether minimal startup/auth coordination is still necessary

No broader move is justified before that sequence.

## Decision 10 — The Existing Minimal Coordinator Does Not Automatically Expand Into Startup/Auth

The coordinator introduced in 7.3.4 remains a narrow solution for already-validated concerns.

It does not automatically absorb startup/auth continuation.

## Decision 11 — Navigator Result Semantics Are Current Behavior, Not Yet Explicit Contract

The current runtime continuation depends partly on popup return semantics.

That is valid current behavior.

It is not yet an explicit continuation contract.

This distinction must be preserved.

## Decision 12 — Logout Reentry Belongs to the Same Boundary Family

Logout currently resets authenticated runtime state and reenters backend/auth requirement flow.

Therefore, startup/auth hardening work must treat both initial startup entry and logout reentry as related runtime cases.

## Decision 13 — Avoid New Hidden Semantics

The current ZIP already contains implicit auth requirement semantics.

Future work must reduce that ambiguity, not add more of it.

## Decision 14 — No Broad Redesign Under Cleanup Language

Phase 7.4 must not be used to introduce:

- event bus
- global runtime engine
- broad startup/auth coordinator
- provider replacement
- navigation redesign

without a later explicit phase and direct justification from code.

## Validation

These decisions are validated against the current ZIP because the codebase currently shows all of the following:

- local startup boundary in `main.dart`
- popup-based bootstrap continuation
- provider-driven backend readiness chain
- implicit auth requirement semantics
- feature-local login state handling
- in-memory authenticated runtime context in ServiceProvider
- logout-triggered reentry into auth requirement flow

## Release Impact

This decisions document has no direct release-facing runtime impact.

Its role is to protect the correct interpretation of the newly opened 7.4 phase.

## Risks

If these decisions are not recorded, future work may:

- reopen 7.3 accidentally
- redesign ServiceProvider prematurely
- confuse login hint persistence with authenticated session persistence
- introduce broad coordination changes too early

## What it does NOT solve

This document does not by itself:

- normalize auth requirement semantics
- define a continuation contract
- change popup ownership
- change runtime behavior

It only freezes the correct interpretation of the current phase baseline.

## Conclusion

The current project baseline is now:

- Phase 7.3 closed
- Phase 7.4 opened
- 7.4.1 completed as an inventory/documentation step

The next correct safe target is:

- `7.4.2 — Auth Requirement Boundary Normalization`