# Phase 14.3.2.3 — Payment Methods Surface Fine-Tuning & Residual Structural Decisions

## Objective

Close the remaining small structural decisions left after the Payment Methods boundary cleanup by making the shared `InfoCard` action contract less payment-specific and by documenting the conservative decision to keep barcode visualization out of the active flow for now.

## Initial Context

The ZIP validated after Phase 14.3.2.2 already confirmed that the main Payment Methods ownership problems had been solved:

- the dialog content already lived under `lib/features/payment_methods/presentation/overlays/`
- the feature already exposed `showPaymentMethodsDialog(...)` as its canonical launcher
- `dashboard_page.dart` no longer owned the popup route mechanics
- the feature remained informational, backend-driven, and external-payment oriented

That left two smaller but still real residual decisions visible in the codebase:

- `lib/shared/widgets/info_card.dart` still hardcoded `Icons.payment` in its generic action button
- `lib/widgets/barcode_widget.dart` still existed outside the modern shared/feature structure and still had no active use in the Payment Methods surface

## Problem Statement

Even after the boundary cleanup, the repository still contained a small semantic mismatch inside the shared widget layer.

`InfoCard` is a shared widget, but its action button contract still assumed a payment-specific icon. That made the widget less neutral than its actual role in the project.

At the same time, the existence of `barcode_widget.dart` could invite an unjustified scope expansion. The active Payment Methods surface in the ZIP still showed backend-provided payment data as text and copyable values, not as a rendered visual barcode.

The problem in this subphase was therefore not missing functionality. It was the need to close these residual decisions honestly without inventing a larger redesign.

## Scope

This subphase covers:

- adding an optional action icon contract to `InfoCard`
- keeping backward compatibility for existing `InfoCard` uses
- updating dashboard to use a more neutral informational icon for the Payment Methods action
- making an explicit non-integration decision about `barcode_widget.dart` based on real current usage
- documenting the resulting state in cumulative phase documentation

This subphase does not cover:

- barcode rendering integration
- in-app payment execution
- checkout semantics
- backend contract changes
- Payment Methods visual redesign
- new feature state or new presentation adapters

## Root Cause Analysis

The residual issues existed for understandable reasons:

- `InfoCard` originally served a dashboard case where the only action-oriented card was the payment-related one, so hardcoding `Icons.payment` was functionally convenient
- `barcode_widget.dart` likely represented an earlier or exploratory utility, but the active product surface never completed a real integration around it

Once Payment Methods gained its own feature boundary, these smaller mismatches became easier to see.

The right next step was not to invent more functionality, but to remove the semantic leak in `InfoCard` and to decide the barcode question conservatively using active usage as the source of truth.

## Files Affected

- `lib/shared/widgets/info_card.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`
- `docs/phase14_surface_normalization_billing_workbench_modernization.md`
- `docs/phase14_surface_normalization_billing_workbench_modernization_14_3_2_3_payment_methods_surface_fine_tuning_residual_structural_decisions.md`
- `docs/index.md`

## Implementation Characteristics

### 1. `InfoCard` action icon became configurable

`InfoCard` now accepts an optional `actionIcon`.

This means:

- the widget remains backward compatible for any existing callers
- the default behavior still falls back to `Icons.payment` when no explicit icon is provided
- the shared widget no longer hardcodes payment semantics as an unavoidable part of its contract

The change is intentionally small and local. It improves shared-widget neutrality without redesigning the card.

### 2. Dashboard now uses a more fitting action icon for the current Payment Methods meaning

The Payment Methods trigger on the dashboard now passes an explicit informational bank/account-style icon instead of inheriting the hardcoded payment icon implicitly.

That choice better reflects the real meaning of the feature in the current product state:

- it shows payment data
- it helps the user pay outside the platform
- it does not initiate an in-app payment execution flow

### 3. `barcode_widget.dart` was deliberately left out of the active flow

This subphase makes the residual barcode decision explicit:

- `barcode_widget.dart` remains outside the active Payment Methods surface
- it was not migrated into `shared/widgets`
- it was not imported into the dialog
- it was not used to render a barcode image

This was intentional. The ZIP still shows the current surface as a text-and-copy data display, and this phase avoids expanding scope beyond what the active product contract actually requires.

## Validation

The structural result after the change is:

- `InfoCard` supports an optional `actionIcon` parameter
- existing `InfoCard` usage stays compatible because the icon remains optional
- dashboard explicitly chooses the action icon for `Ver medios de pago`
- `barcode_widget.dart` remains unused and intentionally outside the active flow
- the Payment Methods surface remains informational, backend-driven, and external-payment oriented

## Release Impact

There is no backend impact and no release-process impact.

The change is local to presentation semantics and shared-widget neutrality. It reduces residual structural bias without changing product behavior.

## Risks

### Over-tuning a small surface

There is always a risk of spending too much effort on micro-polish. This was contained by keeping the implementation to one optional widget parameter and one explicit usage change.

### Premature barcode integration

A rendered barcode might look attractive, but introducing it without a stronger product requirement would expand the scope unnecessarily. This risk was avoided by keeping the barcode utility out of the active flow.

### Accidental semantic drift toward checkout

Anything that makes Payment Methods look more transactional could mislead future work. That risk was contained by keeping the feature informational and by choosing a clearer external-payment-data visual language.

## What it does NOT solve

This subphase does not solve:

- future in-app payment support
- visual barcode rendering in the dialog
- richer Payment Methods hierarchy or layout redesign
- future presentation adapters such as `PaymentMethodsViewData`
- any reinterpretation of backend-provided due date or payment rules

## Conclusion

Phase 14.3.2.3 closes the small but real residual decisions left after the main Payment Methods extraction and boundary cleanup work.

The repository now has:

- a cleaner shared-widget contract in `InfoCard`
- a more semantically accurate Payment Methods trigger icon
- an explicit, honest decision not to integrate barcode rendering yet
- a Payment Methods surface that remains aligned with its current real meaning: informational, backend-driven, and meant to support payment outside the app rather than in-app checkout

This leaves the repository ready for the formal closure step of the 14.3.2 line.
