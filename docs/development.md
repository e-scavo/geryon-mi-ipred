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
- session and app-context normalization

The project is now in Phase 7.3.3.

That means the most visible architectural risk is no longer only implicit flow coordination or vague shared-context semantics.

The next visible risk is leaving real cross-feature interactions undocumented as contracts while later phases prepare to coordinate them more explicitly.

## Problem Statement

After Phase 7.3.2, the real ZIP shows that the app already has:

- explicit feature-local boundaries
- explicit state ownership
- explicit shared-context semantics
- explicit read-only runtime-context access paths

However, several cross-feature interactions are still represented mainly through:

- provider mutations
- runtime listeners
- local consumer decisions
- distributed knowledge across multiple files

Without explicit contract rules, future work could accidentally:

- preserve mechanics while changing interaction meaning
- introduce coordinator logic before current interaction meaning is frozen
- regress to vague cross-feature assumptions
- treat current distributed coordination as an incidental implementation detail rather than active architecture

## Scope

These guidelines apply to:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/**`
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
7. normalize shared context semantics
8. freeze feature interaction meaning as contracts before attempting coordinator work

This order matters.

If feature interaction contracts had been introduced earlier, they would likely have been built on top of unstable boundaries.

If coordinator work were introduced now without explicit contracts, it would risk coordinating mechanics whose meaning was still only implicit.

## Files Affected

Runtime areas governed by these rules:

- `lib/main.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/features/contracts/feature_interaction_contracts.dart`
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
- `docs/phase7_application_layer_consolidation_7_3_3_feature_interaction_contracts.md`

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

This remains true during and after Phase 7.3.3.

### 4. Shared Context Concepts Must Remain Explicitly Separate

The project continues to treat the following as distinct concepts:

#### StartupBoundaryContext
Owned by `main.dart` through `AppStartupViewState`.

This only represents whether the app can leave the startup boundary.

#### PersistedLoginHintContext
Owned by `SessionStorage`.

This only represents the remembered DNI/CUIT hint used by auth bootstrap.

#### AuthenticatedRuntimeContext
Owned by `ServiceProvider`.

This is represented by the in-memory authenticated user runtime state.

#### ActiveOperationalContext
Owned by `ServiceProvider`.

This represents the currently active company/client context used by downstream features.

These concepts must not be casually merged or renamed as if they were interchangeable.

### 5. Persisted Login Hint Lifecycle Must Stay Symmetric

Remember-me behavior remains symmetric.

That means:

- successful login with remember-me enabled saves the normalized DNI
- successful login with remember-me disabled removes any previously stored DNI hint
- logout removes the remembered DNI explicitly instead of clearing all storage indiscriminately

This rule remains part of the active architecture baseline.

### 6. Shared Runtime Context Must Continue to Be Read Through Explicit Read Paths

Do not redesign `ServiceProvider`.

Do not move ownership out of it.

Continue consuming shared runtime context through explicit read-only accessors when shared context is used by multiple features.

Examples valid in the runtime:

- `authenticatedUser`
- `hasAuthenticatedRuntimeContext`
- `activeClientIndex`
- `activeClient`
- `hasActiveClientContext`
- `activeCompany`
- `availableClients`

This reduces implicit coupling without creating a new application layer.

### 7. Feature Interaction Contracts Are Declarative, Not Executable

Phase 7.3.3 introduces explicit feature interaction contracts.

These contracts are:

- declarative
- lightweight
- non-owning
- non-reactive
- non-executing

They exist to freeze interaction meaning, not to dispatch runtime behavior.

They must not become:

- a contract runtime engine
- a new event bus
- a hidden coordinator
- a new state-management layer

### 8. Active Cross-Feature Contracts Must Remain Explicit

The current architecture now recognizes, at minimum, these active contracts:

#### Active Client Change Contract
Dashboard produces active client context changes.
Billing consumes downstream active client changes through the runtime source and reloads feature-local state.

#### Logout Reset Contract
Dashboard produces logout intent.
Runtime reset and unauthenticated continuation remain owned by ServiceProvider/runtime flow.

#### Auth Resolution Contract
Runtime auth requirement leads into auth flow, which resolves whether authenticated continuation can proceed.

#### Shared Runtime Context Read Contract
Consumers read shared runtime context through explicit read-only accessors.
Ownership remains in ServiceProvider.

These contracts must remain explicit as the system evolves.

### 9. Contracts Must Not Move Ownership

A contract does not change who owns the data or who owns the runtime flow.

Examples:

- active client change contract does not make dashboard own billing state
- logout reset contract does not make dashboard own global runtime reset
- auth resolution contract does not make auth UI own startup boundary
- shared runtime context read contract does not make consumers owners of provider state

Contracts only describe interaction meaning across existing ownership boundaries.

### 10. Startup Rule

`main.dart` currently owns the startup boundary.

That includes:

- `AppStartupViewState`
- bootstrap rendering
- launching `_initWork()`
- determining when the startup boundary has completed

It must not start absorbing unrelated feature coordination logic beyond startup entry behavior.

### 11. Auth Rule

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

### 12. Dashboard Rule

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

Dashboard may remain the producer of active client change and logout intent without becoming owner of downstream consumers or global runtime reset.

### 13. Billing Rule

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
- consumes normalized runtime context reads

Billing must not become the owner of active-client or company context.

### 14. Validation Rule

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

It should also preserve the explicit meaning of the active feature interaction contracts.

## Validation

These rules are valid only if they remain aligned with the current ZIP.

At the current baseline, the code confirms:

- startup boundary still lives in `main.dart`
- persisted login hint still lives in `SessionStorage`
- authenticated runtime context still lives in `ServiceProvider`
- active company/client context still lives in `ServiceProvider`
- dashboard continues to read normalized runtime-context accessors
- billing continues to read normalized runtime-context accessors in critical paths
- logout continues to clear remembered login hint explicitly
- the current interaction contracts can now be declared without changing runtime behavior

## Release Impact

These guidelines do not redesign runtime behavior.

They reduce the risk of semantic regression during the next subphases of Phase 7.3.

## Risks

The main risks from this point forward are:

- over-engineering declarative contracts into a runtime engine
- introducing coordinator behavior too early
- confusing contract declaration with ownership transfer
- regressing to vague cross-feature assumptions
- collapsing contract meaning back into raw runtime mechanics only

## What it does NOT solve

This document does not by itself solve:

- minimal application coordinator implementation
- backend-persisted authenticated sessions
- event-driven runtime architecture
- flow-level automated tests

Those belong to later validated subphases.

## Conclusion

The active development rule is now:

- keep feature logic local
- keep runtime source protected
- keep context concepts explicit and separate
- continue consuming shared runtime context through explicit read-only paths
- declare real interactions explicitly as contracts before introducing later coordination mechanisms