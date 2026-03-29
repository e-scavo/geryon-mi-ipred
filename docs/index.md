# 📚 Documentation Index

## Objective

Provide the current entry point to the Mi IP·RED documentation so the repository reading order stays aligned with the real code, the closed Phase 7 baseline, the formally closed Phase 8 runtime-hardening baseline, and the now active Phase 9 product-surface consistency baseline.

## Initial Context

The current ZIP confirms the following phase baseline:

- Phase 6 completed
- Phase 7.1 completed
- Phase 7.2 completed and formally closed
- Phase 7.3 completed and formally closed
- Phase 7.4 completed and formally closed
- Phase 7.5 completed and formally closed
- Phase 8 opened
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

## Problem Statement

The documentation index must clearly distinguish between:

- closed structural work
- closed runtime hardening work
- active product-surface consistency work
- whatever future phase comes next after those completed and active baselines

If that distinction is lost, future work can incorrectly reopen Phase 7 or Phase 8 concerns implicitly, or treat Phase 9 as a redesign phase instead of a controlled UX-hardening phase.

## Scope

This index covers:

- current architecture documents
- governance documents
- historical phase documents
- the closed Phase 7 consolidation baseline
- the closed Phase 8 runtime-hardening baseline
- the active Phase 9 product-surface consistency baseline

## Root Cause Analysis

The project evolved phase by phase together with the implementation.

That means the documentation index must mirror the real repository state.

The current ZIP shows that the structural consolidation baseline and the runtime hardening baseline are already closed, while product-surface consistency work is now the active justified next phase.

The index must therefore stop presenting Phase 8 as an active working phase and must present Phase 9 as the active UI/UX consistency phase without implying redesign of architecture or runtime ownership.

## Files Affected

Primary entry documents include:

- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/architecture-deep.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/flows.md`
- `docs/features.md`
- `docs/phase7_application_layer_consolidation_7_5_formal_closure.md`
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

## Implementation Characteristics

### Core Architecture

- `docs/architecture.md`
- `docs/architecture-deep.md`

### Runtime / Product

- `docs/flows.md`
- `docs/features.md`
- `docs/release.md`
- `docs/secutiry.md`

### Governance

- `docs/development.md`
- `docs/decisions.md`

### Historical / Structural Support

- `docs/service-provider-decomposition.md`
- `docs/module-inventory.md`
- `docs/target-structure.md`
- `docs/legacy.md`
- `docs/cleanup-checklist.md`
- `docs/infra-normalization.md`
- `docs/refactor-plan.md`

### Phase Documents

#### Phase 1
- `docs/phase1_audit.md`

#### Phase 2
- `docs/phase2_structural_plan.md`

#### Phase 3
- `docs/phase3_cleanup_hygene.md`

#### Phase 4
- `docs/phase4_infra_normalization.md`

#### Phase 5
- `docs/phase5_service_provider_decomposition.md`

#### Phase 6
- `docs/phase6_presentation_structure_cleanup.md`

#### Phase 7
- `docs/phase7_application_layer_consolidation.md`

##### Phase 7.1
- `docs/phase7_application_layer_consolidation_7_1_1_auth_extraction.md`
- `docs/phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md`
- `docs/phase7_application_layer_consolidation_7_1_3_billing_extraction.md`

##### Phase 7.2
- `docs/phase7_application_layer_consolidation_7_2_1_feature_state_inventory.md`
- `docs/phase7_application_layer_consolidation_7_2_2_billing_state_boundary_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_2_3_dashboard_state_derivation_normalization.md`
- `docs/phase7_application_layer_consolidation_7_2_4_auth_startup_initial_state_boundary_cleanup.md`
- `docs/phase7_application_layer_consolidation_7_2_5_formal_closure.md`

##### Phase 7.3
- `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`
- `docs/phase7_application_layer_consolidation_7_3_2_session_app_context_normalization.md`
- `docs/phase7_application_layer_consolidation_7_3_3_feature_interaction_contracts.md`
- `docs/phase7_application_layer_consolidation_7_3_4_application_coordinator_minimal.md`
- `docs/phase7_application_layer_consolidation_7_3_5_formal_closure.md`

##### Phase 7.4
- `docs/phase7_application_layer_consolidation_7_4_1_startup_auth_continuation_inventory.md`
- `docs/phase7_application_layer_consolidation_7_4_2_auth_requirement_boundary_normalization.md`
- `docs/phase7_application_layer_consolidation_7_4_3_login_resolution_continuation_contract.md`
- `docs/phase7_application_layer_consolidation_7_4_4_minimal_startup_auth_continuation_coordinator.md`
- `docs/phase7_application_layer_consolidation_7_4_5_formal_closure.md`

##### Phase 7.5
- `docs/phase7_application_layer_consolidation_7_5_formal_closure.md`

#### Phase 8
- `docs/phase8_runtime_reliability_failure_semantics_hardening.md`

##### Phase 8.1
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md`

