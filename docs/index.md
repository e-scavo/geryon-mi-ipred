# 📚 Documentation Index

## Objective

Provide a coherent and accurate entry point to the technical documentation of Mi IP·RED so that the current repository structure, runtime boundaries, phase history, and active architecture baseline remain aligned with the real codebase.

## Initial Context

Mi IP·RED documentation has been built phase by phase together with the implementation.

The current ZIP confirms the following completed baseline:

- Phase 6 — Presentation Structure Cleanup
- Phase 7.1 — Feature-local controller extraction
- Phase 7.2 — State ownership and boundary clarification
- Phase 7.3 — Application flow inventory, context normalization, feature interaction contracts, minimal coordinator, and formal closure

The project has now opened:

- Phase 7.4 — Startup/Auth Continuation Boundary Hardening

The current active subphase is:

- Phase 7.4.1 — Startup/Auth Continuation Inventory

## Problem Statement

After Phase 7.3, the remaining application-layer concern is no longer generic coordination.

The remaining concern is the still-sensitive bridge between:

- startup boundary
- backend readiness
- auth requirement
- login popup entry
- authenticated continuation

That path already works, but it still depends on distributed implicit semantics.

The documentation index must reflect that precisely.

## Scope

This index covers:

- architecture documents
- governance documents
- historical phase documents
- the closed Phase 7.3 baseline
- the newly opened Phase 7.4 baseline

It does not redefine runtime behavior.

## Root Cause Analysis

The documentation must follow the same safe order as the implementation:

1. structural cleanup
2. feature extraction
3. ownership clarification
4. application flow inventory
5. session/app-context normalization
6. feature interaction contract freezing
7. minimal safe coordinator anchoring
8. formal closure of coordination scope
9. startup/auth continuation inventory
10. later normalization of the remaining startup/auth boundary

The index must preserve that reading order.

## Files Affected

Primary documents indexed here include:

- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/architecture-deep.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/flows.md`
- `docs/features.md`
- `docs/phase6_presentation_structure_cleanup.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_2_5_formal_closure.md`
- `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`
- `docs/phase7_application_layer_consolidation_7_3_2_session_app_context_normalization.md`
- `docs/phase7_application_layer_consolidation_7_3_3_feature_interaction_contracts.md`
- `docs/phase7_application_layer_consolidation_7_3_4_application_coordinator_minimal.md`
- `docs/phase7_application_layer_consolidation_7_3_5_formal_closure.md`
- `docs/phase7_application_layer_consolidation_7_4_1_startup_auth_continuation_inventory.md`

## Implementation Characteristics

### Core Architecture Documents

- `docs/architecture.md`
- `docs/architecture-deep.md`

### Runtime / Product Documents

- `docs/flows.md`
- `docs/release.md`
- `docs/secutiry.md`

### Governance Documents

- `docs/development.md`
- `docs/decisions.md`

### Historical / Structural Support Documents

- `docs/service-provider-decomposition.md`
- `docs/module-inventory.md`
- `docs/target-structure.md`
- `docs/legacy.md`
- `docs/cleanup-checklist.md`
- `docs/infra-normalization.md`
- `docs/refactor-plan.md`
- `docs/features.md`

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

## Validation

At the current ZIP baseline, the correct reading order for technical review is:

1. `README.md`
2. `docs/index.md`
3. `docs/architecture.md`
4. `docs/development.md`
5. `docs/decisions.md`
6. `docs/phase6_presentation_structure_cleanup.md`
7. `docs/phase7_application_layer_consolidation.md`
8. `docs/phase7_application_layer_consolidation_7_3_5_formal_closure.md`
9. `docs/phase7_application_layer_consolidation_7_4_1_startup_auth_continuation_inventory.md`

## Release Impact

This update has no direct runtime impact.

Its value is architectural and documentary:

- it keeps the index aligned with the ZIP
- it preserves Phase 7.3 as closed
- it marks Phase 7.4 as opened with the correct real target

## Risks

If this index is not updated, future work may:

- misread the project as still being in 7.3
- skip the startup/auth continuation inventory
- open an unnecessarily broad next step

## What it does NOT solve

This index does not by itself:

- change runtime behavior
- normalize auth requirement semantics
- introduce a continuation contract

It only reflects the real current baseline.

## Conclusion

The current documentation index now reflects the real project state:

- Phase 6 completed
- Phase 7.1 completed
- Phase 7.2 completed and closed
- Phase 7.3 completed and formally closed
- Phase 7.4 opened with 7.4.1 inventory completed as the current documentary baseline