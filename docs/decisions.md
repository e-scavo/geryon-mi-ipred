# 🧠 Architectural & Implementation Decisions

## Objective

Record the active architectural and implementation decisions that govern Mi IP·RED after the closure of Phase 7, after the formal closure of Phase 8 as the completed runtime hardening baseline, during the opening and execution of Phase 9 as the active product-surface consistency baseline, and now after the implementation and formal closure of Phase 9.3.3 as the completed local density / layout consistency baseline inside that broader Phase 9 track.

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
- Phase 9.3.3 is now implemented as the local density / layout consistency adjustment layer
- Phase 9.3.3.1 establishes the shared surface density baseline
- Phase 9.3.3.2 normalizes dashboard layout rhythm
- Phase 9.3.3.3 aligns auth surface density
- Phase 9.3.3.4 improves billing embedded surface fit
- Phase 9.3.3.5 formally closes the 9.3.3 series

## Problem Statement

The repository needs a clear decision baseline so that future development does not:

- reopen structural scope
- reopen runtime-hardening scope
- bypass the retained semantic model
- treat runtime-global and feature-local failures as interchangeable
- treat UX hardening as permission for redesign
- introduce shared UI abstractions without boundaries
- reopen already-resolved local density/layout work after its formal closure
- confuse responsive/platform review work with the already-completed local visual consolidation layer

## Scope

These decisions govern:

- current architecture interpretation
- ownership of runtime lifecycle
- retained interpretation of the boundary model
- retained interpretation of trigger-aware recovery execution
- retained interpretation of runtime observability
- allowed interpretation of Phase 9 UX consistency work
- documented interpretation of Phase 9.3 cross-feature consolidation work
- retained interpretation of the completed 9.3.3 local visual baseline
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

The repository therefore needed decisions that preserved the closure of Phase 7 and Phase 8 while allowing narrowly scoped Phase 9 consistency work.

Inside that Phase 9 work, the repository then evolved through two different but related layers:

- semantic / wording consistency
- local visual density / layout consistency

Phase 9.2 and Phase 9.3.2 established the semantic layer.

Phase 9.3.3 established the local visual layer.

