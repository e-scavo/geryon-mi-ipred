# Phase 14.2.2.1 — Sortable Columns & Query-State Wiring

## Objective

Extend the stabilized billing workbench so the visible table becomes operationally sortable from the UI, with the current sort state owned by the billing surface and sent to the backend through the existing paginated request flow.

## Initial Context

After Phase 14.2.1.3, the billing workbench already had the following properties validated on the real application surface:

- backend pagination through `Offset` and `PageSize`
- stable vertical composition inside dashboard
- harmonized effective table width
- visible and usable download action
- responsive horizontal access when the viewport becomes narrower than the table minimum width

That meant the next correct step was no longer structural stabilization, but interaction capability.

## Problem Statement

The billing table exposed useful columns:

- voucher number
- date
- amount
- action

However, the user still could not request a different ordering directly from the workbench.
The backend request already carried sorting fields internally, but the UI did not own or expose that query state.

As a result:

- the visible order looked fixed
- pagination and sorting were not yet coordinated by the same owner state
- the table behaved more like a static paginated listing than a true workbench surface

## Scope

Phase 14.2.2.1 includes:

- sortable column headers for voucher number, date, and amount
- visible sort state feedback in the table header
- billing-owned query state for `sortField` and `sortAsc`
- backend request wiring so sorting and pagination travel together
- automatic page reset to `1` when the sort changes

Phase 14.2.2.1 does not include:

- text search
- date filters
- multi-select row actions
- export flows
- visual redesign outside the sortable-header concern

## Files Affected

- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/features/billing/presentation/models/billing_workbench_column.dart`
- `lib/features/billing/presentation/widgets/billing_workbench.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_header.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_table.dart`
- `docs/phase14_surface_normalization_billing_workbench_modernization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_2_1_sortable_columns_query_state_wiring.md`
- `docs/index.md`

## Implementation Details

### 1. Billing-owned sort state

`BillingWidget` now owns, in addition to page and page size:

- `sortField`
- `sortAsc`

The default state keeps the prior behavior:

- `sortField = 'FechaCpbte'`
- `sortAsc = false`

This preserves the previous descending-by-date baseline until the user requests a different ordering.

### 2. Controller request wiring

`BillingController.reloadBillingState(...)` and `loadBillingData(...)` now receive:

- `currentPage`
- `rowsPerPage`
- `sortField`
- `sortAsc`

The request payload uses those values directly for:

- `Offset`
- `PageSize`
- `SortField`
- `SortAsc`

That keeps pagination and ordering aligned under the same query-state contract.

### 3. Sortable column metadata

`BillingWorkbenchColumn` now supports:

- `sortable`
- `sortField`

This allows the table definition to declare which columns are interactive and which backend field each sortable column maps to.

The current billing workbench wiring enables sorting for:

- `NroCpbte`
- `FechaCpbte`
- `ImporteTotalConImpuestos`

The action column remains non-sortable.

### 4. Interactive header feedback

`BillingWorkbenchHeader` now renders sortable headers as interactive cells:

- inactive sortable columns show a neutral sort glyph
- the active sortable column shows ascending or descending direction
- clicking a sortable header toggles direction when the same column is already active
- clicking a different sortable column activates it and starts in ascending mode

### 5. Page reset on sort change

Whenever the sort state changes, `BillingWidget` resets the visible page to `1` before requesting the next backend slice.
This prevents stale page positions from conflicting with the newly requested order.

## Validation Expectation

The phase is considered correct when the following conditions hold:

- voucher number, date, and amount headers are clickable
- the action column is not sortable
- sort direction is visible in the active header
- clicking a sortable header triggers a real backend reload
- the request payload reflects the new `SortField` and `SortAsc`
- page resets to `1` when sort changes
- existing backend pagination continues to work
- download per row continues to work
- no overflow or width regressions are introduced

## Risks

The change is intentionally narrow but two points deserve validation:

- the backend field names used for sorting must match the real request contract
- page reset must remain coordinated with the currently selected rows-per-page value

## Conclusion

Phase 14.2.2.1 is the first interaction-layer upgrade on top of the already stabilized billing workbench.
It does not redesign billing, but it makes the table genuinely operable by letting the UI drive sort state and send that query state through the existing paginated backend flow.
