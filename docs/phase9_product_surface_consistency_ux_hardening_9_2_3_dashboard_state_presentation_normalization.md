# 🖥️ Phase 9.2.3 — Dashboard State Presentation Normalization

## Objective

Normalize the visible dashboard feature surface so that Dashboard explicitly and consistently represents:

- loading
- empty operational state
- invalid operational context
- ready state

without changing architecture, runtime ownership, or backend flow.

## Initial Context

The repository baseline before this step already confirmed:

- Phase 7 closed
- Phase 8 closed
- Phase 9 opened as product surface consistency and UX hardening
- Phase 9.2.1 introduced the shared state-surface contract
- Phase 9.2.2 applied that contract to Billing

Dashboard already had a dedicated controller and a dedicated page, but its visible state handling was still too binary and therefore inconsistent with the active Phase 9 baseline.

## Problem Statement

Dashboard previously collapsed multiple distinct operational states into a single loading spinner by relying on an overly simple condition:

- no resolved active client
- therefore show spinner

That meant the feature did not distinguish between:

- real loading
- no available clients
- invalid active operational context
- ready state

This made the dashboard feel ambiguous and visually inconsistent when compared to the newer Billing surface behavior.

## Scope

This step includes:

- introducing explicit dashboard surface-state classification
- moving dashboard surface interpretation into `DashboardController`
- rendering shared state surfaces in `DashboardPage`
- keeping `_DashboardContent` reserved for the ready state
- improving client-selector affordance based on resolved state

This step does not include:

- redesigning the dashboard feature
- changing runtime ownership
- changing `ServiceProvider`
- changing backend contracts
- changing billing logic
- introducing a new global UI framework

## Root Cause Analysis

Dashboard was structurally correct but visually under-classified.

The controller resolved active client information, but it did not expose a real feature-surface contract.

That left the widget to interpret too much through a null check, which collapsed multiple operational meanings into one visible result.

The correct fix is therefore not redesign.

It is explicit state-surface classification.

## Files Affected

This step updates:

- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`

This step relies on the existing shared widgets introduced earlier:

- `lib/shared/widgets/feature_loading_state.dart`
- `lib/shared/widgets/feature_error_state.dart`
- `lib/shared/widgets/feature_empty_state.dart`
- `lib/models/LoadingGeneric/widget.dart`

This step also updates:

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`

## Implementation Characteristics

### 1. Dashboard controller now owns surface classification

`DashboardController` now resolves a feature-surface classification instead of only exposing raw client values.

### 2. Dashboard page now renders explicit shared surfaces

The page now distinguishes between:

- loading
- empty
- invalid operational context
- ready

using shared presentation widgets where appropriate.

### 3. Ready content remains isolated

`_DashboardContent` remains reserved for the ready state only.

It does not absorb loading, empty, or invalid-context logic.

### 4. Client selector now behaves more predictably

The selector remains present in the app bar, but its affordance now reflects whether it is actually usable.

## Validation

This step is considered valid if all of the following remain true:

- Dashboard still compiles and renders correctly
- ready state still shows the main dashboard content
- Billing remains embedded and stable inside ready content
- missing available clients no longer looks like generic loading
- invalid operational context no longer looks like generic loading
- the selector does not imply interactivity when there are no alternatives
- no architecture change is introduced

## Release Impact

This step improves:

- dashboard clarity
- visible product consistency
- operational-state predictability
- coherence with the Billing normalization introduced in Phase 9.2.2

It does so without changing runtime ownership or backend behavior.

## Risks

If implemented incorrectly, this step could:

- over-model dashboard state
- move too much logic into widgets
- blur the distinction between empty and invalid context
- overreach into redesign

The current implementation avoids those risks by keeping state classification narrow and controller-owned.

## What it does NOT solve

This step does not yet normalize:

- Auth
- full responsive polish across all features
- all secondary dashboard interactions
- deeper product-level visual refinement

It only normalizes the main Dashboard state presentation contract.

## Conclusion

Phase 9.2.3 is the correct next step after Phase 9.2.2.

Dashboard now behaves as an explicitly classified product surface instead of a mostly binary screen with a generic spinner fallback.