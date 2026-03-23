# 🏗️ Architecture Deep Dive

## 🎯 Purpose

This document describes the **real current architecture** of Mi IP·RED in more detail than `architecture.md`.

The objective is not to describe an ideal future architecture, but the current system as it actually runs today, including its strengths, constraints, and structural debt.

---

## 🧱 Runtime Composition

At runtime, the application is built around five major technical zones:

1. **Application bootstrap**
2. **Connection and transport**
3. **Backend orchestration and session lifecycle**
4. **Domain/data model layer**
5. **Presentation and interaction layer**

The critical fact is that these zones are not fully isolated yet.  
Today, the application works because the central orchestration layer coordinates all of them successfully.

---

## 1️⃣ Application Bootstrap

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
`main.dart` boots the app and immediately renders `MyStartingPage`.

`MyStartingPage` is not only a visual starting screen; it is also the practical trigger point for the initialization workflow. It waits for the provider state and launches the loading popup if the app is not yet ready.

### Architectural note
This means startup orchestration is split between:
- provider creation in `common_vars.dart`
- async UI boot logic in `main.dart`
- lifecycle transitions inside `ServiceProvider`

That is functional, but it spreads initialization across multiple layers.

---

## 2️⃣ Configuration Layer

### Main files
- `lib/models/ServiceProviderConfig/model.dart`
- `lib/models/ServiceProviderConfig/config_loader.dart`
- `lib/models/ServiceProviderConfig/config_loader_web.dart`
- `lib/models/ServiceProviderConfig/config_loader_io.dart`

### Responsibilities
- define backend connection parameters
- parse a WSS URI into structured config
- save config per platform
- provide startup config to Riverpod

### Current behavior
The configuration provider selects a default URI based on runtime mode and then calls `ServiceProviderConfigModel.loadConfig(...)`.

However, the current platform loaders do not really behave as full persisted-config loaders:

- on Web, the loader builds the default config and saves it
- on IO, the loader builds the default config and saves it
- the code that would read existing persisted config is currently commented out

### Architectural implication
Today, the config system behaves more like:

> “default runtime config materialization + persistence side effect”

than:

> “real load persisted config if present, otherwise create default”

This is important because the structure exists, but the final intended behavior is not yet active.

---

## 3️⃣ Transport Layer

### Main files
- `lib/models/GeryonSocket/geryonsocket_model.dart`
- `lib/models/GeryonSocket/geryonsocket_model_web.dart`
- `lib/models/GeryonSocket/geryonsocket_model_io.dart`

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
This layer is one of the better-separated parts of the project.  
The transport abstraction already exists and should be preserved.

### Important constraint
The transport layer is tightly coupled to the backend contract shape, but not to the UI itself.  
That makes it a good candidate for future stabilization, testability, and logging cleanup.

---

## 4️⃣ Orchestration Layer

### Main file
- `lib/models/ServiceProvider/data_model.dart`

### Supporting files
- `lib/models/ServiceProvider/channel_model.dart`
- `lib/models/ServiceProvider/init_stages_enum_model.dart`
- `lib/models/ServiceProvider/login_data_user_message_model.dart`
- `lib/models/ServiceProvider/whole_message_model.dart`
- `lib/models/CommonRPCMessageResponse/common_rpc_message_response.dart`
- `lib/models/SynchronizedMapV2CRUD/model.dart`
- `lib/models/SynchronizedMapThreadsToDataModelCRUD/model.dart`

### Responsibilities
This is the main application backbone.

It currently handles:

- connection lifecycle
- handshake processing
- token assignment
- channel subscription
- backend status request
- login verification
- login execution
- logout reset
- current company state
- current customer state
- generic message tracking
- callback routing by `messageID`
- listener notification
- some popup orchestration via `navigatorKey`

### Why it is critical
This class is effectively acting as:

- connection manager
- session manager
- app state container
- RPC coordinator
- partial business-context holder

That concentration is the main structural risk of the repository.

### Current initialization sequence inside `ServiceProvider`
1. create WebSocket client
2. call `init()`
3. if provider is new:
   - connect socket
   - wait for handshake
4. when handshake arrives:
   - store `sessionTokenID`
   - mark provider as no longer new
   - subscribe to channels
   - call `init()` again
5. after that:
   - call `getBackendStatus()`
   - call `doCheckLogin()`
   - if not logged:
     - show login popup
   - if login succeeds:
     - mark app ready

### Technical note
The class does work, but it mixes:
- pure backend protocol logic
- state transitions
- UI-side navigation triggers
- domain state

That is exactly why it should be refactored gradually, not split impulsively.

---

## 5️⃣ Message Tracking and RPC Pattern

### Main files
- `lib/models/CommonRPCMessageResponse/common_rpc_message_response.dart`
- `lib/models/SynchronizedMapV2CRUD/model.dart`

### Observed pattern
The app uses a custom RPC-like message exchange over WebSocket:

- a message is built
- a `messageID` is generated
- the request is sent
- a tracking record is stored in a synchronized map
- the backend replies asynchronously
- callbacks update the tracked message
- the caller waits on message state transitions such as:
  - `init`
  - `sent`
  - `queued`
  - `processing`
  - `ok`

