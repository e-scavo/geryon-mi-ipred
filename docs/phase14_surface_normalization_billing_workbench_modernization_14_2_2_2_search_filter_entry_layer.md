# Phase 14.2.2.2 — Search & Filter Entry Layer

## Objective

Add the first useful search-and-filter entry layer to the billing workbench without breaking the backend pagination, backend sorting, stabilized width behavior, horizontal scroll access, or voucher download action already validated in the previous subphases.

## Initial Context

At the start of this subphase, billing already supported:

- backend pagination through `Offset` and `PageSize`
- backend sorting through `SortField` and `SortAsc`
- a stabilized workbench layout with correct vertical flow
- a harmonized table width that follows the workbench viewport
- direct row download actions

What was still missing was a practical way to reduce the result set from the workbench itself.

The current ZIP also confirms something important about the real request contract:

- `HeaderParamsRequest` already supports `Search`
- the billing controller was still forcing `search = ""`
- no equally explicit billing-specific date-range request contract was confirmed in this ZIP for the same request flow

That contract reality matters because the phase must remain honest and must not fake a backend capability that is not proven by the current source of truth.

## Problem Statement

Without a search entry layer, the user still had to move across many pages to find a specific voucher even though the workbench was already paginated and sortable.

The missing capability was not structural anymore.
It was operational:

- there was no visible search entry in the billing toolbar
- the backend request was not receiving the real search string
- the summary could not reflect active search context
- empty states could not differentiate between “there are no vouchers” and “there are no results for this search”

## Scope

Phase 14.2.2.2 includes:

- wiring billing search text from the UI owner to the backend request header
- adding a search field, explicit search action, and clear action in the billing toolbar
- integrating search state into the billing workbench summary
- making the billing empty state contextual when search is active
- resetting the current page to `1` when a new search is applied or cleared

Phase 14.2.2.2 does not include:

- fake local filtering
- fake backend date-range filtering without a verified contract
- multi-filter chips
- export actions
- multi-select
- bulk operations

## Files Affected

- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/features/billing/presentation/widgets/billing_workbench.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_toolbar.dart`
- `lib/features/billing/presentation/widgets/billing_workbench_summary.dart`
- `docs/index.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_2_2_2_search_filter_entry_layer.md`

## Implementation Details

### 1. Query-state ownership

`BillingWidget` now owns the billing search state together with the already existing page, page-size, and sort state. That keeps a single source of truth for the active query being sent to backend.

### 2. Backend request wiring

`BillingController` now accepts `searchText` in the billing reload flow and forwards the normalized value to `HeaderParamsRequest.search`.

This is the part of the phase that is fully backed by the current ZIP contract.

### 3. Toolbar entry layer

The billing toolbar now contains:

- a search field
- a search action
- a clear action when search is active
- the existing rows-per-page selector
- the existing refresh action

The toolbar remains compact-friendly and does not reopen the broader billing layout work already stabilized in prior subphases.

### 4. Contextual summary and empty state

When a search is active:

- the summary reflects that active search context
- the empty state no longer behaves like a generic “no vouchers available” state
- the user gets a contextual message that no results were found for the current search and is offered a direct way to clear it

### 5. Honest handling of date-range filtering

The original phase proposal considered a date-range entry layer as well. After reviewing the current ZIP, explicit support for billing date-range request parameters in this exact flow could not be confirmed with the same confidence as `Search`.

Because of that, this implementation does **not** fake date-range filtering.
That part remains intentionally deferred until the backend contract is explicitly validated in a later subphase.

## Validation Expectations

The phase is considered correct when the following conditions hold:

- searching from the toolbar triggers a new backend request
- the backend request carries the real `Search` value
- applying search resets the page to `1`
- clearing search resets the page to `1`
- sorting and pagination continue to work together with search
- horizontal scroll and row download remain unaffected
- empty states distinguish between generic emptiness and search-without-results

## Risks

The phase is intentionally low risk because it extends an already stabilized owner/controller flow instead of redesigning it.

The only important limitation is deliberate:

- date-range filtering is not claimed as implemented because the current ZIP does not prove that backend contract with the same clarity as it proves `Search`

## Conclusion

Phase 14.2.2.2 adds the first real discovery layer to billing and does so without breaking the validated workbench baseline.
The resulting implementation is useful, honest, and aligned with the actual source of truth in the ZIP: search is fully wired, while date-range filtering remains deferred until its backend contract is explicitly confirmed.
