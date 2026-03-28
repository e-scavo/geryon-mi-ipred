# 🧭 Phase 9.1 — Product Surface Inventory

## Objective

Document the real visible product surface of Mi IP·RED so that later UX-hardening work is based on explicit inventory rather than assumption.

## Initial Context

The ZIP confirms that the app already has working feature slices for:

- auth
- dashboard
- billing

The repository is functionally usable, but the visible surface is still heterogeneous across states and interaction patterns.

## Problem Statement

Without an explicit product-surface inventory, later UI/UX hardening would risk:

- applying fixes inconsistently
- improving the wrong surfaces first
- mixing feature-local symptoms with shared product-surface concerns

## Scope

This inventory covers:

- auth surface
- dashboard surface
- billing surface
- shared loading / error / empty / retry behavior

It does not cover:

- backend protocol redesign
- runtime policy redesign
- feature expansion
- visual rebranding

## Root Cause Analysis

The product grew feature by feature.

That is technically acceptable, but it leaves behind uneven visible behavior because each feature solved its own state presentation independently.

## Files Affected

The primary product-surface inventory concerns:

- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/models/LoadingGeneric/widget.dart`
- `lib/pages/CatchMainScreen/widget.dart`
- `lib/shared/widgets/info_card.dart`
- `lib/shared/layouts/frame_with_scroll.dart`

## Implementation Characteristics

### Auth surface

The login screen already separates bootstrap and submit state in controller terms, but the visible feedback is still minimal and partially implicit.

### Dashboard surface

The dashboard currently falls back to a generic loading surface when `activeClient` is unresolved, which hides the distinction between loading, empty, and inconsistent state.

### Billing surface

Billing already has the strongest technical state handling, but its visible surfaces are still mixed between generic loading, feature-local rendering, and a system-oriented catch surface.

### Shared surface inconsistency

The current ZIP shows multiple visible patterns for equivalent states:

- loading spinner inside a button
- generic centered spinner
- `LoadingGeneric`
- `SnackBar` for auth error
- `CatchMainScreen` for billing feature failure

That proves the need for a shared consistency baseline.

## Validation

The inventory is considered valid if it accurately captures the main visible state classes:

- loading
- error
- empty
- retry
- ready data

The current ZIP justifies that inventory.

## Release Impact

This inventory has no direct runtime impact.

It establishes the baseline required for safe UX hardening.

## Risks

If this inventory is skipped or misread, later work may:

- normalize the wrong surfaces
- overuse technical error surfaces
- fail to distinguish empty vs error states
- introduce more inconsistency while trying to fix inconsistency

## What it does NOT solve

This document does not itself:

- add reusable widgets
- normalize any feature
- modify any screen
- resolve state-surface heterogeneity

It only inventories the problem space.

## Conclusion

Phase 9.1 establishes that the next real repository concern is visible product consistency, not structure and not runtime ownership.