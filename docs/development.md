# 🛠️ Development Guidelines

## Objective

Define the active development rules for Mi IP·RED so that future changes preserve the production runtime, respect the current architecture, and evolve the startup/auth continuation boundary incrementally.

## Initial Context

The current ZIP confirms a stable architecture with the following baseline:

- `presentation → controller → ServiceProvider`
- Phase 7.3 already closed
- Phase 7.4 active as a narrow continuation-hardening phase
- `7.4.2` completed as auth-requirement boundary normalization
- `7.4.3` completed as login resolution continuation contract normalization
- `7.4.4` completed as minimal startup/auth continuation coordination normalization

## Problem Statement

Without updated rules, later work could easily overreach and turn a narrow hardening task into a redesign.

The biggest current risk is confusing boundary normalization with broader runtime restructuring.

## Scope

These rules apply to work touching:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/models/GeneralLoadingProgress/**`
- `lib/models/ServiceProvider/**`
- `lib/core/session/**`
- current Phase 7 documents

These rules do not authorize:

- backend protocol redesign
- ServiceProvider replacement
- navigation redesign
- UI redesign
- broad coordinator introduction

## Root Cause Analysis

By the end of Phase 7.3, the project no longer had a broad coordination problem.

What remained was narrower:

- auth requirement was still implicit
- startup/auth continuation still depended on distributed semantics
- loading-popup close / wait / reboot coordination still remained partially inline

Phase 7.4 addressed those concerns incrementally and conservatively.

## Files Affected

Main files governed by the current baseline include:

- `lib/main.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/auth_requirement_model.dart`
- `lib/models/ServiceProvider/login_continuation_result_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_4_4_minimal_startup_auth_continuation_coordinator.md`

## Implementation Characteristics

### Rule 1 — Preserve `presentation → controller → ServiceProvider`

Feature-local presentation must remain separate from controller logic and runtime-source logic.

Do not move feature logic back into widgets.

### Rule 2 — ServiceProvider remains the runtime source

`ServiceProvider` still owns:

- backend/runtime connectivity state
- authenticated runtime context
- active client/company context

Phase 7.4.4 does not change that ownership.

### Rule 3 — Auth requirement must remain explicit

New work must prefer the explicit auth-requirement model over direct raw magic-code branching.

Current explicit boundary model:

- `ServiceProviderAuthRequirementKind`
- `ServiceProviderAuthRequirement`
- `evaluateAuthRequirement()`

### Rule 4 — Login continuation resolution must remain explicit

The preferred post-login continuation boundary remains:

- `ServiceProviderLoginContinuationDisposition`
- `ServiceProviderLoginContinuationResult`
- `_resolveLoginContinuationResult(...)`
- `_handleResolvedLoginContinuation(...)`

Raw popup return values must not become the primary semantic source of continuation logic.

### Rule 5 — Startup/auth minimal coordination must now be consumed explicitly

The preferred startup/auth boundary-coordination model is now:

- `ServiceProviderStartupAuthContinuationDisposition`
- `ServiceProviderStartupAuthContinuationCoordinatorState`
- `evaluateStartupAuthContinuationCoordinatorState(...)`

Loading-popup close / keep-waiting / reboot decisions must prefer this explicit coordinator state instead of widget-local condition combinations.

### Rule 6 — Login UI remains feature-local

The auth feature still owns:

- login bootstrap view state
- input preparation
- login submit UX
- local failure rendering

Do not use Phase 7.4 as a reason to move UI logic into `ServiceProvider` or `main.dart`.

### Rule 7 — Startup boundary remains local to `main.dart`

`main.dart` continues owning whether the initial startup boundary is completed.

Phase 7.4.4 did not change that.

### Rule 8 — Persisted DNI/CUIT remains a login hint

Remembered DNI/CUIT is still only a bootstrap/login hint.

It is not an authenticated persisted backend session.

### Rule 9 — Reset behavior must stay conservative

When the auth requirement indicates a remembered local user path, the runtime may still reset authenticated runtime state conservatively before reopening login continuation.

Do not loosen that behavior without explicit validation.

### Rule 10 — Startup and logout reentry must both be respected

The auth-requirement boundary is reached from:

- initial startup
- logout reentry

Future hardening work must preserve both paths.

### Rule 11 — No broad redesign under cleanup language

Do not introduce under the label of cleanup:

- event bus
- global runtime engine
- broad startup/auth coordinator
- provider replacement
- navigation overhaul

unless a later phase explicitly justifies it against the real code.

## Validation

Any change after 7.4.4 must preserve all of the following:

- startup with no remembered user still opens login correctly
- startup with remembered local user still behaves conservatively
- manual login still works
- login popup still returns correctly
- invalid or null popup return values remain handled explicitly
- authenticated runtime context still materializes correctly
- loading popup closes only when coordinator state resolves authenticated continuation
- explicit blocked states do not silently close startup boundary
- logout still reenters unauthenticated flow safely

## Release Impact

These rules do not change runtime behavior directly.

They constrain how future work is allowed to evolve the code.

## Risks

Without these rules, future work may:

- add new hidden semantics on top of old ones
- redesign `ServiceProvider` too early
- break the current startup/auth bridge while claiming to clean it up

## What it does NOT solve

This document does not by itself:

- relocate popup ownership
- redesign startup semantics
- introduce a global startup/auth coordinator

It only freezes the correct implementation discipline.

## Conclusion

The current development baseline is conservative:

- keep runtime behavior stable
- prefer explicit auth-requirement meaning
- prefer explicit login continuation meaning
- prefer explicit minimal startup/auth coordinator meaning
- move to `7.4.5` as the formal closure step