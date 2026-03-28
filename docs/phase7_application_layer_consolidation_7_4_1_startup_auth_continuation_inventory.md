# 🧩 Phase 7.4.1 — Startup/Auth Continuation Inventory

## Objective

Inventory the real startup/auth continuation flow of Mi IP·RED exactly as it exists in the current codebase so that the next Phase 7.4 steps can harden the runtime boundary without redesigning the application, the backend flow, or the ServiceProvider contract.

## Initial Context

Phase 7.3 was formally closed with the following already validated outcomes:

- application flow inventory
- session and app-context normalization
- feature interaction contracts
- minimal application coordinator for the narrowest safe coordination concerns
- formal closure of the phase

That closure was correct.

However, the current ZIP still shows one intentionally untouched runtime block:

- startup boundary
- backend status readiness
- auth requirement resolution
- login popup entry
- authenticated continuation back into the runtime

This block already works in production.

The purpose of this document is not to redesign it.

The purpose of this document is to inventory it exactly as implemented so that later hardening work stays grounded in the real code.

## Problem Statement

The current runtime continuation from startup into authenticated application state is materially functional, but it still depends on a distributed meaning across several surfaces rather than one explicit boundary model.

That meaning currently spans:

- `lib/main.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`

This does not mean the flow is broken.

It means the flow is still semantically delicate because:

- auth requirement is represented through error-code semantics
- the popup entry point is still driven from ServiceProvider
- startup completion depends on a popup result rather than on an explicit continuation contract
- runtime continuation is spread across multiple listeners and navigator surfaces

That is the real reason to open Phase 7.4.

## Scope

This inventory covers only the currently implemented startup/auth continuation path.

It includes:

- startup boundary ownership
- backend status readiness path
- login requirement detection
- login popup invocation
- login bootstrap and submit behavior
- continuation back into authenticated runtime
- logout-triggered reentry into the same auth requirement path

It does not include:

- backend protocol redesign
- ServiceProvider redesign
- navigation redesign
- UI redesign
- coordinator expansion
- state-management replacement
- persistent backend-authenticated sessions

## Root Cause Analysis

Earlier Phase 7 work intentionally stopped before touching this block deeply.

That was correct.

The startup/auth/runtime continuation block is one of the most sensitive parts of the application because it sits between:

- application bootstrap
- backend readiness
- authentication entry
- authenticated runtime context materialization
- initial dashboard continuation

The codebase now has enough surrounding clarity to inspect this block safely.

What the ZIP shows is not a broken implementation.

What it shows is a runtime block whose behavior is currently preserved by distributed implicit semantics rather than by one explicit boundary contract.

## Files Affected

The real runtime surfaces involved in this inventory are:

- `lib/main.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/GeneralLoadingProgress/popup_model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/core/session/session_storage.dart`

