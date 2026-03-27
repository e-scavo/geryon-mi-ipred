# 📚 Documentation Index

## Objective

Provide a coherent and accurate entry point to the technical documentation of Mi IP·RED so that the current repository structure, runtime boundaries, application-layer rules, and historical phase outcomes remain aligned with the real codebase.

## Initial Context

Mi IP·RED documentation has been built phase by phase together with the implementation.

At the current project baseline, the repository has already completed:

- Phase 6 — Presentation Structure Cleanup
- Phase 7.1 — Feature-local controller extraction
- Phase 7.2 — State ownership and boundary clarification
- Phase 7.3.1 — Application Flow Inventory
- Phase 7.3.2 — Session & App Context Normalization

The project is now advancing through Phase 7.3.3.

This subphase does not introduce a coordinator yet.

Instead, it freezes the already-existing cross-feature interactions of the current codebase as explicit feature interaction contracts.

## Problem Statement

After Phase 7.3.2, the codebase already has:

- documented flows
- normalized context semantics
- explicit read-only shared runtime-context access paths

However, the meaning of several cross-feature interactions is still distributed across runtime mutations, listeners, and local feature decisions.

That means the interactions already exist, but they are still not declared as explicit contracts.

Without making those contracts explicit now, future work could preserve mechanics while accidentally changing intended meaning.

## Scope

This index covers:

- core architecture documents
- development governance documents
- historical phase documents
- the current Phase 7 baseline
- the newly opened and implemented Phase 7.3.3 feature interaction contract document

It does not attempt to redefine architecture beyond the real codebase.

## Root Cause Analysis

The documentation needed to evolve in the same order as the implementation:

1. first reflect structural cleanup
2. then feature extraction
3. then state-boundary clarification
4. then flow inventory
5. then context normalization
6. and only after that freeze real interactions as explicit contracts

That sequencing remains important because feature interaction contracts only became safe after the earlier layers were made explicit.

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

## Implementation Characteristics

### Core Architecture Documents

- `docs/architecture.md`
- `docs/architecture-deep.md`

These describe the general architecture and deeper technical interpretation of the app runtime.

### Runtime / Product Documents

- `docs/flows.md`
- `docs/release.md`
- `docs/secutiry.md`

These describe runtime flows, release concerns, and security-related aspects.

### Governance Documents

- `docs/development.md`
- `docs/decisions.md`

These define the current implementation rules and active architecture decisions that future work must preserve.

### Historical / Structural Support Documents

- `docs/service-provider-decomposition.md`
- `docs/module-inventory.md`
- `docs/target-structure.md`
- `docs/legacy.md`
- `docs/cleanup-checklist.md`
- `docs/infra-normalization.md`
- `docs/refactor-plan.md`
- `docs/features.md`

These preserve historical rationale and structural evolution context.

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

#### Phase 7 — Application Layer Consolidation
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

Phase 7.3 is now split into three already-defined layers:

- flow inventory
- context normalization
- feature interaction contracts

The current active concern remains coordination-focused, but 7.3.3 freezes the current interactions as explicit contracts before any minimal coordinator is considered.

## Validation

The index is valid only if it reflects the actual current repository baseline.

At this point, the correct reading order for a technical review is:

1. `README.md`
2. `docs/index.md`
3. `docs/architecture.md`
4. `docs/development.md`
5. `docs/decisions.md`
6. `docs/phase6_presentation_structure_cleanup.md`
7. `docs/phase7_application_layer_consolidation.md`
8. `docs/phase7_application_layer_consolidation_7_2_5_formal_closure.md`
9. `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`
10. `docs/phase7_application_layer_consolidation_7_3_2_session_app_context_normalization.md`
11. `docs/phase7_application_layer_consolidation_7_3_3_feature_interaction_contracts.md`

## Release Impact

This update does not change user-facing architecture by itself.

Its impact is documentary and architectural:

- it exposes 7.3.3 as a distinct implemented subphase
- it freezes the current interaction meaning before any coordinator work
- it improves future onboarding for cross-feature coordination work

## Risks

If this index is not updated, future work may:

- treat 7.3.3 as undefined or optional
- assume current interactions are only incidental mechanics
- introduce a coordinator without first freezing the meaning of the interactions it would coordinate

## What it does NOT solve

This document does not by itself:

- introduce a coordinator
- introduce an event bus
- redesign runtime execution
- change implementation behavior

It only reflects the real documentation baseline.

## Conclusion

The documentation index now reflects the real project state:

- Phase 6 completed
- Phase 7.1 completed
- Phase 7.2 completed and closed
- Phase 7.3.1 completed as flow inventory
- Phase 7.3.2 completed as session and app-context normalization
- Phase 7.3.3 completed as feature interaction contract baseline