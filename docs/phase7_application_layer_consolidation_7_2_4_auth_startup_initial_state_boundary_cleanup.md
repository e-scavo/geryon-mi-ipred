# 🔐 Phase 7.2.4 — Auth & Startup Initial State Boundary Cleanup

## Objective

Clarify the initial runtime boundary shared by startup and auth so that bootstrap state, submit state, and pure UI state are no longer mixed implicitly across `main.dart`, `login_widget.dart`, and `login_controller.dart`, while preserving the current runtime sequence and the protected `ServiceProvider` contract.

---

## Initial Context

After Phase 7.1.1:

- login request orchestration had already been extracted into `LoginController`
- login presentation no longer owned the same amount of backend-adjacent logic as before

After Phase 7.2.1:

- auth and startup were identified as a shared initial-boundary concern
- unlike billing and dashboard, the remaining debt was not mainly request shaping or derivation normalization
- the remaining debt was the initial boundary between:
  - app startup
  - auth bootstrap
  - manual login interaction

After Phase 7.2.2 and 7.2.3:

- billing state ownership was clarified
- dashboard source-to-derived boundaries were clarified

This made auth/startup the correct next target for Phase 7.2.

---

## Problem Statement

Before this step, the initial runtime boundary remained partially implicit.

In `main.dart`:

- startup state was represented mainly by `isInit`
- bootstrap completion was coordinated through a generic local boolean
- the startup boundary was functionally meaningful but not explicitly modeled

In `login_widget.dart`:

- `_loading` represented both bootstrap autologin loading and manual submit loading
- `_rememberMe` lived beside feature-bootstrap decisions
- the widget still coordinated the initial auth-entry boundary more than it should

In `login_controller.dart`:

- initial persisted auth data was prepared, but the feature did not yet expose an explicit view-state boundary for login

The result was not a runtime bug, but an ownership ambiguity.

---

## Scope

### Included

- introduce an explicit startup boundary state in `main.dart`
- introduce an explicit auth view state in `login_controller.dart`
- separate auth bootstrap loading from manual submit loading
- simplify login presentation to consume a single auth feature state
- preserve the current startup and login runtime sequence

### Excluded

- ServiceProvider redesign
- navigation redesign
- UI redesign
- global application lifecycle redesign
- new provider/notifier architecture
- billing/dashboard changes
- backend flow changes

---

## Root Cause Analysis

The current ambiguity is the natural result of the earlier phase order.

That order was correct:

1. stabilize runtime
2. protect ServiceProvider
3. normalize structure
4. extract feature orchestration
5. normalize ownership boundaries afterward

For auth/startup, that meant the first extraction pass did not yet fully solve the initial-boundary problem.

It removed request orchestration from presentation, but it still left part of the startup/auth bootstrap state distributed across runtime surfaces.

The safe correction is not a global lifecycle redesign.

The safe correction is to make the initial boundary explicit while preserving the existing runtime triggers.

---

## Files Affected

### Runtime files

- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/main.dart`

### Documentation files

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_2_4_auth_startup_initial_state_boundary_cleanup.md`

---

## Implementation Characteristics

### 1. Explicit auth feature state introduced

A new feature-local auth state was introduced:

- `LoginViewState`

It centralizes:

- `dni`
- `rememberMe`
- `isBootstrapLoading`
- `isSubmitLoading`

This replaces the previous implicit split across widget-local flags.

---

### 2. Auth bootstrap result is now explicit

A new result model was introduced:

- `LoginBootstrapResult`

It carries:

- the prepared login view state
- whether autologin should be attempted

This makes the auth initial boundary more explicit without redesigning the underlying session logic.

---

### 3. Login controller now owns auth-state transitions

The controller now defines explicit auth transitions for:

- initial view state
- bootstrap-prepared state
- bootstrap-ready state
- manual submit loading state
- submit failure recovery state

This means login presentation no longer owns the same level of feature-state ambiguity.

---

### 4. Login widget keeps only UI-specific concerns plus one feature state

After this change, `LoginPageWidget` still owns legitimate UI concerns such as:

- `_dniController`
- `_shakeKey`

But it now consumes a single aggregated feature state:

- `_loginState`

This is the intended pattern for the phase.

---

### 5. Startup boundary is now explicitly modeled

A new local startup model was introduced in `main.dart`:

- `AppStartupViewState`

Its role is not to redesign startup flow.

Its role is to make explicit whether the initial startup boundary has already completed.

This replaces the earlier generic `isInit` ownership pattern with a clearer feature meaning.

---

### 6. Runtime trigger sequence intentionally preserved

This subphase does **not** remove or redesign:

- `addPostFrameCallback(...)`
- `ModelGeneralPoPUpLoadingProgress()`
- the current startup trigger structure
- the real login call path
- the protected `ServiceProvider` runtime source

This is a boundary clarification step, not a runtime redesign step.

---

## Validation

### Runtime behavior expected to remain intact

The following must remain unchanged:

- app startup still shows initial loading correctly
- startup popup flow still behaves as before
- remembered DNI still populates the login field
- autologin still happens when expected
- manual login still works
- invalid manual login still shows shake/snackbar behavior
- successful login still exits the popup correctly
- dashboard entry still occurs as before after startup readiness

### Focused validation points

#### Startup

- open the app from a cold start
- verify the startup loading behavior still appears correctly
- verify the app still reaches dashboard when startup completes

#### Login bootstrap

- test with saved DNI
- verify the input is hydrated
- verify autologin still attempts automatically

#### Manual login

- test without saved DNI
- verify the button is enabled once bootstrap completes
- verify invalid DNI still shows the same error feedback
- verify valid login still succeeds

#### Combined flow

- verify startup completion and auth flow still compose correctly
- verify no regression in the transition from initial load to authenticated runtime

---

## Release Impact

This subphase does not change the release surface of the application.

Its impact is internal and architectural:

- clearer initial-boundary ownership
- safer future maintenance of startup/auth flow
- better distinction between bootstrap state and interaction state

---

## Risks

### Risk 1 — break autologin semantics

If bootstrap and submit states are mixed incorrectly, autologin could stop working or behave inconsistently.

#### Mitigation

- keep the same `SessionStorage` usage
- keep the same login call path
- only normalize state representation and transitions

---

### Risk 2 — break startup completion behavior

If startup boundary state is modeled incorrectly, the app could remain blocked in loading.

#### Mitigation

- preserve the existing startup trigger
- preserve popup-based readiness flow
- only replace implicit boolean ownership with explicit local state

---

### Risk 3 — widen into lifecycle redesign

A larger refactor here could easily expand into a broader application lifecycle redesign.

#### Mitigation

- scope the change strictly to:
  - `main.dart`
  - `login_widget.dart`
  - `login_controller.dart`

---

## What it does NOT solve

This subphase does not:

- redesign the whole application lifecycle
- replace `ServiceProvider`
- introduce a new global auth provider
- redesign login UI
- redesign navigation
- finalize Phase 7.2 closure

It solves only the auth/startup initial-boundary ambiguity identified in Phase 7.2.1.

---

## Conclusion

Phase 7.2.4 clarifies the shared initial boundary between startup and auth without altering the validated runtime contract.

The current result is:

- startup boundary is explicit
- auth bootstrap boundary is explicit
- manual submit state is distinct from bootstrap state
- presentation keeps rendering and UI concerns
- controller owns auth feature-state construction and transitions

This is the intended low-risk outcome of the phase.

The next correct continuation, after local validation, is:

- `Phase 7.2.5 — Formal Closure of Phase 7.2`