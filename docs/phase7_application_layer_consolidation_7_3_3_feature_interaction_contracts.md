# 🤝 Phase 7.3.3 — Feature Interaction Contracts

## Objective

Make the already-existing cross-feature interactions of Mi IP·RED explicit through lightweight and conservative feature interaction contracts so that startup, auth, dashboard, billing, logout, and shared runtime-context consumption stop depending only on distributed implicit semantics while preserving the current runtime contract.

## Initial Context

Phase 7.1 extracted feature-local controllers from the main runtime surfaces.

Phase 7.2 clarified ownership boundaries for:

- billing feature state
- dashboard derived state
- auth bootstrap and submit state
- startup initial boundary

Phase 7.3.1 documented the real application flows currently active in the codebase.

Phase 7.3.2 normalized the semantics and read paths of the shared contexts used by those flows.

At that point, the project already had enough clarity to expose one additional remaining architectural concern:

- the interactions already existed
- the flows already worked
- the context meanings were already clearer
- but the interaction meaning was still distributed rather than explicitly frozen

This subphase addresses that remaining gap conservatively.

## Problem Statement

The current codebase already contains real cross-feature interactions.

However, those interactions were still represented mainly through:

- runtime mutations
- downstream listeners
- consumer-local decisions
- distributed flow knowledge

That created a remaining risk:

- future work could preserve mechanics while changing intended meaning
- future coordinator work could be introduced before the current interactions were frozen as contracts
- downstream behavior could remain “working” while becoming architecturally ambiguous again

The problem was not that the system lacked interactions.

The problem was that the system still lacked an explicit contract baseline for interactions that already existed.

## Scope

This subphase includes:

- a lightweight declarative contract baseline in code
- explicit contract definitions for the real interactions visible in the current ZIP
- documentation updates freezing those contracts as the current architectural baseline

This subphase does not include:

- coordinator implementation
- event bus implementation
- runtime contract execution
- ServiceProvider redesign
- backend flow redesign
- navigation redesign
- UI redesign
- widget-level orchestration changes

## Root Cause Analysis

This issue existed because Mi IP·RED evolved in the correct pragmatic order:

1. make runtime work
2. protect backend flow
3. normalize structure
4. extract feature-local logic
5. clarify state ownership
6. inventory flows
7. normalize context semantics
8. only then freeze interaction meaning as explicit contracts

That sequencing matters.

If contracts had been introduced earlier, they would likely have been built on top of unstable or ambiguous boundaries.

If coordinator work were introduced now without contracts, it would risk coordinating semantics that were still only implicit.

The current ZIP shows that the missing piece was not mechanics.

The missing piece was explicit declared meaning.

## Files Affected

### Runtime files changed

- `lib/features/contracts/feature_interaction_contracts.dart`

