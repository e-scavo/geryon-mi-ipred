# Phase 14.1.1 — Canonical Source Consolidation & Legacy Wrapper Cleanup

## Objective

Close the residual structural debt left after Phase 14.1 by ensuring that the normalized shared and billing-local surfaces now have a single real implementation source, while legacy paths remain available only as compatibility wrappers or export shims.

## Initial Context

The ZIP received for validation after Phase 14.1 already showed meaningful progress:

- auth imported the canonical shared loading widget
- dashboard imported the canonical shared loading widget
- the shared window surface imported the canonical shared system error surface
- main startup imported the canonical shared loading popup route
- billing imported the canonical billing documents table and canonical shared loading/error/system-error surfaces

However, the validation of the real ZIP also showed a smaller but important residual problem:

- several legacy files still kept their own full implementation bodies
- those legacy files coexisted with the new canonical files created in 14.1
- the billing download dialog canonical path still only re-exported the legacy implementation instead of owning it directly

That meant 14.1 was functionally good and safe, but not yet fully consolidated as a single-source structural normalization.

## Problem Statement

The problem left open after 14.1 was no longer about ownership discovery.
That had already been solved.

The residual problem was canonical-source duplication:

- a canonical file existed
- a legacy file still existed with a full copy of the same implementation
- both could look like real implementation owners

This produced avoidable ambiguity in the codebase and left billing only partially normalized at source level.

## Scope

Phase 14.1.1 includes:

- converting legacy shared widget files into wrapper or export-only compatibility files
- converting legacy shared overlay files into wrapper or export-only compatibility files
- converting the legacy billing table file into an export-only compatibility file
- moving the billing document download implementation so that the canonical billing feature path becomes the real implementation owner
- preserving compatibility import paths for older runtime/model callers
- documenting the stricter canonical-source baseline

Phase 14.1.1 does not include:

- visual redesign
- business-logic redesign
- Riverpod changes
- navigation redesign
- runtime owner changes
- broad dormant-code deletion
- billing workbench pagination or desktop-grid modernization

## Root Cause Analysis

Phase 14.1 intentionally favored a compatibility-first migration strategy.
That was the correct choice to reduce regression risk while the main callers were repointed.

The tradeoff of that strategy was that some legacy files remained with full implementations for one more iteration.
That tradeoff was acceptable during the first cut, but after validation it became clear that a narrow consolidation pass was justified before proceeding to 14.2.

The real cause of the residual issue was therefore not a bad migration.
It was the expected intermediate state of a safe migration that had not yet completed the single-source consolidation step.

## Files Affected

### Canonical implementation owners preserved or consolidated

- `lib/shared/widgets/loading_generic.dart`
- `lib/shared/widgets/system_error_surface.dart`
- `lib/shared/overlays/error_dialog_route.dart`
- `lib/shared/overlays/global_loading_dialog.dart`
- `lib/shared/overlays/global_loading_dialog_route.dart`
- `lib/shared/overlays/work_in_progress/work_in_progress_dialog.dart`
- `lib/shared/overlays/work_in_progress/work_in_progress_dialog_route.dart`
- `lib/shared/overlays/work_in_progress/widgets/progress_message.dart`
- `lib/shared/overlays/work_in_progress/widgets/countdown_message.dart`
- `lib/shared/overlays/work_in_progress/widgets/error_message.dart`
- `lib/features/billing/presentation/widgets/billing_documents_table.dart`
- `lib/features/billing/presentation/overlays/billing_document_download_dialog.dart`
- `lib/features/billing/presentation/overlays/billing_document_download_dialog_route.dart`

### Legacy files reduced to compatibility wrappers or exports

