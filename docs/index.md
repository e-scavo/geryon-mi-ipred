# 📚 Documentation Index

## Objective

Provide a coherent and accurate entry point to the technical documentation of Mi IP·RED so that the documented architecture, historical evolution, and current implementation boundaries remain aligned with the real project state.

---

## Initial Context

Mi IP·RED documentation evolved phase by phase together with the codebase.

The current documented baseline is:

- backend/runtime stabilization completed
- ServiceProvider decomposition documented
- presentation structure cleanup completed
- Phase 7.1 controller extraction completed
- Phase 7.2 started
- billing state-boundary consolidation implemented
- dashboard state-derivation normalization implemented
- auth/startup initial-boundary cleanup implemented

This index reflects that state.

---

## Documentation Philosophy

Documentation in Mi IP·RED must:

- reflect real code
- preserve important historical context
- explain why changes happened
- document boundaries, not only outcomes
- remain aligned with the current repository structure
- avoid idealized architecture not present in the runtime

---

## Core Documents

### Architecture

- `docs/architecture.md`
- `docs/architecture-deep.md`

These documents describe:

- high-level architecture
- client/server interaction
- internal runtime flow
- ServiceProvider behavior
- deeper execution details

---

### Runtime / Product

- `docs/flows.md`
- `docs/release.md`
- `docs/secutiry.md`

These documents describe:

- main runtime flows
- release considerations
- security-related behavior and constraints

---

### Engineering Governance

- `docs/development.md`
- `docs/decisions.md`

These documents define:

- implementation constraints
- refactor rules
- architectural sequencing
- active ownership rules
- phase-specific boundaries

---

### Structural / Historical Support

- `docs/service-provider-decomposition.md`
- `docs/module-inventory.md`
- `docs/target-structure.md`
- `docs/legacy.md`
- `docs/cleanup-checklist.md`
- `docs/infra-normalization.md`
- `docs/refactor-plan.md`
- `docs/features.md`

These documents preserve:

- decomposition rationale
- structural inventory
- historical migration context
- cleanup tracking
- infrastructure normalization context
- refactor history

---

## Phase Documents

### Phase 1

- `docs/phase1_audit.md`

---

### Phase 2

- `docs/phase2_structural_plan.md`

---

### Phase 3

- `docs/phase3_cleanup_hygene.md`

---

### Phase 4

- `docs/phase4_infra_normalization.md`

---

### Phase 5

- `docs/phase5_service_provider_decomposition.md`

Documents:

- ServiceProvider decomposition
- protected runtime boundaries
- preparation for later UI/application cleanup

---

### Phase 6

- `docs/phase6_presentation_structure_cleanup.md`

Documents:

- shared UI normalization
- feature UI normalization
- canonical structure adoption
- cleanup and closure of presentation restructuring

---

### Phase 7

- `docs/phase7_application_layer_consolidation.md`

Documents:

- feature-local controller introduction
- Phase 7.1 closure
- Phase 7.2 scope
- current subphase progression

#### Phase 7.1

- `docs/phase7_application_layer_consolidation_7_1_1_auth_extraction.md`
- `docs/phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md`
- `docs/phase7_application_layer_consolidation_7_1_3_billing_extraction.md`

Documents:

- auth extraction
- dashboard extraction
- billing extraction

#### Phase 7.2

- `docs/phase7_application_layer_consolidation_7_2_1_feature_state_inventory.md`
- `docs/phase7_application_layer_consolidation_7_2_2_billing_state_boundary_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_2_3_dashboard_state_derivation_normalization.md`
- `docs/phase7_application_layer_consolidation_7_2_4_auth_startup_initial_state_boundary_cleanup.md`

Documents:

- state ownership inventory
- billing state-boundary consolidation
- dashboard state-derivation normalization
- auth/startup initial-boundary cleanup

Planned continuation:

- formal closure of Phase 7.2

---

## Recommended Reading Order

### General onboarding

1. `README.md`
2. `docs/index.md`
3. `docs/architecture.md`
4. `docs/flows.md`
5. `docs/development.md`
6. `docs/decisions.md`

---

### ServiceProvider / runtime understanding

1. `docs/architecture-deep.md`
2. `docs/service-provider-decomposition.md`
3. `docs/phase5_service_provider_decomposition.md`

---

### Current application / presentation architecture

1. `docs/phase6_presentation_structure_cleanup.md`
2. `docs/phase7_application_layer_consolidation.md`
3. `docs/phase7_application_layer_consolidation_7_1_1_auth_extraction.md`
4. `docs/phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md`
5. `docs/phase7_application_layer_consolidation_7_1_3_billing_extraction.md`
6. `docs/phase7_application_layer_consolidation_7_2_1_feature_state_inventory.md`
7. `docs/phase7_application_layer_consolidation_7_2_2_billing_state_boundary_consolidation.md`
8. `docs/phase7_application_layer_consolidation_7_2_3_dashboard_state_derivation_normalization.md`
9. `docs/phase7_application_layer_consolidation_7_2_4_auth_startup_initial_state_boundary_cleanup.md`

---

## Current Documentation Status

Current reflected status:

- Phase 1 completed
- Phase 2 completed
- Phase 3 completed
- Phase 4 completed
- Phase 5 completed
- Phase 6 completed
- Phase 7.1 completed and formally closed
- Phase 7.2.1 completed
- Phase 7.2.2 completed
- Phase 7.2.3 completed
- Phase 7.2.4 implemented
- next planned step: Phase 7.2.5

---

## Conclusion

The documentation set remains aligned with the real application state reflected in the current project stage.

At this point, the codebase is documented as:

- structurally normalized
- controller-backed in the main features
- actively clarifying state ownership and initial-boundary behavior
- materially cleaner in billing, dashboard, and auth/startup than in the initial Phase 7 baseline