### Documentation files changed

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_3_feature_interaction_contracts.md`

## Implementation Characteristics

### 1. Declarative Contract Baseline

A new lightweight declarative contract file is introduced:

- `lib/features/contracts/feature_interaction_contracts.dart`

This file is intentionally:

- immutable
- lightweight
- declarative
- non-owning
- non-reactive
- non-executing

It exists to anchor interaction meaning, not to execute runtime coordination.

### 2. Contract A — Active Client Change

This contract freezes the meaning of the current dashboard → billing downstream interaction.

#### Producer
- `DashboardController.selectClient(...)`

#### Consumer
- billing downstream runtime listener and billing controller decision path

#### Trigger
- active client index changes in `ServiceProvider`

#### Expected effect
- billing reloads feature-local state for the new active operational context

#### Current mechanism
- dashboard mutates `ServiceProvider` through `setCurrentCliente(...)`
- billing listens to runtime source changes
- billing decides reload locally

#### Important boundary
This contract does not mean dashboard calls billing directly.
It means dashboard produces an active operational context change that billing consumes downstream.

### 3. Contract B — Logout Reset

This contract freezes the meaning of logout as an application reset interaction.

#### Producer
- `DashboardController.logout(...)`

#### Consumer
- unauthenticated runtime continuation

#### Trigger
- user logout action

#### Expected effect
- remembered login hint is removed
- authenticated runtime context is reset
- app returns to unauthenticated runtime flow

#### Current mechanism
- explicit storage cleanup
- `ServiceProvider.logout()`
- backend-status reentry

#### Important boundary
This contract is broader than a dashboard UI action, but it still does not require coordinator logic in this phase.

### 4. Contract C — Auth Resolution

This contract freezes the meaning of the startup/auth/runtime bridge.

#### Producer
- runtime auth requirement path

#### Consumer
- authenticated runtime continuation

#### Trigger
- startup/backend-status path determines that auth is required

#### Expected effect
- auth flow resolves whether authenticated runtime continuation can proceed

#### Current mechanism
- provider-driven auth requirement triggers login popup
- login submit flow runs through `LoginController`
- `ServiceProvider.doLoginCallback()` materializes authenticated runtime context

#### Important boundary
This contract does not redesign startup or popup flow.
It documents the bridge they already implement.

### 5. Contract D — Shared Runtime Context Read

This contract freezes what Phase 7.3.2 already normalized.

#### Producer / owner
- `ServiceProvider`

#### Consumers
- dashboard
- billing
- future feature controllers needing shared runtime context

#### Trigger
- a feature needs authenticated or active operational context

#### Expected effect
- the feature reads shared runtime context only through explicit read-only access paths

#### Current mechanism
- explicit accessors such as:
  - `authenticatedUser`
  - `hasAuthenticatedRuntimeContext`
  - `activeClientIndex`
  - `activeClient`
  - `activeCompany`
  - `availableClients`

#### Important boundary
This contract prevents regression back to raw provider-shape coupling as the informal long-term pattern.

### 6. Code Strategy

The code strategy for 7.3.3 is intentionally narrow.

The project introduces:

- a contract identifier enum
- a small immutable contract model
- a static registry of active contracts

The project does not introduce:

- runtime dispatch
- contract execution
- coordinator callbacks
- new listeners
- feature-to-feature direct calls

### 7. Documentation Strategy

The documentation now freezes:

- which contracts currently exist
- what each contract means
- what each contract does not mean
- which current mechanism implements each contract
- which ownership boundaries remain unchanged

This is the primary protection that 7.3.3 adds before 7.3.4.

## Validation

A valid 7.3.3 implementation must preserve all previous runtime behavior while making the current interactions explicit.

The current implementation should be validated through:

### Runtime preservation

- startup still works exactly as before
- auth popup flow still works exactly as before
- dashboard still changes active client exactly as before
- billing still reloads exactly as before
- logout still resets runtime exactly as before

### Contract baseline preservation

- active client change is explicitly declared
- logout reset is explicitly declared
- auth resolution is explicitly declared
- shared runtime context read rule is explicitly declared

### Ownership preservation

- `ServiceProvider` still owns shared runtime context
- dashboard still does not own billing state
- billing still does not own active client context
- startup boundary still remains in `main.dart`

### Infrastructure preservation

- no coordinator exists yet
- no event bus exists yet
- no runtime contract engine exists
- no state-management redesign exists

## Release Impact

This subphase has no intended user-facing runtime change.

Its practical impact is architectural:

- current interaction meaning becomes explicit
- future regression becomes easier to detect
- future coordinator work can be scoped much more safely
- current distributed coordination is frozen as explicit architecture rather than undocumented behavior

## Risks

The main risks of this subphase were:

- over-engineering the contract layer into a runtime engine
- smuggling coordinator behavior into a declarative layer
- confusing declarative contracts with ownership transfer
- inventing contracts not justified by the current ZIP

The implemented approach avoids those risks by remaining narrow, immutable, and descriptive.

## What it does NOT solve

This subphase does not solve:

- minimal application coordinator implementation
- runtime interaction engine
- backend-authenticated persistent sessions
- event-driven runtime architecture
- automated flow-level contract tests

Those belong to later subphases.

## Conclusion

Phase 7.3.3 is now implemented as a conservative contract baseline over interactions that already existed in the project.

It does not redesign runtime mechanics.

It freezes their meaning.

The resulting baseline is now safer for future work because Mi IP·RED explicitly recognizes and declares:

- active client change
- logout reset
- auth resolution
- shared runtime context read

as real current feature interaction contracts before any later coordination mechanism is introduced.