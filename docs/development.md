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
- minimal coordination anchoring

The project has now formally closed Phase 7.3.

That means the coordination concerns that justified opening Phase 7.3 are no longer open phase-level debt.

The new baseline is explicit and stable.

## Problem Statement

Without updated development rules after formal closure, future work could accidentally:

- reopen already-resolved coordination concerns
- expand the minimal coordinator beyond its intended scope
- regress to raw runtime coupling
- push app-level semantics back into widgets
- blur the difference between preserved ownership and coordination anchoring

The purpose of this document is to freeze the correct post-7.3 interpretation.

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
- broad coordinator expansion
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
9. introduce a minimal coordination anchor only for the safest justified transitions
10. formally close the full coordination phase

This order matters.

The project is now past the phase where coordination meaning was the active unresolved concern.

The project now has a documented coordination baseline that must be preserved.

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
- `lib/features/contracts/application_coordinator.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/core/session/session_storage.dart`
- `lib/core/session/session_storage_io.dart`
- `lib/core/session/session_storage_web.dart`

Documentation governed by these rules:

- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_5_formal_closure.md`

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

No future coordination or cleanup work may silently change those semantics.

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
- delegate only the narrow coordination concerns already anchored in the minimal coordinator

ServiceProvider may:

- remain the protected backend/runtime source
- own backend interaction flow
- own authenticated runtime context
- own active operational context
- notify downstream listeners

The coordinator does not alter this shape.

### 3. Feature-Local Logic Must Stay Feature-Local

Feature-local logic must not be pushed back into widgets and must not be absorbed by the coordinator.

Examples:

- auth submit preparation belongs in `LoginController`
- dashboard source-to-derived resolution belongs in `DashboardController`
- billing feature-state transitions belong in `BillingController`

This remains true after formal closure of Phase 7.3.

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

It must not become:

- a contract runtime engine
- a new event bus
- a hidden coordinator
- a new state-management layer

### 8. The Minimal Coordinator Remains Narrow

The application coordinator introduced in 7.3.4 must remain:

- minimal
- explicit
- non-owning
- narrowly scoped
- easy to audit

It remains justified only for:

- billing downstream refresh coordination
- logout reset coordination

It must not be expanded casually into:

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

Its role remains limited to anchoring the narrowest already-validated application-level coordination semantics.

### 10. Post-7.3 Billing Rule

Billing remains a feature with:

- explicit feature-local state
- a runtime-triggered dependency on active client context

After Phase 7.3 closure:

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
- remains the narrow app-level decision surface for:
  - billing bootstrap coordination
  - billing active-client-change coordination

### 11. Post-7.3 Dashboard Rule

Dashboard remains the feature that produces:

- active client change intent
- logout intent

After Phase 7.3 closure:

- dashboard controller may continue delegating logout reset coordination to the coordinator
- dashboard still does not own global runtime reset
- dashboard still does not own downstream billing state

### 12. Startup/Auth Must Remain Out of the Minimal Coordinator Scope

The current startup/auth/runtime continuation path remains intentionally outside the minimal coordinator scope.

It spans:

- `main.dart`
- provider-driven auth requirement flow
- popup login route
- authenticated continuation

That surface remains intentionally untouched by the minimal coordinator and should not be pulled into it without a separate justified phase.

### 13. Validation Rule

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

It should also preserve the narrow scope of the coordinator and the declarative nature of the contracts.

## Validation

These rules are valid only if they remain aligned with the current ZIP.

At the current baseline, the code confirms:

- startup/auth remains untouched by the minimal coordinator
- persisted login hint remains explicit and narrow
- authenticated runtime context remains owned by `ServiceProvider`
- active company/client context remains owned by `ServiceProvider`
- billing downstream coordination reads through a narrow coordinator surface
- logout reset delegates through a narrow coordinator surface
- no broad coordination infrastructure was introduced

## Release Impact

These guidelines do not redesign runtime behavior.

They freeze the coordination baseline that resulted from Phase 7.3 and reduce the risk of semantic drift in later work.

## Risks

The main risks from this point forward are:

- over-expanding the coordinator scope
- moving ownership accidentally
- confusing the coordinator with a global orchestration engine
- reintroducing coordination semantics into widgets
- pulling startup/auth into the coordinator prematurely
- reopening already-closed 7.3 concerns without justification

## What it does NOT solve

This document does not by itself solve:

- startup/auth coordinator redesign
- backend-persisted authenticated sessions
- event-driven runtime architecture
- flow-level automated tests

Those remain outside the closed scope of Phase 7.3.

## Conclusion

The active development rule is now:

- keep feature logic local
- keep runtime source protected
- keep context concepts explicit and separate
- keep contracts declarative
- keep the coordinator minimal, explicit, and non-owning
- treat Phase 7.3 as formally closed and preserve its resulting baseline