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
- application-flow inventory

The project is now in Phase 7.3.2.

That means the most visible architectural risk is no longer only implicit flow coordination.

The next visible risk is semantic ambiguity around the different context concepts already shared across the runtime.

## Problem Statement

After Phase 7.3.1, the real ZIP shows that the app already distinguishes multiple runtime-related concepts in practice, but not yet through a normalized contract.

Those concepts include:

- startup boundary state
- persisted login hint state
- authenticated runtime context
- active operational context

Without explicit rules, future work could accidentally:

- treat persisted login hint as a real authenticated session
- keep deleting too much storage during logout
- keep coupling feature controllers to raw `ServiceProvider` fields
- build feature contracts on top of ambiguous semantics

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
6. inventory coordination between already-separated features
7. normalize shared context semantics only after the previous steps are stable

This order matters.

If shared-context normalization had been introduced before ownership and flow inventory were stabilized, the project would likely have created abstractions on top of unclear boundaries.

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
- `lib/core/session/session_storage_io.dart`
- `lib/core/session/session_storage_web.dart`

Documentation governed by these rules:

- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`
- `docs/phase7_application_layer_consolidation_7_3_2_session_app_context_normalization.md`

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
- own active operational context
- notify downstream listeners

### 3. Feature-Local Logic Must Stay Feature-Local

Feature-local logic must not be pushed back into widgets.

Examples:

- auth submit preparation belongs in `LoginController`
- dashboard source-to-derived resolution belongs in `DashboardController`
- billing feature-state transitions belong in `BillingController`

This remains true during and after Phase 7.3.2.

### 4. Shared Context Concepts Must Remain Explicitly Separate

The project now treats the following as distinct concepts:

#### StartupBoundaryContext
Owned by `main.dart` through `AppStartupViewState`.

This only represents whether the app can leave the startup boundary.

It is not a session concept.

#### PersistedLoginHintContext
Owned by `SessionStorage`.

This only represents the remembered DNI/CUIT hint used by auth bootstrap.

It is not an authenticated session.

#### AuthenticatedRuntimeContext
Owned by `ServiceProvider`.

This is represented by the in-memory authenticated user runtime state.

#### ActiveOperationalContext
Owned by `ServiceProvider`.

This represents the currently active company/client context used by downstream features.

These concepts must not be casually merged or renamed as if they were interchangeable.

### 5. Persisted Login Hint Lifecycle Must Be Symmetric

Remember-me behavior must be symmetric.

That means:

- successful login with remember-me enabled saves the normalized DNI
- successful login with remember-me disabled removes any previously stored DNI hint
- logout removes the remembered DNI explicitly instead of clearing all storage indiscriminately

This rule is now part of the active architecture baseline.

### 6. Shared Runtime Context Should Be Consumed Through Explicit Read Paths

Do not redesign `ServiceProvider`.

Do not move ownership out of it.

Do normalize reads through explicit read-only accessors when shared context is consumed by multiple features.

Examples now valid in the runtime:

- `authenticatedUser`
- `hasAuthenticatedRuntimeContext`
- `activeClientIndex`
- `activeClient`
- `hasActiveClientContext`
- `activeCompany`
- `availableClients`

This reduces implicit coupling without creating a new application layer.

### 7. Startup Rule

`main.dart` currently owns the startup boundary.

That includes:

- `AppStartupViewState`
- bootstrap rendering
- launching `_initWork()`
- determining when the startup boundary has completed

It must not start absorbing unrelated feature coordination logic beyond startup entry behavior.

### 8. Auth Rule

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
- persisted login hint normalization

#### ServiceProvider
- actual backend login request
- callback processing
- authenticated runtime context materialization

That split must be preserved.

### 9. Dashboard Rule

Dashboard currently owns feature-local derivation from the watched runtime source.

That means:

#### Dashboard presentation
- watches `notifierServiceProvider`
- renders responsive dashboard UI
- dispatches client selection
- dispatches logout

#### Dashboard controller
- builds source state
- resolves derived state
- normalizes active-client selection
- defines display data and options
- exposes select-client and logout helpers

Dashboard may now consume explicit read-only runtime context accessors instead of raw provider fields, but it still must not own global runtime context.

### 10. Billing Rule

Billing remains a feature with:

- explicit feature-local state
- a runtime-triggered reload dependency on active client context

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
- may consume normalized runtime context reads

Billing must not become the owner of active-client or company context.

### 11. Validation Rule

Any future implementation after this point should validate at minimum:

- startup bootstrap
- login popup path
- auto-submit path with saved DNI
- manual login path
- login with remember-me disabled after a previously remembered login
- dashboard render after authenticated context exists
- client switch from dashboard
- billing reload after client switch
- logout and return to unauthenticated path

## Validation

These rules are valid only if they remain aligned with the current ZIP.

At the current baseline, the code confirms:

- startup boundary still lives in `main.dart`
- persisted login hint still lives in `SessionStorage`
- authenticated runtime context still lives in `ServiceProvider`
- active company/client context still lives in `ServiceProvider`
- dashboard now reads normalized runtime-context accessors
- billing now reads normalized runtime-context accessors in its critical paths
- logout now clears remembered login hint explicitly instead of clearing all storage

## Release Impact

These guidelines do not redesign runtime behavior.

They reduce the risk of semantic regression during the next subphases of Phase 7.3.

## Risks

The main risks from this point forward are:

- over-engineering context normalization into a hidden coordinator
- confusing persisted login hint with authenticated runtime context again
- moving ownership accidentally out of `ServiceProvider`
- expanding logout cleanup beyond what it actually owns
- collapsing several runtime concepts into one imprecise “session” notion

## What it does NOT solve

This document does not by itself solve:

- backend-persisted authenticated sessions
- explicit feature interaction contracts
- the introduction of a minimal coordinator
- flow-level automated tests

Those belong to later validated subphases.

## Conclusion

The active development rule is now:

- keep feature logic local
- keep runtime source protected
- keep context concepts explicit and separate
- normalize persisted login hint lifecycle symmetrically
- consume shared runtime context through explicit read-only paths
- introduce no new coordination layer unless later subphases prove it is necessary