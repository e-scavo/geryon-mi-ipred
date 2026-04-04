# Phase 14.2.1.2 — Billing Workbench Header Cleanup, Horizontal Table Access & Backend Pagination Alignment

## Objective

Close the three practical debts detected after the first billing workbench stabilization:

- remove redundant billing-type repetition inside the workbench hierarchy
- make the horizontal billing table fully reachable, including the download action column
- replace presentation-only local pagination with backend-aligned pagination using dynamic `offset` and `pageSize`

## Initial Context

Phase 14.2.1 introduced the first workbench shell for billing.
Phase 14.2.1.1 then corrected the vertical-flow integration so billing sections could live naturally inside the dashboard scroll.

After those two layers, runtime validation against the real rendered screen still exposed three remaining issues:

- the billing type still appeared more times than necessary inside the same section
- the horizontal table contract still did not guarantee reliable access to the action column
- page changes were still visual-only because billing requests continued to load the full dataset with `offset = 0` and `pageSize = 0`

## Problem Statement

The remaining problem was no longer the existence of a workbench shell.
The remaining problem was that the shell still mixed presentation debt with incorrect data-loading behavior.

Specifically:

- the toolbar repeated the billing type even though the section title and header already expressed that identity
- the table still relied on proportional flex distribution and approximate minimum width rather than an explicit column-width contract
- the workbench summary and footer looked paginated, but the controller still requested the complete collection from backend

## Scope

Phase 14.2.1.2 includes:

- toolbar hierarchy cleanup
- explicit-width billing columns
- horizontal scrollbar stabilization for desktop and touch usage
- backend-aligned billing pagination using real page and rows-per-page inputs
- billing widget ownership of current page and rows-per-page state
- workbench conversion from local data slicing owner to presentation/event surface

Phase 14.2.1.2 does not include:

- filtering
- sorting
- bulk actions
- grouped cells
- backend contract redesign
- cross-feature architecture changes

## Files Affected

- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/features/billing/presentation/models/billing_workbench_column.dart`
- `lib/features/billing/presentation/widgets/billing_documents_table.dart`
- `lib/features/billing/presentation/widgets/billing_workbench.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_header.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_row.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_summary.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_table.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_toolbar.dart`
- `docs/phase14_surface_normalization_billing_workbench_modernization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_1_2_billing_workbench_header_cleanup_horizontal_table_access_backend_pagination_alignment.md`
- `docs/index.md`

## Implementation Details

### 1. Header cleanup

The workbench toolbar no longer renders a duplicate billing-type title.
The billing type identity now remains in the section title bar and in the descriptive inner header, while the toolbar focuses only on operational data such as total records, rows-per-page, and refresh.

### 2. Explicit horizontal table contract

The billing table no longer depends only on proportional `flex` sizing.
Each column now owns an explicit width, which gives the table a deterministic total width and keeps the download action column reachable.

The table also now exposes an interactive horizontal scrollbar and drag-capable horizontal access, which makes the action column usable in narrower desktop or touch scenarios.

### 3. Backend pagination alignment

The billing controller now receives the current page and rows-per-page values as explicit inputs.
From those values it computes the request offset and page size sent to backend.

That means the feature now requests only the records needed for the current page instead of loading the entire collection and slicing it in the UI.

### 4. Ownership split

`BillingWidget` now owns:

- current page
- rows per page
- refresh on page change
- refresh on rows-per-page change

`BillingWorkbench` now acts as a presentation/event layer that renders the current page payload already returned by backend and emits page/rows-per-page interaction callbacks upward.

## Validation Expectation

The phase is considered correct when all of the following hold in runtime validation:

- the toolbar no longer repeats the billing type title
- the horizontal table exposes the download action column reliably
- the horizontal scrollbar is visible and usable
- changing page triggers a real backend reload with a different offset
- changing rows per page triggers a real backend reload with a different page size
- the visible-range summary remains aligned with backend totals
- no vertical overflow is reintroduced

## Risks

The most relevant risk of this phase is that backend pagination is now part of the billing interaction loop.
For that reason, page and rows-per-page changes must be validated carefully to confirm they continue working correctly after active-client switches and manual refresh actions.

That risk is acceptable because the feature now behaves more honestly and more efficiently than the previous presentation-only pagination baseline.

## Conclusion

Phase 14.2.1.2 finishes the first practical billing workbench correction cycle.
The surface is now cleaner, the table is more reachable, and pagination is finally aligned with the backend request model instead of being simulated entirely in the UI.
