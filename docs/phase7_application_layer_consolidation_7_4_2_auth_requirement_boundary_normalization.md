# 🧩 Phase 7.4.2 — Auth Requirement Boundary Normalization

## Objective

Normalize the startup/auth requirement boundary of Mi IP·RED by replacing the current implicit magic-code semantics with an explicit auth-requirement model, while preserving the current runtime, popup-based login continuation, ServiceProvider ownership, and startup boundary behavior.

## Initial Context

Phase 7.4.1 validated that the current startup/auth continuation path is functional but semantically distributed.

The real current flow still spans:

- `lib/main.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/features/auth/presentation/login_widget.dart`

Phase 7.4.1 also confirmed that the most fragile current point is not the login UI itself, but the auth-requirement bridge inside `ServiceProvider`, especially around:

- `getBackendStatus()`
- `_handleBackendStatusSuccessFlow(...)`
- `doCheckLogin()`

That bridge was still using implicit special codes to express whether login should be reopened.

## Problem Statement

Before this step, the auth-requirement boundary was still expressed primarily through magic codes returned by `doCheckLogin()`.

Those codes were being interpreted downstream in `_handleBackendStatusSuccessFlow(...)`.

This created two concrete problems:

1. the meaning of the boundary remained implicit
2. the code had a real inconsistency between produced and consumed values

The ZIP confirmed the concrete mismatch:

- `doCheckLogin()` returned `-1001`
- `_handleBackendStatusSuccessFlow(...)` was checking `1001`

That means the old flow was not only semantically implicit, but also structurally fragile.

## Scope

This phase covers only auth-requirement boundary normalization inside the current runtime.

It includes:

- explicit auth-requirement modeling
- compatibility mapping back to legacy `ErrorHandler` semantics
- replacement of direct magic-code branching in backend-status continuation
- documentation updates aligned with the new boundary meaning

It does not include:

- navigation redesign
- login widget redesign
- startup boundary redesign
- moving popup ownership outside `ServiceProvider`
- coordinator expansion
- logout redesign
- backend protocol changes

## Root Cause Analysis

The current runtime had evolved safely in previous phases by preserving behavior first and clarifying ownership second.

That strategy was correct.

However, one narrow area remained behind: the auth requirement itself was still represented as a side effect of `doCheckLogin()` returning legacy integer codes.

That meant the runtime depended on hidden semantic meaning rather than an explicit local boundary model.

Once Phase 7.4.1 finished the inventory, the next safe step became clear:

- keep current behavior
- keep current ownership
- make auth requirement explicit
- keep compatibility temporarily for the rest of the runtime

## Files Affected

### Code

- `lib/models/ServiceProvider/auth_requirement_model.dart` ← new
- `lib/models/ServiceProvider/data_model.dart`

### Documentation

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_4_2_auth_requirement_boundary_normalization.md`

## Implementation Characteristics

### 1. Explicit auth-requirement model introduced

A new file was added:

- `lib/models/ServiceProvider/auth_requirement_model.dart`

This file introduces:

- `ServiceProviderAuthRequirementKind`
- `ServiceProviderAuthRequirement`

The explicit kinds currently modeled are:

- `none`
- `loginRequiredNoRememberedUser`
- `loginRequiredFromRememberedUser`
- `loginRequiredAfterInvalidSession`
- `error`

This gives the boundary a local and explicit semantic representation.

### 2. Legacy compatibility remains intentionally preserved

Phase 7.4.2 does not remove the legacy `ErrorHandler`-based flow yet.

Instead, the new explicit model provides:

- `legacyErrorCode`
- `toLegacyErrorHandler()`

This allows the runtime to keep its previous result shape while stopping the rest of the implementation from depending directly on raw magic-code comparisons.

### 3. `ServiceProvider.evaluateAuthRequirement()` becomes the semantic source

A new method was introduced inside `ServiceProvider`:

- `evaluateAuthRequirement()`

This method is now the local semantic source for deciding which auth-requirement state applies.

At the current ZIP baseline, the evaluation remains conservative:

- if `loggedUser == null` → `loginRequiredNoRememberedUser`
- if `loggedUser != null` → `loginRequiredFromRememberedUser`

That behavior preserves the current runtime semantics exactly as they existed before, but now with explicit boundary meaning.

### 4. `doCheckLogin()` is now a compatibility wrapper

`doCheckLogin()` was preserved to avoid invasive changes.

However, it is no longer treated as the semantic source of truth.

Instead, it now:

- sets the same observable init stage behavior needed by the current runtime
- delegates auth meaning to `evaluateAuthRequirement()`
- maps that explicit model back into the legacy `ErrorHandler` result

This is the key safety characteristic of 7.4.2.

### 5. Direct raw-code branching was removed from `_handleBackendStatusSuccessFlow(...)`

Before this phase, `_handleBackendStatusSuccessFlow(...)` was branching through direct comparisons such as:

- `-1000`
- `1001`
- `1002`

After normalization, that branching is no longer driven by direct integer checks.

It now works through:

- `evaluateAuthRequirement()`
- `authRequirement.requiresInteractiveLogin`
- `authRequirement.shouldResetAuthenticatedRuntimeState`

This eliminates the sign inconsistency from being the source of control flow.

### 6. Runtime ownership remains unchanged

This phase deliberately preserves the existing ownership map:

- `main.dart` still owns startup-boundary completion state
- loading popup still owns bootstrap waiting/listening UI
- auth feature still owns login UI/bootstrap/submit
- `ServiceProvider` still owns authenticated runtime context
- `ServiceProvider` still triggers the login popup path

That means 7.4.2 is normalization, not redesign.

## Validation

The implementation is considered correct if all of the following remain true:

- startup with no remembered authenticated runtime still opens login path
- startup with remembered local user still reopens login path conservatively
- login popup still returns through navigator result semantics
- authenticated runtime context is still applied through existing ServiceProvider logic
- loading popup still closes only after provider-ready authenticated continuation
- logout still reenters backend/auth requirement logic safely
- no direct branch depends on the previous `1001` sign inconsistency anymore

## Release Impact

This phase should not change the visible UX flow.

Its main impact is architectural and semantic:

- auth requirement is now explicit
- legacy compatibility is preserved
- direct magic-code branching is reduced
- the known sign inconsistency is no longer the runtime decision source

## Risks

The main risk of this phase is not UI regression, but semantic drift.

If implemented incorrectly, the runtime could accidentally:

- stop forcing login after backend status
- reset authenticated runtime too early or too late
- break remembered-user startup continuation
- break logout reentry behavior

That is why the implementation remains conservative and transitional.

## What it does NOT solve

This phase does not yet:

- define a dedicated login continuation contract
- move popup ownership outside `ServiceProvider`
- redesign startup completion semantics
- unify startup entry and logout reentry under one explicit coordinator
- validate backend-persisted authenticated sessions

Those concerns remain possible later work.

## Conclusion

Phase 7.4.2 correctly normalizes the auth-requirement boundary without redesigning the runtime.

The key outcomes are:

- explicit auth-requirement model introduced
- `ServiceProvider` now evaluates auth requirement semantically
- `doCheckLogin()` becomes compatibility logic rather than the primary semantic source
- direct raw-code branching is removed from backend-status continuation
- the previous sign inconsistency stops being the source of runtime behavior

The next safe step, if runtime validation passes, is:

- `Phase 7.4.3 — Login Resolution Continuation Contract`