### Why it matters
This is one of the most important implementation patterns in the project.

Any refactor that touches:
- request envelope shape
- tracking storage
- callback dispatch
- response status handling

must be treated as high risk.

---

## 6️⃣ Authentication and Session Lifecycle

### Main files
- `lib/models/Login/widget.dart`
- `lib/models/Login/model.dart`
- `lib/models/SessionStorage/*`
- `lib/models/ServiceProvider/data_model.dart`

### Current behavior
The current authentication flow is pragmatic:

- the user enters DNI/CUIT
- `rememberMe` stores only the DNI locally
- the app sends `Auth:Login` with `LocalParams.Target = customers`
- the backend returns user/customer context
- that context is assigned to `loggedUser`

### Important real-world detail
The current `doCheckLogin()` implementation does **not** perform a full active backend session revalidation on startup.

Instead:

- if there is no `loggedUser`, login is required
- if there is a `loggedUser`, the method currently forces re-login anyway

The old/alternative remote session validation path exists commented out.

### Implication
Current persistence is:
- convenience persistence of the document identifier
- not a fully reused backend-authenticated persistent session

This must be documented clearly so future developers do not assume otherwise.

---

## 7️⃣ Domain Model Layer

### Main folders
- `lib/models/Common*`
- `lib/models/GenericDataModel/*`
- `lib/models/tbl_*/*`

### Responsibilities
This layer holds the typed representation of backend data, including:

- generic/common value wrappers
- whole backend message structures
- table/domain records
- file descriptor models
- common parameter objects
- customer/accounting-related entities

### Observed style
The project has a rich typed model layer with many domain-specific classes.

That is a strength, but the naming is currently uneven:
- `Common*`
- `Generic*`
- `tbl_*`
- `ServiceProvider*`

This makes the model layer harder to navigate than necessary.

### Architectural note
The model richness suggests the backend protocol and business domain have already been translated seriously into Dart types.  
This is valuable and should be preserved.

---

## 8️⃣ Presentation Layer

### Main files
- `lib/pages/dashboard_page.dart`
- `lib/pages/Billing/widget.dart`
- `lib/models/Login/widget.dart`
- `lib/pages/FrameWithScroll/widget.dart`
- `lib/pages/WindowWidget/*`
- `lib/pages/copyable_list_tile_page.dart`
- `lib/pages/infocard_page.dart`

### Responsibilities
- user login
- dashboard rendering
- customer switching
- payment info presentation
- invoices and receipts visualization
- helper popups and progress feedback

### Observed UI structure
The UI is already business-oriented and operational, but it is not yet organized into feature-first folders.

For example:
- login lives under `models/Login`
- billing lives under `pages/Billing`
- some popups live under `models/*`
- some screens live under `pages/*`

So the runtime behavior is clear, but the physical code organization is mixed.

---

## 9️⃣ Cross-Platform Utilities

### Main files
- `lib/models/FileSaver/*`
- `lib/models/SessionStorage/*`
- `lib/utils/utils.dart`
- `lib/utils/utils_web.dart`
- `lib/utils/utils_io.dart`

### Responsibilities
- save files depending on platform
- store local DNI depending on platform
- expose runtime/platform helpers
- abstract Web vs IO differences

### Architectural assessment
This is another good foundation already present in the codebase.

The multi-platform approach is not the problem.  
The problem is mostly structural consistency and removal of legacy leftovers.

---

## 🔟 Structural Pain Points

### A. Oversized central class
`lib/models/ServiceProvider/data_model.dart` is currently too large and too responsible.

### B. Mixed folder semantics
The project uses `models`, `pages`, `utils`, and `services`, but some folders contain UI and some contain logic, so boundaries are not obvious.

### C. Legacy/commented code
There are multiple files and large sections that appear to be:
- old implementations
- disabled features
- commented experiments
- previous iterations

### D. Naming drift
The visible product is **Mi IP·RED**, while the package remains `geryon_web_app_ws_v2`.

### E. Incomplete config persistence
The config loader shape exists, but the persisted-read behavior is currently disabled.

---

## ✅ Architectural Strengths

Even with the current disorder, the project has strong foundations:

- real production behavior already works
- backend contract is already integrated
- Web/IO abstractions already exist
- domain models are strongly typed
- Riverpod is already in use
- the app has a clear critical path

---

## 🛡️ Protected Refactor Boundaries

Future refactors must protect these areas first:

- `ServiceProvider.sendMessageV2(...)`
- `_onData(...)`
- handshake state transitions
- `sessionTokenID`
- channel subscription flow
- `getBackendStatus()`
- `doLogin()`
- `loggedUser` assignment
- customer selection logic
- billing data loading flow

---

## 🚀 Refactor Direction

The correct direction is not “rewrite everything”.

The correct direction is:

1. document current reality
2. isolate responsibilities
3. move files gradually
4. preserve public behavior
5. remove legacy only after dependency confirmation

That is the safest path for Mi IP·RED.