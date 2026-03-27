# 🧭 Phase 7.2.1 — Feature State Inventory & Ownership Definition

## Objective

Document the real state ownership map of Mi IP·RED after Phase 7.1 closure, explicitly separating UI state, feature functional state, derived state, and global source state so that later state-boundary consolidation can be performed safely without breaking runtime behavior.

---

## Initial Context

Phase 7.1 completed the first application-layer extraction pass:

- auth request orchestration moved into a controller
- dashboard customer/session actions moved into a controller
- billing request preparation and backend-facing normalization moved into a controller

That extraction significantly improved responsibility clarity.

However, the real ZIP state shows that several coordination responsibilities are still distributed across widgets and startup/runtime surfaces.

The remaining issue is not that business-adjacent request logic still dominates the widgets.

The remaining issue is that ownership of state is still partially implicit.

This subphase exists to freeze the real map before changing anything.

---

## Problem Statement

The current codebase still contains multiple state categories living side by side without a formal ownership definition.

These categories include:

- purely visual UI state
- feature functional state
- derived rendering state
- global runtime source state
- startup and initialization state

Without a formal inventory, future refactors would risk:

- moving the wrong state out of widgets
- leaving derived state undocumented
- duplicating ownership between presentation and controllers
- confusing startup state with authentication state
- introducing regressions while attempting “cleanup”

The project therefore requires a real, code-backed state inventory before any consolidation work proceeds.

---

## Scope

### Included

- inspect the real ZIP state after Phase 7.1
- identify current state holders
- classify state by ownership category
- map manual coordination points
- define target ownership direction for Phase 7.2
- validate the safest order for later subphases
- re-evaluate whether the original 7.2 scope needs adjustment

### Excluded

- moving state in code
- adding new runtime abstractions
- changing ServiceProvider behavior
- changing navigation
- redesigning widget structure
- changing backend communication flow

---

## Root Cause Analysis

The current ownership ambiguity is the natural result of an incremental evolution path.

Earlier phases prioritized:

- runtime stability
- backend correctness
- structural cleanup
- logic extraction

That was correct.

But once logic extraction finished, a second layer became visible:

- some widgets still coordinate feature lifecycle state
- some derived state is resolved directly from ServiceProvider-backed runtime state
- startup flow still owns part of the auth-entry boundary
- not all local state is actually UI state

This is not a mistake in Phase 7.1.

It is the expected next layer revealed by Phase 7.1.

That is why this inventory is a required transition subphase rather than optional documentation.

---

## Files Affected

### Runtime files analyzed

- lib/main.dart
- lib/features/auth/presentation/login_widget.dart
- lib/features/auth/controllers/login_controller.dart
- lib/features/dashboard/presentation/dashboard_page.dart
- lib/features/dashboard/controllers/dashboard_controller.dart
- lib/features/billing/presentation/billing_widget.dart
- lib/features/billing/controllers/billing_controller.dart

### Documentation files affected by this subphase

- docs/index.md
- docs/development.md
- docs/decisions.md
- docs/phase7_application_layer_consolidation.md
- docs/phase7_application_layer_consolidation_7_2_1_feature_state_inventory.md

---

## Implementation Characteristics

This subphase is documentation-first and code-neutral.

It does not move responsibilities yet.

Instead, it produces an ownership model that future implementation subphases must respect.

### Ownership categories used in this inventory

#### 1. UI State

State that exists only to drive local rendering or direct widget interaction.

Typical examples:

- checkbox selection
- transient animation triggers
- focus-related state
- local visual toggles

#### 2. Feature Functional State

State required to coordinate a feature’s execution lifecycle, but not necessarily global application state.

Typical examples:

- feature loading flags
- last selected feature-relevant identity used to trigger reload
- feature-local error state
- feature-local initialized/not-initialized gate

#### 3. Derived State

State not owned as source-of-truth, but computed from another source for rendering or decision purposes.

Typical examples:

- active customer display name
- currently active customer model
- customer option lists
- resolved initial login configuration

#### 4. Global Source State

State whose source-of-truth lives in shared runtime infrastructure, currently centered on ServiceProvider-backed runtime state and session persistence.

