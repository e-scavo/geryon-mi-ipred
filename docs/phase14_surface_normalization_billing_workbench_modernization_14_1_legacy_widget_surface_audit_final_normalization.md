# Phase 14.1 — Legacy Widget Surface Audit & Final Normalization

## Objective

Complete the first controlled implementation step of Phase 14 by taking the real legacy widget surface still active in the ZIP and normalizing it into the already established `shared` and `features` structure, without altering runtime ownership, navigation, Riverpod, backend communication, or business logic.

## Initial Context

The ZIP already contained a partially normalized structure:

- `lib/features/auth/`
- `lib/features/billing/`
- `lib/features/dashboard/`
- `lib/shared/layouts/`
- `lib/shared/widgets/`
- `lib/shared/window/`

But the active code still depended on legacy UI surfaces located under:

- `lib/models/LoadingGeneric/`
- `lib/models/GeneralLoadingProgress/`
- `lib/models/ScreenGeneralWorkInProgress/`
- `lib/models/child_popup_error_message.dart`
- `lib/models/SimpleTableWithScroll/`
- `lib/pages/CatchMainScreen/`

The audit performed against the real ZIP showed that these were not dormant leftovers only.
Several of them were still directly imported by:

- `lib/main.dart`
- `lib/shared/window/window_widget.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- runtime/model layers that still trigger progress and error overlays

## Problem Statement

The application had already consolidated feature boundaries and runtime contracts, but the canonical import surface still pointed to legacy UI locations.

That produced a mismatch between logical ownership and physical ownership:

- shared widgets were still stored under `models/`
- a reusable system fallback surface was still stored under `pages/`
- a billing-specific documents table still lived outside the billing feature
- billing-specific download popup routing still depended on a generic legacy location

The problem to solve in 14.1 was not UI redesign.
The problem was canonical path normalization with the smallest safe behavioral footprint.

## Scope

Phase 14.1 includes:

- creating canonical shared widget destinations
- creating canonical shared overlay destinations
- creating canonical billing presentation destinations
- repointing active imports in the app surface toward the new canonical files
- preserving old paths as compatibility wrappers where that reduces migration risk
- documenting the resulting normalized map

Phase 14.1 does not include:

- changing runtime owner semantics
- changing feature logic
- changing backend messages
- deleting dormant legacy surfaces wholesale
- redesigning the billing experience into a workbench yet

## Root Cause Analysis

The remaining legacy surface existed for understandable historical reasons:

- earlier phases prioritized stability and behavior closure over final file placement
- runtime overlays were left where they already worked to avoid regressions during reliability hardening
- billing-specific UI was stabilized functionally before the final presentation ownership cleanup

By the time Phase 13 closed, those temporary choices had become the next clear cleanup target.
The real problem was now one of canonical ownership and import discipline rather than missing functionality.

## Files Affected

### New canonical shared widget files

- `lib/shared/widgets/loading_generic.dart`
- `lib/shared/widgets/system_error_surface.dart`

### New canonical shared overlay files

- `lib/shared/overlays/error_dialog_route.dart`
- `lib/shared/overlays/global_loading_dialog.dart`
- `lib/shared/overlays/global_loading_dialog_route.dart`
- `lib/shared/overlays/work_in_progress/work_in_progress_dialog.dart`
- `lib/shared/overlays/work_in_progress/work_in_progress_dialog_route.dart`
- `lib/shared/overlays/work_in_progress/widgets/progress_message.dart`
- `lib/shared/overlays/work_in_progress/widgets/countdown_message.dart`
- `lib/shared/overlays/work_in_progress/widgets/error_message.dart`

### New canonical billing presentation files

- `lib/features/billing/presentation/widgets/billing_documents_table.dart`
- `lib/features/billing/presentation/overlays/billing_document_download_dialog.dart`
- `lib/features/billing/presentation/overlays/billing_document_download_dialog_route.dart`

### Active callers repointed to canonical destinations

- `lib/main.dart`
- `lib/shared/window/window_widget.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/billing/presentation/billing_widget.dart`

### Compatibility wrapper files preserved on legacy paths

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

## Implementation Characteristics

### 1. Shared widget normalization

`LoadingGeneric` was given a canonical location under `lib/shared/widgets/` because it is actively reused by auth, dashboard, and billing.

`CatchMainScreen` was given a canonical location under `lib/shared/widgets/` because it functions as a reusable system error surface rather than as an actual navigation page.

### 2. Shared overlay normalization

The following runtime-wide overlays were normalized under `lib/shared/overlays/`:

- generic error popup route
- startup/loading popup route and widget
- work-in-progress popup route and its supporting widgets

This matches their real role as transversal UI infrastructure rather than data models.

### 3. Billing boundary normalization

The billing comprobantes table was normalized into:

- `lib/features/billing/presentation/widgets/billing_documents_table.dart`

This reflects its real ownership because the widget is tightly coupled to billing row semantics and billing download actions.

The billing document download popup route received canonical feature-local paths under:

- `lib/features/billing/presentation/overlays/`

This provides the correct destination path for future billing workbench evolution even though the current implementation still uses compatibility exports to avoid a larger same-step rewrite.

### 4. Compatibility-first migration strategy

Instead of deleting the old files immediately, 14.1 preserved them as thin export wrappers that forward to the new canonical files.

That strategy was chosen because it offers three benefits:

- active callers can move first without destabilizing the runtime
- deeper model/runtime layers can keep compiling while imports are normalized incrementally
- future cleanup can remove legacy wrappers in a later controlled pass once the canonical paths are fully absorbed

### 5. No logic redesign

14.1 intentionally did not rewrite:

- billing data loading
- websocket/runtime coordination
- overlay semantics
- popup behavior
- business rules

The purpose of the subphase was ownership normalization, not behavioral invention.

## Validation

The implementation is correct only if all of the following are true in the resulting ZIP:

- auth now imports the canonical shared loading widget
- dashboard now imports the canonical shared loading widget
- window rendering now imports the canonical shared system error surface
- main startup flow now imports the canonical shared loading popup route
- billing now imports the canonical billing documents table and canonical shared loading/error/system-error surfaces
- old legacy files remain available as compatibility exports instead of being removed abruptly

The resulting ZIP supports that reading.

## Risks

### Runtime overlay dependency risk

Global overlays are used from runtime/model layers that were intentionally not redesigned in this phase.
Preserving legacy wrappers reduces the chance of breaking indirect callers.

### Billing coupling risk

The billing table still triggers the current download popup route and still depends on the existing billing/download model contracts.
That is acceptable for 14.1 because the goal was relocation of ownership, not replacement of behavior.

### Incomplete dormant cleanup risk

Dormant or low-priority legacy files such as `ServiceProviderConfig` UI helpers and `barcode_widget.dart` were intentionally left out of this implementation cut.
That keeps 14.1 narrow and safe, but it also means a later cleanup pass may still be justified.

## What This Subphase Does Not Solve

Phase 14.1 does not yet deliver:

- a redesigned billing workbench
- grouped/paginated billing grids
- broader final cleanup of dormant UI leftovers
- removal of all compatibility wrappers

Those concerns belong to later controlled subphases after the canonical ownership boundary is stable.

## Conclusion

Phase 14.1 is implemented.

The real ZIP now exposes canonical shared and billing-local paths for the remaining active legacy surfaces that were still structurally misplaced.
The implementation stays faithful to the repository constraints because it normalizes ownership without reopening architecture, runtime, navigation, Riverpod, backend contracts, or business logic.

This leaves Mi IP·RED with a cleaner active surface baseline and a safer starting point for the next billing workbench modernization steps.