- `lib/models/LoadingGeneric/widget.dart`
- `lib/pages/CatchMainScreen/widget.dart`
- `lib/models/child_popup_error_message.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/GeneralLoadingProgress/popup_model.dart`
- `lib/models/ScreenGeneralWorkInProgress/frame.dart`
- `lib/models/ScreenGeneralWorkInProgress/popup_frame.dart`
- `lib/models/ScreenGeneralWorkInProgress/progress_widget.dart`
- `lib/models/ScreenGeneralWorkInProgress/countdown_timer.dart`
- `lib/models/ScreenGeneralWorkInProgress/error_widget.dart`
- `lib/models/SimpleTableWithScroll/widget.dart`
- `lib/models/CommonDownloadLocally/widget.dart`

## Implementation Characteristics

### 1. Shared canonical source consolidation

The canonical shared widgets created in 14.1 remain the real source of implementation.
The legacy `models/` and `pages/` files that previously duplicated those widgets were reduced to export-only compatibility files.

This removes the duplicate-source condition while preserving import stability for callers that were not repointed during 14.1.

### 2. Shared overlay canonical source consolidation

The canonical shared overlays under `lib/shared/overlays/` remain the real implementation owners.
The older overlay files under `lib/models/` now resolve through export-only compatibility layers.

That keeps runtime/model callers compatible without leaving multiple full overlay implementations in parallel.

### 3. Billing source consolidation

The billing documents table canonical file created in 14.1 remains the real implementation owner.
The old table file under `lib/models/SimpleTableWithScroll/` was reduced to a compatibility export.

The billing document download dialog canonical file under `lib/features/billing/presentation/overlays/` now owns the implementation body directly.
The legacy `lib/models/CommonDownloadLocally/widget.dart` file was reduced to a compatibility export.

This is the most important structural tightening performed in 14.1.1 because it makes the billing feature own both the table surface and its download flow surface.

### 4. No contract redesign

Phase 14.1.1 does not redefine the public classes, constructor contracts, popup route contracts, runtime semantics, or backend-facing behavior.
It only changes where the real implementation lives and how the legacy paths resolve to it.

## Validation

The implementation is correct only if all of the following are true in the resulting ZIP:

- `lib/models/LoadingGeneric/widget.dart` resolves to the canonical shared loading widget without keeping a duplicate implementation body
- `lib/pages/CatchMainScreen/widget.dart` resolves to the canonical shared system error surface without keeping a duplicate implementation body
- the old shared overlay files under `lib/models/` now resolve to the canonical shared overlay files
- `lib/models/SimpleTableWithScroll/widget.dart` resolves to the canonical billing documents table
- `lib/features/billing/presentation/overlays/billing_document_download_dialog.dart` now contains the real implementation body
- `lib/models/CommonDownloadLocally/widget.dart` resolves to the canonical billing download dialog rather than owning the implementation itself

The resulting ZIP supports that reading.

## Risks

### Compatibility signature risk

When converting a legacy implementation file into an export-only wrapper, the public classes exposed by the canonical file must remain compatible with the older callers.
This phase keeps the public class names and constructor signatures intact to avoid reopening behavior changes.

### Billing download-flow risk

The billing download dialog touches a deeper runtime and file-generation flow.
Moving the implementation owner to the billing feature boundary is safe only because the public classes and contracts remain unchanged.

### Dormant cleanup still deferred

This subphase intentionally does not delete dormant UI leftovers such as `ServiceProviderConfig` surfaces or unrelated unused widgets.
The focus remains narrow: active canonical-source consolidation.

## What This Subphase Does Not Solve

Phase 14.1.1 does not yet deliver:

- billing pagination
- grouped desktop-style billing workbench interactions
- dormant legacy surface deletion across the entire repository
- a generalized component cleanup of every historical helper file

Those remain later concerns.

## Conclusion

Phase 14.1.1 is implemented.

The project no longer keeps duplicate full implementations for the active shared and billing-local surfaces normalized in Phase 14.1.
Instead, the canonical shared and billing feature paths now act as the true implementation owners, while the legacy paths survive only as controlled compatibility wrappers.

This closes the residual normalization debt detected during the Phase 14.1 validation pass and leaves Mi IP·RED in a cleaner state before the next billing workbench modernization step.
