# 🔁 Phase 8.3 — Retry / Reboot / Reconnect Policy Hardening

## Objective

Harden the execution path of runtime recovery in Mi IP·RED so that retry, reboot, and reconnect requests stop behaving as distributed direct actions and start flowing through an explicit, trigger-aware, policy-driven recovery baseline inside `ServiceProvider`.

## Initial Context

The current ZIP confirms the following baseline:

- Phase 7 is formally closed
- Phase 8 is active
- Phase 8.1 documented the real runtime failure surfaces
- Phase 8.2 introduced explicit failure-boundary normalization
- the architecture remains:
  - `presentation → controller → ServiceProvider`
- runtime recovery requests still existed in multiple places before this step:
  - startup/auth continuation coordinator
  - manual retry button in loading popup
  - `_onDone()` transport disconnect callback
  - logout-driven runtime reset

Phase 8.2 already gave the repository a shared semantic vocabulary for failure interpretation.

That meant the next safe step was no longer to classify failures.

The next safe step was to harden how runtime recovery gets executed.

## Problem Statement

Before 8.3, the repository already had recovery behavior, but it was still triggered through partially direct and partially duplicated execution paths.

Real examples from the ZIP baseline before this step included:

- `_onDone()` calling `reboot()` directly
- startup/auth continuation coordinator calling `reboot()` directly
- the loading popup retry button mutating runtime flags inline and then calling `reboot()`
- `logout()` re-entering backend-status evaluation without an explicit recovery-policy decision

The problem was not absence of recovery.

The problem was that recovery execution was still distributed and only lightly guarded.

## Scope

Phase 8.3 includes:

- explicit runtime recovery trigger model
- explicit runtime recovery policy decision model
- minimal recovery-in-progress guard inside `ServiceProvider`
- trigger-aware recovery entry points for:
  - manual retry
  - startup/auth continuation recovery
  - transport disconnect recovery
  - runtime reset recovery
- removal of inline retry-flag mutation from loading popup UI
- documentation updates that freeze the new recovery baseline

Phase 8.3 does not include:

- transport redesign
- `init()` redesign
- retry-count policy redesign
- reconnect backoff redesign
- UI redesign
- observability expansion
- `ServiceProvider` replacement
- broad runtime engine introduction

## Root Cause Analysis

Phase 8.1 proved that runtime failure handling already existed in multiple operational surfaces.

Phase 8.2 proved that those surfaces could be interpreted through a normalized failure-boundary language.

What still remained unresolved was the execution path of recovery itself.

Recovery triggers were still able to enter runtime restart behavior too directly.

That created four practical risks:

- trigger origin remained implicit
- recovery calls could remain duplicated or overlap conceptually
- UI still touched runtime-recovery flags directly
- future policy hardening would otherwise have to continue from raw direct actions instead of explicit trigger-aware decisions

The root cause was distributed recovery execution, not absence of state classification.

## Files Affected

### New code

- `lib/models/ServiceProvider/runtime_recovery_trigger_model.dart`
- `lib/models/ServiceProvider/runtime_recovery_policy_decision_model.dart`

### Updated code

- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/GeneralLoadingProgress/model.dart`

### Updated documentation

- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_3_retry_reboot_reconnect_policy_hardening.md`
- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`

## Implementation Characteristics

### 1. Runtime recovery trigger is now explicit

`ServiceProviderRuntimeRecoveryTrigger` classifies the recovery origin.

Current triggers are:

- `unknown`
- `startupCoordinator`
- `manualRetry`
- `transportDone`
- `runtimeReset`

This removes the need to treat all reboot-like requests as if they came from the same cause.

### 2. Runtime recovery policy decision is now explicit

`ServiceProviderRuntimeRecoveryPolicyDecision` describes whether a recovery attempt should proceed and what kind of operational reset is allowed.

The model explicitly captures:

- trigger
- failure boundary state
- whether recovery should proceed
- whether loading popup should open
- whether retry counter should reset
- whether session token should reset
- whether recovery would be allowed while another recovery is already running
- reason code
- description

This remains intentionally small.

It is not a framework.

It is a policy description object.

### 3. `ServiceProvider` now owns trigger-aware recovery execution

`ServiceProvider` now exposes explicit recovery entry points:

- `requestManualRecovery()`
- `requestStartupRecovery()`
- `requestTransportRecovery()`
- `requestRuntimeResetRecovery()`

All of them flow through a private `_requestRuntimeRecovery(...)` path.

That path now:

- evaluates policy explicitly
- blocks fatal-boundary recovery
- blocks duplicate recovery while one is already running
- resets only the runtime pieces allowed by policy
- centralizes loading-popup opening
- centralizes re-entry into `init()`

### 4. Minimal in-progress guard is now explicit

`ServiceProvider` now tracks:

- `isRecoveryInProgress`
- `activeRecoveryTrigger`

This is intentionally minimal.

It is not broad orchestration.

It is a narrow deduplication guard so recovery paths stop behaving as totally independent fire-and-forget actions.

### 5. Direct UI mutation of recovery flags was removed

The loading popup retry button no longer mutates:

- `connRetry`
- `initStageAdditionalMsg`
- `initStage`
- `canRetry`

inline from the widget.

Instead, it now delegates to:

- `appStatus.requestManualRecovery()`

That keeps runtime policy inside `ServiceProvider`, where it belongs.

### 6. Startup and transport recovery now use explicit trigger entry points

The startup/auth continuation coordinator now uses:

- `requestStartupRecovery()`

The transport disconnect callback now uses:

- `requestTransportRecovery()`

This means the same broad operational action no longer hides its origin.

### 7. Legacy `reboot()` remains but becomes a compatibility wrapper

`reboot()` remains present so the codebase does not suffer a broader API disruption.

However, it is no longer the raw recovery implementation.

It now delegates into the new explicit recovery entry path.

### 8. Logout now re-enters runtime through explicit recovery semantics

`logout()` now resets authenticated runtime state and then routes re-entry through:

- `requestRuntimeResetRecovery()`

This keeps runtime reset inside the same trigger-aware policy model.

## Validation

The implementation is valid for 8.3 because it satisfies all of the following:

- it preserves the active architecture
- it does not redesign the runtime layer
- it introduces only small explicit models plus narrow execution hardening
- it keeps widgets out of runtime-policy ownership
- it routes recovery through explicit triggers and policy decisions
- it adds a minimal guard against overlapping recovery attempts
- it prepares later observability work without prematurely redesigning transport or startup

## Release Impact

User-visible behavior should remain broadly familiar:

- retry is still available
- startup recovery still occurs
- transport disconnect can still lead to controlled recovery
- logout still resets runtime state

The real impact is internal:

- recovery is now trigger-aware
- recovery is now policy-driven
- duplicate recovery entry is more constrained
- runtime-policy ownership is clearer

## Risks

The main risk is over-interpreting 8.3 as if it solved all runtime policy questions.

It did not.

This phase introduces a safer execution baseline, but it does not yet redesign retry limits, reconnect backoff, or observability.

Another risk is assuming `isRecoveryInProgress` is full orchestration.

It is not.

It is a narrow protection against overlapping recovery entry.

## What it does NOT solve

Phase 8.3 does not yet:

- redesign `init()` recursion
- redesign reconnect timing or backoff
- fix `setCurrentCliente()` boundary validation
- add diagnostic signal streams
- unify error UI
- redesign transport client behavior

Those remain for later steps.

## Conclusion

Phase 8.3 is the correct follow-up to 8.2.

The repository now has:

- explicit failure-boundary semantics
- explicit recovery triggers
- explicit recovery policy decisions
- minimal protection against overlapping recovery execution
- runtime-policy ownership pushed back into `ServiceProvider`

That creates the right baseline for:

- `8.4 — Runtime Diagnostic & Observability Signals`