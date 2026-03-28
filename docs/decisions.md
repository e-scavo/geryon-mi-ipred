# 🧠 Decisions — Phase 7 Alignment

## Objective

Record the architectural decisions that remain active after the completion of Phase 7.4.4 so future work stays aligned with the real current runtime.

## Initial Context

The current ZIP confirms:

- Phase 7.3 remains formally closed
- Phase 7.4 is active
- `7.4.2` normalized auth-requirement semantics without redesigning the runtime
- `7.4.3` normalized login continuation resolution without redesigning the runtime
- `7.4.4` normalized minimal startup/auth continuation coordination without redesigning the runtime

## Problem Statement

Without explicit decisions, future work could incorrectly assume that the startup/auth bridge still requires a broad coordinator.

It does not.

The current baseline only justifies a narrow, local coordinator state.

## Scope

These decisions govern:

- interpretation of the current startup/auth runtime
- what `7.4.4` actually changed
- what remains prohibited until later phases

They do not implement runtime behavior by themselves.

## Root Cause Analysis

The current project no longer needs broad application-layer cleanup.

It needs narrow, validated continuation hardening.

That distinction must stay explicit.

## Files Affected

These decisions apply primarily to:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/models/GeneralLoadingProgress/**`
- `lib/models/ServiceProvider/auth_requirement_model.dart`
- `lib/models/ServiceProvider/login_continuation_result_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- current Phase 7 documentation

## Implementation Characteristics

## Decision 1 — Phase 7.3 remains closed

The existence of Phase 7.4 does not reopen the previous coordination phase.

## Decision 2 — ServiceProvider remains the authenticated runtime source

The authenticated runtime context is still owned by `ServiceProvider`.

Phase 7.4.4 did not change that.

## Decision 3 — Startup boundary remains local

`main.dart` still owns startup-boundary completion state.

## Decision 4 — Auth requirement has explicit local semantics

The preferred current semantic boundary is now:

- `ServiceProviderAuthRequirementKind`
- `ServiceProviderAuthRequirement`
- `evaluateAuthRequirement()`

## Decision 5 — Login continuation has explicit local semantics

The preferred post-login continuation boundary is now:

- `ServiceProviderLoginContinuationDisposition`
- `ServiceProviderLoginContinuationResult`
- `_resolveLoginContinuationResult(...)`
- `_handleResolvedLoginContinuation(...)`

## Decision 6 — Startup/auth minimal coordination now has explicit local semantics

The preferred startup/auth coordination boundary is now:

- `ServiceProviderStartupAuthContinuationDisposition`
- `ServiceProviderStartupAuthContinuationCoordinatorState`
- `evaluateStartupAuthContinuationCoordinatorState(...)`

Widget-local inline startup/auth coordination branching is no longer the preferred semantic source.

## Decision 7 — Popup ownership remains where it is for now

`ServiceProvider` still triggers the login popup path.

That is accepted current baseline behavior.

It was not moved in 7.4.4.

## Decision 8 — Loading popup remains a UI bridge, not the owner of startup/auth semantics

`ModelGeneralLoadingProgress` still renders waiting state and responds to state changes.

But it should now consume explicit coordinator decisions rather than inventing startup/auth coordination semantics inline.

## Decision 9 — Login UI is not the current architectural problem

The auth feature continues owning login bootstrap and submit behavior.

The main current concern was the boundary meaning before and after popup entry, not the popup UI itself.

## Decision 10 — Persisted login hint is not a backend session

Stored DNI/CUIT remains a remembered login hint only.

It must not be treated as a persisted authenticated backend session.

## Decision 11 — Reset-before-login continuation remains conservative baseline behavior

When auth requirement is evaluated from remembered local user state, the runtime may still reset authenticated runtime state conservatively before reopening login.

That behavior remains accepted current baseline.

## Decision 12 — Startup entry and logout reentry belong to the same boundary family

Future hardening work must continue to respect both:

- initial startup entry
- logout-triggered reentry

## Decision 13 — No broad redesign under the banner of normalization

Phase 7.4.4 does not authorize:

- event bus
- global runtime engine
- broad startup/auth coordinator
- navigation redesign
- ServiceProvider replacement

## Validation

These decisions remain valid only if the current runtime still demonstrates:

- popup-based startup continuation
- explicit auth-requirement evaluation inside `ServiceProvider`
- explicit login continuation resolution inside `ServiceProvider`
- explicit minimal startup/auth coordination inside `ServiceProvider`
- feature-local login handling
- in-memory authenticated runtime context ownership
- logout reentry behavior preserved

## Release Impact

These decisions have no direct user-facing release impact.

They protect the correct interpretation of the current implementation.

## Risks

If these decisions are ignored, future work may:

- drift back into implicit semantics
- over-expand the coordination scope
- destabilize the current runtime

## What it does NOT solve

This decisions document does not itself:

- change popup ownership
- redesign startup completion flow
- introduce a global application coordinator

It only freezes the correct interpretation of 7.4.4.

## Conclusion

The current project baseline is:

- Phase 7.3 closed
- Phase 7.4 active
- `7.4.4` completed as explicit minimal startup/auth continuation coordination normalization

The next correct target is:

- `Phase 7.4.5 — Formal Closure of Phase 7.4`