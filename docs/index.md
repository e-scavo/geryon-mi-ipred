# 📚 Documentation Index

## Objective

Provide the canonical documentation entry point for Mi IP·RED so the reading order of the repository remains aligned with:

- the real code currently present in the ZIP
- the already closed structural consolidation baseline from Phase 7
- the already closed runtime-hardening baseline from Phase 8
- the active product-surface consistency baseline introduced in Phase 9
- the now completed semantic and local visual consolidation work executed through Phase 9.3.3
- the correct documentary handoff into the next justified step after that closure

This index is not only a file list. It is the high-level map that preserves continuity between historical restructuring, runtime hardening, product-surface normalization, and the current UX-consistency baseline.

## Initial Context

The current ZIP confirms the following real repository baseline:

- Phase 6 completed
- Phase 7 completed and formally closed
- Phase 8 completed and formally closed
- Phase 9 opened as product surface consistency and UX hardening

Inside Phase 9, the current confirmed baseline is:

- Phase 9.1 completed as product surface inventory
- Phase 9.2.1 completed as shared state surface contract foundation
- Phase 9.2.2 completed as Billing state surface normalization
- Phase 9.2.3 completed as Dashboard state presentation normalization
- Phase 9.2.4 completed as Auth interaction feedback normalization
- Phase 9.3.1 completed as cross-feature UX consistency inventory
- Phase 9.3.2 completed as copy / action / feedback consolidation
- Phase 9.3.3 completed as local density / layout consistency adjustments
- Phase 9.3.3.1 completed as shared surface density baseline
- Phase 9.3.3.2 completed as dashboard layout rhythm normalization
- Phase 9.3.3.3 completed as auth surface density alignment
- Phase 9.3.3.4 completed as billing embedded surface fit
- Phase 9.3.3.5 completed as formal closure of the 9.3.3 series

That means the repository is no longer at the point where the main unresolved concern is:

- structure
- runtime semantics
- semantic wording consistency
- local panel density inconsistency

The next justified concern begins after this baseline.

## Problem Statement

The index must preserve the correct documentary progression of the project.

If it stops at a partially updated state or collapses completed work into a short summary, it creates several risks:

- Phase 7 and Phase 8 look less foundational than they really are
- Phase 9.2 and Phase 9.3 lose their incremental relation
- the 9.3.3 implementation work in the code is not reflected faithfully in docs
- the next phase boundary becomes blurry
- future work can reopen already closed local UI adjustments accidentally

The index therefore needs to be both:

- historical
- current
- incremental
- truthful to the ZIP

## Scope

This index covers:

- architecture and deep-architecture documents
- governance and development rules
- feature and flow documents
- historical structural phases
- runtime-hardening phases
- product-surface consistency phases
- current closure state of 9.3.3

It does not itself modify behavior, define design tokens, or implement UI changes.

## Root Cause Analysis

The project evolved in layered form:

### Phase 1 to Phase 6
The project first required audit, structural planning, cleanup, normalization, ServiceProvider decomposition, and presentation cleanup.

### Phase 7
The dominant unresolved concern became application-layer consolidation. That phase clarified:

- feature extraction
- state boundaries
- session/app context normalization
- interaction contracts
- startup/auth continuation coordination

### Phase 8
Once structure was stable, the next unresolved concern became runtime reliability and failure semantics. That phase clarified:

- runtime failure surface inventory
- failure boundary normalization
- retry / reboot / reconnect policy hardening
- runtime diagnostic / observability signals
- formal closure of the runtime-hardening baseline

### Phase 9
Only after those two larger baselines were closed did the project move into product-surface consistency and UX hardening.

That Phase 9 progression is itself layered:

#### Phase 9.1
Inventory of product-surface inconsistency.

#### Phase 9.2
Semantic consistency hardening across the three critical surfaces:
- Billing
- Dashboard
- Auth

