# 🔎 Phase 8.1 — Runtime Failure Surface Inventory

## Objective

Identify and freeze the real runtime failure surfaces currently present in Mi IP·RED so that later Phase 8 work can normalize semantics and recovery behavior based on the actual code rather than on assumptions.

## Initial Context

The current ZIP already confirms that:

- Phase 7 is formally closed
- the application-layer structure is stable
- startup/auth continuation is explicitly modeled
- feature-local controllers already exist
- runtime recovery-related logic already exists in the codebase

This means the first safe step of Phase 8 is not implementation.

The first safe step is to map the real runtime failure surfaces.

## Problem Statement

The runtime currently contains failure handling in several places, but those behaviors are not yet frozen as one explicit operational inventory.

Without that inventory:

- future hardening may focus on the wrong failure points
- implementation may overreact to local symptoms
- recovery policies may become inconsistent across startup and features
- small fixes may reopen broader architecture concerns indirectly

The problem now is lack of explicit inventory, not lack of runtime mechanisms.

## Scope

This inventory includes real failure surfaces across:

- startup bootstrap
- startup/auth continuation
- websocket lifecycle
- handshake and session token establishment
- channel subscription
- backend status check
- login continuation
- feature-level loading and fetch behavior
- active-client-dependent runtime updates
- logout reset path

This inventory does not include:

- fixes
- refactors
- retry-policy implementation
- observability implementation
- UI redesign
- backend changes

## Root Cause Analysis

The current runtime evolved incrementally around a working production application.

As that happened, operational failure handling accumulated naturally in different layers:

- startup route and loading popup
- ServiceProvider initialization state machine
- websocket platform implementation
- feature controllers
- feature widgets
- popup-based and inline error surfaces

That is normal for a growing application.

The issue is that, after structural consolidation, those operational concerns are now the main remaining distributed concern.

## Files Affected

### Runtime files analyzed

- `lib/main.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/GeneralLoadingProgress/popup_model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/ServiceProvider/init_stages_enum_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/models/ServiceProvider/login_continuation_result_model.dart`
- `lib/models/ServiceProvider/auth_requirement_model.dart`
- `lib/core/transport/geryonsocket_model.dart`
- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/core/transport/geryonsocket_model_web.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/contracts/application_coordinator.dart`

### Documentation

- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md` ← new
- `docs/phase8_runtime_reliability_failure_semantics_hardening.md`
- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`

### Code

- no code changes in 8.1

## Implementation Characteristics

### 1. Startup boundary failure surface

The startup flow is anchored in:

- `lib/main.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/data_model.dart`

Current behavior:

- `MyStartingPage` opens the loading popup when the app is not ready
- the popup watches `ServiceProvider`
- coordinator state decides whether to:
  - keep waiting
  - close popup and complete startup
  - trigger reboot

This is already a runtime recovery surface because the user-visible startup path depends on:

- `isReady`
- `isProgress`
- `initStage`
- `canRetry`
- coordinator disposition
- popup route close timing

This boundary is critical and must remain a first-class Phase 8 concern.

### 2. WebSocket connection lifecycle failure surface

The WebSocket implementation exists in:

- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/core/transport/geryonsocket_model_web.dart`

The runtime response to socket loss is anchored in:

- `ServiceProvider._onDone()`
- `ServiceProvider.reboot()`
- `ServiceProvider.init()`

Current behavior already includes:

- startup connection attempts
- connection retry counting during init
- auto reboot when socket is closed
- transport-specific `sendMessageV2()` closed-socket failures

This proves that websocket lifecycle is one of the most important operational surfaces of the app.

### 3. Handshake / session-token establishment failure surface

Inside `ServiceProvider`, the initial runtime establishment still depends on:

- handshake message detection
- session token extraction
- subscribe-channel flow
- later backend status check

Any failure in this chain can block the whole runtime.

This makes the handshake path a runtime-global failure surface, not a feature-local one.

### 4. Channel subscription failure surface

`subscribeChannel()` and `subscribeChannelCallback()` already define a recovery-sensitive path.

Current behavior shows that channel subscription can fail because of:

- tracked message failure
- callback failure
- channel mismatch
- incomplete subscription completion
- general backend error response

This is a runtime-global boundary because the app cannot proceed safely if the communication baseline is not subscribed correctly.

### 5. Backend status / authenticated-runtime continuation failure surface

`getBackendStatus()` and related continuation helpers are a central boundary between:

- connected runtime
- remembered login continuation
- interactive login reopening
- error-blocked startup

This is not only a login concern.

It is the seam where the runtime decides whether the app can become operational.

That makes it one of the highest-value surfaces for Phase 8.

