# Phase X — Task 010 — Login Vertical Viewport Overflow Stabilization

## Objective

Correct the login layout overflow that appears when a validation or authentication error expands the login card inside a reduced vertical viewport, such as a web browser with DevTools docked.

## Confirmed Root Cause

The login surface was vertically centered inside a fixed `Column` with external padding. Its content was allowed to grow when `FeatureErrorState` became visible, but the page had no vertical scrolling boundary.

On a normal viewport the complete card fit correctly. On a reduced-height viewport, the same card plus the error state and action exceeded the available height and Flutter reported a bottom overflow.

The failure was therefore presentation-only. It was not caused by login state, validation, route ownership, or ServiceProvider recovery.

## Implemented Correction

### Scrollable viewport contract

The login body now uses:

- `SafeArea` to respect platform insets;
- `LayoutBuilder` to derive the real available viewport;
- `SingleChildScrollView` as the vertical overflow boundary;
- a minimum-height constraint so the card remains centered when it fits;
- natural top-to-bottom scrolling when the card grows beyond the viewport.

This keeps the login centered on normal screens without sacrificing access to the submit action on short screens.

### Compact responsive presentation

A compact presentation is selected for narrow or reduced-height viewports. It adjusts:

- outer viewport padding;
- card padding;
- logo width;
- vertical spacing;
- embedded error-state density.

The compact mode does not change theme colors, typography ownership, validation behavior, or login flow.

### Keyboard behavior

Dragging the login viewport now dismisses the software keyboard, preserving access to validation feedback and the submit button on mobile-height screens.

### Shared error-state compatibility

`FeatureErrorState` now accepts an optional `compact` flag. Its default remains `false`, so every existing caller preserves the previous presentation. The login opts into the compact rendering only when the current viewport requires it.

## Resulting Behavior

- normal-height web and Android layouts remain centered;
- validation and backend errors no longer produce a bottom overflow;
- the complete error message and login action remain reachable by scrolling;
- docking browser DevTools or reducing window height does not break the layout;
- login ownership and ServiceProvider continuation contracts remain unchanged.

## Files Modified

- `lib/features/auth/presentation/login_widget.dart`
- `lib/shared/widgets/feature_error_state.dart`
- `docs/tasks/010_login_vertical_viewport_overflow_stabilization.md`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation Notes

The correction was derived from the supplied Task 009 ZIP and screenshots showing the overflow only after the error surface expanded within a reduced-height browser viewport. Flutter/Dart tooling is not installed in the execution environment, so `dart format`, `dart analyze`, and runtime tests could not be executed here.
