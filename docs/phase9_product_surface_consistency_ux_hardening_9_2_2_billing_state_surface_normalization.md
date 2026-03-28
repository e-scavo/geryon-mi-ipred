# 💳 Phase 9.2.2 — Billing State Surface Normalization

## Objective

Normalize the visible billing feature surface so that Billing explicitly and consistently presents:

- loading
- recoverable feature error
- empty state
- ready data

using the shared state-surface contract introduced in Phase 9.2.1.

## Initial Context

The current ZIP confirms the following baseline before this step:

- Phase 7 closed
- Phase 8 closed
- Phase 9 opened as product surface consistency and UX hardening
- Phase 9.1 completed as product surface inventory
- Phase 9.2.1 completed as shared state surface contract foundation
- Billing already had a relatively mature controller and feature-state model
- Billing already had:
  - controlled reload behavior
  - active-client change awareness
  - failure-boundary awareness
  - a dedicated feature controller

The remaining problem was therefore no longer technical state ownership.

It was visible surface inconsistency.

## Problem Statement

Billing still mixed different categories of visible surfaces:

- a shared loading contract through `LoadingGeneric`
- a technical/system-oriented error surface through `CatchMainScreen`
- an implicit empty state buried inside the table widget
- a placeholder header that still looked provisional rather than productized

That meant Billing was technically mature but not yet normalized as a product feature.

## Scope

This step includes:

- replacing recoverable feature error rendering with `FeatureErrorState`
- elevating empty-state rendering to Billing feature level with `FeatureEmptyState`
- keeping loading aligned with the shared state contract
- replacing the temporary Billing header placeholder with a stable feature header
- adding minimal BillingController helpers for feature-surface semantics

This step does not include:

- redesigning table layout
- changing billing runtime ownership
- changing `ServiceProvider`
- changing navigation
- changing voucher download semantics
- redesigning the full product visual language

## Root Cause Analysis

Billing evolved correctly through structural and runtime-hardening phases, but its visible surface still reflected mixed historical solutions:

- technical failure rendering
- internal table-level empty handling
- temporary placeholder UI
- no explicit surface-level product contract for all user-visible states

The repository therefore needed Billing to become the first concrete feature adopter of the shared Phase 9.2.1 state-surface contract.

## Files Affected

This step updates:

- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`

This step relies on previously introduced shared widgets:

- `lib/shared/widgets/feature_loading_state.dart`
- `lib/shared/widgets/feature_error_state.dart`
- `lib/shared/widgets/feature_empty_state.dart`
- `lib/models/LoadingGeneric/widget.dart`

This step also updates:

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`

## Implementation Characteristics

### 1. Billing remains controller-owned

Billing state interpretation remains centered in `BillingController`.

The widget does not take ownership of business logic or runtime decisions.

### 2. Shared state surfaces are now adopted concretely

Billing now uses the shared contract through:

- `LoadingGeneric` for loading
- `FeatureErrorState` for recoverable feature errors
- `FeatureEmptyState` for explicit no-data state

### 3. Recoverable feature errors are no longer rendered as system crashes

`CatchMainScreen` remains available for unexpected rendering/runtime-level failure in the outer build catch.

It is no longer the primary surface for normal recoverable Billing feature errors.

### 4. Empty state is now explicit at feature level

The feature now decides “this section is empty” before handing control to the table.

That avoids burying product-surface semantics inside a lower-level rendering widget.

### 5. Header is now productized

The placeholder header is replaced with a stable, contextual section header that communicates the billing type and its purpose more clearly.

## Validation

This step is considered valid if all of the following remain true:

- Billing still reloads correctly on client changes
- Billing still loads data through the existing controller path
- recoverable load failures show a feature-level error surface
- the feature exposes explicit retry
- empty data produces an explicit empty-state surface
- data-ready state still renders the table
- no architecture change is introduced

## Release Impact

This step improves:

- visible consistency
- clarity of Billing feature states
- perceived product quality
- retry discoverability

It does so without changing runtime ownership or backend contracts.

## Risks

If implemented incorrectly, this step could:

- duplicate empty-state behavior
- move too much presentation logic into the widget
- collapse feature-local and system-level failures into the same surface
- overextend the scope into redesign

The current implementation avoids those risks by keeping controller helpers narrow and presentation-only.

## What it does NOT solve

This step does not yet normalize:

- Dashboard
- Auth
- cross-feature interaction consistency in full
- responsive polish across the entire app
- download-progress feedback semantics

It only normalizes Billing as the first real feature adopter of the shared state-surface contract.

## Conclusion

Phase 9.2.2 is the correct next implementation step after Phase 9.2.1.

Billing is now the first feature that explicitly behaves like a normalized product surface rather than a technically correct but visually mixed feature.