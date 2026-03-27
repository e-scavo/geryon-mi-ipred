# 🔄 Phase 7.3.1 — Application Flow Inventory

## Objective

Inventory the real application flows currently present in Mi IP·RED so that cross-feature coordination, session/runtime transitions, and downstream dependencies become explicit before any future coordination contracts or minimal application coordinator are introduced.

## Initial Context

Phase 7.1 extracted feature-local controllers from the main runtime surfaces.

Phase 7.2 clarified ownership boundaries for:

- billing feature state
- dashboard derived state
- auth bootstrap and submit state
- startup initial boundary

Those phases intentionally stopped before introducing a global coordination layer.

That was correct.

The current ZIP now shows a different class of debt:

- features are more internally coherent
- but the flows connecting them are still distributed

This means the safest next step is not to invent a new abstraction immediately.

The safest next step is to inventory the real flows first.

## Problem Statement

The current codebase already contains cross-feature coordination.

However, that coordination is still distributed across:

- `main.dart`
- `ServiceProvider`
- `LoginController`
- `LoginPageWidget`
- `DashboardController`
- `DashboardPage`
- `BillingWidget`
- `SessionStorage`

That creates several risks:

- dependencies are real but partially implicit
- downstream effects can be missed during future refactors
- responsibilities may be moved twice
- a future coordinator could be introduced without understanding the actual current owners

The problem is not absence of coordination.

The problem is absence of an explicit inventory of that coordination.

## Scope

This inventory documents the current flows for:

- startup bootstrap
- backend status and auth decision
- login popup fallback
- login auto-submit and manual submit
- authenticated runtime context materialization
- dashboard consumption of authenticated context
- client selection propagation
- billing reload after client change
- logout reset flow

This subphase does not:

- introduce new runtime behavior
- introduce a coordinator
- redesign ServiceProvider
- redesign navigation
- redesign UI
- normalize session/app-context ownership yet

## Root Cause Analysis

The current flow ambiguity is a consequence of the project maturing correctly in layers.

Earlier work focused on:

- making the app work
- preserving backend flow
- cleaning structure
- extracting feature-local logic
- clarifying state ownership

Once that work succeeded, the next visible problem became flow-level rather than feature-local.

That is why the current debt appears as distributed coordination instead of feature-local chaos.

## Files Affected

Runtime files analyzed in this inventory:

- `lib/main.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/core/session/session_storage.dart`

