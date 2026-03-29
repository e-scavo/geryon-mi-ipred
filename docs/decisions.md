# 🧠 Architectural & Implementation Decisions

## Objective

Record the active architectural and implementation decisions that govern Mi IP·RED after the closure of Phase 7, after the formal closure of Phase 8 as the completed runtime hardening baseline, and during the opening of Phase 9 as the active product-surface consistency baseline.

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
- Phase 9 is opened as product surface consistency and UX hardening
- Phase 9.1 inventories product-surface inconsistency
- Phase 9.2.1 introduces the minimal shared state-surface contract foundation
- Phase 9.2.2 applies that shared contract concretely to Billing
- Phase 9.2.3 applies that shared contract concretely to Dashboard
- Phase 9.2.4 applies consistent interaction feedback normalization to Auth
- Phase 9.3 opens cross-feature UX consistency consolidation
- Phase 9.3.1 defines the cross-feature UX consistency inventory
- Phase 9.3.2 defines the copy / action / feedback consolidation contract

## Problem Statement

The repository now needs a clear decision baseline so that future development does not:

- reopen structural scope
- reopen runtime-hardening scope
- bypass the retained semantic model
- treat runtime-global and feature-local failures as interchangeable
- treat UX hardening as permission for redesign
- introduce shared UI abstractions without boundaries

## Scope

These decisions govern:

- current architecture interpretation
- ownership of runtime lifecycle
- retained interpretation of the boundary model
- retained interpretation of trigger-aware recovery execution
- retained interpretation of runtime observability
- allowed interpretation of Phase 9 UX consistency work
- documented interpretation of Phase 9.3 cross-feature consolidation work
- sequencing expectations for future work
- what remains explicitly out of scope

## Root Cause Analysis

After Phase 7, the dominant unresolved concern was no longer structure.

After Phase 8.1, the dominant unresolved concern was no longer discovery of failure surfaces.

After Phase 8.2, the project had explicit semantic vocabulary for runtime and feature failure boundaries.

After Phase 8.3, recovery entry and recovery policy execution were explicitly hardened.

After Phase 8.4, runtime observability also became explicit and bounded.

After Phase 8.5, the correct next concern was no longer runtime semantics.

It was product-surface consistency.

