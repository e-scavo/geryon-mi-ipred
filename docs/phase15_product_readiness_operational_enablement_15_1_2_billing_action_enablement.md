# Phase 15.1.2 — Billing Action Enablement

## Objective

Extend the already stabilized Billing surface so it behaves as an operational customer workbench rather than as a read-only invoice list.

This subphase does not redesign Billing, replace its data model, or alter the backend contract. It only enables additional real user actions on top of the already validated Phase 14 and Phase 15.1.1 baseline.

The concrete target is to keep the existing download flow intact while adding two additional action primitives directly where the user already works:

- copy voucher-related information
- prepare voucher sharing behavior through the newly introduced shared action layer

## Initial Context

The ZIP validated before this subphase confirms the following real baseline:

- Phase 14 is already closed
- shared action primitives were already introduced in Phase 15.1.1
- `payment_methods` already exposes actionable copy behavior through a dedicated UI pattern
- `billing` already exposes a real download action through the existing voucher download overlay flow
- the Billing workbench already includes:
  - table view
  - sort
  - pagination
  - search
  - interaction refresh state
  - overlay-based download initiation

That means Billing was already structurally stable and visually consistent, but still only partially operational.

## Problem Statement

Before this subphase, Billing rows exposed only one direct action:

- download

That left several practical use cases unresolved:

- the user could not copy voucher information directly from the Billing workbench
- the user could not trigger any forward-looking sharing action from the same row
- Billing still behaved more like a visual ledger than like an operational customer panel

This was no longer an architecture problem. It was an action-enablement gap.

## Scope

This subphase includes:

- extending the Billing action column from a single download affordance to a small multi-action group
- reusing the shared action layer introduced in Phase 15.1.1
- adding copy behavior for voucher summary data
- wiring a share placeholder using the shared action abstraction
- preserving the existing download flow exactly as it already works

This subphase does not include:

- backend changes
- file-sharing integration packages
- redesign of Billing layout
- invoice preview
- bulk actions
- changes to Payment Methods or Dashboard

## Root Cause Analysis

The Billing surface had already been normalized during Phase 14 around data presentation and interaction rhythm. That work made the table usable and visually coherent, but it intentionally did not attempt to transform Billing into an action hub.

Once Phase 15 started, the correct next step was not to refactor Billing again. The correct step was to activate already justified user operations on the stable row model.

The root cause of the gap was therefore simple:

- Billing had a stable table
- Billing had one real backend-driven action
- Billing did not yet reuse the new shared action primitives for anything else

The solution had to remain additive.

## Files Affected

### UI action wiring
- `lib/features/billing/presentation/widgets/billing_workbench.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_table.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_row.dart`

### Reused shared action layer
- `lib/shared/actions/copy_action.dart`
- `lib/shared/actions/share_action.dart`

## Implementation Characteristics

### 1. Action column evolves without changing the table contract

The Billing table still renders the same dataset and keeps the same overall rhythm.

The only intentional surface-level adjustment is that the former single `download` action column becomes a broader `actions` column, allowing the row to expose a small grouped set of operational affordances:

- download
- copy
- share

This remains local to Billing and does not introduce new table abstractions.

### 2. Download remains the canonical real action

The existing download flow already routes through the established overlay/process path.

That flow is preserved and not replaced.

This matters because the download action is already backend-driven and already aligned with the project’s operational constraints.

### 3. Copy is implemented as a reusable summary-level action

The new copy action does not attempt to serialize the raw row or the backend payload.

Instead, it builds a normalized text summary from the row’s already visible billing data, including:

- voucher number
- date
- amount
- voucher class

This gives the user a practical clipboard result while staying detached from backend internals.

### 4. Share is intentionally prepared, not fully implemented

The share action is wired to the shared `ShareAction` abstraction added in Phase 15.1.1.

At this stage, that abstraction still resolves to a safe placeholder message rather than to native platform sharing.

That is intentional and phase-correct because Phase 15.1.2 is about enabling the action surface now without introducing new runtime/package complexity.

### 5. No architectural deviation is introduced

The implementation remains faithful to the already stabilized repository boundaries:

- feature-based structure remains unchanged
- Billing keeps its existing widget composition
- no controller/service refactor is introduced
- no cross-feature coupling is added
- no new backend-facing models are created

## Validation

This subphase is considered correct when all of the following are true:

- Billing still loads exactly as before
- sorting, search, pagination, and refresh continue to behave exactly as before
- clicking download still opens the existing voucher download process
- clicking copy copies a readable voucher summary and shows feedback
- clicking share triggers the existing shared placeholder feedback
- no backend contract changes are required
- no other surface regresses

## Release Impact

The release impact is low and intentionally localized.

Visible product impact:

- Billing becomes more operational
- users gain direct clipboard utility from each row
- the UI now exposes the next justified operational affordance set without redesign

Engineering impact:

- reuse of the shared action layer becomes real rather than purely preparatory
- future Phase 15.x or Phase 16 work can later replace the share placeholder without reworking the Billing row model again

## Risks

The risks are limited but real:

- the wider action column slightly increases horizontal demand in narrow layouts
- users may assume sharing is already fully implemented because the icon is visible
- poorly normalized voucher text could reduce the usefulness of the copy action if backend display values are inconsistent

These risks are acceptable because:

- the Billing surface already supports horizontal overflow correctly
- the share layer explicitly communicates that it is not yet fully available
- the copied content is intentionally derived from visible row data rather than from hidden backend fields

## What it does NOT solve

This subphase does not solve:

- native share integration
- batch invoice operations
- payment execution
- invoice preview
- smarter formatting of voucher export text
- post-download success telemetry
- billing-level observability

Those belong to later subphases.

## Conclusion

Phase 15.1.2 completes the first real operational lift inside Billing without reopening the structural work already closed in earlier phases.

Billing now preserves its validated download behavior while gaining two additional action entry points that are phase-correct, additive, and consistent with the new shared action layer.

This makes the surface meaningfully more operational while keeping the implementation narrow, safe, and aligned with the real ZIP baseline.