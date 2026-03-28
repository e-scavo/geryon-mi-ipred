# 🧭 Phase 8.2 — Failure Boundary Normalization

## Objective

Introduce an explicit and reusable runtime failure-boundary language for Mi IP·RED so that later recovery hardening work can act on a normalized semantic model instead of ad hoc combinations of runtime flags and feature-local checks.

## Initial Context

The current ZIP confirms the following baseline:

- Phase 7 is formally closed
- Phase 8 is open
- Phase 8.1 already documented the real runtime failure surfaces
- the active architecture remains:
  - `presentation → controller → ServiceProvider`
- `ServiceProvider` remains the owner of runtime connectivity, bootstrap, authenticated context, and active operational client context
- `billing` is the clearest current feature-level example of a feature that depends on both runtime-global validity and feature-local loading behavior

Phase 8.1 proved that the runtime already contains real recovery-related behavior, but that the semantics of failure were still distributed across:

- `initStage`
- `isReady`
- `isProgress`
- `canRetry`
- authenticated-runtime checks
- active-client checks
- feature-local request failures

That made 8.2 the next safe step.

## Problem Statement

The project already had failure handling.

What it lacked was an explicit normalized answer to these questions:

- is this a startup-boundary problem or a feature-local problem?
- does this state invalidate the authenticated runtime context?
- does this state invalidate only the active operational client context?
- is the correct expectation to keep waiting, request login, allow manual retry, suggest reboot, or limit recovery to feature reload?

Without that normalization, later work in retry / reboot / reconnect would risk being implemented directly against raw runtime flags, which would keep the semantics implicit and fragile.

## Scope

Phase 8.2 includes:

- explicit runtime failure-boundary scope model
- explicit recovery-expectation model
- normalized failure-boundary state model
- a pure `ServiceProvider` evaluator that maps current runtime state to that language
- a conservative billing-boundary evaluator that distinguishes runtime-invalid versus feature-local failure conditions
- documentation updates to freeze the new semantic baseline

Phase 8.2 does not include:

- reconnect-policy changes
- retry-policy changes
- reboot-sequencing changes
- logout-sequencing changes
- UI redesign
- error-presentation unification
- `ServiceProvider` replacement
- structural redesign

## Root Cause Analysis

By the end of Phase 7, the dominant unresolved concern was no longer application structure.

The dominant unresolved concern became runtime semantics under failure.

The code already had meaningful state transitions and recovery paths, but they were still interpreted indirectly through combinations such as:

- `initStage + canRetry`
- `isReady + isProgress`
- `loggedUser == null`
- `availableClients.isEmpty`
- `activeClient == null`

That meant the runtime could behave correctly in many cases while still lacking a formal shared language that future hardening work could safely build upon.

The root cause was not absence of logic.

The root cause was absence of normalization.

## Files Affected

### New code

- `lib/models/ServiceProvider/failure_boundary_scope_model.dart`
- `lib/models/ServiceProvider/failure_recovery_expectation_model.dart`
- `lib/models/ServiceProvider/failure_boundary_state_model.dart`

### Updated code

- `lib/models/ServiceProvider/data_model.dart`
- `lib/features/billing/controllers/billing_controller.dart`

### Updated documentation

- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_2_failure_boundary_normalization.md`
- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`

## Implementation Characteristics

### 1. Boundary scope is now explicit

The new boundary-scope model introduces named semantic categories instead of relying only on raw boolean combinations.

Current normalized scope categories are:

- `none`
- `startupBoundary`
- `runtimeGlobal`
- `authContinuation`
- `activeOperationalContext`
- `featureLocal`
- `transport`
- `backendRequest`

This is intentionally narrow.

It is not a framework.

It is a semantic vocabulary.

### 2. Recovery expectation is now explicit

The new recovery-expectation model introduces the runtime expectation associated with a boundary.

Current normalized expectations are:

