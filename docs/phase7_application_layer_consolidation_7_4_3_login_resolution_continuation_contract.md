# 🧩 Phase 7.4.3 — Login Resolution Continuation Contract

## Objective

Make the startup/auth login resolution path explicit by introducing a formal continuation result contract inside `ServiceProvider`, so the runtime no longer depends on raw popup return semantics, implicit `null` handling, or hybrid success/failure interpretation logic.

## Initial Context

Phase 7.4.1 inventoried the real startup/auth continuation path.

Phase 7.4.2 normalized auth requirement semantics by introducing:

- `ServiceProviderAuthRequirementKind`
- `ServiceProviderAuthRequirement`
- `ServiceProvider.evaluateAuthRequirement()`

That solved the question of whether login must be reopened.

However, the next runtime segment remained implicit:

- popup opens
- popup returns some raw value
- ServiceProvider interprets that value
- authenticated runtime continuation is either resumed or aborted

Before 7.4.3, that segment still depended on raw `ErrorHandler` shape, payload casting, and the ambiguous meaning of `null` popup results.

## Problem Statement

The real remaining problem after 7.4.2 was not auth requirement itself.

It was login continuation resolution.

The ZIP showed the following weaknesses:

- `LoginPageWidget` returned `Navigator.pop(context, result.response)`
- `_handleBackendStatusSuccessFlow(...)` received the popup return directly
- `_handleBackendStatusLoginFailure(...)` handled both failure and success despite its name
- `null` popup results had no explicit continuation meaning
- success depended on both `errorCode == 0` and a castable `data` payload

That meant the continuation contract still existed only implicitly.

## Scope

This phase covers only the explicit resolution contract for login continuation.

It includes:

- a new continuation result model
- explicit normalization of popup return values
- explicit distinction between success, failure, cancellation, and invalid results
- replacement of the previous hybrid post-login handler with explicit continuation resolution
- documentation updates aligned with the new contract

It does not include:

- moving popup ownership outside `ServiceProvider`
- redesigning `LoginPageWidget`
- redesigning `main.dart`
- redesigning loading popup behavior
- introducing a broader coordinator
- changing logout flow semantics
- redesigning navigation

## Root Cause Analysis

The old runtime was safe enough while earlier phases clarified bigger architectural concerns.

But once auth requirement itself became explicit in 7.4.2, the next implicit seam became obvious:

- auth requirement was explicit
- login continuation result was still implicit

That created a structural mismatch.

The runtime knew why login was required, but still did not model explicitly what came back from the login resolution step.

As a result, continuation logic still depended on weakly typed popup return semantics.

## Files Affected

### Code

- `lib/models/ServiceProvider/login_continuation_result_model.dart` ← new
- `lib/models/ServiceProvider/data_model.dart`

### Documentation

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_4_3_login_resolution_continuation_contract.md`

## Implementation Characteristics

### 1. Explicit login continuation result model introduced

A new file was added:

- `lib/models/ServiceProvider/login_continuation_result_model.dart`

It defines:

- `ServiceProviderLoginContinuationDisposition`
- `ServiceProviderLoginContinuationResult`

The modeled dispositions are:

- `success`
- `cancelled`
- `failed`
- `invalidResult`

This makes the post-login continuation path explicit.

### 2. Popup return normalization is now local to `ServiceProvider`

A new method was introduced inside `ServiceProvider`:

- `_resolveLoginContinuationResult(...)`

This method receives the raw popup result and converts it into the explicit continuation model.

It now distinguishes between:

- `null` result → `cancelled`
- non-`ErrorHandler` result → `invalidResult`
- `ErrorHandler` with non-zero code → `failed`
- `ErrorHandler` success without valid authenticated payload → `invalidResult`
- `ErrorHandler` success with valid authenticated payload → `success`

### 3. Success and failure continuation handling are now separated explicitly

The previous hybrid handler:

- `_handleBackendStatusLoginFailure(...)`

was replaced by:

- `_handleResolvedLoginContinuation(...)`

That new method now consumes the explicit continuation model and applies runtime state accordingly.

This corrects the old semantic mismatch between method name and actual behavior.

### 4. `null` popup return no longer falls through implicitly

Before this phase, a `null` popup result could leave the runtime depending on accidental fallthrough behavior.

After 7.4.3:

- `null` popup result becomes an explicit continuation failure state
- the runtime records it as an error boundary outcome
- startup/auth continuation does not silently pass through as success

### 5. Missing navigator state no longer leaves continuation implicit

If auth is required but no navigator state is available, the runtime now produces an explicit `invalidResult` continuation outcome.

That means a structurally invalid continuation start is now expressed directly rather than left to implicit fallthrough.

### 6. Runtime ownership remains unchanged

This phase does not move ownership boundaries.

The current ownership map remains:

- `main.dart` owns startup boundary completion state
- loading popup owns waiting/listening UI
- auth feature owns login UI/bootstrap/submit
- `ServiceProvider` owns authenticated runtime context
- `ServiceProvider` still owns popup entry for login continuation

This remains a hardening step, not a redesign.

## Validation

The implementation is considered correct if all of the following remain true:

- startup with no remembered user still opens login flow
- startup with remembered local user still reopens login flow conservatively
- successful login still materializes authenticated runtime context
- login failure still keeps startup/auth continuation unresolved
- popup `null` result is handled explicitly
- invalid popup return types are handled explicitly
- logout reentry still goes through the same startup/auth family safely
- loading popup still closes only after provider-ready authenticated continuation

## Release Impact

This phase is intended to have low visible UX impact.

Its primary value is semantic and runtime-safety related:

- continuation result meaning is now explicit
- success/failure/cancellation are separated clearly
- popup return handling is no longer weakly implicit
- invalid continuation results no longer pass unnoticed

## Risks

The main risk is misclassifying a real successful login response as invalid.

That would prevent authenticated continuation from completing.

For that reason, the implementation keeps the existing successful runtime contract intact:

- success still depends on an `ErrorHandler`
- success still requires a valid `ServiceProviderLoginDataUserMessageModel`
- runtime ownership still stays in `ServiceProvider`

## What it does NOT solve

This phase does not yet:

- move popup ownership outside `ServiceProvider`
- introduce continuation-source modeling across startup vs logout
- redesign startup boundary completion
- unify startup and logout reentry through a dedicated coordinator
- redesign login widget return shape

Those remain possible later concerns.

## Conclusion

Phase 7.4.3 correctly makes login continuation resolution explicit without redesigning the runtime.

The key outcomes are:

- explicit login continuation result model introduced
- popup return values are now normalized explicitly
- hybrid success/failure continuation logic was replaced with an explicit contract consumer
- `null` and invalid popup results no longer rely on implicit behavior
- runtime ownership remains unchanged

The next safe target, if validation remains clean, is:

- `Phase 7.4.4 — Minimal Startup/Auth Continuation Coordinator` only if still justified by the real code