#### Phase 9.3
Cross-feature UX consistency work, which then split into:
- inventory of cross-feature inconsistency
- copy / action / feedback consolidation
- local density / layout consistency adjustments

The current ZIP now confirms that the 9.3.3 local density/layout layer is no longer pending; it is implemented and formally closable.

That is why the index now needs to represent 9.3.3 as completed work rather than as an open or undefined continuation.

## Files Affected

Primary documentation entry documents include:

- `README.md`
- `docs/index.md`
- `docs/architecture.md`
- `docs/architecture-deep.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/flows.md`
- `docs/features.md`
- `docs/release.md`

Historical support documents include:

- `docs/module-inventory.md`
- `docs/cleanup-checklist.md`
- `docs/infra-normalization.md`
- `docs/refactor-plan.md`
- `docs/service-provider-decomposition.md`
- `docs/target-structure.md`
- `docs/legacy.md`

Phase-specific documents include all phase files from:

- `docs/phase1_audit.md`
through
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_5_formal_closure.md`

## Implementation Characteristics

### Core Architecture Documents

- `docs/architecture.md`
- `docs/architecture-deep.md`

These remain the primary reference for architecture and layering.

### Governance Documents

- `docs/development.md`
- `docs/decisions.md`

These define how the repository is allowed to evolve after each baseline closure.

### Feature and Runtime Interpretation Documents

- `docs/flows.md`
- `docs/features.md`
- `docs/release.md`

These help relate architectural decisions to visible product behavior.

### Structural History

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

### Phase 7 — Application Layer Consolidation

Master:
- `docs/phase7_application_layer_consolidation.md`

Subphases:
- `docs/phase7_application_layer_consolidation_7_1_1_auth_extraction.md`
- `docs/phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md`
- `docs/phase7_application_layer_consolidation_7_1_3_billing_extraction.md`
- `docs/phase7_application_layer_consolidation_7_2_1_feature_state_inventory.md`
- `docs/phase7_application_layer_consolidation_7_2_2_billing_state_boundary_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_2_3_dashboard_state_derivation_normalization.md`
- `docs/phase7_application_layer_consolidation_7_2_4_auth_startup_initial_state_boundary_cleanup.md`
- `docs/phase7_application_layer_consolidation_7_2_5_formal_closure.md`
- `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`
- `docs/phase7_application_layer_consolidation_7_3_2_session_app_context_normalization.md`
- `docs/phase7_application_layer_consolidation_7_3_3_feature_interaction_contracts.md`
- `docs/phase7_application_layer_consolidation_7_3_4_application_coordinator_minimal.md`
- `docs/phase7_application_layer_consolidation_7_3_5_formal_closure.md`
- `docs/phase7_application_layer_consolidation_7_4_1_startup_auth_continuation_inventory.md`
- `docs/phase7_application_layer_consolidation_7_4_2_auth_requirement_boundary_normalization.md`
- `docs/phase7_application_layer_consolidation_7_4_3_login_resolution_continuation_contract.md`
- `docs/phase7_application_layer_consolidation_7_4_4_minimal_startup_auth_continuation_coordinator.md`
- `docs/phase7_application_layer_consolidation_7_4_5_formal_closure.md`
- `docs/phase7_application_layer_consolidation_7_5_formal_closure.md`

### Phase 8 — Runtime Reliability / Failure Semantics Hardening

Master:
- `docs/phase8_runtime_reliability_failure_semantics_hardening.md`

Subphases:
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_2_failure_boundary_normalization.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_3_retry_reboot_reconnect_policy_hardening.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_4_runtime_diagnostic_observability_signals.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_5_formal_closure.md`

### Phase 9 — Product Surface Consistency & UX Hardening

Master:
- `docs/phase9_product_surface_consistency_ux_hardening.md`

#### Phase 9.1
- `docs/phase9_product_surface_consistency_ux_hardening_9_1_product_surface_inventory.md`

