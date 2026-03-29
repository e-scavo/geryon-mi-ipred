# 🛠️ Development Guidelines

## Objective

Define the active development rules for Mi IP·RED so that future changes preserve the working runtime, respect the current architecture, retain the closed Phase 7 and Phase 8 baselines, and execute Phase 9 as controlled product-surface consistency work rather than hidden redesign.

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
- Phase 9 opened as product surface consistency and UX hardening
- Phase 9.1 completed as product surface inventory
- Phase 9.2.1 completed as shared state surface contract foundation
- Phase 9.2.2 completed as Billing state surface normalization
- Phase 9.2.3 completed as Dashboard state presentation normalization
- Phase 9.2.4 completed as Auth interaction feedback normalization

That means the repository is no longer in either:

- a structural extraction phase, or
- an active runtime hardening phase

It is now in a controlled product-surface consistency phase.

## Problem Statement

Without clear development rules after the closure of Phase 8 and the opening of Phase 9, later work could still:

- reopen closed structural work from Phase 7
- reopen closed runtime-hardening work from Phase 8
- disguise redesign as UX-hardening work
- blur the difference between product-surface consistency and feature expansion
- add inconsistent UI state handling while claiming to improve consistency

## Scope

These rules apply to work touching:

- `lib/main.dart`
- `lib/models/ServiceProvider/**`
- `lib/models/GeneralLoadingProgress/**`
- `lib/models/LoadingGeneric/**`
- `lib/core/transport/**`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/**`
- `lib/shared/**`
- current Phase 7, Phase 8, and Phase 9 documents

These rules do not authorize by default:

- backend protocol redesign
- `ServiceProvider` replacement
- navigation redesign
- full UI redesign
- broad coordinator expansion
- state-management rearchitecture
- informal reopening of Phase 8 runtime hardening scope
- speculative introduction of a broad UI framework

## Root Cause Analysis

Phase 7 resolved the dominant structural ambiguity.

Phase 8 resolved the dominant runtime-hardening ambiguity by introducing:

- failure surface inventory
- failure-boundary normalization
- trigger-aware recovery policy execution
- runtime diagnostic events and snapshot exposure

After those closures, the dominant unresolved concern became visible product-surface inconsistency.

That means Phase 9 must improve:

- loading surfaces
- error surfaces
- empty states
- retry affordances
- feature-to-feature UX consistency

without disturbing the retained structural and runtime baselines.

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
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/shared/widgets/**`
- `lib/models/LoadingGeneric/widget.dart`
- `lib/core/transport/geryonsocket_model.dart`
- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/core/transport/geryonsocket_model_web.dart`

## Implementation Characteristics

### 1. The architecture remains frozen

All new work must preserve:

- `presentation → controller → ServiceProvider`

Neither Phase 7 nor Phase 8 remains open for reinterpretation as architectural redesign.

### 2. Phase 8 runtime hardening remains retained baseline

The following are no longer experimental or provisional:

- failure-boundary semantics
- recovery trigger semantics
- recovery policy decision semantics
- guarded runtime recovery entry points
- bounded runtime diagnostic events
- runtime diagnostic snapshot exposure

Any future work must treat these as part of the active repository baseline.

### 3. Phase 9 may improve visible product surfaces only

Phase 9 may standardize:

- loading surfaces
- recoverable feature-error surfaces
- empty states
- retry affordances
- visible interaction consistency

Phase 9 must not:

- redesign runtime semantics
- take ownership away from controllers or `ServiceProvider`
- hide broad design changes under small UI wording

### 4. Runtime changes must not bypass retained semantic models

Any future work touching runtime continuation, recovery, or diagnostics must still respect:

- `ServiceProviderFailureBoundaryScope`
- `ServiceProviderFailureRecoveryExpectation`
- `ServiceProviderFailureBoundaryState`
- `ServiceProviderRuntimeRecoveryTrigger`
- `ServiceProviderRuntimeRecoveryPolicyDecision`
- runtime diagnostic event and snapshot models

These are part of the closed baseline.

### 5. ServiceProvider remains the runtime owner

`ServiceProvider` remains the owner of:

- transport bootstrap
- authenticated runtime lifecycle
- active operational context
- startup/runtime continuation
- recovery policy execution
- runtime diagnostic signal emission

It may be maintained and incrementally improved when justified.

It must not be replaced or bypassed casually.

### 6. Widgets must not become owners of business or runtime policy

Widgets may:

- display current state
- trigger explicit user actions
- react to already-normalized and already-owned state
- offer shared presentation surfaces for loading / error / empty cases

Widgets must not:

- redefine recovery policy
- mutate runtime baseline flags ad hoc
- become owners of diagnostic logic
- perform controller work
- replace feature-state ownership with UI-state ownership

### 7. Minimal shared UI surfaces are allowed

Phase 9 explicitly allows narrowly scoped reusable widgets when they:

- reduce visible inconsistency
- remain presentation-only
- do not become a hidden framework
- do not pull business logic out of controllers

This rule justifies small shared state-surface widgets.

It does not justify a large new abstraction layer.

### 8. Billing, Dashboard, and Auth now act as the reference adoption pattern

Billing, Dashboard, and Auth are now the concrete adopters of the shared Phase 9 consistency baseline.

That means future feature adoption should follow the same discipline:

- controller keeps feature-state semantics
- widget renders clear visible state branches
- recoverable feature errors remain distinct from system failures
- loading meanings remain explicit rather than generic
- retry stays natural to the feature context

### 9. Closed phases must not be reopened informally

This remains a mandatory rule.

Future work must not continue as:

- implicit `7.x`
- implicit `8.x`

If future work truly requires a new scope, that scope must be opened explicitly as a justified new phase.

### 10. Narrow maintenance remains allowed

Closing Phase 8 does not prohibit all changes.

It allows:

- bug fixes
- narrowly justified hardening
- compatibility adjustments
- documentation alignment
- product-surface consistency work inside the explicit Phase 9 scope

### 11. No hidden redesign under the label of UX hardening

The following remain explicitly disallowed unless the ZIP later proves a narrowly justified need:

- broad application coordinator expansion
- event-bus introduction
- global error framework replacement
- navigation replacement
- feature-state ownership redesign
- backend contract redesign
- new speculative runtime engine layers
- speculative broad design-system introduction

## Validation

Future work is aligned with the current baseline only if all of the following remain true:

- architecture remains `presentation → controller → ServiceProvider`
- closed Phase 7 scope is not reopened informally
- closed Phase 8 scope is not reopened informally
- retained runtime semantic models remain respected
- retained recovery-policy models remain respected
- retained runtime observability models remain respected
- Phase 9 changes stay surface-oriented
- shared widgets remain presentation-only
- maintenance remains narrower than redesign

## Release Impact

These guidelines have no direct user-facing runtime impact.

They protect the project from reopening already closed baselines and preserve the discipline of explicit phase-based evolution while permitting controlled Phase 9 UX hardening.

## Risks

If these rules are ignored, future work may:

- reopen closed structural scope
- reopen closed runtime-hardening scope
- bypass the retained runtime semantic baseline
- introduce ad hoc runtime changes that weaken the current architecture
- create a fragmented pseudo-design-system
- blur the difference between UX hardening and redesign

## What it does NOT solve

This document does not itself:

- change runtime behavior
- add new diagnostics
- normalize every screen immediately
- fix all historical UI hotspots
- define the full Phase 9 roadmap implementation order

It only defines how future work must behave after the closure of Phase 8 and during active Phase 9 execution.

## Conclusion

The active development baseline is now:

- Phase 7 closed
- Phase 8 closed
- structural and runtime-hardening baselines frozen
- Phase 9 opened for controlled product-surface consistency work
- Phase 9.2.2 established Billing normalization
- Phase 9.2.3 established Dashboard normalization
- Phase 9.2.4 established Auth normalization
- future work required to respect retained baselines without reopening them informally

Any future larger scope beyond this must still begin as a new explicitly justified phase.