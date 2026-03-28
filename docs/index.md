# 📚 Documentation Index

## Objective

Provide a coherent entry point to the Mi IP·RED documentation so the current repository structure, phase baseline, and runtime architecture remain aligned with the real code.

## Initial Context

The current ZIP confirms the following phase status:

- Phase 6 completed
- Phase 7.1 completed
- Phase 7.2 completed and formally closed
- Phase 7.3 completed and formally closed
- Phase 7.4 active

Current active completed subphases inside 7.4:

- `7.4.1 — Startup/Auth Continuation Inventory`
- `7.4.2 — Auth Requirement Boundary Normalization`
- `7.4.3 — Login Resolution Continuation Contract`
- `7.4.4 — Minimal Startup/Auth Continuation Coordinator`

## Problem Statement

The documentation index must reflect the real current state of the project.

At this point, the remaining application-layer work is not a generic cleanup pass.

It is a narrow continuation-hardening pass over the startup/auth bridge.

## Scope

This index covers:

- core architecture documents
- governance documents
- historical phase documents
- current Phase 7 baseline
- current 7.4 documentation

It does not define runtime behavior.

## Root Cause Analysis

The documentation has been built phase by phase together with the implementation.

That means the index must preserve the same reading order as the real architecture work.

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
- `docs/phase6_presentation_structure_cleanup.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_4_1_startup_auth_continuation_inventory.md`
- `docs/phase7_application_layer_consolidation_7_4_2_auth_requirement_boundary_normalization.md`
- `docs/phase7_application_layer_consolidation_7_4_3_login_resolution_continuation_contract.md`
- `docs/phase7_application_layer_consolidation_7_4_4_minimal_startup_auth_continuation_coordinator.md`

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

## Validation

Recommended current reading order:

1. `README.md`
2. `docs/index.md`
3. `docs/architecture.md`
4. `docs/development.md`
5. `docs/decisions.md`
6. `docs/phase7_application_layer_consolidation.md`
7. `docs/phase7_application_layer_consolidation_7_3_5_formal_closure.md`
8. `docs/phase7_application_layer_consolidation_7_4_1_startup_auth_continuation_inventory.md`
9. `docs/phase7_application_layer_consolidation_7_4_2_auth_requirement_boundary_normalization.md`
10. `docs/phase7_application_layer_consolidation_7_4_3_login_resolution_continuation_contract.md`
11. `docs/phase7_application_layer_consolidation_7_4_4_minimal_startup_auth_continuation_coordinator.md`

## Release Impact

This document has no direct runtime impact.

It keeps the documentation aligned with the real current phase baseline.

## Risks

If this index is not aligned, future work may:

- treat Phase 7.3 as reopened
- skip the explicit 7.4 documentation path
- misread the startup/auth work as generic cleanup

## What it does NOT solve

This index does not by itself:

- change runtime behavior
- normalize auth requirement semantics
- define continuation contracts

It only reflects the real current baseline.

## Conclusion

The current documentation baseline is:

- Phase 6 completed
- Phase 7.1 completed
- Phase 7.2 completed and closed
- Phase 7.3 completed and closed
- Phase 7.4 active with `7.4.4` now documented