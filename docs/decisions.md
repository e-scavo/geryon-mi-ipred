# 🧠 Decisions — Phase 7 Alignment

## Objective

Record the architectural decisions that remain active after the completion and formal closure of Phase 7 so future work stays aligned with the real current runtime.

## Initial Context

The current ZIP confirms:

- Phase 7.3 is formally closed
- Phase 7.4 is formally closed
- Phase 7.5 is formally closed
- `7.4.2` normalized auth-requirement semantics without redesigning the runtime
- `7.4.3` normalized login continuation resolution without redesigning the runtime
- `7.4.4` normalized minimal startup/auth continuation coordination without redesigning the runtime
- `7.4.5` froze the startup/auth continuation baseline
- `7.5` froze the full Application Layer Consolidation baseline

## Problem Statement

Without explicit decisions, future work could incorrectly assume that the application layer still requires ongoing Phase 7 hardening.

It does not.

The current baseline only justifies preserving the explicit, local, narrow models introduced during Phase 7, not continuing to extend that phase implicitly.

## Scope

These decisions govern:

- interpretation of the current application-layer runtime
- what Phase 7 actually changed
- what remains prohibited until a new explicitly scoped phase exists

They do not implement runtime behavior by themselves.

## Root Cause Analysis

The current project no longer needs broad application-layer cleanup inside the closed Phase 7 scope.

It now has:

- explicit feature-local controller ownership
- explicit state and derived-state boundaries
- explicit shared runtime and interaction semantics
- explicit auth-requirement meaning
- explicit login continuation meaning
- explicit minimal startup/auth coordination meaning

That means the remaining requirement is not more Phase 7 implementation, but disciplined preservation of the closed baseline.

## Files Affected

These decisions apply primarily to:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/**`
- `lib/models/GeneralLoadingProgress/**`
- `lib/models/ServiceProvider/auth_requirement_model.dart`
- `lib/models/ServiceProvider/login_continuation_result_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- current Phase 7 documentation

## Implementation Characteristics

## Decision 1 — Phase 7 is formally closed

Phase 7 has reached its intended scope and is now closed.

No further work should be introduced under Phase 7 without reopening scope explicitly and with new justification from the real code.

## Decision 2 — Phase 7.3 remains closed

The completion of later work does not reopen the earlier coordination phase.

## Decision 3 — ServiceProvider remains the authenticated runtime source

The authenticated runtime context is still owned by `ServiceProvider`.

Phase 7 did not change that ownership.

## Decision 4 — Startup boundary remains local

`main.dart` still owns startup-boundary completion state.

## Decision 5 — Auth requirement has explicit local semantics

The preferred current semantic boundary is:

- `ServiceProviderAuthRequirementKind`
- `ServiceProviderAuthRequirement`
- `evaluateAuthRequirement()`

## Decision 6 — Login continuation has explicit local semantics

The preferred post-login continuation boundary is:

- `ServiceProviderLoginContinuationDisposition`
- `ServiceProviderLoginContinuationResult`
- `_resolveLoginContinuationResult(...)`
- `_handleResolvedLoginContinuation(...)`

## Decision 7 — Startup/auth minimal coordination has explicit local semantics

The preferred startup/auth coordination boundary is:

- `ServiceProviderStartupAuthContinuationDisposition`
- `ServiceProviderStartupAuthContinuationCoordinatorState`
- `evaluateStartupAuthContinuationCoordinatorState(...)`

Widget-local inline startup/auth coordination branching is no longer the preferred semantic source.

## Decision 8 — Popup ownership remains where it is for now

`ServiceProvider` still triggers the login popup path.

That is accepted current baseline behavior.

Phase 7 did not move that ownership.

## Decision 9 — Loading popup remains a UI bridge, not the owner of startup/auth semantics

`ModelGeneralLoadingProgress` still renders waiting state and responds to state changes.

But it must consume explicit coordinator decisions rather than inventing startup/auth coordination semantics inline.

## Decision 10 — Login UI is not the current architectural problem

The auth feature continues owning login bootstrap and submit behavior.

The main concern solved by Phase 7 was the boundary meaning before and after popup entry, not the popup UI itself.

## Decision 11 — Persisted login hint is not a backend session

Stored DNI/CUIT remains a remembered login hint only.

It must not be treated as a persisted authenticated backend session.

## Decision 12 — Reset-before-login continuation remains conservative baseline behavior

When auth requirement is evaluated from remembered local user state, the runtime may still reset authenticated runtime state conservatively before reopening login.

That behavior remains accepted current baseline.

## Decision 13 — Startup entry and logout reentry belong to the same boundary family

Future hardening work, when explicitly justified, must continue to respect both:

- initial startup entry
- logout-triggered reentry

## Decision 14 — No broad redesign under the banner of normalization

Phase 7 did not authorize:

- event bus
- global runtime engine
- broad startup/auth coordinator
- navigation redesign
- ServiceProvider replacement

## Decision 15 — The final Phase 7 baseline is frozen

The closed baseline produced by Phase 7 is:

- `presentation → controller → ServiceProvider`
- explicit feature-local controller ownership
- explicit state and derived-state boundaries
- explicit shared runtime and interaction semantics
- explicit auth requirement, login continuation, and startup/auth coordinator semantics
- narrow coordination only where justified

Future evolution must occur under a new phase with explicit scope definition justified by the real code.

## Validation

These decisions remain valid only if the current runtime still demonstrates:

- popup-based startup continuation
- explicit auth-requirement evaluation inside `ServiceProvider`
- explicit login continuation resolution inside `ServiceProvider`
- explicit minimal startup/auth coordination inside `ServiceProvider`
- feature-local login handling
- feature-local controller ownership preserved
- in-memory authenticated runtime context ownership
- logout reentry behavior preserved where relevant
- Phase 7 treated as a closed baseline rather than active implementation scope

## Release Impact

These decisions have no direct user-facing release impact.

They protect the correct interpretation of the current implementation and the formal closure of the whole Application Layer Consolidation phase.

## Risks

If these decisions are ignored, future work may:

- drift back into implicit semantics
- over-expand the coordination scope
- destabilize the current runtime
- reopen a closed phase without recognizing it

## What it does NOT solve

This decisions document does not itself:

- change popup ownership
- redesign startup completion flow
- introduce a global application coordinator
- define the exact contents of the next phase

It only freezes the correct interpretation of the current closed baseline.

## Conclusion

The current project baseline is:

- Phase 7 closed
- application-layer consolidation completed
- startup/auth continuation explicitly modeled and minimally coordinated
- further evolution blocked from continuing under Phase 7 implicitly

The next correct step must be introduced as a new phase with a new justified scope.