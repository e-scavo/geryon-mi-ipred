# 🛠️ Development Guidelines

## Objective

Define the active development rules for Mi IP·RED so that future changes preserve the working runtime, respect the current architecture, and treat both the structural baseline and the runtime hardening baseline as already closed.

## Initial Context

The current ZIP confirms this baseline:

- active architecture: `presentation → controller → ServiceProvider`
- Phase 7 closed
- Phase 8 closed
- Phase 8.1 completed as runtime failure surface inventory
- Phase 8.2 completed as failure boundary normalization
- Phase 8.3 completed as retry / reboot / reconnect policy hardening
- Phase 8.4 completed as runtime diagnostic / observability signals
- Phase 8.5 completed as formal closure of Phase 8

That means the repository is no longer in either:

- a structural extraction phase, or
- an active runtime hardening phase

## Problem Statement

Without clear development rules after formal closure, later work could still:

- reopen closed structural work from Phase 7
- reopen closed runtime-hardening work from Phase 8
- continue changing runtime recovery policy or runtime semantics as if Phase 8 were still open
- blur the difference between baseline-preserving maintenance and genuinely new phase-worthy work

## Scope

These rules apply to work touching:

- `lib/main.dart`
- `lib/models/ServiceProvider/**`
- `lib/models/GeneralLoadingProgress/**`
- `lib/core/transport/**`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/**`
- current Phase 7 and Phase 8 documents

These rules do not authorize by default:

- backend protocol redesign
- `ServiceProvider` replacement
- navigation redesign
- UI redesign
- broad coordinator expansion
- state-management rearchitecture
- informal reopening of Phase 8 runtime hardening scope

## Root Cause Analysis

Phase 7 resolved the dominant structural ambiguity.

Phase 8 resolved the dominant runtime-hardening ambiguity by introducing:

- failure surface inventory
- failure-boundary normalization
- trigger-aware recovery policy execution
- runtime diagnostic events and snapshot exposure

That means future development must now treat those outcomes as retained baseline, not as still-open design space.

## Files Affected

Main files governed by the current baseline include:

- `lib/main.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/ServiceProvider/failure_boundary_scope_model.dart`
- `lib/models/ServiceProvider/failure_recovery_expectation_model.dart`
- `lib/models/ServiceProvider/failure_boundary_state_model.dart`
- `lib/models/ServiceProvider/runtime_recovery_trigger_model.dart`
- `lib/models/ServiceProvider/runtime_recovery_policy_decision_model.dart`
- `lib/models/ServiceProvider/runtime_diagnostic_event_type_model.dart`
- `lib/models/ServiceProvider/runtime_diagnostic_event_model.dart`
- `lib/models/ServiceProvider/runtime_diagnostic_snapshot_model.dart`
- `lib/models/ServiceProvider/init_stages_enum_model.dart`
- `lib/models/ServiceProvider/auth_requirement_model.dart`
- `lib/models/ServiceProvider/login_continuation_result_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/core/transport/geryonsocket_model.dart`
- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/core/transport/geryonsocket_model_web.dart`

## Implementation Characteristics

### 1. The architecture remains frozen

All new work must preserve:

- `presentation → controller → ServiceProvider`

Neither Phase 7 nor Phase 8 remains open for reinterpretation as architectural redesign.

### 2. Phase 8 runtime hardening is now retained baseline

The following are no longer experimental or provisional:

- failure-boundary semantics
- recovery trigger semantics
- recovery policy decision semantics
- guarded runtime recovery entry points
- bounded runtime diagnostic events
- runtime diagnostic snapshot exposure

Any future work must treat these as part of the active repository baseline.

### 3. Runtime changes must not bypass retained semantic models

Any future work touching runtime continuation, recovery, or diagnostics must still respect:

- `ServiceProviderFailureBoundaryScope`
- `ServiceProviderFailureRecoveryExpectation`
- `ServiceProviderFailureBoundaryState`
- `ServiceProviderRuntimeRecoveryTrigger`
- `ServiceProviderRuntimeRecoveryPolicyDecision`
- runtime diagnostic event and snapshot models

These are now part of the closed baseline.

### 4. ServiceProvider remains the runtime owner

`ServiceProvider` remains the owner of:

- transport bootstrap
- authenticated runtime lifecycle
- active operational context
- startup/runtime continuation
- recovery policy execution
- runtime diagnostic signal emission

It may be maintained and incrementally improved when justified.

It must not be replaced or bypassed casually.

### 5. Widgets must not become runtime-policy owners

Widgets may:

- display current state
- trigger explicit user actions
- react to already-normalized and already-owned runtime state

Widgets must not:

- redefine recovery policy
- mutate runtime baseline flags ad hoc
- become owners of diagnostic logic
- reintroduce direct reboot-style runtime control

### 6. Closed phases must not be reopened informally

This is now a mandatory rule.

Future work must not continue as:

- implicit `7.x`
- implicit `8.x`

If future work truly requires a new scope, that scope must be opened explicitly as a new justified phase.

### 7. Narrow maintenance remains allowed

Closing Phase 8 does not prohibit all changes.

It does allow:

- bug fixes
- narrowly justified hardening
- compatibility adjustments
- documentation alignment
- production maintenance

However, such changes must not be misrepresented as continuation of still-open Phase 8 work.

### 8. No hidden redesign under the label of maintenance

The following remain explicitly disallowed unless the ZIP later proves a narrowly justified need:

- broad application coordinator expansion
- event-bus introduction
- global error framework replacement
- navigation replacement
- feature-state ownership redesign
- backend contract redesign
- new speculative runtime engine layers

## Validation

Future work is aligned with the current baseline only if all of the following remain true:

- architecture remains `presentation → controller → ServiceProvider`
- closed Phase 7 scope is not reopened informally
- closed Phase 8 scope is not reopened informally
- retained runtime semantic models remain respected
- retained recovery-policy models remain respected
- retained runtime observability models remain respected
- maintenance remains narrower than redesign

## Release Impact

These guidelines have no direct user-facing runtime impact.

They protect the project from reopening already closed baselines and preserve the discipline of explicit phase-based evolution.

## Risks

If these rules are ignored, future work may:

- reopen closed structural scope
- reopen closed runtime-hardening scope
- bypass the retained runtime semantic baseline
- introduce ad hoc runtime changes that weaken the current architecture
- blur the difference between maintenance and new-phase work

## What it does NOT solve

This document does not itself:

- change runtime behavior
- add new diagnostics
- fix historical hotspots
- define the next phase roadmap

It only defines how future work must behave after formal closure of Phase 8.

## Conclusion

The active development baseline is now:

- Phase 7 closed
- Phase 8 closed
- structural and runtime-hardening baselines frozen
- future work required to respect both retained baselines without reopening them informally

Any future larger scope must now begin as a new explicitly justified phase.