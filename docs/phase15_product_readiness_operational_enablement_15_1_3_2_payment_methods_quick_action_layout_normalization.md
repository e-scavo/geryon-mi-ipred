# Phase 15.1.3.2 — Payment Methods Quick Action Layout Normalization

## Objective

Normalize the action affordance and quick-action presentation of the Payment Methods surface after the initial external action wiring introduced in Phase 15.1.3.1.

This subphase does not redesign the dialog, does not introduce payment execution, and does not modify the backend contract. Its purpose is narrower and strictly phase-aligned: to make the already-enabled operational actions visually explicit, coherent, and easier to use.

## Initial Context

Before this subphase, the Payment Methods dialog already had the following characteristics:

- overlay presentation already normalized in previous phases
- backend-driven payment data rendering
- copy-oriented per-field interaction through `CopyableListTile`
- recently introduced support for:
  - copying a payment summary
  - attempting to open an external payment-related URL
  - showing fallback feedback when the URL is not available

That meant the dialog had already started to become operational, but its quick actions still behaved more like appended controls than like a normalized action zone.

## Problem Statement

The functional gap from Phase 15.1.3.1 was no longer about capability. It was about clarity.

Even with the newly added actions, the surface still needed:

- a clearer quick-action grouping
- stronger action affordance
- more explicit distinction between actionable controls and informational content
- better consistency with the operational direction introduced in Billing during Phase 15.1.2

Without this normalization step, the feature would technically work, but the product surface would still read as primarily informational.

## Scope

This subphase includes:

- extracting the quick actions into a dedicated visual card inside the dialog body
- clarifying the action intent of the surface
- keeping copy and external-open actions grouped and explicit
- visually reflecting whether an external link exists
- maintaining the rest of the dialog layout unchanged

This subphase does not include:

- native share integration
- payment intent modeling
- backend changes
- new payment method entities
- redesign of the full dialog structure
- removal or replacement of `CopyableListTile`

## Root Cause Analysis

The Payment Methods dialog historically served as an informational overlay that displayed out-of-platform payment instructions and references.

That baseline was valid and aligned with earlier phases. However, once Product Readiness began, the surface needed to evolve from a passive data presentation panel into an operational support panel.

Phase 15.1.3.1 added the missing action capability. The remaining gap was that those actions still lacked a normalized visual anchor.

The root cause was therefore not architectural and not data-related. It was presentational:

- actions existed
- actions worked
- actions were not yet framed as a clear quick-action layer

## Files Affected

### Primary UI file
- `lib/features/payment_methods/presentation/overlays/payment_methods_dialog.dart`

### Reused shared operational layer
- `lib/shared/actions/copy_action.dart`
- `lib/shared/actions/external_action.dart`

## Implementation Characteristics

### 1. Quick actions move into a dedicated operational card

Instead of keeping the actions as loose controls in the header area, the dialog now exposes them inside a dedicated quick-action block placed at the top of the body content.

This improves clarity without changing the dialog’s identity.

### 2. The surface remains informational first, but operationally enabled

The payment data is still shown through the same validated field layout. The dialog does not stop being a payment-information surface.

What changes is that the most relevant operational entry points are now surfaced before the detailed fields.

### 3. External availability is reflected in the button itself

The external action affordance now changes its icon and label according to availability:

- when a link exists, the control communicates that it can open an external destination
- when no link exists, the control still remains visible but clearly communicates that no external link is available

This avoids misleading silent failure.

### 4. No contract assumptions are introduced beyond the current safe fallback approach

The implementation still reads optional URL-like values conservatively from the serialized user data shape without hard-binding the dialog to a newly invented typed backend contract.

This preserves compatibility with the real project state while allowing later tightening if the model is formalized.

### 5. No structural refactor is introduced

The dialog still uses:

- `AppOverlayPanel`
- the same popup route
- the same field rendering sequence
- the same backend-driven source object

The implementation is additive and local.

## Validation

This subphase is considered valid when all of the following are true:

- the dialog still opens exactly as before
- the payment fields remain visible and copyable
- the quick-action block appears before the field list
- the summary copy action works and shows feedback
- the external action opens a link when one exists
- the fallback message still appears when no link exists
- responsive behavior remains stable within the current overlay size constraints

## Release Impact

The release impact is intentionally low-risk but product-visible.

User-facing effect:

- the dialog now reads as an actionable operational surface
- the most useful actions are easier to discover
- the surface better matches the Product Readiness direction of Phase 15

Engineering effect:

- quick-action presentation is normalized without introducing a new component hierarchy
- the surface is better prepared for later Phase 15.2 and Phase 16 payment-related evolution

## Risks

The risks are limited:

- the extra action card slightly increases visual density
- if the backend later formalizes different URL keys, the fallback extraction strategy may need tightening
- users may interpret the external action as a real payment flow even though it is only an external redirect capability

These risks are acceptable within the current phase because:

- no real payment is being promised
- feedback remains explicit
- the interaction remains safely bounded to existing data and external opening behavior

## What it does NOT solve

This subphase does not solve:

- payment execution
- in-app payment flows
- payment status synchronization
- native share support
- typed modeling of payment links
- telemetry or observability for action usage

Those belong to later work.

## Conclusion

Phase 15.1.3.2 completes the visual normalization of the Payment Methods action layer after the functional groundwork laid in Phase 15.1.3.1.

The surface now remains faithful to its original role while clearly exposing the operational actions that matter most to the user, without redesigning the dialog or introducing architectural change.