# Phase X — Task 013 — Billing Document Download Overlay Theme and Responsive Normalization

## Objective

Normalize the billing document download overlay after the DBVersion 10 functional migration, without changing the already-working backend download flow.

The supplied screenshot showed three concrete presentation defects:

- the popup expanded to almost the entire available viewport instead of remaining a bounded dialog
- a development `Placeholder` remained visible as `Header for DESCARGA DE COMPROBANTES`
- the body mixed hard-coded colors, typography, button styling, fixed heights, and legacy spacing instead of using the application Material 3 theme

## Root Cause

`ScreenPoPUpCommonDownloadLocallyScreen` calculated an `effectiveWidth` and `effectiveHeight`, but those values were only passed as ordinary widget properties. They did not actually constrain the child in the route layout.

The nested `CommonDownloadLocallyScreen` therefore received the full loose viewport constraints from `Center`, and `AppOverlayPanel` expanded to those constraints. This explains the large blank vertical surface visible in the supplied screenshot.

The same canonical billing overlay also still contained a temporary `Placeholder`, a fixed 50-pixel information area, `Colors.redAccent`, `Colors.white`, `Colors.black54`, a legacy `ElevatedButton.styleFrom`, and fixed font sizing.

## Implementation

### 1. The popup route now owns real dialog bounds

The route now wraps the canonical download screen in a `SizedBox` whose dimensions are derived from the current viewport and capped at:

- 520 px width
- 420 px height

The result is a real modal boundary rather than advisory width/height values passed to the child.

`SafeArea` and route padding remain in place, so reduced-height windows can shrink the modal instead of overflowing the viewport.

### 2. Development placeholder removed

The temporary `Header for ...` placeholder was removed completely.

The overlay title bar remains the canonical title surface and is initialized synchronously from the requested operation, avoiding a transient placeholder title during startup.

### 3. Download status body rebuilt with Material 3 semantics

The body now uses the active application theme for:

- primary/error/status colors
- surface and outline colors
- typography
- filled primary actions
- progress indicators
- status and detail containers

The download surface now presents:

- a compact progress indicator while processing
- a normalized operation title
- an optional `n de total` status
- a bounded linear progress indicator
- voucher/client information in a themed information surface
- a themed error surface when the operation reports an error
- a full-width `FilledButton.icon` only when a manual action is appropriate

The same component continues to support the existing send-email request variant.

### 4. Responsive vertical behavior

The body is now scrollable inside the bounded dialog.

This prevents future overflow when:

- the browser viewport is short
- DevTools reduces available vertical space
- accessibility text scaling increases content height
- an error message requires additional vertical space

### 5. Shared overlay panel normalized

`AppOverlayPanel` was already the shared owner used by billing download and payment-method overlays, so its remaining hard-coded surface styling was normalized instead of creating a second download-only panel.

It now derives:

- body/surface color from `ColorScheme.surface`
- borders from `ColorScheme.outlineVariant`
- title typography from `TextTheme`
- title foreground from the active title color/theme contract
- shadow color from the active theme
- default title background from `ColorScheme.primary`

Existing callers that explicitly provide a title background remain compatible.

### 6. Related lifecycle/progress cleanup

The progress controller no longer registers a redundant listener that called `setState()` for values already updated inside state mutations.

All scroll/progress controllers are now disposed by the widget.

The delayed completion callback verifies `mounted` before calling `setState()`, and the progress value now represents completed work instead of displaying 100% at the start of a one-item download.

## Functional Contract Preserved

This task does not change:

- DBVersion 10 request construction
- `GenerateAndDownloadPDFFromVoucher`
- request tables/action routing
- file saving
- voucher selection
- backend response handling
- automatic close after successful completion

The change is intentionally limited to presentation, modal sizing, progress semantics, and related widget lifecycle safety.

## Files Modified

- `lib/features/billing/presentation/overlays/billing_document_download_dialog.dart`
- `lib/shared/overlays/app_overlay_panel.dart`
- `docs/tasks/013_billing_document_download_overlay_theme_responsive_normalization.md`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation

Static validation against the supplied Task 012 ZIP:

- canonical billing download route traced from `BillingWorkbench._downloadVoucher()`
- legacy `models/CommonDownloadLocally/widget.dart` confirmed not to be imported by the active billing feature
- active `billing_document_download_dialog_route.dart` confirmed to export the feature-owned overlay
- temporary `Placeholder` removed from the active surface
- legacy hard-coded download body button/color/text styling removed from the active surface
- route now applies actual width and height constraints
- bracket/structure balance verified after modification

The environment does not provide the Flutter/Dart SDK, so `dart format`, `dart analyze`, and Flutter widget tests could not be executed here.

## Status

Completed.