### 6. Interactive login failure surface

`LoginController` and `LoginPageWidget` show a narrower but still important failure surface:

- invalid or empty DNI/CUIT
- backend login rejection
- remembered login auto-submit
- remembered DNI persistence / removal

This surface is partially feature-local, but it also participates in runtime continuation because login success materializes authenticated runtime context.

### 7. Feature fetch failure surface: billing

Billing is currently the clearest feature-level failure surface.

The path involves:

- `BillingController.loadBillingData()`
- `BillingWidget._reloadBillingData()`
- active-client dependency
- local error state rendering through `CatchMainScreen`

Current billing load can fail because of:

- missing authenticated runtime context
- missing active client
- tracked request failure
- backend fetch failure
- unexpected response shape
- catch-level local exception

This is a good example of a feature-local failure boundary that depends on global runtime validity.

### 8. Active-client change recovery surface

Billing listens to `ServiceProvider` and reloads when the active client changes.

That means client switching is not only a dashboard interaction.

It is an operational trigger that can cause reload and failure in downstream features.

That makes active-client change a runtime-adjacent recovery surface that must later be normalized.

### 9. Logout reset surface

`DashboardController.logout()` delegates to `ApplicationCoordinator.performLogoutReset()`, which:

- removes remembered DNI
- calls `ServiceProvider.logout()`

`ServiceProvider.logout()` then resets authenticated runtime state and re-enters backend-status evaluation.

This means logout is not merely a feature action.

It is a runtime reset path and therefore a formal failure/recovery surface.

### 10. Heterogeneous error-presentation surface

The current runtime does not expose failures through one single presentation model.

Real examples in the ZIP:

- startup connection errors → loading popup retry UI
- login errors → `SnackBar`
- billing load errors → `CatchMainScreen`
- some ServiceProvider failures → popup dialog
- some transport errors → state mutation and reconnect behavior

This is not automatically wrong.

But it confirms that failure semantics are still distributed and therefore must be normalized before implementation hardening begins.

### 11. Concrete runtime hotspots detected during inventory

The ZIP exposes at least these concrete hotspots that justify Phase 8 follow-up work:

#### 11.1 `setCurrentCliente()` boundary check
Current code allows:

- `loggedUser!.clientes.length >= clientID`

That admits `clientID == length`, which is an invalid list index and creates a real boundary-risk hotspot.

#### 11.2 `logout()` does not await runtime re-evaluation
`logout()` triggers `getBackendStatus()` without `await`.

That is not necessarily wrong, but it is a real sequencing surface that must later be classified.

#### 11.3 `reboot()` triggers `init()` without explicit awaited orchestration
Again, this may be acceptable in the current model, but it is a real operational sequencing hotspot.

#### 11.4 disconnect handling is automatic but not yet semantically frozen
`_onDone()` immediately triggers `reboot()`.

That shows a real recovery mechanism already exists, but its semantic category is not yet explicitly frozen.

## Validation

The current ZIP validates the opening of 8.1 because it shows all of the following:

- real startup coordination under failure
- explicit websocket reconnect-related behavior
- runtime-global failure boundaries
- feature-local failure boundaries dependent on global runtime state
- heterogeneous recovery and error-presentation paths
- concrete hotspots suitable for later normalization

That is enough evidence to conclude that the inventory phase is real and justified.

## Release Impact

This step has no direct runtime impact.

Its impact is documentary and architectural:

- it freezes the real operational failure map
- it prevents guessing about where reliability work should happen
- it allows later implementation to stay narrow and justified

## Risks

If this inventory is skipped, later Phase 8 work may:

- fix symptoms instead of boundaries
- over-focus on local widgets
- normalize the wrong failure categories
- introduce recovery logic in inconsistent places
- accidentally blur feature-local versus runtime-global failures

## What it does NOT solve

This inventory does not yet:

- define the final failure taxonomy
- implement retry policy
- harden reconnect behavior
- unify recovery surfaces
- add observability primitives
- fix billing reload behavior
- fix `setCurrentCliente()`
- change logout or reboot sequencing

Those belong to later subphases.

## Conclusion

The current ZIP confirms that Mi IP·RED already contains meaningful runtime recovery behavior, but that behavior still depends on distributed failure semantics.

The most important result of 8.1 is now explicit:

- the next work must focus on failure-boundary normalization, not on structural redesign
- the runtime already has identifiable global and feature-local failure surfaces
- the most sensitive surfaces are startup, websocket lifecycle, backend-status continuation, billing fetch, active-client reload, and logout reset

The next recommended subphase is:

- `8.2 — Failure Boundary Normalization`