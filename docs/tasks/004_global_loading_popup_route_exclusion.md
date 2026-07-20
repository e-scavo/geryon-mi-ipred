# Phase X — Task 004 — Global Loading Popup Route Exclusion

## Problem Confirmed

With the backend intentionally unavailable, every manual retry darkened the complete application surface again. The visual accumulation proved that new `ModelGeneralPoPUpLoadingProgress` routes were being pushed over a loading route that was still alive.

Task 003 correctly serialized `ServiceProvider.init()`, but it did not serialize ownership of the loading route itself.

The remaining defect was caused by using `isProgress` for two unrelated responsibilities:

- whether initialization was actively progressing;
- whether the global loading route already existed in the Navigator.

At the retry limit, initialization correctly set `isProgress = false` so the Retry action could be shown. The loading route, however, remained open. A manual recovery then interpreted `isProgress == false` as permission to push a new route, producing one modal barrier per interaction.

## Architectural Correction

`ServiceProvider` is now the global owner of the loading popup route, its completion future, and its lifecycle references.

A new canonical entry point was introduced:

- `requestGlobalLoadingPopup(calledFrom: ...)`

Its contract is:

- when a loading route already exists, return the existing Future;
- never push a second route while the owned route remains alive;
- register ownership synchronously before scheduling navigation;
- clear ownership only when that exact route completes;
- safely resolve with `false` when no Navigator is available.

## Call-Site Consolidation

Both loading-route entry points now use the same owner:

- initial startup in `main.dart`;
- runtime recovery in `ServiceProvider._requestRuntimeRecovery()`.

No widget or recovery callback pushes `ModelGeneralPoPUpLoadingProgress` directly anymore.

## Result

With the backend unavailable:

1. startup opens exactly one loading popup;
2. automatic retries execute inside that popup;
3. reaching the retry limit leaves the same popup visible with Retry;
4. every manual Retry reuses the same route and Future;
5. no additional modal barrier is added;
6. the route closes only when the startup coordinator resolves the boundary.

## Files Modified

- `lib/models/ServiceProvider/data_model.dart`
- `lib/main.dart`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation

Repository-wide search confirms that `ModelGeneralPoPUpLoadingProgress` is instantiated only by `ServiceProvider`. `main.dart` and runtime recovery both call the canonical loading-popup owner.