##### Phase 8.2
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_2_failure_boundary_normalization.md`

##### Phase 8.3
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_3_retry_reboot_reconnect_policy_hardening.md`

##### Phase 8.4
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_4_runtime_diagnostic_observability_signals.md`

##### Phase 8.5
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_5_formal_closure.md`

#### Phase 9
- `docs/phase9_product_surface_consistency_ux_hardening.md`

##### Phase 9.1
- `docs/phase9_product_surface_consistency_ux_hardening_9_1_product_surface_inventory.md`

##### Phase 9.2.1
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_1_shared_state_surface_contract.md`

##### Phase 9.2.2
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_2_billing_state_surface_normalization.md`

##### Phase 9.2.3
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_3_dashboard_state_presentation_normalization.md`

##### Phase 9.2.4
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_4_auth_interaction_feedback_normalization.md`

## Validation

Recommended current reading order:

1. `README.md`
2. `docs/index.md`
3. `docs/architecture.md`
4. `docs/development.md`
5. `docs/decisions.md`
6. `docs/phase7_application_layer_consolidation_7_5_formal_closure.md`
7. `docs/phase8_runtime_reliability_failure_semantics_hardening.md`
8. `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md`
9. `docs/phase8_runtime_reliability_failure_semantics_hardening_8_2_failure_boundary_normalization.md`
10. `docs/phase8_runtime_reliability_failure_semantics_hardening_8_3_retry_reboot_reconnect_policy_hardening.md`
11. `docs/phase8_runtime_reliability_failure_semantics_hardening_8_4_runtime_diagnostic_observability_signals.md`
12. `docs/phase8_runtime_reliability_failure_semantics_hardening_8_5_formal_closure.md`
13. `docs/phase9_product_surface_consistency_ux_hardening.md`
14. `docs/phase9_product_surface_consistency_ux_hardening_9_1_product_surface_inventory.md`
15. `docs/phase9_product_surface_consistency_ux_hardening_9_2_1_shared_state_surface_contract.md`
16. `docs/phase9_product_surface_consistency_ux_hardening_9_2_2_billing_state_surface_normalization.md`
17. `docs/phase9_product_surface_consistency_ux_hardening_9_2_3_dashboard_state_presentation_normalization.md`
18. `docs/phase9_product_surface_consistency_ux_hardening_9_2_4_auth_interaction_feedback_normalization.md`

## Release Impact

This index has no direct runtime impact.

It keeps the documentation aligned with the current repository baseline and makes explicit that:

- Phase 7 is closed
- Phase 8 is closed
- Phase 9 is now the active product-surface consistency phase
- Billing, Dashboard, and Auth are now normalized adopters of the shared consistency baseline

## Risks

If the index is not aligned, future work may:

- treat Phase 8 as still active
- reopen application-layer or runtime-hardening concerns implicitly
- blur the handoff between completed baseline work and active UX-hardening work
- misread Phase 9 as redesign permission instead of controlled consistency work

## What it does NOT solve

This index does not itself:

- change runtime behavior
- add new diagnostics
- harden retry / reboot / reconnect further
- redesign the application surface
- implement the remaining Phase 9 work beyond Auth normalization

It only reflects the correct current documentary baseline.

## Conclusion

The current project baseline is:

- Phase 7 closed
- Phase 8 closed
- runtime hardening baseline frozen through Phase 8.5
- Phase 9 opened for product surface consistency and UX hardening
- Phase 9.1 completed as inventory
- Phase 9.2.1 completed as shared-state foundation
- Phase 9.2.2 completed as Billing normalization
- Phase 9.2.3 completed as Dashboard normalization
- Phase 9.2.4 completed as Auth normalization

That is now the correct documentation entry point for Mi IP·RED.