That means the repository now needs decisions that preserve not only the Phase 7 and Phase 8 closures, but also the completed local visual baseline already implemented through the 9.3.3 series.

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
- `lib/shared/window/**`
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
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_surface_density_layout_consistency_adjustments.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_1_shared_surface_density_baseline.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_2_dashboard_layout_rhythm_normalization.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_3_auth_surface_density_alignment.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_4_billing_embedded_surface_fit.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_5_formal_closure.md`

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

### Decision 10 — Error-presentation heterogeneity justified controlled UI normalization only

The codebase historically presented equivalent visible states through different surfaces.

That justified:

- controlled shared presentation widgets
- feature-by-feature normalization
- explicit UX-hardening steps

It did not justify:

- a new global error framework
- business-logic migration into widgets
- architectural redesign

That decision remains valid after 9.3.3 closure.

### Decision 11 — Runtime-global and feature-local failures must not be merged implicitly

The following remain distinct categories:

- startup blocked state
- auth continuation required state
- transport disconnect state
- active client context invalidity
- feature-local request failure

This distinction remains mandatory after Phase 8 closure and during Phase 9 execution.

### Decision 12 — Minimal shared state surfaces are allowed

The project may introduce narrowly scoped shared UI surfaces for:

- loading
- recoverable feature error
- empty state

only when those widgets remain:

- presentation-only
- controller-agnostic
- narrow in scope
- reversible

That decision remains valid and is now materially reflected in the current repository baseline.

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

After Phase 9.2 completed feature-by-feature normalization of Billing, Dashboard, and Auth, the next justified concern was no longer an isolated feature surface.

It was the consistency between those already-hardened surfaces.

That justified Phase 9.3 specifically as:

- copy consistency
- action-label consistency
- loading / error / retry wording consistency
- feedback hierarchy consistency
- cross-feature product coherence
- and later, local density / layout consolidation once semantic consistency had already been established

It did not justify architecture changes, runtime changes, or broad visual redesign.

### Decision 21 — Phase 9.3 documentation had to precede broader visual adjustment

Before broader visual or spacing adjustments were proposed, the repository needed to record:

- what inconsistency existed across features
- what wording and interaction rules should be treated as baseline
- what remained deliberately out of scope

That preserved traceability and prevented ad hoc UI changes.

### Decision 22 — Copy / action / feedback normalization remained surface-local in implementation

Even when Phase 9.3 applied visible wording improvements in code, ownership remained unchanged:

- controllers still own state meaning
- widgets still render feature-local visible branches
- `ServiceProvider` still owns runtime lifecycle

Cross-feature consistency did not authorize ownership drift.

### Decision 23 — 9.3.3 is now a retained local visual baseline

With the current ZIP, the project now explicitly retains the results of the 9.3.3 series as completed baseline work.

That means the following local concerns are no longer active open problems:

- mismatch between shared state-surface density
- dashboard vertical rhythm inconsistency
- auth visual over-compactness relative to the shared baseline
- billing embedded header/body fit mismatch

They are now part of the retained visible product baseline.

### Decision 24 — Shared surface density baseline is retained

`FeatureErrorState`, `FeatureEmptyState`, and `InfoCard` now form the retained local density baseline for shared product surfaces.

They may still receive narrow bug fixes, but not casual redesign.

### Decision 25 — Dashboard layout rhythm baseline is retained

Dashboard content spacing, constrained width behavior, section cadence, and billing embedding rhythm now form part of the retained UI baseline.

Future work must not continue tuning them informally under the old local-density subphase.

### Decision 26 — Auth density alignment baseline is retained

The login surface remains intentionally compact, but it is no longer treated as a pre-baseline outlier.

Its current local width/elevation/padding cadence now belongs to the retained product-surface baseline.

### Decision 27 — Billing embedded fit baseline is retained

Billing embedded composition now includes:

- actual rendering of `headerWidget`
- more integrated header/body composition
- theme-aligned title-bar treatment
- corrected reserved height from dashboard after the header became real rendered structure

This is now part of the retained baseline for billing as an embedded dashboard surface.

### Decision 28 — Theme-aligned billing title-bar color is now the preferred baseline

The earlier use of strong per-type colors for embedded billing title bars is no longer the preferred baseline.

The retained contract now prioritizes:

- product coherence first
- section identity second

That means alignment to the active theme now has priority over saturated category-color signaling for the embedded billing surface.

### Decision 29 — Remaining wide-screen / platform issues belong to the next concern class

The repository may still show unresolved behavior in cases such as:

- maximized web viewport focus
- large empty regions on wide screens
- composition centering on web
- Web / Android layout drift

Those concerns do not belong to the already completed local density/layout layer anymore.

They belong to the next justified concern class after 9.3.3 closure.

### Decision 30 — Future larger work must still open a new explicit phase

Neither Phase 7 nor Phase 8 should be reopened informally.

Phase 9 also must not be expanded silently into redesign or feature expansion.

And now, after 9.3.3 closure, the repository must not keep using 9.3.3 as an implicit catch-all bucket for local polishing.

If future work requires more than narrow retained-baseline bug fixing, it must open or continue under the next explicitly justified phase.


## Decision 31 — Phase 9.3.4 is established as cross-context consistency layer

### Context

After the formal closure of Phase 9.3.3, the repository confirms that the dominant remaining inconsistency is no longer local to surfaces.

Instead, it appears across:

- viewport widths
- constrained vs wide layouts
- Web vs mobile rendering contexts

### Problem

The system shows divergent behavior depending on rendering context, including:

- overflow conditions under constrained width
- loss of focus in wide viewport
- layout rigidity across different environments

These problems are not part of the already-closed local density/layout layer.

### Decision

Establish Phase 9.3.4 as a distinct and explicit concern layer focused on:

- cross-context consistency
- responsive behavior driven by width
- separation from local visual baseline work

### Impact

- responsive behavior becomes width-driven (constraints-based)
- AppBar, InfoCard and Billing surfaces adapt to viewport conditions
- overflow elimination becomes a required baseline guarantee

### Constraints

- 9.3.3 baseline must not be reopened
- no architectural changes allowed
- no global responsive framework introduction
- no redesign justified under this phase

### Result

- stable behavior across viewport sizes
- elimination of overflow conditions
- clear separation between:
  - retained local visual baseline (9.3.3)
  - new cross-context consistency layer (9.3.4)

### Status

✔ Applied and validated in Phase 9.3.4

## Decision 32 — Phase 10 is established as capability-completion layer

### Context

After the formal closure of Phase 9.3.4, the repository confirms that the dominant remaining concern is no longer:

- structure
- runtime semantics
- semantic wording consistency
- local visual density / layout consistency
- cross-context layout / responsive consistency

Instead, the next unresolved concern is the mismatch between:

- capabilities already implemented in code
- capabilities actually exposed in the product surface

### Problem

The system may already contain product-relevant capabilities that are:

- defined in domain or UI-support structures
- partially wired into feature logic
- not yet exposed coherently through primary product entry points

That creates a different kind of inconsistency than the ones resolved in Phase 9.

It is no longer a consistency-hardening problem.

It is now a capability-completion problem.

### Decision

Establish Phase 10 as a distinct and explicit concern layer focused on:

- identifying implemented capabilities
- classifying their exposure state
- preparing controlled product-surface expansion without reopening already-closed baselines

### Constraints

- Phase 7 remains closed
- Phase 8 remains closed
- Phase 9 remains closed as a consistency-hardening baseline
- no architecture redesign is justified under Phase 10
- no runtime-ownership changes are justified under Phase 10
- capability expansion must remain anchored to the real ZIP, not to speculative feature ideation

### Result

- phase progression remains explicit
- product-surface expansion becomes capability-driven rather than ad hoc
- future implementation can remain controlled and traceable

## Decision 33 — Phase 10.1 is mandatory before exposure implementation

### Context

Once capability-completion becomes the new concern class, the repository must not jump directly into visible product-surface changes.

Without a formal inventory step, development could:

- assume support where support is incomplete
- expose partial capability paths inconsistently
- reopen earlier UX baselines by improvisation

### Decision

Define Phase 10.1 as a required pre-implementation inventory layer.

This layer must:

- identify the real billing/comprobante capability classes present in the ZIP
- map where each capability is already represented
- classify each capability according to exposure state
- produce the explicit documentary handoff required for the next implementation phase

### Constraints

Phase 10.2 or any later exposure work must not begin unless Phase 10.1 has first established:

- capability inventory
- exposure-state classification
- implementation handoff boundaries

### Result

- development remains evidence-based
- capability exposure is controlled
- already-closed baselines are protected from uncontrolled expansion

## Decision 34 — Phase 10.2 completes capability exposure without altering ownership

### Context

After Phase 10.1 established the capability inventory baseline, the repository required a controlled exposure step.

### Problem

Billing capabilities already existed in the system but were not fully exposed through the primary product surface.

### Decision

Expose all supported billing capabilities through the dashboard using existing structures:

- BillingWidget remains the rendering surface
- Dashboard acts as exposure orchestrator
- no new abstraction layers are introduced

### Constraints

- no controller refactor
- no runtime modification
- no UI redesign
- no architectural changes

### Result

- dashboard now reflects the full billing capability set
- exposure aligns with real system support
- ownership boundaries remain intact

### Status

✔ Implemented and validated in Phase 10.2

## Validation

These decisions are valid only if the current ZIP still confirms all of the following:

- Phase 7 is closed
- Phase 8 is closed
- the architecture is stable
- the retained failure-boundary model exists in code
- the retained recovery-trigger and policy model exists in code
- the retained runtime observability model exists in code
- Phase 9 work remains surface-oriented and minimal
- the 9.3.3 local visual adjustments are materially present in the repository
- the 9.3.4 cross-context baseline is materially present in the repository
- Phase 10 is interpreted as capability-completion work rather than as redesign
- Phase 10.2 is implemented as controlled exposure of existing billing capability support rather than as a new ownership or architecture layer

The current ZIP confirms those conditions.

## Release Impact

These decisions have no direct user-facing runtime impact.

They protect the interpretation of the repository and ensure that:

- the structural baseline remains frozen
- the runtime-hardening baseline remains frozen
- Phase 9 remains constrained to justified product-surface consistency work
- the completed 9.3.3 local visual layer is treated as retained baseline rather than as ongoing undocumented tweaking
- the completed 9.3.4 cross-context layer is treated as retained baseline rather than as ongoing undocumented responsive tweaking
- Phase 10 begins as controlled capability-completion work
- Phase 10.2 remains a narrow exposure step that preserves existing ownership boundaries

## Risks

If these decisions are ignored, future work may:

- bypass the retained semantic model
- reopen runtime-hardening scope informally
- overreact to local issues with broad runtime changes
- weaken the clarity gained through Phase 8
- introduce architecture drift under the label of UX hardening
- accumulate shared UI abstractions without discipline
- reopen already-completed local visual consolidation work by ambiguity
- blur the boundary between retained local baseline and future responsive/platform review work
- jump into capability exposure without inventory or classification
- reinterpret 10.2 as permission to move billing ownership away from its current feature/controller surfaces

## What it does NOT solve

This document does not itself:

- close Phase 9 formally
- replace historical technical surfaces globally
- redesign the application
- define the entire later Phase 9 sequence in implementation detail
- solve wide-screen Web / Android parity by itself
- expose billing capabilities beyond the supported set already present in the current ZIP

It only records the governing decisions.

## Conclusion

The repository now has these explicit baseline truths:

- Phase 7 closed
- Phase 8 closed
- Phase 9 active only as controlled product-surface consistency work
- Billing, Dashboard, and Auth are concrete adopters of the shared consistency standard in production code
- Phase 9.3 first established cross-feature semantic consistency and then completed the local density / layout consistency layer through 9.3.3
- the 9.3.3 local visual series is now retained baseline rather than active open work
- Phase 9.3.4 established the cross-context consistency layer
- Phase 10 begins as capability-completion work grounded in repository evidence
- Phase 10.2 completes controlled billing capability exposure without changing ownership
- the next justified concern begins after that closure, not inside it

Those decisions now govern how Mi IP·RED should evolve from this point forward.

## Decision 35 — Phase 11 is established as release/distribution layer

### Context

After Phase 10.2 completed the controlled exposure of the supported billing capability surface, the repository confirms that the dominant remaining concern is no longer:

- architecture
- runtime semantics
- product-surface consistency
- responsive parity
- capability exposure completeness

Instead, the next unresolved concern is release readiness.

### Problem

The product is functional and already in use, but the repository still required a formal release/distribution layer to reduce version drift and build inconsistency risk.

### Decision

Establish Phase 11 as a distinct and explicit concern layer focused on:

- release/versioning standardization
- reproducible build generation
- preparation for packaging/distribution work

### Constraints

- Phase 7 remains closed
- Phase 8 remains closed
- Phase 9 remains closed as UX/responsive baseline
- Phase 10 remains closed as capability-completion baseline
- Phase 11 must not be used to introduce product redesign

### Result

- phase progression remains truthful to the ZIP
- release work becomes explicit and bounded
- later packaging/distribution steps gain a stable foundation

## Decision 36 — Phase 11.1 is mandatory as the first release baseline

### Context

Once release/distribution becomes the new concern class, the repository must not jump directly into store or deployment work without first standardizing versioning and build commands.

### Problem

Without a dedicated first release baseline, later distribution work would inherit:

- version drift risk
- inconsistent artifact generation
- outdated git automation assumptions
- unclear release documentation

### Decision

Define Phase 11.1 as the required first implementation step of Phase 11.

This layer must:

- synchronize `pubspec.yaml` and `lib/config/version.dart`
- standardize build targets for Web, APK and AAB
- make git mutation opt-in instead of implicit
- align version metadata branding with Mi IP·RED

### Constraints

Later Phase 11 work must not begin by bypassing these normalization steps.

### Result

- release commands become reproducible
- artifact generation becomes clearer
- later distribution work can remain incremental rather than ad hoc

## Validation Extension

These additional decisions are valid only if the current ZIP still confirms all of the following:

- Phase 10.2 is complete
- the repository contains active build/versioning utility files
- the release concern is now more justified than another product-behavior concern
- the implemented changes remain scoped to release/versioning normalization

The current ZIP confirms those conditions.

## Conclusion Extension

The repository now has these additional baseline truths:

- Phase 11 begins as release/distribution work grounded in repository evidence
- Phase 11.1 is the mandatory first normalization step of that layer
- build/versioning standardization is now the active implementation baseline after Phase 10.2
