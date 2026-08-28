# Phase X — Task 012 — Mandatory DBVersion Transport Boundary and Error Surface

## Objective

Correct the remaining DBVersion=0 path observed after the DBVersion 10 migration and make startup/backend errors visible in the global progress surface instead of requiring browser DevTools or console inspection.

This task is a continuation of Task 011, but it changes the contract established there: DBVersion is not limited to database-style SCRUD application calls. The current backend dispatches `Subscribe_Channel` work through the DBVersion-aware GERYON worker path as well, so every request serialized by `ServiceProvider.sendMessageV2()` must carry `LocalParams.DBVersion = 10`.

## Evidence from the Current ZIP and Backend Log

The backend log supplied with the Task 011 implementation shows the initial channel subscription reaching the backend as:

- `Action: Subscribe_Channel`
- `ChannelsName: [GERYON_General, GERYON_General_SCRUD]`
- `ParamsClientRequest.LocalParams.DBVersion: 0`

The backend then starts `Proc_GERYONDBVersion10()` and reports an unsupported/invalid DBVersion path. This proves that treating `Subscribe_Channel` as a versionless transport-only operation was incorrect for the current backend contract.

The customer-facing global loading surface also detected the failure but only classified connection-level error stages. Subscription/status/backend-processing errors could therefore remain represented by a generic `onData` catch message while the concrete `ErrorHandler.errorDsc` was only visible in logs.

## Repository-Wide Request Audit

All active outgoing WebSocket application requests were traced again from widgets/models to the transport boundary.

The active send path is centralized as:

`feature/model -> CommonDataModel or ServiceProvider request builder -> ServiceProvider.sendMessageV2() -> WebSocketClient.sendMessageV2()`

No active widget serializes and sends an independent backend request outside this boundary.

Relevant direct ServiceProvider builders are:

- `_buildBackendStatusRequest()`
- `_buildSubscribeChannelRequest()`
- `_buildLoginRequest()`

Generic SCRUD/data traffic continues through `CommonParamRequest` / `CommonDataModel`.

## Implementation

### 1. Subscribe_Channel now explicitly declares DBVersion 10

`_buildSubscribeChannelRequest()` now includes:

`pParams.LocalParams.DBVersion = BackendContract.dbVersion`

This makes the request contract readable at the builder itself and matches the backend worker semantics observed in the supplied log.

### 2. DBVersion 10 is enforced at the final ServiceProvider serialization boundary

A new `_normalizeMandatoryBackendParams()` boundary normalizes the request immediately before it is copied into the serialized `ParamRequest` envelope.

It:

- creates `pParams` when absent
- preserves all existing request parameters
- creates `LocalParams` when absent
- preserves all existing local parameters
- overwrites missing, zero, stale, or caller-supplied DBVersion values with `BackendContract.dbVersion`
- applies to every action, including `Subscribe_Channel`

This is intentionally stronger than Task 011. A future widget/model can no longer accidentally reintroduce DBVersion 0 merely by constructing a direct ServiceProvider request without `LocalParams`.

### 3. Existing explicit contracts remain

`CommonParamRequest`, `CommonDataModel`, `Get:Status`, `Auth:Login`, and feature-level explicit users still carry the canonical value. The transport-boundary normalization is the final safety invariant, not a replacement for clear request construction.

### 4. Global progress error classification was completed

`ModelGeneralLoadingProgress` now recognizes all relevant startup/runtime error stages, including:

- connection/reconnection errors
- channel subscription errors
- backend status errors
- backend request errors
- high-severity backend errors
- login-status validation errors
- custom errors

It also treats a non-zero `initStageError.errorCode` as an error even if a future enum stage is not yet explicitly listed.

### 5. Concrete backend errors are surfaced to the user

For an error stage, the loading surface now prefers the actual `initStageError.errorDsc` and displays the error code when present.

Only the user-relevant description is rendered; stack traces, class/function names, raw payloads, and internal diagnostic fields remain in logs.

This removes the previous failure mode where the UI showed a generic `Caught/Catched an error on ...onData...` message while the actionable backend response existed only in DevTools.

## Architectural Result

The invariant is now:

> Every application message emitted through `ServiceProvider.sendMessageV2()` reaches the wire with `ParamRequest.LocalParams.DBVersion = 10`.

This includes startup, authentication, channel subscription, status checks, generic SCRUD operations, recovery, and feature requests.

The global progress surface remains the single startup/recovery UI owner and now has enough error semantics to expose backend failures without introducing a parallel popup or navigation path.

## Files Modified

- `lib/models/ServiceProvider/data_model.dart`
- `lib/shared/overlays/global_loading_dialog.dart`
- `docs/tasks/012_mandatory_dbversion_transport_boundary_and_error_surface.md`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation

Static repository audit performed against the supplied Task 011 ZIP:

- all active Dart request senders traced
- all direct `ServiceProvider.sendMessageV2()` call sites reviewed
- all active `DBVersion` occurrences reviewed
- `Subscribe_Channel` confirmed as the remaining DBVersion 0 construction path
- final serialization boundary now enforces the invariant independently of caller implementation

The current environment does not include the Dart/Flutter SDK, so `dart format`, `dart analyze`, and Flutter tests could not be executed here.

## Status

Completed.