#### Phase 9.2
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_1_shared_state_surface_contract.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_2_billing_state_surface_normalization.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_3_dashboard_state_presentation_normalization.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_2_4_auth_interaction_feedback_normalization.md`

#### Phase 9.3
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_1_cross_feature_ux_consistency_inventory.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_2_copy_action_feedback_consolidation.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_surface_density_layout_consistency_adjustments.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_1_shared_surface_density_baseline.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_2_dashboard_layout_rhythm_normalization.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_3_auth_surface_density_alignment.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_4_billing_embedded_surface_fit.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_3_5_formal_closure.md`

---

## Phase 9.3.4 — Web / Android Consistency Review

The repository now formally introduces the next justified layer after the closure of 9.3.3.

This layer addresses cross-context behavior:

- viewport width differences
- constrained vs wide layout rendering
- Web vs mobile behavior

### Included Documents

- `docs/phase9_product_surface_consistency_ux_hardening.md` (extended)
- responsive behavior adjustments implemented in:
  - dashboard
  - shared widgets
  - billing surfaces

### Subphases

- 9.3.4.1 — Wide viewport focus normalization
- 9.3.4.2 — Responsive container normalization
- 9.3.4.3 — Cross-context surface fit validation
- 9.3.4.4 — Formal closure

---

## Phase 10 — Product Capability Completion

The repository now moves beyond the consistency-hardening layer and into the next justified concern.

This concern is no longer centered on:

- structure
- runtime semantics
- wording consistency
- local visual density
- cross-context layout behavior

Instead, it is centered on the gap between:

- capabilities already implemented in code
- capabilities actually exposed in the product surface

### Phase 10.1 — Financial Capability Inventory & Exposure Baseline

This subphase establishes the first justified step of Phase 10.

Its purpose is to document and classify the real billing capability surface before any exposure expansion is implemented.

### Included Concerns

- inventory of currently supported billing/comprobante capability classes
- validation of where each capability is already represented in code
- classification of exposure state across product surface entry points
- preparation of a controlled implementation handoff into the next subphase

### Expected Outputs

- capability matrix
- exposure gap report
- integration strategy without implementation

### Constraints

- no reopening of Phase 9 baselines
- no layout redesign
- no responsive rework
- no runtime ownership changes
- no speculative feature expansion beyond what the ZIP already supports

---

### Phase 10.2 — Financial Capability Exposure Implementation

This subphase completes the controlled exposure of billing capabilities already supported by the system.

### Implemented Exposure

The dashboard now exposes:

- FacturasVT
- RecibosVT
- DebitosVT
- CreditosVT

### Interpretation

The system transitions from a partially exposed billing surface to a complete and aligned financial capability surface.

### Constraints Respected

- no reopening of Phase 7 architecture
- no reopening of Phase 8 runtime baseline
- no reopening of Phase 9 UX or responsive baselines
- no introduction of new abstraction layers

### Result

- dashboard becomes a faithful representation of billing capabilities
- exposure is aligned with real system support
- no ownership boundaries are altered

---


---

## Phase 11 — Release & Distribution

The repository now moves beyond capability completion and into the next justified concern layer.

This concern is no longer centered on:

- architecture
- runtime semantics
- UX consistency
- responsive fit
- billing capability exposure completeness

Instead, it is centered on the gap between:

- a functionally complete product surface
- a reproducible and distribution-ready release process

### Phase 11.1 — Build & Versioning Standardization

This subphase establishes the first justified implementation step of Phase 11.

Its purpose is to normalize and synchronize the active release/versioning surface already present in the ZIP.

### Phase 11.2 — Packaging & Artifact Structuring

This subphase formalizes how generated release artifacts are copied, renamed, organized, and described after build completion.

Its purpose is to move the repository from reproducible builds into reproducible delivery outputs without changing product behavior.

### Phase 11.3 — Distribution Readiness & Publication Surface Validation

