# Phase X — Task 009 — Fresh Transport Handshake after Runtime Reset

## Objective

Correct the logout/manual-retry recovery path introduced by Task 008, where canonical initialization waited for a new WebSocket handshake while reusing an already-open transport that could no longer emit that handshake.

## Confirmed Root Cause

The supplied runtime log shows the exact sequence:

```text
WebSocket already connected
WebSocketClient initialized successfully
Timed out waiting for the WebSocket handshake
```

Task 008 correctly required startup/recovery to wait for the `NEW` handshake before sending `Get:Status`. However, logout reset `isNew` and the session token without closing the existing WebSocket.

Because the transport was still open, `WebSocketClientPlatform.init()` returned `WebSocket already connected`. The server only emits the initial private-token handshake for a newly established connection, so no new handshake could arrive on that reused socket. The new completion boundary therefore waited until timeout on every logout and every manual retry.

This was not a backend-request or `ChannelName` problem in Task 008. No `Get:Status` request was sent because initialization never crossed the handshake boundary.

## Implemented Correction

### Fresh transport requirement

`ServiceProvider` now records when the current runtime generation requires a fresh transport handshake.

That requirement is activated when:

- recovery resets the session token;
- backend validation fails and the canonical loop must return to a new-session connection state.

Before preparing the handshake completer, canonical initialization now:

1. intentionally closes the previous WebSocket;
2. clears the transport reference;
3. suppresses the expected close callback from starting another recovery;
4. creates a new WebSocket;
5. waits for the server handshake;
6. subscribes channels;
7. continues with `Get:Status`.

### Cross-platform transport reset contract

Both WebSocket platform implementations now expose the same `resetConnection()` contract:

- Web: closes the browser WebSocket with a normal closure code and clears the active socket.
- IO/Android: awaits `WebSocket.close()` and clears the active socket.

The change is applied to both implementations so web and Android retain the same ServiceProvider behavior.

### Obsolete close isolation

Close handlers capture the concrete socket instance they belong to. A close event may request runtime recovery only when that socket is still the active transport.

Therefore, a delayed close event from the intentionally retired socket cannot invalidate or restart the newly opened connection.

## Resulting Flow

```text
Logout / manual retry
  -> invalidate authenticated runtime state
  -> mark fresh transport handshake required
  -> intentionally close old WebSocket
  -> ignore old socket close as a recovery trigger
  -> open new WebSocket
  -> receive NEW handshake and TokenID
  -> subscribe GERYON_General
  -> send Get:Status with ChannelName
  -> continue to globally owned login popup
```

## Files Modified

- `lib/core/transport/geryonsocket_model_web.dart`
- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `docs/tasks/009_fresh_transport_handshake_after_runtime_reset.md`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation Notes

The correction is grounded in the Task 008 ZIP and the supplied log, which proves that recovery reused an already-connected WebSocket and then timed out waiting for a handshake that only belongs to a new connection. Flutter/Dart tooling is not installed in the execution environment, so `dart format`, `dart analyze`, and runtime tests could not be executed here.
