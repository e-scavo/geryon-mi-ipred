# 🛠️ Development Guidelines

## Objective

Define the active implementation rules for Mi IP·RED so that future work preserves runtime stability, respects the current architecture validated in code, and evolves the application layer incrementally without reintroducing ambiguity that earlier phases already removed.

## Initial Context

Mi IP·RED is an already working application.

Its current codebase has already gone through:

- structural cleanup
- ServiceProvider decomposition and protection
- presentation-layer normalization
- feature-local controller extraction
- state ownership clarification

The project is now entering Phase 7.3.

That means the main architectural risk has shifted.

The system is no longer mainly threatened by feature-local logic living in widgets.

The main visible risk now is implicit coordination between already-separated runtime surfaces.

## Problem Statement

After Phase 7.1 and Phase 7.2, the project has better boundaries inside each feature.

However, application flows still span several files and owners.

Examples visible in the real code include:

- startup bootstrap path in `main.dart`
- backend-status to login decision in `ServiceProvider`
- login popup and auto-submit behavior in auth
- dashboard-driven client change propagating to billing through runtime state
- logout clearing session storage and then re-entering backend status flow

Without explicit development rules, future work could accidentally:

- reintroduce business-adjacent logic into widgets
- overload ServiceProvider with app-coordination responsibilities
- create a broad coordinator too early
- blur the distinction between session persistence, authenticated runtime context, active client, and startup readiness

## Scope