This subphase hardens the final pre-publication layer by validating the generated release set, aligning public-facing web metadata with Mi IP·RED branding, and documenting the local Android signing contract without changing product runtime behavior.

### Included Concerns

- synchronization of `pubspec.yaml` and `lib/config/version.dart`
- standardization of Web / APK / AAB release targets
- explicit release forwarding of build-name/build-number
- removal of outdated fixed-branch assumptions from release automation
- alignment of version metadata branding with Mi IP·RED
- structured artifact copying into `dist/`
- versioned artifact naming conventions for Web / APK / AAB
- release manifest generation for the structured outputs
- branded public metadata alignment for web publication surfaces
- local signing-contract documentation for Android release work
- repeatable release validation reporting through `validate_release.dart`

### Expected Outputs

- synchronized version baseline
- reproducible release command baseline
- Android App Bundle treated as first-class release artifact
- structured `dist/` tree for release outputs
- release manifest per version and rolling latest manifest
- release validation report per version and rolling latest report
- documentary handoff toward later distribution work

### Constraints

- no reopening of Phase 7 architecture
- no reopening of Phase 8 runtime baseline
- no reopening of Phase 9 UX/responsive baselines
- no reopening of Phase 10 capability-completion baseline
- no business logic changes under the label of release work



---

## Phase 12 — Store Publication Assets & Operational Rollout

The repository now moves beyond local/manual release readiness and into the next justified concern layer.

This concern is no longer centered on:

- architecture
- runtime semantics
- UX consistency
- responsive fit
- feature exposure
- release build reproducibility
- submission-bundle generation

Instead, it is centered on the remaining gap between:

- a validated local/manual release package
- a publication surface that is structurally ready for real Play Console rollout
- a track-by-track rollout contract that keeps promotion decisions versioned and explicit

### Phase 12.1 — Store Asset Baseline & Publication Surface Structuring

Implemented.

Its purpose is to convert the already validated submission baseline into a versioned publication surface that organizes store assets, track notes, metadata copies, and rollout evidence without changing application behavior.

### Phase 12.2 — Track Rollout Operational Checklist

Implemented.

Its purpose is to convert the previously generated rollout directories into explicit operator contracts for `internal`, `closed`, and `production`, including promotion gates and evidence templates.

### Phase 12.3 — Publication Evidence & Post-Upload Validation

Implemented.

Its purpose is to formalize what gets recorded after the upload and validation steps, so each version keeps post-upload evidence, validation results, promotion decisions, and an operator ledger inside the generated publication surface.

### Included Concerns

- versioned publication surfaces under `distribution/play_store/releases/<version>/`
- canonical generation through `prepare_store_publication.dart`
- alignment between `distribution/submissions/<version>/` and the store-facing surface for the same version
- normalized Android store asset directories for phone, 7-inch, 10-inch, and feature-graphic material
- active-track registration inside the generated publication surface
- track-specific rollout notes, checklists, promotion gates, and evidence templates for `internal`, `closed`, and `production`
- publication summary and manifest files for the generated surface
- versioned post-upload evidence and validation documents per track
- a publication ledger for repository-side auditability of rollout decisions

### Expected Outputs

- structured publication surface per version
- copied metadata/checklist baseline for the same version
- operator-facing asset directory contracts
- explicit rollout contracts per Play track
- documentary handoff toward later publication automation work

### Constraints

- no reopening of Phase 7 architecture
- no reopening of Phase 8 runtime baseline
- no reopening of Phase 9 UX/responsive baselines
- no reopening of Phase 10 capability-completion baseline
- no reopening of Phase 11 release/distribution readiness baseline
- no business logic changes under the label of publication work

## Validation

This index is aligned only if all of the following are true:

- it still presents Phase 7 and Phase 8 as closed foundational baselines
- it still presents Phase 9 as active product-surface consistency work
- it preserves the distinction between semantic consistency and local visual consistency
- it reflects the fact that 9.3.3 is now implemented and formally closable
- it leaves the next justified concern outside the local density/layout layer
- it reflects the closure of 9.3.4 as cross-context consistency work
- it establishes Phase 10 as capability-completion work rather than as redesign
- it reflects Phase 10.2 as controlled exposure of already-supported billing capabilities rather than as new feature invention

