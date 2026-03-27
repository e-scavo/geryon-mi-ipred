# 📚 Documentation Index

## Objective

Provide a coherent and accurate entry point to the technical documentation of Mi IP·RED so that the current repository structure, runtime boundaries, application-layer rules, and historical phase outcomes remain aligned with the real codebase.

## Initial Context

Mi IP·RED documentation has been built phase by phase together with the implementation.

At the current project baseline, the repository has already completed:

- Phase 6 — Presentation Structure Cleanup
- Phase 7.1 — Feature-local controller extraction
- Phase 7.2 — State ownership and boundary clarification

The project is now entering Phase 7.3.

This new phase does not continue state cleanup.

Instead, it begins documenting and normalizing the real coordination flows that already exist between startup, auth, dashboard, billing, session persistence, and global runtime state.

## Problem Statement

After Phase 7.1 and Phase 7.2, the project now has:

- clearer feature-local boundaries
- clearer ownership of feature state vs derived state vs runtime source state

However, the codebase still contains cross-feature coordination that is real but only partially explicit.

That coordination currently spans:

- `main.dart`
- `ServiceProvider`
- `LoginController`
- `DashboardController`
- `BillingWidget`
- `SessionStorage`

Without a clear documentation entry point, future work could incorrectly assume that those flows are already formalized when, in reality, they are still distributed across runtime surfaces.

## Scope

This index covers:

- core architecture documents
- development governance documents
- phase history documents
- the currently active Phase 7 documentation baseline
- the newly opened Phase 7.3 flow-inventory document

It does not attempt to redefine architecture beyond the real codebase.

## Root Cause Analysis

The documentation needed to evolve in the same order as the implementation:

1. first reflect structural cleanup
2. then reflect feature extraction
3. then reflect state ownership clarification
4. only after that reflect cross-feature flow coordination

This means the index must now expose Phase 7.3 as a distinct architectural concern rather than pretending it is part of Phase 7.2.

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

Phase 7.3 is now the active continuation of Phase 7.

Its focus is:

- coordination between features
- application-flow sequencing
- runtime transition ownership
- explicit documentation of currently implicit interaction paths

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

## Release Impact

This update does not change runtime behavior.

Its impact is documentary and architectural:

- it exposes the real active documentation baseline
- it prevents Phase 7.3 from being hidden under the Phase 7.2 closure state
- it improves onboarding for future technical work

## Risks

If this index is not updated, future work may:

- treat Phase 7.3 as an undefined continuation
- miss the fact that coordination is now the current architectural concern
- read the codebase as if state cleanup were still the active phase

## What it does NOT solve

This document does not by itself:

- introduce new coordination contracts
- normalize session/app-context ownership
- create a coordinator
- change implementation

It only reflects the real documentation baseline.

## Conclusion

The documentation index now reflects the real project state:

- Phase 6 completed
- Phase 7.1 completed
- Phase 7.2 completed and closed
- Phase 7.3 opened through `7.3.1 — Application Flow Inventory`

This is the correct current documentation entry point for Mi IP·RED.