# Architecture Deep Dive

## Purpose

This document describes the real current architecture of Mi IP·RED in more detail than `architecture.md`.

The objective is not to describe an ideal future architecture, but the current system as it actually runs today, including its strengths, constraints, and structural debt.

---

## Runtime Composition

At runtime, the application is built around five major technical zones:

1. Application bootstrap
2. Connection and transport
3. Backend orchestration and session lifecycle
4. Domain/data model layer
5. Presentation and interaction layer

The critical fact is that these zones are not fully isolated yet.
Today, the application works because the central orchestration layer coordinates all of them successfully.

---

## 1. Application Bootstrap

### Main files
- `lib/main.dart`
- `lib/common_vars.dart`

### Responsibilities
- initialize Flutter bindings
- create `ProviderScope`
- mount `MaterialApp`
- register global theme
- provide a global `navigatorKey`
- create the main `ServiceProvider` instance through Riverpod

### Observed behavior
`main.dart` boots the app and renders the starting page, which coordinates readiness with provider state and popup-based loading/error behavior.

### Architectural note
Startup orchestration is still distributed across:
- provider creation in `common_vars.dart`
- app boot logic in `main.dart`
- async lifecycle transitions inside `ServiceProvider`

That remains acceptable, but it must be treated as a sensitive path.

---

## 2. Configuration Layer

### Main files
- `lib/models/ServiceProviderConfig/*`

### Responsibilities
- define backend connection parameters
- parse the backend URI into structured config
- save config per platform
- provide startup config to Riverpod

### Current behavior
The configuration system still behaves closer to:

> default runtime config materialization + persistence side effect

than to a full “load persisted config if present” implementation.

This is not a Phase 5 target, but it remains documented debt.

---

## 3. Transport Layer

### Main files
- `lib/models/GeryonSocket/*`

### Responsibilities
- abstract WebSocket transport across platforms
- initialize socket
- listen for messages
- forward incoming messages to callbacks
- send outbound messages
- report socket errors and closure events

### Runtime relation
`ServiceProvider` owns a `WebSocketClient` instance and supplies the callbacks:

- `_onData`
- `_onError`
- `_onDone`

### Architectural note
This layer remains one of the better-separated parts of the project and should be preserved.

---

## 4. Orchestration Layer

### Main file
- `lib/models/ServiceProvider/data_model.dart`

### Responsibilities
This is the runtime core of the application.

It currently handles:

- connection lifecycle
- handshake processing
- token assignment
- channel subscription
- backend status request
- login verification
- login execution
- logout/reset
- current company state
- current customer state
- generic message tracking
- callback routing by `messageID`
- listener notification
- popup orchestration via `navigatorKey`

### What changed in Phase 5
Phase 5 did not replace `ServiceProvider`, but it did reduce internal concentration by extracting stable helper groups inside the same file.

The most relevant stabilized areas are:

#### Handshake decomposition
- handshake detection
- token validation
- token application
- initialization continuation after handshake

#### Tracked incoming message decomposition
- `_onData(...)` as dispatcher
- tracked message status synchronization
- tracked callback-or-cleanup flow

#### Tracked request execution reuse
The repeated runtime pattern:
- send tracked request
- prepare tracked response state
- wait for completion
- read final response
- wait for post-processing
- cleanup tracking

was consolidated and reused in the main runtime request paths:
- `getBackendStatus()`
- `subscribeChannel()`
- `doLogin()`

#### Auth/context helpers
The logic for applying or resetting authenticated runtime state was extracted into helpers to reduce duplication and keep callback behavior aligned.

### Important architectural constraint
Although these internal helpers now exist, `ServiceProvider` is still the main runtime backbone and must still be treated as a protected refactor area.

---

## 5. Message Tracking and RPC Pattern

### Main files
- `lib/models/CommonRPCMessageResponse/*`
- synchronized map helpers
- `lib/models/ServiceProvider/data_model.dart`

### Observed pattern
The app uses a custom RPC-like exchange over WebSocket:

1. build request payload
2. generate or track a `messageID`
3. send request
4. store tracking state
5. receive async callback(s)
6. update tracked state
7. finalize with a normalized response object

### Phase 5 result
This pattern is now more explicit and easier to follow in the runtime code because:
- tracked wait helpers were extracted
- callback helpers were extracted
- post-send preparation helpers were extracted
- a reusable tracked request execution helper is used by multiple critical flows

### What remains sensitive
Callback bodies still contain business-specific differences and should not be over-abstracted without direct validation.

---

## 6. Login and Session Runtime

### Main methods
- `doCheckLogin()`
- `doCheckLoginCallback()`
- `doLogin()`
- `doLoginCallback()`

### Observed behavior
The actual login/auth materialization still happens inside callback logic, not inside the outward request method.

This is important:
- `doLogin()` orchestrates the tracked request
- `doLoginCallback()` parses the response and applies authenticated context
- `doCheckLoginCallback()` validates and applies existing session/user context when appropriate

### Phase 5 result
This behavior was preserved while improving internal structure:
- no backend contract changes
- no change to callback-triggered auth semantics
- better separation between request dispatch and callback-side state materialization

---

## 7. Subscription Runtime

### Main methods
- `subscribeChannel()`
- `subscribeChannelCallback()`

### Observed behavior
Channel subscription remains a multi-step tracked process whose completion depends on the number of expected subscribed channels.

### Phase 5 result
The request execution flow was simplified without changing:
- callback semantics
- counter-based completion
- subscription stage progression
- final readiness implications

---

## 8. Presentation and Interaction Layer

### Main files
- `lib/pages/*`
- widgets and popup-related classes

### Responsibilities
- render login
- render dashboard
- show errors and loading
- expose account, balance, billing, and payment information

### Architectural note
Phase 5 intentionally did not redesign the UI layer.

The main goal was to reduce pressure on the runtime core so later presentation cleanup can happen with lower risk.

---

## Current Deep-Architecture Summary

Mi IP·RED still relies on a central runtime orchestrator, but after Phase 5:

- the most fragile runtime flows are better isolated internally
- tracked request execution is more coherent
- handshake and callback support logic is easier to trace
- login and subscription flows preserve behavior while being easier to maintain

The codebase is still backend-centric, but it is now in a safer condition for the next documentation and cleanup stages.