The current ZIP supports that reading.

## Release Impact

This index has no direct runtime impact.

Its purpose is documentary truth and navigation quality:

- preserving historical continuity
- keeping phase progression understandable
- preventing reopened work by ambiguity
- strengthening the handoff from 9.3.3 to the next phase

## Risks

If this document remains partial or over-compressed, future work may:

- treat 9.3.3 as incompletely documented work
- reopen local layout tuning without phase control
- misread Phase 9 as still centered only on wording/copy
- lose continuity between code and documentation
- skip capability classification and move straight into uncontrolled exposure changes
- misread 10.2 as permission for broader redesign instead of narrow capability exposure

## What it does NOT solve

This index does not itself:

- solve wide web viewport focus
- solve Android vs Web parity
- redesign screens
- modify any widget or controller
- expose new billing capability entry points beyond those already implemented in the current ZIP

It only preserves the correct documentary map.

## Conclusion

The correct documentary reading of the repository is now:

- Phase 7 closed
- Phase 8 closed
- Phase 9 active
- Phase 9.2 closed semantic consistency across critical surfaces
- Phase 9.3.3 completed local density / layout consistency work
- formal closure of 9.3.3 is now part of the truthful baseline
- Phase 9.3.4 established as cross-context consistency layer
- Phase 10 established as product capability completion layer
- Phase 10.2 completed the controlled exposure of the supported billing capability surface
- the next justified concern begins after that closure, not inside it
- Phase 11.3 now closes the immediate distribution-readiness gap before later deployment workflow work
- Phase 11.4 completes the final local/manual submission handoff baseline
- Phase 12 now becomes the justified next layer because the remaining gap is publication-surface organization rather than release reproducibility
- Phase 12.1 establishes store asset and rollout structure without reopening product behavior
- Phase 12.2 formalizes track rollout criteria and operator evidence without reopening product behavior
- Phase 12.3 formalizes repository-side post-upload evidence without reopening product behavior
- Phase 12.4 formalizes the automation boundary so publication support remains human-controlled
- Phase 13 now becomes the justified next layer because the remaining gap is not structural publication scaffolding but store-readiness verification of the actual visual assets
- Phase 13.1 establishes a local asset-readiness baseline for the versioned publication surface without changing application behavior or publication control
- Phase 13.2 adds the explicit listing-consistency contract so minimum-ready assets do not drift into an arbitrary store narrative
- Phase 13.3 consolidates release validation, submission, publication-surface, and asset-readiness evidence into a single final publication-readiness gate
- Phase 13.4 closes the whole store/publication readiness baseline as a reusable operating model with documented accepted warnings

### Phase 11 — Release & Distribution

Master:
- `docs/phase11_release_distribution.md`

Subphases:
- `docs/phase11_release_distribution_11_1_build_versioning_standardization.md`
- `docs/phase11_release_distribution_11_2_packaging_artifact_structuring.md`
- `docs/phase11_release_distribution_11_3_distribution_readiness_validation.md`
- `docs/phase11_release_distribution_11_4_final_release_operations_submission_checklist.md`

### Phase 12 — Store Publication Assets & Operational Rollout

Master:
- `docs/phase12_store_publication_assets_operational_rollout.md`

Subphases:
- `docs/phase12_store_publication_assets_operational_rollout_12_1_store_asset_baseline_publication_surface_structuring.md`
- `docs/phase12_store_publication_assets_operational_rollout_12_2_track_rollout_operational_checklist.md`
- `docs/phase12_store_publication_assets_operational_rollout_12_3_publication_evidence_post_upload_validation.md`
- `docs/phase12_store_publication_assets_operational_rollout_12_4_optional_automation_boundaries.md`

