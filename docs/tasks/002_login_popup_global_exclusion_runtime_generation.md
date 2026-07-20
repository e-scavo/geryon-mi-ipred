# Phase X — Task 002 — Login Popup Global Exclusion and Runtime Generation

## Objective

Apply the startup/authentication correction confirmed by the current ZIP so the customer frontend can never keep more than one interactive login popup alive and stale login continuations cannot overwrite a newer runtime recovery cycle.

## Initial ZIP Baseline

Source of truth:

- `geryon-mi-ipred-x.task1.zip`

The baseline already contained a centralized `ServiceProvider`, startup/auth continuation states, a global loading popup, runtime recovery entry points, and an interactive `PopUpLoginWidget`.

## Problem Confirmed in the Repository

The concrete flow opened the login route directly from `_handleBackendStatusSuccessFlow()` with:

- no globally tracked route
- no shared future/completer
- no route reuse
- no runtime generation
- no invalidation before transport recovery
- direct `Navigator.pop()` ownership inside the login widget

This allowed concurrent or obsolete startup continuations to open more than one login route and allowed an old login completion to continue after a newer recovery cycle had already started.

The loading popup also performed route closure directly from a provider listener and started `ServiceProvider.init()` only on Web, leaving platform startup behavior inconsistent with the canonical `Config Loader -> ServiceProvider.init()` order.

## Owner Analysis

The existing owner is `ServiceProvider`.

It already owns:

- startup state
- authentication requirement evaluation
- runtime recovery policy
- transport recovery
- login continuation resolution
- readiness and startup stage transitions

Therefore login-route exclusion and recovery generation were consolidated there. No widget-local/static exclusion flag and no second coordinator were introduced.

## Implementation

### Global login ownership

`ServiceProvider` now tracks exactly one active login presentation through:

- active route
- active completer/future
- active login generation
- current runtime generation

Repeated login requests reuse the existing future instead of pushing another route.

### Runtime generation

Every accepted runtime recovery invalidates the previous login generation before re-entering initialization.

A continuation verifies its captured generation after the login future resolves. Obsolete continuations are discarded without applying login state to the new runtime cycle.

### Recovery cleanup

Before the loading recovery route is opened, the active login completer is invalidated and the owned route is removed safely, including the case where it is covered by another route.

### Navigation safety

ServiceProvider navigation actions are deferred with `WidgetsBinding.instance.addPostFrameCallback` and include diagnostic logging with generation, startup stage, and recovery state.

The login widget no longer closes its own route. It reports successful completion to the ServiceProvider owner.

### Startup ordering

The loading popup now waits for `serviceProviderConfigProvider.future` before reading and initializing the real ServiceProvider.

This applies on all supported platforms rather than only Web.

### Loading popup closure

Provider-listener route closure is deferred until the loading route is current and the Navigator is safe to pop. Duplicate close scheduling is excluded.

## Files Modified

- `lib/models/ServiceProvider/data_model.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/shared/overlays/global_loading_dialog.dart`
- `docs/tasks/index.md`
- `docs/index.md`

## Files Added

- `docs/tasks/002_login_popup_global_exclusion_runtime_generation.md`

## Secondary Corrections

- Removed platform-specific startup initialization from the loading popup.
- Prevented startup initialization from running against the temporary/dummy ServiceProvider created while configuration is still loading.
- Deferred loading-route opening during recovery instead of pushing synchronously from the runtime state transition.
- Added explicit diagnostics for route failures, reuse, invalidation, and stale continuation discard.

## Validation

Performed repository-level validation of:

- every `PopUpLoginWidget` construction and call site
- login success completion path
- runtime recovery entry points
- `_onDone()` transport recovery path
- loading-popup provider listener
- startup config/provider ordering
- delimiter balance for all modified Dart files
- partial ZIP contents and preserved repository paths

The execution environment does not contain the Dart/Flutter SDK, so `dart format`, `dart analyze`, and Flutter runtime tests could not be executed here. The modified files were therefore kept compatible with APIs already used by the repository and structurally checked before delivery.

## Compatibility and Risk

- No backend request or response contract changed.
- No Riverpod provider type changed.
- No login-controller contract changed.
- No numbered project phase was reopened.
- The configuration popup remains outside this task because the current ZIP contains only an empty route shell and no active configuration form implementation to preserve.

## Final State

The customer frontend now has one central login owner, a global single-popup invariant, recovery-generation invalidation, stale-continuation rejection, and deferred navigation for startup/login recovery transitions.