These guidelines apply to:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/models/ServiceProvider/**`
- `lib/core/session/**`
- phase documentation related to Phase 7

These guidelines do not authorize by themselves:

- backend protocol changes
- ServiceProvider redesign
- navigation redesign
- UI redesign
- full state-management replacement
- broad new application-layer infrastructure without explicit phase justification

## Root Cause Analysis

Mi IP·RED evolved correctly in practical order:

1. make the runtime work
2. protect backend flow
3. organize structure
4. extract feature-local logic
5. clarify state ownership
6. only then inventory coordination between already-separated features

This order matters.

If a coordination layer had been introduced before feature-local extraction and ownership clarification, the project would likely have created abstractions on top of unstable boundaries.

Phase 7.3 is valid precisely because Phase 7.1 and Phase 7.2 are already complete.

## Files Affected

Runtime areas governed by these rules:

- `lib/main.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/core/session/session_storage.dart`

Documentation governed by these rules:

- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`

## Implementation Characteristics

### 1. Runtime Preservation Rule

The backend/runtime contract remains the highest-priority constraint.

This includes preserving:

- startup initialization behavior
- handshake and channel subscription flow
- backend status validation
- login request/response behavior
- authenticated user materialization
- client selection propagation
- billing reload behavior
- logout fallback to backend-status flow

No cleanup or coordination work may silently change those semantics.

### 2. Active Architectural Shape

The active architectural interpretation remains:

presentation → controller → ServiceProvider

This shape is still valid.

Presentation may:

- render UI
- capture user interaction
- host strictly local widget concerns
- host reactive bindings to runtime state where already required by the implementation

Controllers may:

- own feature-local orchestration
- normalize inputs
- derive feature-local render-ready state
- dispatch to ServiceProvider where required by the existing runtime

ServiceProvider may:

- remain the protected backend/runtime source
- own backend interaction flow
- own authenticated runtime context
- own current active client context
- notify downstream listeners

### 3. Feature-Local Logic Must Stay Feature-Local

Feature-local logic must not be pushed back into widgets.

Examples:

- auth submit preparation belongs in `LoginController`
- dashboard source-to-derived resolution belongs in `DashboardController`
- billing feature-state transitions belong in `BillingController`

This remains true during and after Phase 7.3.1.

### 4. Cross-Feature Coordination Must Be Named Explicitly

Cross-feature interaction is now a first-class architecture concern.

That means any dependency between features or between a feature and the global runtime source must be understood in explicit terms such as:

- startup flow dependency
- authenticated runtime transition
- session/app-context transition
- downstream feature refresh dependency
- application-flow sequencing

This does not yet require a new coordinator.

It does require explicit naming and documentation.

### 5. Do Not Introduce a Broad Coordinator Prematurely

Phase 7.3.1 is an inventory step.

Therefore, it does not justify:

- a global app coordinator
- a new application service layer
- a broad provider redesign
- a ServiceProvider replacement
- a new navigation architecture

A future minimal coordinator is only valid if the inventory proves a repeated coordination concern that cannot remain safely distributed.

### 6. Startup Rule

`main.dart` currently owns the startup boundary.

That includes:

- `AppStartupViewState`
- bootstrap rendering
- launching `_initWork()`
- determining when the startup boundary has completed

It must not start absorbing unrelated feature coordination logic beyond startup entry behavior.

### 7. Auth Rule

Auth currently remains split correctly across three responsibilities:

#### Auth presentation
- user input
- local widget feedback
- visual loading behavior
- popup rendering

#### Auth controller
- initial state construction
- bootstrap-prepared state
- manual submit loading state
- submit failure state recovery
- login request dispatch preparation

#### ServiceProvider
- actual backend login request
- callback processing
- authenticated runtime context materialization

That split must be preserved.

### 8. Dashboard Rule

Dashboard currently owns feature-local derivation from the watched runtime source.

That means:

#### Dashboard presentation
- watches `notifierServiceProvider`
- renders responsive dashboard UI
- dispatches client selection
- dispatches logout

#### Dashboard controller
- builds `DashboardSourceState`
- resolves `DashboardResolvedState`
- normalizes active-client selection
- defines display data and options
- exposes select-client and logout helpers

Dashboard may trigger downstream effects indirectly through runtime-state mutation, but it must not absorb billing logic.

### 9. Billing Rule

Billing remains a feature with:

- explicit feature-local state
- a runtime-triggered reload dependency on current client context

That means:

#### Billing presentation
- manages local scroll/widget concerns
- attaches a listener to the runtime source
- renders loading/error/ready states

#### Billing controller
- owns billing feature-state transitions
- resolves bootstrap decision
- resolves client-change reload decision
- performs billing reload orchestration

Billing must not become the owner of active-client context.

### 10. Session and App Context Rule

The current runtime contains several related but distinct concepts:

- persisted DNI in `SessionStorage`
- authenticated runtime user in `ServiceProvider.loggedUser`
- active client in `loggedUser.cCliente`
- provider readiness in `ServiceProvider.isReady`
- startup-boundary completion in `AppStartupViewState`

Until a later subphase explicitly normalizes them, they must remain documented as distinct responsibilities.

### 11. Validation Rule

Any future implementation after this point should validate at minimum:

- startup bootstrap
- login popup path
- auto-submit path with saved DNI
- manual login path
- dashboard render after authenticated context exists
- client switch from dashboard
- billing reload after client switch
- logout and return to unauthenticated path

## Validation

These rules are valid only if they remain aligned with the current ZIP.

At the current baseline, the code confirms:

- startup boundary still lives in `main.dart`
- login decision bridge still lives in `ServiceProvider`
- login feature still owns popup submit behavior
- dashboard still drives active-client selection
- billing still reacts to active-client changes via runtime source
- logout still clears session storage and resets runtime auth flow

## Release Impact

These guidelines do not change runtime behavior.

They reduce the risk of architectural regressions during the next subphases of Phase 7.3.

## Risks

The main risks from this point forward are:

- over-engineering coordination too early
- hiding feature interaction under vague global refresh behavior
- reintroducing feature logic into widgets
- turning ServiceProvider into both backend engine and broad application coordinator
- collapsing several runtime concepts into one imprecise “session” notion

## What it does NOT solve

This document does not by itself solve:

- session/app-context normalization
- explicit feature interaction contracts
- the introduction of a minimal coordinator
- flow-level automated tests

Those belong to later validated subphases.

## Conclusion

The active development rule is now:

- keep feature logic local
- keep runtime source protected
- document cross-feature coordination explicitly
- inventory real flows before abstracting them
- introduce no new global coordination layer unless the real code proves it is necessary