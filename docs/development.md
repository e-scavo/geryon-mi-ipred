# 🛠️ Development Guidelines

## Objective

Define the active development rules for Mi IP·RED so that future changes preserve the working runtime, respect the current architecture, and continue Phase 8 under an explicit runtime-hardening scope.

## Initial Context

The current ZIP confirms this baseline:

- active architecture: `presentation → controller → ServiceProvider`
- Phase 7 closed
- Phase 8 active
- Phase 8.1 completed as runtime failure surface inventory
- Phase 8.2 completed as failure boundary normalization
- Phase 8.3 completed as retry / reboot / reconnect policy hardening

That means the repository is no longer in a structural extraction phase.

## Problem Statement

Without clear development rules, later work could either:

- reopen closed structural work from Phase 7, or
- start changing runtime recovery policy directly against raw flags and local conditions without respecting the normalized failure-boundary model introduced in 8.2

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
- current Phase 8 documents

These rules do not authorize:

- backend protocol redesign
- `ServiceProvider` replacement
- navigation redesign
- UI redesign
- broad coordinator expansion
- state-management rearchitecture

## Root Cause Analysis

Phase 7 resolved the dominant structural ambiguity.

Phase 8.1 proved the project still had distributed runtime failure surfaces.

Phase 8.2 introduced a normalized semantic model for:

- boundary scope
- recovery expectation
- runtime / feature failure interpretation

That means future runtime-hardening work must now build on the normalized model instead of bypassing it.

## Files Affected

Main files governed by the current baseline include:

- `lib/main.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/ServiceProvider/failure_boundary_scope_model.dart`
- `lib/models/ServiceProvider/failure_recovery_expectation_model.dart`
- `lib/models/ServiceProvider/failure_boundary_state_model.dart`
- `lib/models/ServiceProvider/runtime_recovery_trigger_model.dart`
- `lib/models/ServiceProvider/runtime_recovery_policy_decision_model.dart`
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

Phase 8 is not permission to reopen architecture.

### 2. Runtime hardening must stay runtime-focused

Phase 8 work may harden:

- failure semantics
- retry behavior
- reconnect behavior
- reboot behavior
- runtime recovery boundaries
- diagnostic signaling

It may not drift into:

- broad structural extraction
- widget-owned recovery policy
- speculative new global layers

### 3. The 8.2 boundary model is now mandatory context

Any later work touching retry / reconnect / reboot / reset must first consider the explicit boundary model introduced in 8.2.

That means runtime changes should be interpreted through:

- `ServiceProviderFailureBoundaryScope`
- `ServiceProviderFailureRecoveryExpectation`
- `ServiceProviderFailureBoundaryState`

This is now part of the repository baseline.

### 4. Recovery execution must stay trigger-aware

Any later work touching runtime recovery entry points must route through explicit trigger-aware policy decisions instead of introducing new direct reboot-style calls from UI or coordinator layers.

This means the current baseline now also includes:

- `ServiceProviderRuntimeRecoveryTrigger`
- `ServiceProviderRuntimeRecoveryPolicyDecision`

### 5. ServiceProvider may be hardened, not replaced

`ServiceProvider` remains the runtime owner of:

- transport bootstrap
- authenticated runtime lifecycle
- active operational context
- startup/runtime continuation
- recovery policy execution

It may be clarified and hardened.

It must not be replaced or bypassed by a new runtime engine.

### 6. Widgets must not become recovery-policy owners

Widgets may:

- display failure state
- trigger explicit user actions
- react to already-normalized state

Widgets must not become the place where recovery policy is invented.

### 7. Feature-local failure and runtime-global failure must stay distinct

This distinction is mandatory.

Examples:

- missing authenticated runtime context is not the same as a billing fetch failure
- missing active client context is not the same as a transport disconnect
- startup blocked state is not the same as a feature-local reload problem

### 8. Phase 8 must continue in explicit order

The current recommended order remains:

- `8.1 — Runtime Failure Surface Inventory`
- `8.2 — Failure Boundary Normalization`
- `8.3 — Retry / Reboot / Reconnect Policy Hardening`
- `8.4 — Runtime Diagnostic & Observability Signals`
- `8.5 — Formal Closure of Phase 8`

### 9. No hidden redesign under the label of hardening

The following remain explicitly disallowed unless the ZIP later proves a narrowly justified need:

- broad application coordinator expansion
- event-bus introduction
- global error framework replacement
- navigation replacement
- feature-state ownership redesign
- backend contract redesign

## Validation

Future work is aligned with the current baseline only if all of the following remain true:

- architecture remains `presentation → controller → ServiceProvider`
- runtime hardening stays narrower than redesign
- the 8.2 boundary model is consulted before policy changes
- policy is hardened only after semantics are already explicit
- feature-local logic remains outside widgets where already extracted
- runtime recovery execution continues to flow through explicit trigger-aware entry points

## Release Impact

These guidelines have no direct user-facing runtime impact.

They protect the project from mixing runtime policy changes with architecture changes.

## Risks

If these rules are ignored, future work may:

- reopen closed Phase 7 scope
- bypass the normalized boundary model
- implement retry or reconnect behavior ad hoc
- move operational logic into the wrong layer
- reintroduce direct reboot-style policy from UI code

## What it does NOT solve

This document does not itself:

- change retry behavior
- change reboot behavior
- change reconnect behavior
- fix runtime hotspots
- add observability signals

It only defines how that work must proceed.

## Conclusion

The active development baseline is now:

- Phase 7 closed
- Phase 8 active
- failure surfaces inventoried
- failure boundaries normalized
- runtime recovery execution hardened through explicit trigger-aware policy

Future work must now continue from that explicit semantic baseline, with runtime recovery execution routed through explicit recovery triggers and policy decisions instead of ad hoc direct reboot calls.