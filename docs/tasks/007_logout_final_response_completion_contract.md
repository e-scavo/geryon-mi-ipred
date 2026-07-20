# Phase X — Task 007 — Logout Final Response Completion Contract

## Objective

Correct the logout re-entry path that remained waiting in the global loading surface even though the backend had already answered the status request.

The intervention preserves the existing owners:

- `ServiceProvider` remains the owner of startup, runtime recovery, tracked requests, loading, and login continuation.
- `ApplicationCoordinator` remains the producer of the logout reset action.
- no dashboard-owned navigation or parallel authentication flow is introduced.

## Confirmed Cause

The logout recovery reached the backend and received the tracked response, but two response-processing contracts could prevent the waiting request from observing its final completion:

1. tracked API v2 responses were allowed to omit `ChannelName` only while their status was `queued` or `processing`; a final correlated response with status `ok`, valid `MessageID`, and empty `ChannelName` was therefore rejected before its callback could finalize the tracker;
2. `SynchronizedMapV2CRUD.execute()` invoked an asynchronous callback without awaiting it, so callback completion and tracker finalization were detached from the incoming-message processing boundary.

This explains why cold startup could succeed while logout re-entry remained on the progress surface: the backend response existed, but the final tracked-request state was not guaranteed to be committed through the same processing boundary.

## Implemented Correction

### Tracked response channel contract

For non-handshake runtime messages:

- `MessageID` is the canonical correlation key;
- `ChannelName` must still be present as a string;
- an empty `ChannelName` is accepted when the response carries a non-empty tracked `MessageID`;
- handshake messages retain their existing strict transport identity validation.

This applies consistently to queued, processing, and final tracked responses instead of changing validation according to an intermediate status value.

### Awaited callback completion

`SynchronizedMapV2CRUD.execute()` now awaits the registered asynchronous callback.

The incoming-message flow therefore does not report callback dispatch as completed until the callback has:

- parsed the response;
- updated `finalResponse`;
- changed the tracker status to `ok` when appropriate;
- applied the corresponding ServiceProvider state transition.

Exceptions raised by an asynchronous callback are also captured by the existing `try/catch` instead of escaping after `execute()` has already returned.

## Resulting Logout Flow

The expected flow is now:

`Logout -> authenticated-state reset -> runtime reset recovery -> Get:Status -> correlated final response -> callback finalization -> auth requirement -> unique login popup`

The loading popup remains globally unique and closes only through the existing startup/auth continuation coordinator.

## Files Modified

- `lib/models/ServiceProvider/model.dart`
- `lib/models/SynchronizedMapV2CRUD/model.dart`
- `docs/tasks/007_logout_final_response_completion_contract.md`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation Notes

The correction was made against the Task 006 ZIP supplied as the only source of truth.

The execution environment does not provide the Flutter/Dart SDK, so `dart format`, `dart analyze`, and platform execution could not be run here. The modified control flow and signatures were inspected against the existing callback typedef and tracked-message contracts.
