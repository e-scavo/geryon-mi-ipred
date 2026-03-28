# 🛠️ Development Guidelines

## Objective

Define the active development rules for Mi IP·RED so that future changes preserve the production runtime, respect the current architecture, and evolve the startup/auth continuation boundary incrementally.

## Initial Context

The current ZIP confirms a stable architecture with the following baseline:

- `presentation → controller → ServiceProvider`
- Phase 7.3 already closed
- Phase 7.4 active as a narrow continuation-hardening phase
- `7.4.2` completed as auth-requirement boundary normalization

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

Phase 7.4.2 addressed the first of those two concerns conservatively.

## Files Affected

Main files governed by the current baseline include:

- `lib/main.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/auth_requirement_model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_4_2_auth_requirement_boundary_normalization.md`

## Implementation Characteristics

### Rule 1 — Preserve `presentation → controller → ServiceProvider`

Feature-local presentation must remain separate from controller logic and runtime-source logic.

Do not move feature logic back into widgets.

### Rule 2 — ServiceProvider remains the runtime source

`ServiceProvider` still owns:

- backend/runtime connectivity state
- authenticated runtime context
- active client/company context

Phase 7.4.2 does not change that ownership.

### Rule 3 — Auth requirement must now be expressed explicitly

New work must prefer the explicit auth-requirement model over direct raw magic-code branching.

Current explicit boundary model:

- `ServiceProviderAuthRequirementKind`
- `ServiceProviderAuthRequirement`
- `evaluateAuthRequirement()`

### Rule 4 — Legacy compatibility is transitional, not the semantic source

`doCheckLogin()` may still exist for compatibility.

But new semantic decisions must not be anchored primarily in raw `ErrorHandler.errorCode` comparisons when explicit auth-requirement meaning is already available.

### Rule 5 — Login UI remains feature-local

The auth feature still owns:

- login bootstrap view state
- input preparation
- login submit UX
- local failure rendering

Do not use Phase 7.4 as a reason to move UI logic into `ServiceProvider` or `main.dart`.

### Rule 6 — Startup boundary remains local to `main.dart`

`main.dart` continues owning whether the initial startup boundary is completed.

Phase 7.4.2 did not change that.

### Rule 7 — Persisted DNI/CUIT remains a login hint

Remembered DNI/CUIT is still only a bootstrap/login hint.

It is not an authenticated persisted backend session.

### Rule 8 — Reset behavior must stay conservative

When the auth requirement indicates a remembered local user path, the runtime may still reset authenticated runtime state conservatively before reopening login continuation.

Do not loosen that behavior without explicit validation.

### Rule 9 — Startup and logout reentry must both be respected

The auth-requirement boundary is reached from:

- initial startup
- logout reentry

Future hardening work must preserve both paths.

### Rule 10 — No broad redesign under cleanup language

Do not introduce under the label of cleanup:

- event bus
- global runtime engine
- broad startup/auth coordinator
- provider replacement
- navigation overhaul

unless a later phase explicitly justifies it against the real code.

## Validation

Any change after 7.4.2 must preserve all of the following:

- startup with no remembered user still opens login correctly
- startup with remembered local user still behaves conservatively
- manual login still works
- login popup still returns correctly
- authenticated runtime context still materializes correctly
- logout still reenters unauthenticated flow safely
- loading popup still closes under the same real runtime conditions

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

- define a continuation contract
- relocate popup ownership
- redesign startup semantics

It only freezes the correct implementation discipline.

## Conclusion

The current development baseline is conservative:

- keep runtime behavior stable
- prefer explicit auth-requirement meaning
- treat legacy compatibility as temporary scaffolding
- move to `7.4.3` only if runtime validation remains clean