Typical examples:

- logged user
- current selected customer index
- app readiness
- progress state
- persisted saved DNI

#### 5. Manual Coordination Points

Places where widget lifecycle or local logic currently bridges multiple ownership categories through explicit manual handling.

Typical examples:

- addPostFrameCallback
- listenManual
- setState used for feature lifecycle
- tracking last known global value to trigger reloads

---

## Validation

### Inventory Result — Startup / App Entry

#### File

- lib/main.dart

#### Current owned state

UI State:

- none of significance beyond loading rendering itself

Feature Functional State:

- `isInit`
- implicit startup progression owned by `_initWork()`

Derived State:

- runtime rendering decision derived from `appStatus.isProgress`
- runtime rendering decision derived from `appStatus.isReady`

Global Source State:

- `ref.watch(notifierServiceProvider)`
- `appStatus.isReady`
- `appStatus.isProgress`
- `appStatus.initStage`

Manual Coordination Points:

- `addListener()` in `initState()`
- `WidgetsBinding.instance.addPostFrameCallback(...)`
- `_initWork()` calling popup-based initialization
- local `setState(() => isInit = false)`

#### Ownership assessment

The startup page currently owns more than pure rendering.

It owns part of the app initialization boundary and participates in the transition into the authenticated runtime surface.

This confirms that Phase 7.2 must include startup/auth boundary cleanup, not only feature-widget cleanup.

#### Target ownership direction

- startup rendering may remain in presentation
- startup coordination state should become more explicitly bounded
- startup/auth transition should be documented as part of a shared initial-boundary concern, not as isolated widget-local behavior

---

### Inventory Result — Auth Feature

#### Files

- lib/features/auth/presentation/login_widget.dart
- lib/features/auth/controllers/login_controller.dart

#### Current owned state in presentation

UI State:

- `_rememberMe`
- `_shakeKey`
- `_dniController`

Feature Functional State:

- `_loading`
- widget-local execution of `_checkAutoLogin()`

Derived State:

- `initialState` returned by `prepareInitialState()`
- interpretation of `shouldAutoSubmit`

Global Source State:

- persisted DNI through `SessionStorage` access invoked by controller
- login result originating from `ServiceProvider.doLogin(...)`

Manual Coordination Points:

- `addPostFrameCallback(...)` in `initState()`
- local `setState(...)` before and after autologin preparation
- local `setState(...)` before and after login attempt
- inline widget reaction to login result

#### Ownership assessment

Auth improved significantly in Phase 7.1, because request orchestration and persistence coordination moved into the controller.

However, the presentation layer still coordinates the initial auth-entry lifecycle:

- prepare initial state
- hydrate field value
- decide rememberMe
- decide autosubmit path
- transition loading state between bootstrap and interactive login modes

This means auth still mixes:

- UI state
- feature functional state
- derived initial state

#### Target ownership direction

- input and visual feedback can remain in presentation
- initial auth-entry coordination should be clarified as feature functional state
- startup/auth initialization boundary should be addressed together in 7.2.4

---

### Inventory Result — Dashboard Feature

#### Files

- lib/features/dashboard/presentation/dashboard_page.dart
- lib/features/dashboard/controllers/dashboard_controller.dart

#### Current owned state in controller/presentation boundary

UI State:

- dashboard-local visual rendering concerns only
- no large widget-local feature execution state observed as a primary risk hotspot

Feature Functional State:

- customer selection delegation
- logout delegation

Derived State:

- active client resolution
- active client display name
- client option list construction

Global Source State:

- `loggedUser`
- `loggedUser.clientes`
- `loggedUser.cCliente`
- session clear + logout dependency path

Manual Coordination Points:

- direct derivation from `ref.watch(notifierServiceProvider).loggedUser`
- controller depends on `WidgetRef` at resolve time
- derived state is recomputed from shared runtime state during widget build consumption

#### Ownership assessment

Dashboard is already cleaner than billing.

Its main remaining debt is not manual reload coordination but derivation boundary clarity.

The derived state exists and is already centralized in the controller, which is good.

But the source/derived/rendering boundary is still implicit rather than formally normalized.

