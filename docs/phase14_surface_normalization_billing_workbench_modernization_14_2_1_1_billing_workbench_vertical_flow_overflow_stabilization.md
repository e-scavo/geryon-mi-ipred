# Phase 14.2.1.1 — Billing Workbench Vertical Flow & Overflow Stabilization

## Objective

Stabilize the billing workbench baseline introduced in Phase 14.2.1 so each billing section can live correctly inside the dashboard vertical flow, without fixed-height clipping and without `BOTTOM OVERFLOWED` runtime failures.

## Initial Context

Phase 14.2.1 introduced a modular billing workbench surface with toolbar, summary, table, and pagination.
That baseline was directionally correct, but runtime validation against the real rendered screen exposed an important integration issue:

- billing sections still lived inside fixed-height embeddings
- the billing surface still behaved like an internally bounded viewport
- sections with visible rows could overflow vertically before the pagination footer was fully visible

## Problem Statement

The problem was not the workbench concept itself.
The problem was that the first implementation still combined:

- dashboard embedding with hard-coded billing heights
- a billing surface that behaved like a clipped inner window

That combination was incompatible with a section that now includes:

- title bar
- descriptive header
- toolbar
- summary strip
- current page rows
- pagination footer

## Scope

Phase 14.2.1.1 includes:

- removing fixed-height billing embedding
- allowing billing sections to grow naturally by visible content
- restoring parent-owned vertical scroll behavior for dashboard
- preserving toolbar, summary, table, footer, and row actions

Phase 14.2.1.1 does not include:

- sorting
- filtering
- backend pagination changes
- grouped rows
- visual redesign unrelated to overflow correction

## Files Affected

- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `docs/phase14_surface_normalization_billing_workbench_modernization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_1_1_billing_workbench_vertical_flow_overflow_stabilization.md`
- `docs/index.md`

## Implementation Details

### 1. Dashboard billing embedding

The dashboard billing section no longer forces each billing block into a fixed height.
Each section now expands with its own visible content.

### 2. Billing section shell

The billing surface no longer depends on a rigid inner viewport assumption.
Instead, the section keeps its title bar and descriptive header while allowing the workbench body to determine the final height naturally.

### 3. Scroll ownership

The dashboard parent remains the owner of the vertical reading flow.
Billing sections provide content height, but they do not attempt to become separate vertically clipped windows.

## Validation Expectation

The phase is considered correct when:

- no billing section shows `BOTTOM OVERFLOWED`
- billing rows and pagination footer remain visible
- the page scroll continues naturally through all billing types
- empty billing sections remain visually stable

## Conclusion

Phase 14.2.1.1 closes the first runtime stabilization issue discovered after the billing workbench baseline was introduced.
It preserves the workbench direction while fixing the layout contract that had produced vertical overflow in the real screen.
