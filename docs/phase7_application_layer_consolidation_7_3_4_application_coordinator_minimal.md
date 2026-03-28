# 🎛️ Phase 7.3.4 — Application Coordinator (mínimo)

## Objective

Introduce a minimal and narrowly scoped application coordination surface in Mi IP·RED so that the already-declared interaction contracts with the highest safe implementation value stop depending on distributed coordination semantics across presentation/runtime surfaces, while preserving the current ownership model and the current runtime contract.

## Initial Context

Phase 7.1 extracted feature-local controllers from the main runtime surfaces.

Phase 7.2 clarified ownership boundaries for:

- billing feature state
- dashboard derived state
- auth bootstrap and submit state
- startup initial boundary

Phase 7.3.1 documented the real application flows currently active in the codebase.

Phase 7.3.2 normalized the semantics and read paths of the shared contexts used by those flows.

Phase 7.3.3 froze the current cross-feature meaning as explicit declarative contracts.

At that point, the project already had enough clarity to expose one additional remaining architectural concern:

- the interactions already existed
- the meanings were already clearer
- the contracts were already declared
- but a small number of execution-level coordination concerns were still more distributed than their ideal semantic owner

This subphase addresses that remaining gap conservatively.

## Problem Statement

The current codebase no longer lacked architectural meaning.

The remaining gap was narrower:

- selected application transitions already had explicit meaning
- but their coordination execution still remained partially distributed

The safest currently justified examples were:

### A. Billing downstream refresh coordination

The current billing path still relied on widget-layer inline coordination semantics for:

- bootstrap decision
- active client change reaction decision

That made the widget broader than its ideal semantic responsibility.

### B. Logout reset coordination

The current logout path already represented an application-level transition:

- remove remembered login hint
- delegate runtime reset
- return to unauthenticated runtime continuation

But that execution still remained directly expressed from dashboard intent plus provider delegation without a narrow app-level coordination anchor.

## Scope

This subphase includes:

- a new minimal application coordinator file
- coordinator methods only for:
  - billing bootstrap coordination
  - billing active-client-change coordination
  - logout reset coordination
- migration of billing downstream coordination decisions to the coordinator
- migration of logout reset execution coordination to the coordinator
- documentation alignment for the new minimal coordination baseline

This subphase does not include:

- startup/auth continuation coordination
- backend flow redesign
- ServiceProvider redesign
- navigation redesign
- UI redesign
- event bus implementation
- runtime engine implementation
- broad coordinator implementation

## Root Cause Analysis

This issue existed because Mi IP·RED evolved in the correct pragmatic order:

1. make runtime work
2. protect backend flow
3. normalize structure
4. extract feature-local logic
5. clarify state ownership
6. inventory flows
7. normalize context semantics
8. freeze interaction meaning
9. only then anchor the narrowest safe execution-level coordination concerns

That sequencing mattered.

If a coordinator had been introduced earlier, it would likely have coordinated unstable or still-implicit semantics.

At the current baseline, the missing piece was no longer meaning.

The missing piece was only a narrow execution anchor.

## Files Affected

### Runtime files changed

- `lib/features/contracts/application_coordinator.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`

### Documentation files changed

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_4_application_coordinator_minimal.md`

## Implementation Characteristics

### 1. Minimal Coordinator Surface

A new narrow coordination file is introduced:

- `lib/features/contracts/application_coordinator.dart`

This file is intentionally:

- small
- explicit
- non-owning
- easy to audit
- limited to the narrowest safe coordination concerns

### 2. Billing Bootstrap Coordination

The coordinator now exposes a dedicated decision surface for whether billing should bootstrap.

This extracts the application-level coordination rule out of inline widget semantics while preserving:

- billing widget lifecycle ownership
- billing controller feature-state ownership
- provider runtime ownership

### 3. Billing Active Client Change Coordination

The coordinator now exposes a dedicated decision surface for whether billing should react to active client changes.

This keeps the listener in the widget, but it moves the semantic decision rule into a dedicated application-level coordination surface.

### 4. Logout Reset Coordination

The coordinator now exposes a dedicated execution surface for logout reset coordination.

This operation performs:

- remembered login hint removal
- delegated runtime reset through `ServiceProvider`

This does not move ownership of runtime reset out of `ServiceProvider`.

It only gives the app-level transition a narrower explicit coordination anchor.

### 5. Ownership Preservation

After this implementation:

- `billing_widget.dart` still owns lifecycle and rendering
- `BillingController` still owns feature-state transitions and billing load/reload execution
- `DashboardController` still produces dashboard-local intent
- `ServiceProvider` still owns runtime context and runtime reset
- `ApplicationCoordinator` only owns narrow coordination semantics for selected app-level transitions

### 6. Scope Restriction

This implementation intentionally leaves startup/auth continuation untouched.

That surface remains broader and more sensitive than the currently safe coordination targets.

Keeping it out of 7.3.4 is part of the correctness of the subphase.

## Validation

A valid 7.3.4 implementation must preserve all previous runtime behavior while narrowing the execution-level coordination surface.

The current implementation should be validated through:

### Startup / Auth preservation

- startup still works exactly as before
- auth popup flow still works exactly as before

### Billing preservation

- billing still bootstraps correctly
- billing still reloads after active client change
- billing widget still renders correctly

### Dashboard / Logout preservation

- logout can still be triggered from dashboard
- remembered login hint is still removed
- runtime reset still happens
- app still returns to unauthenticated flow

### Ownership preservation

- `ServiceProvider` still owns shared runtime state
- `BillingController` still owns billing feature logic
- coordinator remains narrow and non-owning

## Release Impact

This subphase has no intended user-facing feature redesign.

Its practical impact is architectural:

- billing downstream coordination is less widget-distributed
- logout reset gains a minimal app-level execution anchor
- the coordinator remains intentionally narrow

## Risks

The main risks of this subphase were:

- over-expanding the coordinator into a broad orchestration layer
- moving ownership accidentally
- touching startup/auth too early
- obscuring logic instead of clarifying it

The implemented approach avoids those risks by remaining narrow and only coordinating the two safest already-validated concerns.

## What it does NOT solve

This subphase does not solve:

- startup/auth coordinator redesign
- runtime interaction engine
- event-driven runtime architecture
- backend-authenticated persistent sessions
- automated flow-level coordination tests

Those belong to later work outside the safe scope of this subphase.

## Conclusion

Phase 7.3.4 is now implemented as a minimal execution-level coordination anchor over the safest already-declared application transitions.

It does not redesign runtime mechanics.

It narrows where selected coordination meaning is executed.

The resulting baseline is now safer for formal closure of Phase 7.3 because Mi IP·RED explicitly anchors:

- billing downstream refresh coordination
- logout reset coordination

through a minimal application coordinator while preserving all prior ownership boundaries.