#### Target ownership direction

- keep derivation feature-local
- make source vs derived boundary explicit
- avoid widening dashboard into a global state abstraction prematurely
- normalize how derived state is consumed in 7.2.3

---

### Inventory Result — Billing Feature

#### Files

- lib/features/billing/presentation/billing_widget.dart
- lib/features/billing/controllers/billing_controller.dart

#### Current owned state in presentation

UI State:

- table rendering inputs
- widget-local display and interaction concerns

Feature Functional State:

- `dThreadHashID`
- `isInit`
- `tEnteDataModel`
- `hasError`
- `errorHandler`
- `_lastCCliente`

Derived State:

- billing reload necessity inferred from selected customer change
- table rows derived from loaded billing data

Global Source State:

- currently selected customer through ServiceProvider-backed user state
- request execution delegated through controller and ServiceProvider path

Manual Coordination Points:

- `ref.listenManual(...)`
- `setState(...)` around load lifecycle
- local comparison of `_lastCCliente`
- manual reload triggering
- `unawaited(...)` refresh path
- mixed reliance on provider watching plus manual coordination

#### Ownership assessment

Billing is the clearest state-boundary hotspot in the current ZIP.

Phase 7.1 removed backend-facing request preparation from the widget, which was correct.

But the widget still owns a broad set of functional coordination responsibilities.

That makes billing the safest and highest-value first implementation target for Phase 7.2 after this inventory step.

#### Target ownership direction

- keep visual/table rendering in presentation
- move or formalize feature functional state boundary away from scattered widget-local coordination
- reduce the need for manual listen/reload coupling
- preserve current runtime behavior during consolidation

---

### Priority Validation

The real ZIP confirms the following safest order after this inventory:

1. Billing State Boundary Consolidation
2. Dashboard State Derivation Normalization
3. Auth & Startup Initial State Boundary Cleanup
4. Formal closure

#### Why billing first

Because it contains the largest concentration of:

- feature functional state
- manual coordination
- widget-owned lifecycle handling
- explicit customer-change synchronization logic

#### Why dashboard second

Because its remaining issue is important but narrower:

- derivation normalization
- not the same level of manual widget-side coordination risk

#### Why auth and startup must be combined

Because the real runtime splits the initial boundary across:

- lib/main.dart
- login widget
- session persistence
- ServiceProvider-backed app state

Treating auth initial cleanup without startup would leave the boundary half-defined.

---

## Release Impact

This subphase does not modify runtime behavior.

There is no release-impacting code change.

Its release value is architectural safety:

- clearer next-step targeting
- lower risk of regression in future state-boundary work
- explicit documentation of real ownership instead of assumed ownership

---

## Risks

### If ownership is misclassified

Later implementation steps could:

- move UI state unnecessarily
- leave feature functional state trapped in widgets
- duplicate derived state
- create startup/auth regressions
- increase coupling instead of reducing it

### If this step is treated as optional

The team could jump into state consolidation with incomplete assumptions, especially around:

- billing reload semantics
- dashboard derivation
- startup/auth transition ownership

### Mitigation

- treat this inventory as the baseline contract for Phase 7.2
- use only code-backed ownership statements
- keep later implementation incremental and scoped by this document

---

## What it does NOT solve

This subphase does not:

- refactor billing state yet
- refactor dashboard derivation yet
- refactor auth initial state yet
- refactor startup state yet
- introduce new providers or state stores
- redesign ServiceProvider
- centralize app flow ownership

It only documents the real ownership baseline required for those future steps.

---

## Conclusion

Phase 7.2.1 confirms that the project is ready for state-boundary work, but not for a broad or blind state redesign.

The inventory validates four key conclusions:

- Billing is the main feature-functional-state hotspot
- Dashboard mainly needs derived-state normalization
- Auth still mixes UI state with initial feature coordination
- Startup participates in the same initial boundary and must be included explicitly in scope

Therefore, the correct continuation after this step is:

- 7.2.2 — Billing State Boundary Consolidation

And the correct adjusted wording for the later auth cleanup step is:

- 7.2.4 — Auth & Startup Initial State Boundary Cleanup