The repository therefore now needs decisions that preserve the closure of Phase 7 and Phase 8 while allowing narrowly scoped Phase 9 consistency work.

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
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/shared/widgets/**`
- `lib/models/LoadingGeneric/widget.dart`
- `docs/phase8_runtime_reliability_failure_semantics_hardening.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_2_failure_boundary_normalization.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_3_retry_reboot_reconnect_policy_hardening.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_4_runtime_diagnostic_observability_signals.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_5_formal_closure.md`
- `docs/phase9_product_surface_consistency_ux_hardening.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_1_product_surface_inventory.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_1_shared_state_surface_contract.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_2_billing_state_surface_normalization.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_3_dashboard_state_presentation_normalization.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_4_auth_interaction_feedback_normalization.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_1_cross_feature_ux_consistency_inventory.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_2_copy_action_feedback_consolidation.md`

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

Bounded runtime observability is part of the repository baseline, not a provisional experiment.

### Decision 8 — Policy changes must still follow semantics

Any future change to retry / reboot / reconnect / reset behavior must continue to respect the retained semantic model first.

Phase 8 closure did not remove that rule.

It froze it.

### Decision 9 — Billing remains an explicit example of boundary distinction

Billing continues to represent the distinction between:

- authenticated-runtime invalidity
- active operational context invalidity
- feature-local load failure

That distinction remains part of the retained baseline.

### Decision 10 — Error-presentation heterogeneity justifies controlled UI normalization only

The current code still presents equivalent visible states through different surfaces.

That justifies:

- controlled shared presentation widgets
- feature-by-feature normalization
- explicit UX-hardening steps

It does not justify:

- a new global error framework
- business-logic migration into widgets
- architectural redesign

### Decision 11 — Runtime-global and feature-local failures must not be merged implicitly

The following remain distinct categories:

- startup blocked state
- auth continuation required state
- transport disconnect state
- active client context invalidity
- feature-local request failure

This distinction remains mandatory after Phase 8 closure and during Phase 9 execution.

### Decision 12 — Minimal shared state surfaces are allowed

The project may now introduce narrowly scoped shared UI surfaces for:

- loading
- recoverable feature error
- empty state

only when those widgets remain:

- presentation-only
- controller-agnostic
- narrow in scope
- reversible

### Decision 13 — Shared state widgets must not become a framework

Any shared UI surface introduced in Phase 9 must stay minimal.

It must not become:

- a new state-management layer
- a broad design-system engine
- a replacement for controller-owned feature logic

### Decision 14 — Billing recoverable errors now use feature-level surfaces

Normal recoverable Billing failures are no longer treated as system crashes.

That means:

- `FeatureErrorState` is now the correct primary surface for recoverable Billing errors
- retry affordance belongs on the feature surface
- `CatchMainScreen` remains reserved for unexpected or higher-severity failures, such as outer rendering/build failures

### Decision 15 — Billing empty state is now a feature-surface concern

Billing no longer leaves empty-state semantics buried exclusively inside the table widget.

The feature itself now decides when it is:

- loading
- errored
- empty
- ready

That is the required product-surface pattern for later Phase 9 feature adoption.

### Decision 16 — Dashboard now classifies surface states explicitly

Dashboard no longer treats the absence of a resolved active client as a single generic loading case.

It now explicitly distinguishes between:

- loading
- empty available-client surface
- invalid operational context
- ready

This becomes the required pattern for later feature normalization.

### Decision 17 — Ready content must stay isolated from surface-state branches

Dashboard ready content remains in `_DashboardContent`.

That means:

- loading does not leak into ready UI
- empty does not leak into ready UI
- invalid context does not leak into ready UI

This preserves feature clarity and avoids mixed rendering semantics.

### Decision 18 — Auth now distinguishes bootstrap and submit feedback explicitly

Auth no longer treats all busy behavior as the same visible condition.

It now explicitly distinguishes between:

- bootstrap loading while preparing remembered-session login behavior
- submit loading while validating login input and sending credentials
- validation failure
- recoverable login failure

This aligns Auth with the same explicit product-surface standard already applied to Billing and Dashboard.

### Decision 19 — Auth retry remains natural to the main action

Auth retry is not introduced as a separate feature flow.

It remains centered on the existing main submit action, which is the correct product behavior for login.

### Decision 20 — Phase 9.3 is justified as cross-feature consolidation, not redesign

After Phase 9.2 completed feature-by-feature normalization of Billing, Dashboard, and Auth, the next justified concern is no longer an isolated feature surface.

It is the consistency between those already-hardened surfaces.

That justifies Phase 9.3 specifically as:

- copy consistency
- action-label consistency
- loading / error / retry wording consistency
- feedback hierarchy consistency
- cross-feature product coherence

It does not justify architecture changes, runtime changes, or broad visual redesign.

### Decision 21 — Phase 9.3 documentation must precede any broader visual adjustment

Before broader visual or spacing adjustments are proposed, the repository should first record:

- what inconsistency exists across features
- what wording and interaction rules should be treated as baseline
- what remains deliberately out of scope

This preserves traceability and prevents ad hoc UI changes.

### Decision 22 — Copy / action / feedback normalization must remain surface-local in implementation

Even when Phase 9.3 later applies visible wording improvements in code, ownership must remain unchanged:

- controllers still own state meaning
- widgets still render feature-local visible branches
- `ServiceProvider` still owns runtime lifecycle

Cross-feature consistency does not authorize ownership drift.

### Decision 23 — Future larger work must open a new explicit phase

Neither Phase 7 nor Phase 8 should be reopened informally.

Phase 9 also must not be expanded silently into redesign or feature expansion.

If future work requires more than narrow product-surface hardening, it must open a new justified phase.

## Validation

These decisions are valid only if the current ZIP still confirms all of the following:

- Phase 7 is closed
- Phase 8 is closed
- the architecture is stable
- the retained failure-boundary model exists in code
- the retained recovery-trigger and policy model exists in code
- the retained runtime observability model exists in code
- Phase 9 work remains surface-oriented and minimal

The current ZIP confirms those conditions.

## Release Impact

These decisions have no direct user-facing runtime impact.

They protect the interpretation of the repository and ensure that:

- the structural baseline remains frozen
- the runtime-hardening baseline remains frozen
- Phase 9 remains constrained to justified product-surface consistency work

## Risks

If these decisions are ignored, future work may:

- bypass the retained semantic model
- reopen runtime-hardening scope informally
- overreact to local issues with broad runtime changes
- weaken the clarity gained through Phase 8
- introduce architecture drift under the label of UX hardening
- accumulate shared UI abstractions without discipline

## What it does NOT solve

This document does not itself:

- close Phase 9 formally
- replace historical technical surfaces globally
- redesign the application
- define the entire later Phase 9 sequence in implementation detail

It only records the governing decisions.

## Conclusion

The repository now has these explicit baseline truths:

- Phase 7 closed
- Phase 8 closed
- Phase 9 active only as controlled product-surface consistency work
- Billing, Dashboard, and Auth are now concrete adopters of the shared consistency standard in production code
- Phase 9.3 is now the documented cross-feature consistency continuation

Those decisions now govern how Mi IP·RED should evolve from this point forward.