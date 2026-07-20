# Phase X — Task 005 — Progress and Login Theme Normalization

## Scope Confirmed

Task 004 resolved global loading-route accumulation. Runtime validation supplied with the Task 004 baseline confirms that startup and runtime recovery now reuse one progress popup and continue through the expected login boundary when the backend becomes available again.

The remaining issue was visual and interaction inconsistency in the startup/recovery progress surface. The popup still contained hardcoded black/grey colors, an English `Retry` label, fixed low-contrast typography, an unthemed button, and a minimal layout that did not match the customer-facing login and dashboard surfaces.

The related login surface was also reviewed for residual normalization issues.

## Progress Surface Normalization

`ModelGeneralLoadingProgress` now derives presentation from `Theme.of(context)` and the application `ColorScheme`:

- surface and surface tint come from the active theme;
- primary/error colors drive progress and failure states;
- title, message, attempt counter, and action use the active text theme;
- the action is a themed `FilledButton.icon`;
- copy is normalized to Spanish (`Reintentar`, connection status, attempt status);
- the content is presented inside a responsive, bounded Material card;
- spacing, elevation, clipping, and logo sizing are consistent with the login surface;
- retry is disabled while a recovery attempt is actively running;
- logo and route labels now expose meaningful semantic descriptions.

The existing ServiceProvider ownership, retry behavior, startup coordinator, route exclusion, and recovery flow were not duplicated or moved into the widget.

## Login Surface Review and Normalization

The login surface already used most of the application theme. Residual inconsistencies were corrected:

- the primary action now uses the Material 3 themed `FilledButton` contract;
- the submit spinner uses the active `onPrimary` color;
- the DNI/CUIT field now has a themed label and leading icon;
- numeric keyboard and completed-action semantics are declared;
- submitting from the keyboard executes the same canonical login callback;
- the remember-me label uses the active body text style;
- modal barrier opacity and transition duration now match the progress route;
- route barrier labels are meaningful and accessible instead of `Dismissible Dialog`.

`ShakeTextField` was extended only with presentation/input parameters required by the login owner. Its shake behavior remains unchanged.

## Files Modified

- `lib/shared/overlays/global_loading_dialog.dart`
- `lib/shared/overlays/global_loading_dialog_route.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/shared/widgets/shake_text_field.dart`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation

Repository review confirms that:

- progress actions still call `ServiceProvider.requestManualRecovery()`;
- no new recovery coordinator or route owner was introduced;
- the login still completes through `ServiceProvider.completeActiveLogin()`;
- the global loading and login routes remain non-dismissible;
- all newly introduced visual colors come from the active theme except the modal scrim, which belongs to the route barrier contract;
- no additional loading or login popup entry point was created.

The execution environment does not provide the Flutter/Dart SDK, so `dart format`, `dart analyze`, and runtime widget tests could not be executed here.
