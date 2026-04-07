# Phase 14.3.2.2 — Payment Methods Dashboard Integration Boundary Cleanup

## Objective

Complete the structural normalization started in Phase 14.3.2.1 by removing the remaining Payment Methods popup ownership from `dashboard_page.dart` and consolidating the canonical dialog-opening entry point inside the `payment_methods` feature itself.

## Initial Context

The ZIP validated after Phase 14.3.2.1 already confirmed an important first extraction cut:

- the Payment Methods overlay content had been moved out of `dashboard_page.dart`
- the project already had `lib/features/payment_methods/presentation/overlays/payment_methods_dialog.dart`
- the project already had `lib/features/payment_methods/presentation/overlays/payment_methods_dialog_route.dart`
- the surface still remained informational and backend-driven

However, the boundary was not fully normalized yet.

The route file still behaved only as a re-export, while `dashboard_page.dart` still kept:

- a local `_showPaymentDialog(...)` helper
- direct ownership of `Navigator.of(context).push(...)`
- direct knowledge of `ScreenPoPUpPaymentMethodsDialog`

That meant the overlay body had been extracted, but the dashboard still remained a co-owner of how the feature was opened.

## Problem Statement

A normalized feature boundary is not complete if the host feature keeps the opening mechanics and direct route knowledge of the extracted surface.

Leaving that state in place would preserve three forms of coupling:

- dashboard would still know the concrete popup route class used by Payment Methods
- dashboard would still own the navigation call that opens the feature
- the `payment_methods` route file would still not provide a canonical, feature-owned opening API

The problem in this subphase was therefore not visual and not behavioral.
It was the remaining integration-boundary leakage between dashboard and Payment Methods.

## Scope

This subphase covers:

- replacing the temporary route re-export with a canonical launcher function
- removing `_showPaymentDialog(...)` from `dashboard_page.dart`
- removing direct `Navigator.of(context).push(...)` ownership from dashboard for this surface
- keeping the visible dialog content unchanged
- keeping the backend contract unchanged
- preserving the current external-payment, informational semantics

This subphase does not cover:

- payment in-app
- checkout or transaction states
- backend contract changes
- new Riverpod state
- visual redesign of the dialog
- barcode rendering changes
- reinterpretation of due-date business rules

## Root Cause Analysis

Phase 14.3.2.1 intentionally prioritized a safe first extraction cut.
That first cut moved the overlay content to its canonical feature location, but it left a temporary integration compromise behind:

- content ownership moved
- route ownership did not move completely

This happened because the safest intermediate step was to extract the dialog first and keep the trigger path working before finishing the boundary cleanup.

After validating that first extraction, the next justified step was to let the feature own its launcher API too.

## Files Affected

- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/payment_methods/presentation/overlays/payment_methods_dialog_route.dart`
- `docs/phase14_surface_normalization_billing_workbench_modernization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_3_2_2_payment_methods_dashboard_integration_boundary_cleanup.md`
- `docs/index.md`

## Implementation Characteristics

### 1. Feature-owned launcher introduced

`payment_methods_dialog_route.dart` was converted from a plain export into a canonical launcher entry point.

The file now exposes `showPaymentMethodsDialog(...)`, which:

- receives `BuildContext`
- receives the backend-provided `ServiceProviderLoginDataUserMessageModel`
- owns `Navigator.of(context).push(...)`
- owns the use of `ScreenPoPUpPaymentMethodsDialog`

This change makes the feature responsible for how its own overlay is opened.

### 2. Dashboard local helper removed

`dashboard_page.dart` no longer keeps `_showPaymentDialog(...)`.

That removal means dashboard no longer keeps a feature-specific navigation helper for Payment Methods.

### 3. Direct route knowledge removed from dashboard

The `InfoCard` action in dashboard now delegates directly to the feature-owned launcher:

- dashboard remains the trigger surface for the button
- dashboard stops knowing the concrete popup route class
- dashboard stops owning the navigation mechanics for this feature

### 4. Visible behavior preserved

The visible surface remains intentionally unchanged in this subphase:

- the button still says `Ver medios de pago`
- the same backend-driven data is shown
- the feature is still informational only
- payment still happens outside the app

## Validation

The structural result after the change is:

- `dashboard_page.dart` no longer contains `_showPaymentDialog(...)`
- `dashboard_page.dart` no longer pushes `ScreenPoPUpPaymentMethodsDialog` directly
- `payment_methods_dialog_route.dart` now provides the canonical launcher API
- overlay content ownership remains in `payment_methods_dialog.dart`
- the Payment Methods feature now owns both the overlay and the opening entry point used by dashboard

## Release Impact

There is no release-process impact and no backend impact.

The change is structural and local to feature ownership.
It reduces integration coupling and makes future Payment Methods surface work safer without changing the current product meaning of the feature.

## Risks

### Over-normalizing too early

There is always a risk of creating more abstraction than the current surface needs.
That risk was contained by introducing only one canonical launcher function instead of adding new state or new intermediate models.

### Accidental semantic drift toward payment in-app

The Payment Methods name could encourage future work to behave as though the app already supports real payment execution.
This subphase explicitly avoids that.
The resulting structure still represents a data-display surface for out-of-app payment.

### Unnecessary visual churn

Changing the integration boundary could have become an excuse to restyle the dialog.
That did not happen here.
The visible surface remained intentionally stable.

## What it does NOT solve

This subphase does not solve:

- future in-app payment support
- barcode visualization decisions
- richer Payment Methods visual hierarchy
- generic action-icon normalization in `InfoCard`
- possible future presentation adapters for Payment Methods data

Those concerns remain outside the justified scope of 14.3.2.2.

## Conclusion

Phase 14.3.2.2 closes the remaining integration-boundary gap left after the first Payment Methods extraction cut.

The project now has a cleaner and more truthful ownership line:

- dashboard triggers the feature
- Payment Methods owns how its surface is opened
- the overlay content remains feature-local
- the feature remains informational, backend-driven, and oriented to external payment rather than in-app checkout

This leaves the repository in a correct state for any later fine-tuning work without reintroducing dashboard-level coupling.