- `none`
- `stayWaiting`
- `interactiveLoginRequired`
- `manualRetryAllowed`
- `automaticRebootCandidate`
- `runtimeResetRequired`
- `featureReloadAllowed`
- `fatalBlocked`

These values do not yet change runtime behavior.

They only describe what kind of recovery category the current state belongs to.

### 3. Failure-boundary state is now an explicit object

`ServiceProviderFailureBoundaryState` centralizes:

- boundary scope
- recovery expectation
- init stage
- reason code
- description
- whether startup is blocked
- whether authenticated runtime context is invalidated
- whether active operational context is invalidated
- whether the feature can safely continue

This gives the codebase a single semantic object that later phases can consult before changing runtime policy.

### 4. `ServiceProvider` now exposes a pure boundary evaluator

`ServiceProvider.evaluateFailureBoundaryState()` is a pure semantic evaluator.

It does not change runtime behavior.

It maps the current runtime state into one normalized boundary result, for example:

- fully ready runtime → `none`
- bootstrap in progress → `startupBoundary + stayWaiting`
- interactive login required → `authContinuation + interactiveLoginRequired`
- disconnected transport → `transport + automaticRebootCandidate`
- explicit startup error → `startupBoundary + manualRetryAllowed`
- high severity backend state → `startupBoundary + fatalBlocked`
- missing active client context → `activeOperationalContext + featureReloadAllowed`

That is the core implementation of 8.2.

### 5. Billing now distinguishes runtime-invalid vs feature-local failure

`BillingController` now exposes `evaluateBillingFailureBoundaryState()`.

It classifies billing failures conservatively into:

- `authContinuation` when authenticated runtime context is missing
- `activeOperationalContext` when runtime exists but active client context is missing or invalid
- `featureLocal` when runtime and active client are valid but the billing request itself fails
- `none` when the billing boundary is clear

This keeps billing aligned with the new runtime language without redesigning the billing feature state model.

### 6. Billing state now carries normalized boundary metadata

`BillingFeatureState` and `BillingLoadResult` now optionally carry a `failureBoundaryState`.

This does not alter the current UI flow.

It preserves current behavior while making the semantic classification available for later hardening.

### 7. No policy change was introduced yet

This is critical.

Phase 8.2 deliberately does not change:

- retry execution
- reboot execution
- reconnect execution
- logout sequencing
- loading popup sequencing

It only makes the current semantics explicit.

## Validation

The implementation is valid for 8.2 because it satisfies all of the following:

- it preserves the current architecture
- it introduces only pure semantic models plus pure evaluators
- it does not redesign `ServiceProvider`
- it does not move logic back into widgets
- it does not change runtime flow contracts
- it gives both runtime-global and feature-local logic a shared semantic vocabulary
- it prepares 8.3 without prematurely altering operational policy

## Release Impact

User-visible runtime behavior should remain effectively unchanged.

The impact of 8.2 is internal and architectural:

- runtime semantics are now explicit
- future hardening can target normalized categories instead of raw state combinations
- billing now distinguishes runtime-invalid versus feature-local failure more clearly

## Risks

The main risk is semantic over-classification.

This phase mitigates that by keeping the model intentionally small and by avoiding behavior changes.

Another risk is assuming the new model is already a policy engine.

It is not.

The new model is descriptive, not yet prescriptive.

## What it does NOT solve

Phase 8.2 does not yet:

- decide when reboot should actually happen
- decide how many retries should occur
- change disconnect handling
- fix `setCurrentCliente()` boundary validation
- change `logout()` sequencing
- unify error UI
- add observability signals

Those remain for later subphases.

## Conclusion

Phase 8.2 is the correct next step after the failure-surface inventory.

The codebase now has an explicit shared language for:

- failure boundary scope
- recovery expectation
- normalized runtime / feature failure interpretation

That creates the safe foundation required for:

- `8.3 — Retry / Reboot / Reconnect Policy Hardening`
