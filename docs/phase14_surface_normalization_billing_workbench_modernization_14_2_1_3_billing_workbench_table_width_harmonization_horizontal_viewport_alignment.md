# Phase 14.2.1.3 — Billing Workbench Table Width Harmonization & Horizontal Viewport Alignment

## Objective

Stabilize the visual relation between the billing workbench table and the wider section container so the table expands to the available surface width when room exists, while still preserving horizontal scroll only when the viewport becomes narrower than the table intrinsic minimum width.

## Initial Context

After Phase 14.2.1.2, three important improvements were already in place:

- billing pagination became backend-driven through real `offset` and `pageSize` values
- the download action column was preserved and reachable
- horizontal scrolling became available on narrow viewports

Runtime validation against the real rendered screen still exposed one remaining presentation issue: the table body was rendered with a fixed intrinsic width smaller than the surrounding workbench container on wider screens.

## Problem Statement

The problem was no longer overflow or fake local pagination.
The remaining issue was width harmonization.

The workbench shell could correctly occupy the full responsive width of the billing block, but the table itself continued to render with a single intrinsic width derived only from the sum of column widths. On wide screens that produced a visible mismatch:

- the billing container looked wider than the table
- the footer and surrounding block stretched further than the table grid
- the horizontal scrollbar only appeared after the viewport shrank below the intrinsic table width

That behavior was technically valid but visually misaligned with the intended workbench surface.

## Scope

Phase 14.2.1.3 includes:

- separating the intrinsic minimum table width from the effective rendered table width
- letting the table grow to match the available workbench viewport width when enough space exists
- preserving horizontal scrolling only for cases where the viewport becomes narrower than the intrinsic minimum table width
- keeping header, rows, and empty-state rendering aligned under the same effective width

Phase 14.2.1.3 does not include:

- sorting
- filters
- multi-select interactions
- business-logic changes
- backend contract changes

## Files Affected

- `lib/features/billing/presentation/widgets/billing_workbench.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_table.dart`
- `docs/phase14_surface_normalization_billing_workbench_modernization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_1_3_billing_workbench_table_width_harmonization_horizontal_viewport_alignment.md`
- `docs/index.md`

## Implementation Details

### 1. Intrinsic minimum width

The billing workbench still defines an intrinsic minimum width from the configured billing columns. That value represents the smallest width at which the full table can render without compressing the expected columns.

### 2. Effective rendered width

The workbench now resolves an effective table width as the maximum between:

- the intrinsic minimum width
- the real available width of the current billing section

This allows the table to visually accompany the section container on wide layouts while keeping the original minimum as the threshold for horizontal scrolling.

### 3. Horizontal viewport alignment

The table widget now computes the final rendered width inside its own layout pass and reuses that same width for:

- table header
- data rows
- empty-page message

That keeps the grid aligned with the section container and ensures that the horizontal scrollbar appears only when the viewport width is truly smaller than the minimum table width.

## Validation Expectation

The phase is considered correct when runtime validation confirms that:

- the table fills the billing workbench width on large screens
- the table no longer looks visually narrower than the surrounding billing block
- horizontal scrolling still appears on narrow windows
- header, rows, and action column stay aligned
- backend pagination behavior remains unchanged

## Conclusion

Phase 14.2.1.3 closes the remaining visual mismatch between the workbench shell and the rendered table grid. The billing surface now behaves as a responsive workbench table that grows with the available container width and only falls back to horizontal scrolling when the viewport becomes narrower than the table minimum width.
