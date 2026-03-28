# 🧩 Phase 7.4.4 — Minimal Startup/Auth Continuation Coordinator

## Objective

Introduce a minimal and explicit startup/auth continuation coordinator so that the loading popup, startup boundary completion, and controlled reboot decisions no longer depend on distributed inline widget logic, while preserving the current runtime architecture and behavior.

## Initial Context

Phase 7.4.1 inventoried the real startup/auth continuation bridge.

Phase 7.4.2 normalized auth-requirement semantics by introducing an explicit auth-requirement model.

Phase 7.4.3 normalized login-resolution continuation through an explicit continuation result contract.

After those steps, the remaining sensitive problem in the ZIP was no longer auth meaning itself.

The remaining problem was the residual coordination of the startup/auth bridge across:

- `main.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/data_model.dart`

## Problem Statement

Before this phase, the loading popup still contained coordination logic that was more than just UI.

Specifically, `ModelGeneralLoadingProgress` was still deciding inline:

- when the loading popup should close
- when startup boundary resolution should be considered successful
- when a reboot should be triggered

At the same time, `ServiceProvider` already knew:

- auth requirement meaning
- login continuation meaning
- authenticated runtime readiness

But it did not yet expose an explicit local boundary-coordination decision for the startup/auth bridge.

That left one narrow but real coordination seam still distributed.

## Scope

This phase covers only the minimal startup/auth continuation coordinator.

It includes:

- a new explicit coordinator-state model
- a local evaluator inside `ServiceProvider`
- moving popup-close / keep-waiting / reboot decisions away from inline widget logic
- documentation alignment with the new boundary coordination model

It does not include:

- global coordinator introduction
- event bus
- popup ownership relocation
- `main.dart` redesign
- login widget redesign
- backend protocol changes
- broader navigation changes

## Root Cause Analysis

The startup/auth boundary was intentionally hardened in layers:

1. inventory real flow
2. normalize auth requirement
3. normalize login continuation resolution
4. normalize the remaining minimal coordination seam

That final seam was still visible in the ZIP because the loading popup remained responsible for interpreting raw provider-state combinations and deciding what to do.

That was too much implicit coordination for a UI surface.

The correct safe move was not a broad coordinator.

The correct safe move was a narrow local coordinator state that could be evaluated from current runtime state and then consumed by the loading popup.

## Files Affected

### Code

- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart` ← new
- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/GeneralLoadingProgress/model.dart`

### Documentation

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_4_4_minimal_startup_auth_continuation_coordinator.md`

## Implementation Characteristics

### 1. Minimal coordinator-state model introduced

A new file was added:

- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`

It defines:

- `ServiceProviderStartupAuthContinuationDisposition`
- `ServiceProviderStartupAuthContinuationCoordinatorState`

The explicit coordinator dispositions are:

- `waitingForInitialization`
- `waitingForInteractiveLogin`
- `authenticatedContinuationResolved`
- `retryRequired`
- `blockedByError`

This gives the startup/auth bridge a minimal explicit coordination model.

### 2. `ServiceProvider` now evaluates startup/auth coordination state explicitly

A new method was introduced:

- `evaluateStartupAuthContinuationCoordinatorState({ ServiceProvider? previousState })`

This method evaluates the current boundary state using already-existing runtime signals such as:

- `isReady`
- `isProgress`
- `isUserLoggedIn`
- `initStage`
- `canRetry`

And, when useful, a minimal comparison with the previous provider snapshot.

That means the coordinator does not invent new ownership.

It only makes existing boundary decisions explicit.

### 3. Loading popup no longer decides coordination through inline state combinations

Before this phase, the loading popup directly interpreted provider state combinations inline.

After this phase, `ModelGeneralLoadingProgress` consumes an explicit coordinator-state decision.

That means the widget now asks the runtime:

- should the popup close?
- should startup boundary be considered complete?
- should reboot be triggered?
- should it keep waiting?

This is the key architectural outcome of 7.4.4.

### 4. Reboot decision remains narrow and controlled

This phase does not preserve the previous “reboot on many transitions” style as implicit widget logic.

Instead, reboot is now only requested through the explicit coordinator state.

The current implementation keeps reboot narrow and controlled, especially around:

- websocket endpoint changes
- dropped connection transitions outside explicit blocked-error states

This is intentionally conservative.

### 5. Ownership remains unchanged

This phase does not move ownership boundaries.

The runtime still remains:

- `main.dart` owns startup-boundary completion state
- `ServiceProvider` owns authenticated runtime state
- auth feature owns login UI and submit logic
- loading popup remains a UI bridge for waiting and status display

The only change is that the coordination seam is now explicit and local instead of being embedded in widget conditionals.

## Validation

The implementation is considered correct if all of the following remain true:

- startup without remembered user still opens login flow
- startup with remembered local user still reopens login conservatively
- successful login still closes the loading popup correctly
- failed or cancelled continuation does not close the loading popup as success
- explicit error states remain blocked rather than reboot-looping
- controlled reboot only occurs in the narrow coordinator-approved cases
- logout reentry still traverses the same startup/auth family safely

## Release Impact

This phase is intended to have low visible UX impact.

Its main value is architectural and semantic:

- loading popup behavior is now driven by explicit coordinator state
- startup boundary resolution becomes clearer
- reboot decisions are no longer hidden in widget-local conditional logic
- the startup/auth bridge is now explicit end to end

## Risks

The main risk is over-triggering or under-triggering reboot behavior.

To reduce that risk, this phase keeps reboot criteria narrow and explicit, and does not redesign the rest of the runtime.

Another risk is incorrectly classifying a successful continuation as still waiting.

That is why the coordinator resolves success only when the already-established runtime-ready/authenticated conditions are true.

## What it does NOT solve

This phase does not:

- move popup ownership outside `ServiceProvider`
- redesign `main.dart`
- redesign login widget result shape
- introduce a global application coordinator
- redesign logout flow
- introduce persisted authenticated session semantics

Those remain outside the scope of this narrow phase.

## Conclusion

Phase 7.4.4 correctly introduces a minimal startup/auth continuation coordinator without expanding architecture scope.

The key outcomes are:

- explicit coordinator-state model introduced
- `ServiceProvider` now evaluates startup/auth boundary coordination explicitly
- loading popup consumes explicit decisions instead of raw inline state combinations
- reboot behavior is narrow and controlled
- ownership boundaries remain unchanged

The next correct step after validation is:

- `Phase 7.4.5 — Formal Closure of Phase 7.4`