The documentation surfaces affected by Phase 7.4.1 are:

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_4_1_startup_auth_continuation_inventory.md`

## Implementation Characteristics

### 1. Startup boundary remains locally owned by `main.dart`

`main.dart` introduces `AppStartupViewState` with one explicit concern:

- whether the initial startup boundary has already completed

`MyStartingPage` starts with:

- `hasCompletedInitialBoundary = false`

The startup page then calls `_initWork()` after first frame.

That startup boundary does not itself execute backend work directly.

Instead, it delegates runtime bootstrap through the loading popup route.

### 2. `main.dart` waits for popup completion rather than owning auth continuation directly

`MyStartingPage._initWork()` currently does the following:

- reads `notifierServiceProvider`
- if `isReady` is already true, completes the startup boundary immediately
- otherwise pushes `ModelGeneralPoPUpLoadingProgress()`
- waits for its returned status
- only completes startup boundary when popup returns a truthy result

This means startup completion is not directly bound to one explicit auth continuation model.

It is currently bound to popup result semantics.

### 3. Loading popup owns bootstrap triggering and readiness listening

`ModelGeneralLoadingProgress` currently performs two relevant responsibilities:

- on Web, it triggers `appStatus.init()` after first frame when the provider is not ready
- it listens manually to provider changes through `ref.listenManual(...)`

The popup closes only when:

- `next.isReady`
- `!next.isProgress`
- `next.isUserLoggedIn`

Therefore, startup/auth continuation is currently mediated by popup listener logic rather than by a dedicated continuation contract.

### 4. Popup listener also contains reconnection sensitivity

Inside the same manual listener, when the success condition is not met, the popup may call `next.reboot()` if it detects changes such as:

- URI changes
- progress changes
- init-stage changes

This confirms that the bootstrap/auth path is still operationally delicate and highly coupled to provider stage transitions.

### 5. Backend readiness and auth requirement are chained inside ServiceProvider

`ServiceProvider.getBackendStatus()` delegates success handling to `_handleBackendStatusSuccessFlow(...)`.

That method currently does the following sequence:

1. apply backend-ready state
2. call `doCheckLogin()`
3. interpret its result
4. possibly open login popup
5. resume runtime flow depending on popup result

This means the runtime source layer currently also owns the bridge into auth requirement resolution.

### 6. `doCheckLogin()` does not currently validate a backend-persisted session

The current implementation of `doCheckLogin()` behaves as follows:

- if `loggedUser == null`:
  - set `userIsNotloggedIn`
  - return error code `-1000`
- if `loggedUser != null`:
  - call `_resetAuthenticatedRuntimeState(clearLoggedUser: false)`
  - return error code `-1001`

This means the method no longer acts as a backend session validation flow.

Instead, it effectively acts as an auth requirement discriminator using magic error-code semantics.

That behavior is not wrong in itself.

But it means the meaning of “auth required” is not explicitly modeled as a boundary state.

### 7. Auth requirement is currently encoded through magic codes

The codes observed in the current flow are:

- `-1000`
- `-1001`
- `-1002`

`_handleBackendStatusSuccessFlow(...)` interprets them as the path that must open `PopUpLoginWidget`.

This is one of the clearest reasons to continue with Phase 7.4.2.

The code works, but the meaning is implicit.

### 8. ServiceProvider currently opens the login popup itself

When auth is required, `_handleBackendStatusSuccessFlow(...)` uses `navigatorKey.currentState?.push(PopUpLoginWidget<ErrorHandler>())`.

That means ServiceProvider is currently responsible not only for runtime/authenticated context ownership, but also for opening the UI entry point that resolves auth requirement.

This is exactly the sort of distributed meaning that Phase 7.4 should harden carefully.

### 9. Login bootstrap is feature-local and already reasonably separated

The login popup itself is not the main problem.

Inside auth feature code:

- `LoginController.prepareViewState()` reads remembered DNI/CUIT from session storage
- it builds `LoginBootstrapResult`
- `LoginPageWidget` consumes it
- if remembered DNI exists, auto-submit is attempted

This part already matches the feature-local boundary direction established in earlier phases.

### 10. Successful login returns through navigator result semantics

When login succeeds:

- `LoginController.login(...)` delegates to `ServiceProvider.doLogin(...)`
- `ServiceProvider.doLoginCallback(...)` materializes authenticated runtime context
- `LoginPageWidget` closes itself with `Navigator.pop(context, result.response)`

Then `_handleBackendStatusSuccessFlow(...)` receives that navigator result and processes it as the continuation input.

This means continuation currently depends on navigator result semantics rather than on an explicit continuation object or boundary contract.

### 11. Authenticated runtime continuation completes in more than one place

The current continuation is not completed in one single explicit step.

Instead it is distributed across:

- `ServiceProvider.doLoginCallback()` applying authenticated runtime context
- `_handleBackendStatusLoginFailure(...)` reapplying authenticated context from returned login result on success
- `ModelGeneralLoadingProgress` deciding when to close
- `main.dart` deciding when startup boundary is complete

This is the most important structural finding of this inventory.

The flow works.

But continuation completion is semantically distributed.

### 12. Logout reenters the same boundary from a different runtime path

`ServiceProvider.logout()` currently does:

- `_resetAuthenticatedRuntimeState()`
- `getBackendStatus()`

That means logout reenters the backend/auth requirement block outside the original startup page boundary.

This does not automatically mean the flow is incorrect.

It does mean Phase 7.4 must consider that the same auth requirement path can be reached from:

- initial startup
- post-logout runtime reentry

### 13. Real ownership after inventory

After inspecting the ZIP, the real ownership map remains:

- `main.dart` owns startup boundary completion state
- loading popup owns bootstrap waiting UI and readiness listening
- auth feature owns login bootstrap and submit UI/state
- `ServiceProvider` owns authenticated runtime context
- `ServiceProvider` also currently owns auth requirement orchestration trigger
- navigator result semantics currently glue the continuation together

That last point is the one that remains too implicit.

## Validation

This inventory is valid against the current ZIP because all of the following are directly present in code:

- local startup boundary state in `main.dart`
- popup-based initial bootstrap continuation
- manual provider listener inside loading popup
- `ServiceProvider.getBackendStatus()` chaining into `doCheckLogin()`
- magic-code auth requirement path
- provider-driven login popup push
- login feature bootstrap from persisted DNI/CUIT
- successful login returning through navigator result
- logout-triggered reentry into provider auth requirement logic

## Release Impact

Phase 7.4.1 does not change runtime behavior.

Its impact is documentary and architectural only.

It provides the exact baseline needed to continue Phase 7.4 safely without inventing debt or redesigning behavior that currently works.

## Risks

If this inventory is skipped or misread, future work may incorrectly:

- treat the login widget itself as the main problem
- redesign ServiceProvider too early
- introduce a broad coordinator without justification
- break popup-based startup continuity
- confuse persisted login hint with authenticated session semantics
- change runtime behavior while claiming to do only cleanup

## What it does NOT solve

This inventory does not by itself:

- normalize auth requirement semantics
- replace magic-code auth requirement handling
- introduce a continuation contract
- move popup ownership
- add a startup/auth coordinator
- redesign logout reentry behavior
- validate backend-persisted sessions

Those are possible later concerns.

This step only establishes the real current baseline.

## Conclusion

The current ZIP confirms that opening Phase 7.4 is justified.

The startup/auth/runtime continuation block is not broken, but it is still semantically distributed.

The most important findings are:

- auth requirement is currently represented implicitly through special error codes
- ServiceProvider currently owns both runtime context and login-popup trigger path
- startup continuation currently depends on popup result semantics
- authenticated continuation completion is spread across multiple runtime surfaces

Therefore, the next correct safe step is:

- `7.4.2 — Auth Requirement Boundary Normalization`

That step should make the auth requirement boundary explicit without redesigning the runtime.