### Phase 13 — Store Execution Integrity & Market Presence Hardening

Master:
- `docs/phase13_store_execution_integrity_market_presence_hardening.md`

Subphases:
- `docs/phase13_store_execution_integrity_market_presence_hardening_13_1_store_asset_readiness_baseline.md`
- `docs/phase13_store_execution_integrity_market_presence_hardening_13_2_store_listing_visual_consistency_contract.md`
- `docs/phase13_store_execution_integrity_market_presence_hardening_13_3_publication_readiness_gate.md`
- `docs/phase13_store_execution_integrity_market_presence_hardening_13_4_store_publication_readiness_closure.md`

## Current documentary state

The current ZIP confirms that the release/publication baseline is now closed through:

- Phase 11.4
- Phase 12.1
- Phase 12.2
- Phase 12.3
- Phase 12.4
- Phase 13.1
- Phase 13.2
- Phase 13.3
- Phase 13.4

The current justified step remains inside store-execution integrity and should not reopen architecture, runtime, UX, navigation, Riverpod, backend communication, or existing features.


## Phase 14 Status

The current ZIP now also supports the opening and implementation of the next justified layer after the formal closure of Phase 13.

That layer is:

- `docs/phase14_surface_normalization_billing_workbench_modernization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_1_legacy_widget_surface_audit_final_normalization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_1_1_canonical_source_consolidation_legacy_wrapper_cleanup.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_1_billing_workbench_surface_contract_pagination_baseline.md`

Phase 14 does not reopen release, publication, runtime, or cross-feature UX baselines.
It begins the controlled normalization of the remaining legacy widget surface that still coexists with the already consolidated feature/shared structure.

### Phase 14 — Surface Normalization & Billing Workbench Modernization

Master:
- `docs/phase14_surface_normalization_billing_workbench_modernization.md`

Subphases:
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_1_legacy_widget_surface_audit_final_normalization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_1_1_canonical_source_consolidation_legacy_wrapper_cleanup.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_1_billing_workbench_surface_contract_pagination_baseline.md`

- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_1_1_billing_workbench_vertical_flow_overflow_stabilization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_1_2_billing_workbench_header_cleanup_horizontal_table_access_backend_pagination_alignment.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_2_1_sortable_columns_query_state_wiring.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_2_2_search_filter_entry_layer.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_2_3_table_interaction_rhythm_state_feedback.md`


## Phase 14.2.1.3

- Phase 14.2.1.3 completed as billing workbench table width harmonization and horizontal viewport alignment

## Phase 14.2.2.1

- Phase 14.2.2.1 completed as sortable columns and billing query-state wiring


## Phase 14.2.2.2

- Phase 14.2.2.2 completed as billing search and filter entry layer


## Phase 14.2.2.3

- Phase 14.2.2.3 completed as billing table interaction rhythm and localized state feedback

## Phase 14.2.2.4 — Formal Closure

- Billing Workbench UX & Interaction Layer finalizada
- Se consolida paginación, sorting, search y feedback UX
- Se cierra formalmente la línea 14.2

## Phase 14.3

- Phase 14.3 opened as Payment Methods Surface Modernization after the formal closure of Phase 14.2
- the current payment methods surface remains informational, backend-driven, and external-payment oriented
- Phase 14.3.2.1 completed the first structural extraction cut by creating the payment methods feature boundary and moving the dialog ownership out of dashboard

### Phase 14.3 — Payment Methods Surface Modernization

Subphases:
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_3_2_1_payment_methods_feature_boundary_overlay_extraction.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_3_2_2_payment_methods_dashboard_integration_boundary_cleanup.md`


## Phase 14.3.2.2

- Phase 14.3.2.2 completed as dashboard integration boundary cleanup for the Payment Methods surface
- dashboard now opens the Payment Methods dialog through the feature-owned launcher API
- the feature remains informational, backend-driven, and external-payment oriented
