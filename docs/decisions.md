# 🧠 Architectural & Implementation Decisions

## Objective

Record the active architectural and implementation decisions that govern Mi IP·RED after the closure of Phase 7 and after the formal closure of Phase 8 as the completed runtime hardening baseline.

## Initial Context

The current ZIP confirms:

- Phase 7 is closed
- the architecture remains `presentation → controller → ServiceProvider`
- Phase 8 is closed
- Phase 8.1 documented runtime failure surfaces
- Phase 8.2 introduced explicit failure-boundary normalization
- Phase 8.3 introduced explicit recovery-trigger and policy-decision hardening
- Phase 8.4 introduced explicit runtime diagnostic / observability signals
- Phase 8.5 formally closes Phase 8

## Problem Statement

The repository now needs a clear decision baseline so that future development does not:

- reopen structural scope
- reopen runtime-hardening scope
- bypass the retained semantic model
- treat runtime-global and feature-local failures as interchangeable
- introduce policy changes without recognizing that Phase 8 is already closed

## Scope

These decisions govern:

- current architecture interpretation
- ownership of runtime lifecycle
- retained interpretation of the boundary model
- retained interpretation of trigger-aware recovery execution
- retained interpretation of runtime observability
- sequencing expectations for future work
- what remains explicitly out of scope

## Root Cause Analysis

After Phase 7, the dominant unresolved concern was no longer structure.

After Phase 8.1, the dominant unresolved concern was no longer discovery of failure surfaces.

After Phase 8.2, the project had explicit semantic vocabulary for runtime and feature failure boundaries.

After Phase 8.3, recovery entry and recovery policy execution were explicitly hardened.

After Phase 8.4, runtime observability also became explicit and bounded.

At that point, the correct remaining step was formal closure.

The repository now needs decisions that preserve that closure and prevent Phase 8 from being treated as still-open design space.

## Files Affected

These decisions directly govern interpretation of:

- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/ServiceProvider/failure_boundary_scope_model.dart`
- `lib/models/ServiceProvider/failure_recovery_expectation_model.dart`
- `lib/models/ServiceProvider/failure_boundary_state_model.dart`
- `lib/models/ServiceProvider/runtime_recovery_trigger_model.dart`
- `lib/models/ServiceProvider/runtime_recovery_policy_decision_model.dart`
- `lib/models/ServiceProvider/runtime_diagnostic_event_type_model.dart`
- `lib/models/ServiceProvider/runtime_diagnostic_event_model.dart`
- `lib/models/ServiceProvider/runtime_diagnostic_snapshot_model.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/core/transport/geryonsocket_model.dart`
- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/core/transport/geryonsocket_model_web.dart`
- `docs/phase8_runtime_reliability_failure_semantics_hardening.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_2_failure_boundary_normalization.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_3_retry_reboot_reconnect_policy_hardening.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_4_runtime_diagnostic_observability_signals.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_5_formal_closure.md`

## Implementation Characteristics

### Decision 1 — Phase 7 remains closed

No further `7.x` continuation is active.

Structural consolidation remains frozen.

### Decision 2 — Phase 8 also remains closed

No further `8.x` continuation is active after the current baseline.

Runtime hardening remains frozen at the baseline completed through Phase 8.5.

### Decision 3 — The active architecture remains unchanged

The active architecture remains:

- `presentation → controller → ServiceProvider`

This is a fixed baseline, not an open design question.

### Decision 4 — ServiceProvider remains the runtime owner

`ServiceProvider` remains the owner of:

- connection bootstrap
- authenticated runtime lifecycle
- startup/runtime continuation
- active operational client context
- trigger-aware recovery execution
- runtime diagnostic signal emission

This ownership is retained as part of the closed Phase 8 baseline.

### Decision 5 — The Phase 8 failure-boundary model is retained baseline

The project explicitly retains:

- `ServiceProviderFailureBoundaryScope`
- `ServiceProviderFailureRecoveryExpectation`
- `ServiceProviderFailureBoundaryState`

These models remain the shared language for interpreting runtime and feature failure boundaries.

### Decision 6 — Trigger-aware recovery execution is retained baseline

The project explicitly retains:

- `ServiceProviderRuntimeRecoveryTrigger`
- `ServiceProviderRuntimeRecoveryPolicyDecision`

Recovery entry points must remain routed through explicit trigger-aware policy decisions unless a future explicitly justified phase changes that baseline.

### Decision 7 — Runtime observability is retained baseline

The project explicitly retains:

- `ServiceProviderRuntimeDiagnosticEventType`
- `ServiceProviderRuntimeDiagnosticEvent`
- `ServiceProviderRuntimeDiagnosticSnapshot`

Bounded runtime observability is now part of the repository baseline, not a provisional experiment.

### Decision 8 — Policy changes must still follow semantics

Any future change to retry / reboot / reconnect / reset behavior must continue to respect the retained semantic model first.

Phase 8 closure does not remove that rule.

It freezes it.

### Decision 9 — Billing remains an explicit example of boundary distinction

Billing continues to represent the distinction between:

- authenticated-runtime invalidity
- active operational context invalidity
- feature-local load failure

That distinction remains part of the retained baseline.

### Decision 10 — Error-presentation heterogeneity remains evidence, not redesign permission

The current code still presents errors through different UI surfaces.

That remains historical evidence of how runtime concerns evolved.

It is still not, by itself, justification for a new global error framework or redesign.

### Decision 11 — Runtime-global and feature-local failures must not be merged implicitly

The following remain distinct categories:

- startup blocked state
- auth continuation required state
- transport disconnect state
- active client context invalidity
- feature-local request failure

This distinction remains mandatory after Phase 8 closure.

### Decision 12 — Future larger work must open a new explicit phase

Neither Phase 7 nor Phase 8 should be reopened informally.

If future work requires more than narrow maintenance, it must open a new justified phase rather than continue under implicit closed-scope labels.

## Validation

These decisions are valid only if the current ZIP still confirms all of the following:

- Phase 7 is closed
- Phase 8 is closed
- the architecture is stable
- the retained failure-boundary model exists in code
- the retained recovery-trigger and policy model exists in code
- the retained runtime observability model exists in code

The current ZIP confirms those conditions.

## Release Impact

These decisions have no direct user-facing impact.

They protect the interpretation of the repository and ensure that both the structural baseline and the runtime-hardening baseline remain clearly frozen.

## Risks

If these decisions are ignored, future work may:

- bypass the retained semantic model
- reopen runtime-hardening scope informally
- overreact to local issues with broad runtime changes
- weaken the clarity gained through Phase 8
- reintroduce architecture drift under the label of maintenance

## What it does NOT solve

This decision record does not itself:

- change reconnect behavior
- change retry behavior
- change reboot behavior
- fix current hotspots such as `setCurrentCliente()`
- add new observability features
- define the next phase scope

It only freezes the correct interpretation of the current baseline after formal closure of Phase 8.

## Conclusion

The current project baseline is now:

- Phase 7 closed
- architecture frozen
- Phase 8 closed
- ServiceProvider retained as runtime owner
- failure surfaces inventoried in 8.1
- failure boundaries normalized in 8.2
- recovery execution hardened in 8.3
- runtime observability added in 8.4
- runtime hardening formally frozen in 8.5

Future work must now continue from that explicit retained baseline, and any larger new scope must begin as a new justified phase.