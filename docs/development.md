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
- feature interaction contract freezing

The project is now in Phase 7.3.4.

That means the most visible architectural risk is no longer only implicit flows, vague context semantics, or undeclared interaction meaning.

The next visible risk is leaving selected application transitions distributed across runtime surfaces that are broader than the ideal semantic owner for app-level coordination.

## Problem Statement

After Phase 7.3.3, the real ZIP shows that the app already has:

- explicit feature-local boundaries
- explicit state ownership
- explicit shared-context semantics
- explicit declarative interaction contracts

However, selected coordination concerns still remain too distributed in execution terms.

The two safest currently validated examples are:

- billing downstream refresh coordination
- logout reset coordination

Without a minimal coordination anchor, those transitions remain semantically broader than the surfaces currently expressing them.

## Scope

These guidelines apply to:

- `lib/features/billing/**`
- `lib/features/dashboard/**`
- `lib/features/contracts/**`
- `lib/models/ServiceProvider/**`
- `lib/core/session/**`
- phase documentation related to Phase 7

These guidelines do not authorize by themselves:

- backend protocol changes
- ServiceProvider redesign
- navigation redesign
- UI redesign
- startup/auth coordinator redesign
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
8. freeze interaction meaning as contracts
9. only then introduce a minimal execution anchor for the safest coordination concerns

This order matters.

If a coordinator had been introduced earlier, it would likely have coordinated unstable or still-implicit boundaries.

If a broad coordinator were introduced now, it would exceed the real problem shown by the ZIP.

## Files Affected

Runtime areas governed by these rules:

- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/contracts/feature_interaction_contracts.dart`
- `lib/features/contracts/application_coordinator.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/core/session/session_storage.dart`
- `lib/core/session/session_storage_io.dart`
- `lib/core/session/session_storage_web.dart`

Documentation governed by these rules:

- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_3_feature_interaction_contracts.md`
- `docs/phase7_application_layer_consolidation_7_3_4_application_coordinator_minimal.md`

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

No coordination work may silently change those semantics.

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
- delegate narrow application-level coordination only when the coordinator now owns that semantic transition

ServiceProvider may:

- remain the protected backend/runtime source
- own backend interaction flow
- own authenticated runtime context
- own active operational context
- notify downstream listeners

The coordinator introduced in 7.3.4 does not alter this shape.

### 3. Feature-Local Logic Must Stay Feature-Local

Feature-local logic must not be pushed back into widgets and must not be absorbed by the coordinator.

Examples:

- auth submit preparation belongs in `LoginController`
- dashboard source-to-derived resolution belongs in `DashboardController`
- billing feature-state transitions belong in `BillingController`

This remains true during and after Phase 7.3.4.

### 4. Shared Context Concepts Must Remain Explicitly Separate

The project continues to treat the following as distinct concepts:

#### StartupBoundaryContext
Owned by `main.dart` through `AppStartupViewState`.

#### PersistedLoginHintContext
Owned by `SessionStorage`.

#### AuthenticatedRuntimeContext
Owned by `ServiceProvider`.

#### ActiveOperationalContext
Owned by `ServiceProvider`.

These concepts must not be casually merged or re-owned by the coordinator.

### 5. Persisted Login Hint Lifecycle Must Stay Symmetric

Remember-me behavior remains symmetric.

That means:

- successful login with remember-me enabled saves the normalized DNI
- successful login with remember-me disabled removes any previously stored DNI hint
- logout removes the remembered DNI explicitly

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

### 7. Feature Interaction Contracts Remain Declarative

The contract layer introduced in 7.3.3 remains:

- declarative
- lightweight
- non-owning
- non-reactive
- non-executing

It still must not become:

- a contract runtime engine
- a new event bus
- a hidden coordinator
- a new state-management layer

### 8. The 7.3.4 Coordinator Must Remain Narrow

The application coordinator introduced in 7.3.4 must remain:

- minimal
- explicit
- non-owning
- narrowly scoped
- easy to audit

It must coordinate only the currently justified safe transitions:

- billing downstream refresh coordination
- logout reset coordination

It must not expand into:

- startup/auth continuation coordination
- navigation coordination
- routing ownership
- global orchestration engine
- state machine infrastructure

### 9. Coordinator Does Not Own State

The coordinator does not own:

- feature state
- shared runtime state
- widget lifecycle
- backend flow

Its role is limited to anchoring selected application-level coordination semantics.

Examples:

- billing widget still owns lifecycle and rendering
- billing controller still owns billing feature-state transitions
- dashboard controller still owns dashboard-local intent production
- ServiceProvider still owns runtime reset and runtime context lifecycle

### 10. Billing Rule After 7.3.4

Billing remains a feature with:

- explicit feature-local state
- a runtime-triggered dependency on active client context

After 7.3.4:

#### Billing presentation
- still attaches the listener
- still renders
- still owns widget lifecycle
- no longer remains the main semantic home of the billing downstream coordination rule

#### Billing controller
- still owns feature-state transitions
- still owns billing load and reload execution
- still owns render-data helpers

#### Application coordinator
- now owns the narrow app-level decision surface for:
  - billing bootstrap coordination
  - billing active-client-change coordination

### 11. Dashboard Rule After 7.3.4

Dashboard remains the feature that produces:

- active client change intent
- logout intent

After 7.3.4:

- dashboard controller may delegate logout reset coordination to the coordinator
- dashboard still does not own global runtime reset
- dashboard still does not own downstream billing state

### 12. Startup/Auth Must Stay Out of 7.3.4 Scope

The current startup/auth/runtime continuation path remains out of scope for 7.3.4.

It spans:

- `main.dart`
- provider-driven auth requirement flow
- popup login route
- authenticated continuation

That surface remains intentionally untouched in this subphase.

### 13. Validation Rule

Any future implementation after this point should validate at minimum:

- startup bootstrap
- login popup path
- auto-submit path with saved DNI
- manual login path
- dashboard render after authenticated context exists
- client switch from dashboard
- billing reload after client switch
- logout and return to unauthenticated path

It should also preserve the narrow scope of the coordinator.

## Validation

These rules are valid only if they remain aligned with the current ZIP.

At the current baseline, the code confirms:

- startup/auth remains untouched
- persisted login hint remains explicit and narrow
- authenticated runtime context remains owned by `ServiceProvider`
- active company/client context remains owned by `ServiceProvider`
- billing downstream coordination now reads through a coordinator decision surface
- logout reset now delegates the app-level transition to the coordinator
- no broad coordination infrastructure was introduced

## Release Impact

These guidelines do not redesign runtime behavior.

They reduce the risk of semantic drift while the project approaches formal closure of Phase 7.3.

## Risks

The main risks from this point forward are:

- over-expanding the coordinator scope
- moving ownership accidentally
- confusing the coordinator with a global orchestration engine
- reintroducing coordination semantics into widgets after extracting them
- letting startup/auth slip into this narrow coordinator scope without separate justification

## What it does NOT solve

This document does not by itself solve:

- startup/auth coordinator redesign
- backend-persisted authenticated sessions
- event-driven runtime architecture
- flow-level automated tests

Those remain outside the safe scope of this subphase.

## Conclusion

The active development rule is now:

- keep feature logic local
- keep runtime source protected
- keep context concepts explicit and separate
- keep contracts declarative
- keep the coordinator minimal, explicit, and non-owning
- use it only where the ZIP already justifies a narrow application-level transition anchor