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

The project is now advancing through Phase 7.3.2.

This subphase does not introduce a coordinator yet.

Instead, it normalizes the meaning and consumption of runtime context already shared across startup, auth, dashboard, billing, logout, and persisted login hint behavior.

## Problem Statement

After Phase 7.3.1, the project already has an explicit inventory of its real application flows.

The next visible problem in the real ZIP is no longer flow discovery.

The next visible problem is semantic ambiguity between different kinds of context that already exist in code:

- startup boundary context
- persisted login hint
- authenticated runtime context
- active operational context

Without making those distinctions explicit, future work could accidentally build feature contracts or coordination logic on top of vague assumptions.

## Scope

This index covers:

- core architecture documents
- development governance documents
- historical phase documents
- the current Phase 7 baseline
- the new Phase 7.3.2 session and app-context normalization document

It does not attempt to redefine architecture beyond the real codebase.

## Root Cause Analysis

The documentation needed to evolve in the same order as the implementation:

1. first reflect structural cleanup
2. then feature extraction
3. then state-boundary clarification
4. then flow inventory
5. only after that normalize shared runtime-context semantics

That sequencing remains important because context normalization only became safe after the previous layers were clarified.

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

Phase 7.3 is now split into two already-defined layers:

- flow inventory
- context normalization

The current active concern is still coordination-focused, but 7.3.2 narrows that concern into explicit semantics for shared context before contracts or coordinator logic are introduced.

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

## Release Impact

This update does not change user-facing architecture by itself.

Its impact is documentary and architectural:

- it exposes the real active documentation baseline
- it makes 7.3.2 visible as a distinct subphase
- it improves future onboarding for coordination and context work

## Risks

If this index is not updated, future work may:

- treat 7.3.2 as undefined or optional
- confuse persisted login hint with authenticated runtime state
- miss the fact that context normalization is now the active concern before contracts/coordinator work

## What it does NOT solve

This document does not by itself:

- introduce feature interaction contracts
- introduce an application coordinator
- redesign backend session behavior
- change implementation

It only reflects the real documentation baseline.

## Conclusion

The documentation index now reflects the real project state:

- Phase 6 completed
- Phase 7.1 completed
- Phase 7.2 completed and closed
- Phase 7.3.1 completed as flow inventory
- Phase 7.3.2 opened and implemented as session and app-context normalization