Documentation files updated by this step:

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`

## Implementation Characteristics

### Inventory Principle

This document describes flows exactly as they exist in the current codebase.

It does not describe an idealized future design.

Each flow is documented with:

- trigger
- current owner(s)
- runtime source(s)
- downstream effect(s)
- coordination interpretation

### Flow 1 — Application Startup Bootstrap

#### Trigger

Application launch.

#### Current entrypoint

- `main.dart`
- `MyStartingPage`
- `_initWork()`

#### Current sequence

1. Flutter initializes and runs `ProviderScope`
2. `MyStartingPage` is rendered
3. local startup state starts as `AppStartupViewState.initial()`
4. `WidgetsBinding.instance.addPostFrameCallback(...)` triggers `_initWork()`
5. `_initWork()` reads `ref.read(notifierServiceProvider)`
6. if `appStatus.isReady` is already true, startup boundary completes
7. otherwise a loading popup is pushed via `ModelGeneralPoPUpLoadingProgress()`
8. if the popup returns success, startup boundary completes
9. once startup boundary is complete and `appStatus.isProgress` is false, `DashboardPage(clientID: -1)` is rendered

#### Current owners

- startup boundary ownership: `main.dart`
- startup local state: `AppStartupViewState`
- readiness source: `ServiceProvider.isReady`
- progress source: `ServiceProvider.isProgress`

#### Downstream effect

The application exits bootstrap and enters the main dashboard surface.

#### Coordination interpretation

This is the application entry flow.

It already coordinates startup UI state and runtime readiness, but it is still modeled only locally inside `main.dart`.

### Flow 2 — Backend Status Success → Auth Decision Bridge

#### Trigger

Successful backend status validation inside `ServiceProvider.getBackendStatus()`.

#### Current owner

- `ServiceProvider`

#### Current sequence

1. `getBackendStatus()` is executed
2. `_handleBackendStatusSuccessFlow(...)` runs after backend status success
3. backend-success state is applied
4. `doCheckLogin()` is called
5. if login status is considered invalid or missing, the login popup path is triggered
6. if authenticated context is valid, runtime continues toward ready state

#### Current owners

- backend-status flow: `ServiceProvider`
- auth decision bridge: `ServiceProvider`

#### Runtime sources used

- `ServiceProvider.loggedUser`
- `ServiceProvider.isReady`
- `ServiceProvider.initStage`
- navigator access through `navigatorKey.currentState`

#### Downstream effect

The application transitions either toward authenticated continuity or toward login fallback.

#### Coordination interpretation

This is a bridge between infrastructure readiness and user-session readiness.

It is not merely a low-level backend concern.

### Flow 3 — Login Popup Fallback

#### Trigger

`doCheckLogin()` indicates login is required.

#### Current owner

- popup trigger: `ServiceProvider`
- popup UI: `LoginPageWidget`
- popup submit preparation: `LoginController`

#### Current sequence

1. `ServiceProvider._handleBackendStatusSuccessFlow(...)` detects login-required status
2. `navigatorKey.currentState?.push(PopUpLoginWidget<ErrorHandler>())`
3. `LoginPageWidget` is rendered
4. auth bootstrap starts through `_checkAutoLogin()`
5. the login surface either auto-submits or waits for manual user submit

#### Runtime sources used

- login-required result from `ServiceProvider`
- saved DNI from `SessionStorage`
- local login view state in `LoginPageWidget`

#### Downstream effect

The unauthenticated startup path transitions into the auth feature flow.

#### Coordination interpretation

The popup is not an isolated UI event.

It is part of the app-entry coordination path.

### Flow 4 — Login Bootstrap Auto-Submit

#### Trigger

Auth popup renders and saved DNI exists.

#### Current owners

- state preparation: `LoginController.prepareViewState()`
- persisted value source: `SessionStorage.getSavedDni()`
- auto-submit dispatch: `LoginPageWidget._checkAutoLogin()`

#### Current sequence

1. `LoginPageWidget` runs `_checkAutoLogin()`
2. `LoginController.prepareViewState()` reads saved DNI from `SessionStorage`
3. bootstrap result returns `state` plus `shouldAutoSubmit`
4. widget updates `_loginState`
5. if `shouldAutoSubmit` is true, `_login(isAutoSubmit: true)` runs
6. `_controller.login(...)` sends login through `ServiceProvider.doLogin(...)`

#### Downstream effect

The auth surface can attempt login without manual user interaction.

#### Coordination interpretation

This flow connects persisted session input to auth runtime behavior.

It is a session-related coordination path, not just a local widget detail.

### Flow 5 — Manual Login Submit

#### Trigger

User presses the login button.

#### Current owners

- UI submit trigger: `LoginPageWidget`
- submit state transitions: `LoginController`
- backend login execution: `ServiceProvider`

#### Current sequence

1. widget reads current DNI and remember-me state
2. widget moves into submit-loading state through `LoginController.buildSubmitLoadingState(...)`
3. `LoginController.login(...)` validates DNI
4. `ServiceProvider.doLogin(...)` sends the login request
5. if the response fails, widget returns to submit-failure state and shows feedback
6. if success, popup closes and returns the response

#### Downstream effect

The authenticated runtime path can now materialize in the global runtime source.

#### Coordination interpretation

This is a feature-local flow whose success has global runtime consequences.

### Flow 6 — Authenticated Runtime Context Materialization

#### Trigger

Successful login callback.

#### Current owner

- `ServiceProvider.doLoginCallback()`

#### Current sequence

1. backend login callback arrives
2. `ServiceProvider.doLoginCallback()` parses the response
3. `ServiceProviderLoginDataUserMessageModel` is extracted
4. `_applyAuthenticatedUserContext(...)` is called
5. `loggedUser` is set
6. `cEmpresa` is set from authenticated context
7. `isUserLoggedIn` becomes true
8. listeners are updated

#### Runtime sources written

- `loggedUser`
- `cEmpresa`
- `isUserLoggedIn`

#### Downstream effect

Other runtime surfaces can now react to authenticated user context.

#### Coordination interpretation

This is the real point where auth transitions into global runtime state.

It is the central auth-to-app bridge.

### Flow 7 — Dashboard Consumption of Authenticated Runtime Context

#### Trigger

Dashboard renders and watches `notifierServiceProvider`.

#### Current owners

- reactive watch: `DashboardPage`
- source-state construction: `DashboardController.buildSourceState(...)`
- derived-state construction: `DashboardController.resolveStateFromSource(...)`

#### Current sequence

1. `DashboardPage` executes `ref.watch(notifierServiceProvider)`
2. the current `ServiceProvider` snapshot is passed to `DashboardController.buildSourceState(...)`
3. `DashboardResolvedState` is derived from source state
4. active client, active client display name, and client options are resolved
5. dashboard body renders using `dashboardState.activeClient`

#### Runtime source used

- `ServiceProvider.loggedUser`
- `loggedUser.cCliente`

#### Downstream effect

Dashboard UI becomes the main authenticated application surface.

#### Coordination interpretation

Dashboard is the main consumer of authenticated runtime context.

It does not own that context, but it depends on it to exist.

### Flow 8 — Client Selection Propagation

#### Trigger

User selects a client from dashboard actions.

#### Current owners

- user interaction: `DashboardPage`
- action dispatch helper: `DashboardController.selectClient(...)`
- active client mutation: `ServiceProvider.setCurrentCliente(...)`

#### Current sequence

1. dashboard menu selection dispatches selected client index
2. `DashboardController.selectClient(...)` is called
3. `ServiceProvider.setCurrentCliente(clientIndex)` mutates `loggedUser!.cCliente`
4. listeners are updated

#### Runtime sources written

- `loggedUser.cCliente`

#### Downstream effect

Any surface that depends on active client context can react.

#### Coordination interpretation

This is the clearest current cross-feature trigger originating in dashboard.

### Flow 9 — Billing Reload After Client Change

#### Trigger

`BillingWidget` receives a runtime-source update and detects that the current client index changed.

#### Current owners

- runtime listening: `BillingWidget`
- reload decision: `BillingController.shouldReloadForClientChange(...)`
- billing reload orchestration: `BillingController.reloadBillingState(...)`

#### Current sequence

1. `BillingWidget` attaches `ref.listenManual<ServiceProvider>(...)`
2. listener reads `next.loggedUser?.cCliente`
3. the current client index is compared against `_billingState.trackedClientIndex`
4. if the controller decides reload is required, `_reloadBillingData()` runs
5. widget updates local feature state to loading
6. controller reloads billing state
7. widget updates local feature state to ready or error

#### Runtime source used

- `ServiceProvider.loggedUser?.cCliente`

#### Downstream effect

Billing refreshes when dashboard changes active client.

#### Coordination interpretation

This is a real downstream feature interaction.

Dashboard does not call billing directly.

The connection is mediated by the global runtime source.

### Flow 10 — Logout Reset Path

#### Trigger

User presses logout from dashboard.

#### Current owners

- user interaction: `DashboardPage`
- logout helper: `DashboardController.logout(...)`
- persisted session cleanup: `SessionStorage.clear()`
- runtime reset: `ServiceProvider.logout()`

#### Current sequence

1. dashboard logout action is triggered
2. `DashboardController.logout(...)` clears persisted session storage
3. controller calls `ref.read(notifierServiceProvider).logout()`
4. `ServiceProvider.logout()` calls `_resetAuthenticatedRuntimeState()`
5. `ServiceProvider.logout()` then calls `getBackendStatus()`

#### Runtime sources reset

- `isUserLoggedIn`
- `loggedUser`
- `cEmpresa`

#### Downstream effect

The application leaves authenticated runtime context and re-enters backend-status flow.

#### Coordination interpretation

Logout is not just an auth event.

It is a multi-surface reset flow involving session persistence, runtime source reset, and re-entry into startup/auth decision behavior.

## Validation

This inventory is validated against the current ZIP because the code confirms all of the following:

- `main.dart` still owns the startup boundary
- `ServiceProvider` still bridges backend readiness and login decision
- login popup is still triggered from ServiceProvider
- auth bootstrap still uses `SessionStorage.getSavedDni()`
- authenticated runtime context is still materialized in `doLoginCallback()`
- dashboard still watches `notifierServiceProvider`
- dashboard still mutates current client through `setCurrentCliente(...)`
- billing still reloads through runtime-source listening
- logout still clears persisted session data and resets runtime auth flow

## Release Impact

This subphase has no intended runtime impact.

Its value is architectural and documentary:

- it makes real flow ownership explicit
- it reveals where coordination already exists
- it prepares later subphases without inventing new behavior prematurely

## Risks

The main risks revealed by this inventory are:

- coordination is currently distributed rather than explicitly contracted
- several runtime concepts are related but not yet normalized
- future work could mistakenly centralize too much logic in the wrong place
- future work could also mistakenly leave real dependencies undocumented

## What it does NOT solve

This inventory does not yet solve:

- explicit session/app-context normalization
- formal feature interaction contracts
- minimal application coordinator implementation
- automated flow-level tests

Those belong to later subphases.

## Conclusion

The current ZIP confirms that Mi IP·RED already has real application-flow coordination.

That coordination currently exists through distributed but valid runtime paths across startup, auth, dashboard, billing, session persistence, and ServiceProvider.

Phase 7.3.1 correctly documents that baseline first so later subphases can normalize it safely and incrementally.s