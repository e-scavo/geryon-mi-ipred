# Phase X — Task 008 — Handshake Completion and Channel Serialization

## Objective

Correct the logout/recovery initialization race that allowed `Get:Status` to be sent while the WebSocket transport was still in the new-session handshake state.

## Confirmed Root Cause

The request builder correctly provided:

```dart
'ChannelName': 'GERYON_General'
```

However, `sendMessageV2()` conditionally serialized `ChannelName` only when `ServiceProvider.isNew == false`.

During logout recovery, the runtime intentionally reset `isNew = true` and opened a fresh WebSocket. `wssClient.init()` returned after establishing the transport, but before the asynchronous server handshake had necessarily been received and processed. The canonical initialization loop then immediately called `getBackendStatus()`.

Consequently, the request still contained a channel at the builder boundary, but the serializer omitted it because the transport remained in the new-session state. The backend therefore received:

```json
"Action": "Get:Status",
"ChannelName": ""
```

The same race also exposed a second architectural issue: the handshake callback recursively invoked `init()`, while the already-active canonical initialization continued independently. Single-flight prevented a second initialization Future, but it did not make the first initialization wait for handshake and channel subscription completion.

## Implemented Correction

### Explicit handshake completion boundary

`ServiceProvider` now owns a generation-aware handshake completer.

Before opening a new WebSocket connection, canonical initialization:

1. creates the handshake wait boundary;
2. starts the transport;
3. waits for the server handshake;
4. waits for channel subscription completion;
5. only then sends `Get:Status`.

A bounded timeout converts a missing handshake into a controlled `ErrorHandler` instead of allowing an invalid status request.

### Removed recursive initialization continuation

The handshake handler no longer calls `init()` recursively.

It now:

1. validates and applies the session token;
2. subscribes to configured channels;
3. completes the handshake boundary;
4. allows the already-active canonical initialization to continue.

This preserves one owner and one sequential startup/recovery flow.

### Channel serialization contract

`sendMessageV2()` now validates and serializes `ChannelName` according to the outgoing action contract, not according to the mutable `isNew` transport flag.

Every action except `Subscribe_Channel` must provide a non-empty channel and that channel is always copied into the wire request.

This guarantees that a valid request builder cannot silently lose its channel during serialization.

### Generation isolation

Handshake completion is tied to the current runtime generation. Obsolete completions cannot release a newer recovery cycle.

## Resulting Flow

```text
Logout
  -> runtime reset recovery
  -> WebSocket connect
  -> wait for NEW handshake
  -> apply TokenID
  -> Subscribe_Channel
  -> handshake boundary completed
  -> Get:Status with ChannelName=GERYON_General
  -> backend status callback
  -> login requirement
  -> globally owned login popup
```

## Files Modified

- `lib/models/ServiceProvider/data_model.dart`
- `docs/tasks/008_handshake_completion_channel_serialization.md`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation Notes

The correction is repository-grounded against the Task 007 ZIP and the backend wire payload supplied with the issue. The environment does not provide Flutter/Dart tooling, so `dart format`, `dart analyze`, and runtime tests could not be executed here.
