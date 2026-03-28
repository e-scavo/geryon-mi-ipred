# 🧠 Decisions — Phase 7 Alignment

## Objective

Record the architectural decisions that remain active after the completion of Phase 7.4.2 so future work stays aligned with the real current runtime.

## Initial Context

The current ZIP confirms:

- Phase 7.3 remains formally closed
- Phase 7.4 is active
- `7.4.2` normalized auth-requirement semantics without redesigning the runtime

## Problem Statement

Without explicit decisions, future work could incorrectly assume that auth-requirement normalization authorizes broader structural changes.

It does not.

## Scope

These decisions govern:

- interpretation of the current startup/auth runtime
- what `7.4.2` actually changed
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
- `lib/models/ServiceProvider/data_model.dart`
- current Phase 7 documentation

## Implementation Characteristics

## Decision 1 — Phase 7.3 remains closed

The existence of Phase 7.4 does not reopen the previous coordination phase.

## Decision 2 — ServiceProvider remains the authenticated runtime source

The authenticated runtime context is still owned by `ServiceProvider`.

Phase 7.4.2 did not change that.

## Decision 3 — Startup boundary remains local

`main.dart` still owns startup-boundary completion state.

## Decision 4 — Auth requirement now has explicit local semantics

The preferred current semantic boundary is now:

- `ServiceProviderAuthRequirementKind`
- `ServiceProviderAuthRequirement`
- `evaluateAuthRequirement()`

## Decision 5 — Legacy `ErrorHandler` auth codes remain compatibility only

Legacy auth-related error codes still exist for compatibility.

They are no longer the preferred semantic source of control-flow meaning.

## Decision 6 — The previous `-1001` / `1001` inconsistency must not remain a control-flow dependency

The earlier sign inconsistency was a real fragility.

After 7.4.2, control-flow decisions must rely on explicit auth-requirement meaning rather than that mismatch.

## Decision 7 — Popup ownership remains where it is for now

`ServiceProvider` still triggers the login popup path.

That is accepted current baseline behavior.

It was not moved in 7.4.2.

## Decision 8 — Login UI is not the current architectural problem

The auth feature continues owning login bootstrap and submit behavior.

The main current concern was the boundary meaning before popup entry, not the popup UI itself.

## Decision 9 — Persisted login hint is not a backend session

Stored DNI/CUIT remains a remembered login hint only.

It must not be treated as a persisted authenticated backend session.

## Decision 10 — Reset-before-login continuation remains conservative baseline behavior

When auth requirement is evaluated from remembered local user state, the runtime may still reset authenticated runtime state conservatively before reopening login.

That behavior remains accepted current baseline.

## Decision 11 — Startup entry and logout reentry belong to the same boundary family

Future hardening work must continue to respect both:

- initial startup entry
- logout-triggered reentry

## Decision 12 — No broad redesign under the banner of normalization

Phase 7.4.2 does not authorize:

- event bus
- global runtime engine
- broad startup/auth coordinator
- navigation redesign
- ServiceProvider replacement

## Validation

These decisions remain valid only if the current runtime still demonstrates:

- popup-based startup continuation
- explicit auth-requirement evaluation inside `ServiceProvider`
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

- define the next continuation contract
- change popup ownership
- redesign startup completion flow

It only freezes the correct interpretation of 7.4.2.

## Conclusion

The current project baseline is:

- Phase 7.3 closed
- Phase 7.4 active
- `7.4.2` completed as explicit auth-requirement boundary normalization

The next possible target, if validated, is:

- `Phase 7.4.3 — Login Resolution Continuation Contract`