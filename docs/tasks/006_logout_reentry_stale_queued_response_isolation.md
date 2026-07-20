# Phase X — Task 006 — Logout Re-entry and Stale Queued Response Isolation

## Scope Confirmed

Runtime validation of Task 005 confirmed that the global progress and login route exclusions are stable. Two residual behaviors remained:

- logout cleared the authenticated state but re-entered initialization without opening the globally owned loading boundary, leaving the web surface on the unauthenticated fallback background while the runtime continued internally;
- delayed `queued` or `processing` replies from a previous runtime generation could still be parsed and dispatched during a newer startup/recovery cycle.

The supplied logs also confirmed that backend acknowledgement messages may legitimately use an empty `ChannelName` while their status is `queued`. The previous parser treated that transport acknowledgement as a malformed application message and moved the ServiceProvider into `errorRequestingBackend`.

## Logout Re-entry Correction

The `runtimeReset` recovery policy now opens the same globally owned loading popup used by startup and transport recovery.

Logout therefore follows the canonical sequence:

1. clear remembered credentials and authenticated runtime state;
2. invalidate the previous login/runtime generation;
3. enter runtime-reset recovery through ServiceProvider;
4. reuse or open the unique loading route;
5. reconnect and validate the backend;
6. request the unique login route when authentication is required.

No dashboard-owned navigation or alternate login entry point was introduced.

## Tracked Request Generation Isolation

Every `CommonRPCMessageResponse` now records the ServiceProvider runtime generation in which it was created.

Incoming tracked messages are accepted only when:

- the message identifier is still present in the active tracker; and
- the tracked generation equals the current runtime generation.

Late replies without an active tracker and replies belonging to an obsolete generation are discarded silently after diagnostic logging. Stale tracked entries are removed and cannot mutate startup, login, retry, or recovery state.

## Queued Acknowledgement Compatibility

`ServiceProviderModel.fromJSON` now permits an empty `ChannelName` only for transport acknowledgement states:

- `queued`;
- `processing`.

Final/application messages retain the existing non-empty channel validation. This preserves the contract while accepting the backend response shape observed in the supplied runtime evidence.

## Files Modified

- `lib/models/CommonRPCMessageResponse/common_rpc_message_response.dart`
- `lib/models/ServiceProvider/model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `docs/tasks/index.md`
- `docs/index.md`

## Validation

Static repository validation confirms that:

- logout still originates in `DashboardController` and delegates to `ApplicationCoordinator`;
- `ApplicationCoordinator` still delegates global reset ownership to `ServiceProvider.logout()`;
- runtime reset now uses the existing global loading owner instead of dashboard navigation;
- tracked messages are stamped at the canonical `sendMessageV2` registration point;
- stale/untracked responses are rejected before callback dispatch or status mutation;
- empty channels remain invalid for completed application messages;
- no parallel queue manager, retry loop, recovery coordinator, loading popup, or login popup was added.

The execution environment does not provide the Flutter/Dart SDK, so `dart format`, `dart analyze`, and runtime widget tests could not be executed here.
