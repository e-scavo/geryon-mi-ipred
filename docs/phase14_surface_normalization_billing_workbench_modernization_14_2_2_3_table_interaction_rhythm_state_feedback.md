
# Phase 14.2.2.3 — Table Interaction Rhythm & State Feedback

## Objective

Refine the billing workbench interaction layer so the table communicates actionable areas more clearly, preserves user context during incremental refreshes, and improves day-to-day readability without changing billing contracts, pagination rules, sorting rules, or backend behavior.

## Initial Context

By the end of Phase 14.2.2.2, the billing module already had the hard functional pieces in place:

- backend pagination
- backend sorting
- backend search
- stabilized horizontal scrolling
- stabilized vertical layout
- contextual empty-state handling

That meant the remaining work was no longer structural.
The next improvement point was experiential: the surface still worked, but it could communicate interaction and in-flight updates more clearly.

## Problem Statement

The pre-phase workbench behaved correctly, but it still felt flatter than necessary in a few practical ways:

- sortable headers did not strongly advertise themselves as interactive
- row scanning could be more comfortable with better hover rhythm
- paging, sorting, and search refreshes still replaced the whole section with a larger loading treatment than necessary
- toolbar, summary, table, and footer were already correct, but they did not yet read as one deliberately rhythmized operator surface

## Scope

Phase 14.2.2.3 includes:

- stronger hover and active feedback for sortable headers
- soft row hover treatment and denser row rhythm
- localized refresh feedback that preserves the current workbench while a paging, sort, or search update is in flight
- spacing and presentation refinements across toolbar, summary, table, and pagination footer

Phase 14.2.2.3 does not include:

- date filtering
- multi-select
- exports
- bulk actions
- backend changes
- navigation changes
- architectural changes

## Files Affected

- `lib/features/billing/presentation/billing_widget.dart`
- `lib/features/billing/presentation/widgets/billing_workbench.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_header.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_row.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_table.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_toolbar.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_summary.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_pagination.dart`
- `docs/phase14_surface_normalization_billing_workbench_modernization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_2_3_table_interaction_rhythm_state_feedback.md`
- `docs/index.md`

## Implementation Details

### 1. Localized refresh behavior

`BillingWidget` now tracks whether a reload is occurring while the table already has visible data.
When that is the case, the widget preserves the current workbench surface and passes a localized refresh flag down to the table area instead of immediately swapping the whole body for the generic loading surface.

This keeps the current rows visible while communicating that the page, sort, or search operation is being refreshed.

### 2. Header interaction affordance

The billing header cells now expose clearer interaction cues:

- pointer cursor on sortable columns
- hover feedback
- stronger active-sort emphasis
- clearer sort direction indicator

The action column remains intentionally non-sortable.

### 3. Row hover rhythm

Rows now use a soft hover treatment and slightly tighter vertical rhythm so the table reads more comfortably while preserving the existing desktop-like density target.

### 4. Workbench card rhythm

The toolbar, summary, table, and pagination footer now share a more deliberate spacing pattern and more coherent card treatment.
The summary tiles also gained lightweight iconography to improve scanning without introducing a redesign outside the agreed scope.

## Validation Expectation

The phase is considered correct when the following conditions hold:

- the table keeps showing current results while a paging, sort, or search refresh is in flight
- sortable headers clearly look interactive
- the active sorted column is visually easier to identify
- rows respond with a soft, readable hover treatment
- toolbar, summary, table, and footer feel more coherent as a single workbench
- existing backend pagination, sorting, search, and download behavior remain intact

## Risks

This phase intentionally avoids backend and contract changes.
The main implementation risk is visual overstatement, so the applied hover and active treatments are intentionally subtle.

## Conclusion

Phase 14.2.2.3 does not change what the billing workbench can do.
It changes how clearly and smoothly the surface communicates that behavior, which is exactly the right next step once the structural and backend-backed pieces are already stable.
