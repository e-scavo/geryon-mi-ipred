# 🛠️ Development Guidelines

## Objective

Define the active development rules for Mi IP·RED so that future changes preserve the production runtime, respect the current architecture, and evolve the application in explicitly scoped phases.

## Initial Context

The current ZIP confirms a stable architecture with the following baseline:

- `presentation → controller → ServiceProvider`
- Phase 7.3 already closed
- Phase 7.4 completed and formally closed
- Phase 7.5 completed and formally closed
- `7.4.2` completed as auth-requirement boundary normalization
- `7.4.3` completed as login resolution continuation contract normalization
- `7.4.4` completed as minimal startup/auth continuation coordination normalization
- `7.4.5` completed as formal closure of Phase 7.4
- `7.5` completed as formal closure of the whole Application Layer Consolidation effort

## Problem Statement

Without updated rules, later work could easily overreach and turn a closed consolidation effort into a stealth redesign.

The biggest current risk is treating the already-closed application-layer and startup/auth continuation baselines as if they were still open for incremental modification under Phase 7.

## Scope

These rules apply to work touching:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/**`
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

Phase 7.5 then closed the whole Application Layer Consolidation effort.

That work is now complete and frozen.

## Files Affected

Main files governed by the current baseline include:

- `lib/main.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/auth_requirement_model.dart`
- `lib/models/ServiceProvider/login_continuation_result_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_5_formal_closure.md`

## Implementation Characteristics

### Rule 1 — Preserve `presentation → controller → ServiceProvider`

Feature-local presentation must remain separate from controller logic and runtime-source logic.

Do not move feature logic back into widgets.

### Rule 2 — ServiceProvider remains the runtime source

`ServiceProvider` still owns:

- backend/runtime connectivity state
- authenticated runtime context
- active client/company context

Phase 7 did not change that ownership.

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

### Rule 5 — Startup/auth minimal coordination must remain explicit

The preferred startup/auth boundary-coordination model remains:

- `ServiceProviderStartupAuthContinuationDisposition`
- `ServiceProviderStartupAuthContinuationCoordinatorState`
- `evaluateStartupAuthContinuationCoordinatorState(...)`

Loading-popup close / keep-waiting / reboot decisions must continue to prefer this explicit coordinator state instead of widget-local condition combinations.

### Rule 6 — Login UI remains feature-local

The auth feature still owns:

- login bootstrap view state
- input preparation
- login submit UX
- local failure rendering

Do not use post-Phase-7 work as a reason to move UI logic into `ServiceProvider` or `main.dart`.

### Rule 7 — Startup boundary remains local to `main.dart`

`main.dart` continues owning whether the initial startup boundary is completed.

Phase 7 did not change that.

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

Future hardening work must preserve both paths when relevant.

### Rule 11 — No broad redesign under cleanup language

Do not introduce under the label of cleanup:

- event bus
- global runtime engine
- broad startup/auth coordinator
- provider replacement
- navigation overhaul

unless a later phase explicitly justifies it against the real code.

### Rule 12 — Phase 7 is closed and must not be extended implicitly

The Application Layer Consolidation baseline is now considered stable.

Future changes must:

- not extend Phase 7 implicitly
- not introduce new startup/auth continuation logic as a hidden continuation of the closed phase
- not bypass the explicit auth / continuation / coordinator models established during Phase 7
- not reopen earlier controller/boundary/coordination work without a new explicit phase and new justification

Any new work must be introduced under a new phase with explicit justification grounded in the real code.

## Validation

Any change after Phase 7 closure must preserve all of the following:

- startup with no remembered user still opens login correctly
- startup with remembered local user still behaves conservatively
- manual login still works
- login popup still returns correctly
- invalid or null popup return values remain handled explicitly
- authenticated runtime context still materializes correctly
- loading popup closes only when coordinator state resolves authenticated continuation
- explicit blocked states do not silently close startup boundary
- logout still reenters unauthenticated flow safely when relevant
- the closed Phase 7 baseline is not bypassed implicitly

## Release Impact

These rules do not change runtime behavior directly.

They constrain how future work is allowed to evolve the code after the formal closure of the whole Application Layer Consolidation phase.

## Risks

Without these rules, future work may:

- add new hidden semantics on top of the frozen baseline
- redesign `ServiceProvider` too early
- break the current startup/auth bridge while claiming to “continue Phase 7”
- reopen a closed consolidation phase without acknowledging it

## What it does NOT solve

This document does not by itself:

- relocate popup ownership
- redesign startup semantics
- introduce a global startup/auth coordinator
- define the next phase content

It only freezes the correct implementation discipline after Phase 7 closure.

## Conclusion

The current development baseline is conservative and explicit:

- keep runtime behavior stable
- preserve `presentation → controller → ServiceProvider`
- prefer explicit auth-requirement meaning
- prefer explicit login continuation meaning
- prefer explicit minimal startup/auth coordinator meaning
- treat Phase 7 as formally closed

Any further evolution must proceed under a new phase.