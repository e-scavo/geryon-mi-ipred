# 📚 Documentation Index

## Objective

Provide a coherent entry point to the Mi IP·RED documentation so the current repository structure, phase baseline, and runtime architecture remain aligned with the real code.

## Initial Context

The current ZIP confirms the following phase status:

- Phase 6 completed
- Phase 7.1 completed
- Phase 7.2 completed and formally closed
- Phase 7.3 completed and formally closed
- Phase 7.4 completed and formally closed
- Phase 7.5 completed and formally closed
- Phase 8 opened
- Phase 8.1 documented as the active first subphase

Current completed subphases inside the Phase 7 consolidation effort are:

- `7.1.1 — Auth extraction`
- `7.1.2 — Dashboard extraction`
- `7.1.3 — Billing extraction`
- `7.2.1 — Feature State Inventory & Ownership Definition`
- `7.2.2 — Billing State Boundary Consolidation`
- `7.2.3 — Dashboard State Derivation Normalization`
- `7.2.4 — Auth & Startup Initial State Boundary Cleanup`
- `7.2.5 — Formal Closure of Phase 7.2`
- `7.3.1 — Application Flow Inventory`
- `7.3.2 — Session & App Context Normalization`
- `7.3.3 — Feature Interaction Contracts`
- `7.3.4 — Application Coordinator (mínimo)`
- `7.3.5 — Formal Closure of Phase 7.3`
- `7.4.1 — Startup/Auth Continuation Inventory`
- `7.4.2 — Auth Requirement Boundary Normalization`
- `7.4.3 — Login Resolution Continuation Contract`
- `7.4.4 — Minimal Startup/Auth Continuation Coordinator`
- `7.4.5 — Formal Closure of Phase 7.4`
- `7.5 — Formal Closure of Phase 7`

Current active Phase 8 documentary baseline is:

- `8.1 — Runtime Failure Surface Inventory`

## Problem Statement

The documentation index must reflect the real current state of the project.

At this point:

- Phase 7 is closed and frozen
- Phase 8 is now the active phase
- the current active scope is runtime reliability and failure semantics hardening rather than application-layer restructuring

If the index does not make this explicit, future work could incorrectly continue reopening Phase 7 concerns.

## Scope

This index covers:

- core architecture documents
- governance documents
- historical phase documents
- the completed Phase 7 baseline
- the newly opened Phase 8 runtime-hardening effort

It does not define runtime behavior by itself.

## Root Cause Analysis

The documentation has been built phase by phase together with the implementation.

That means the index must preserve the real reading order of the project and clearly distinguish:

- closed structural work
- active runtime hardening work

The current ZIP justifies that distinction.

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
- `docs/phase7_application_layer_consolidation_7_5_formal_closure.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md`

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

## Release Impact

This document has no direct runtime impact.

It keeps the documentation aligned with the real current phase baseline and makes the transition from closed Phase 7 to active Phase 8 explicit.

## Risks

If this index is not aligned, future work may:

- treat Phase 7 as still active
- reopen closed application-layer concerns implicitly
- misread runtime hardening as structural redesign
- lose the correct documentary handoff into Phase 8

## What it does NOT solve

This index does not by itself:

- change runtime behavior
- define retry policy
- normalize failure taxonomy
- harden reconnect behavior
- fix runtime hotspots

It only reflects the real current baseline.

## Conclusion

The current documentation baseline is:

- Phase 6 completed
- Phase 7 completed and formally closed
- Phase 8 opened
- Phase 8.1 documented as runtime failure surface inventory

That is the correct current entry point for the project.