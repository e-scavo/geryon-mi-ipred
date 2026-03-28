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
- Phase 7.3.3 — Feature Interaction Contracts

The project is now advancing through Phase 7.3.4.

This subphase does not introduce a broad coordinator.

Instead, it introduces a minimal coordination surface only for the safest already-validated application transitions.

## Problem Statement

After Phase 7.3.3, the codebase already has:

- documented flows
- normalized context semantics
- explicit shared runtime-context access paths
- explicit declarative interaction contracts

However, some execution-level coordination still remains more distributed than ideal in runtime surfaces.

The most visible safe targets in the current ZIP are:

- billing downstream refresh coordination
- logout reset coordination

Without a minimal coordination anchor, those transitions remain semantically broader than their current execution location suggests.

## Scope

This index covers:

- core architecture documents
- development governance documents
- historical phase documents
- the current Phase 7 baseline
- the newly opened and implemented Phase 7.3.4 application coordinator document

It does not redefine the architecture beyond the current real codebase.

## Root Cause Analysis

The documentation needed to evolve in the same order as the implementation:

1. structural cleanup
2. feature extraction
3. state-boundary clarification
4. flow inventory
5. context normalization
6. contract freezing
7. only then minimal coordination anchoring for the safest application transitions

That sequencing remains important because coordinator work only became safe after the previous layers were already explicit.

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
- `docs/phase7_application_layer_consolidation_7_3_4_application_coordinator_minimal.md`

Phase 7.3 is now split into four already-defined layers:

- flow inventory
- context normalization
- feature interaction contracts
- minimal coordination anchoring

The current active concern remains coordination-focused, but 7.3.4 keeps the coordinator intentionally narrow and auditable.

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
12. `docs/phase7_application_layer_consolidation_7_3_4_application_coordinator_minimal.md`

## Release Impact

This update does not change user-facing architecture by itself.

Its impact is documentary and architectural:

- it exposes 7.3.4 as a distinct implemented subphase
- it documents the first minimal execution anchor for app-level coordination
- it improves future onboarding for the closure of Phase 7.3

## Risks

If this index is not updated, future work may:

- assume 7.3.4 introduced a broad coordinator when it did not
- miss that only two safe transitions were intentionally coordinated
- over-extend later work beyond the current coordinator scope

## What it does NOT solve

This document does not by itself:

- introduce a broad app coordinator
- redesign startup/auth continuation
- introduce an event bus
- redesign runtime execution

It only reflects the real documentation baseline.

## Conclusion

The documentation index now reflects the real project state:

- Phase 6 completed
- Phase 7.1 completed
- Phase 7.2 completed and closed
- Phase 7.3.1 completed as flow inventory
- Phase 7.3.2 completed as session and app-context normalization
- Phase 7.3.3 completed as feature interaction contract baseline
- Phase 7.3.4 completed as a minimal application coordinator for billing downstream refresh and logout reset