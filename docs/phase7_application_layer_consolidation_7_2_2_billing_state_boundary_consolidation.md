# 🧾 Phase 7.2.2 — Billing State Boundary Consolidation

## Objective

Consolidate the functional feature state of billing into an explicit feature-local boundary so that presentation stops owning dispersed billing lifecycle coordination while preserving the exact runtime flow already validated in production-oriented behavior.

---

## Initial Context

After Phase 7.1.3:

- billing request orchestration was already extracted into `BillingController`
- request shaping, thread preparation, and response normalization were no longer inline inside `BillingWidget`
- the architectural direction `presentation → controller → ServiceProvider` was already active

After Phase 7.2.1:

- billing was formally identified as the strongest state-boundary hotspot in the current ZIP
- widget-local state was classified into:
  - UI state
  - feature functional state
  - manual coordination points
- the next safe implementation step was validated as billing state consolidation

This subphase executes that step without expanding scope into a wider state-management redesign.

---

## Problem Statement

`BillingWidget` no longer owned too much backend-facing request logic, but it still owned too much feature lifecycle state.

Before this step, the widget still stored and coordinated:

- thread hash
- initialization/loading state
- loaded data model
- error presence
- error payload
- last observed client index

It also performed manual coordination for:

- provider listening
- client-change detection
- reload decisions
- loading/error/success transitions

That meant the widget still carried state ownership responsibilities that were not purely presentational.

The problem was therefore not request orchestration anymore.

The problem was billing feature-state ownership.

---

## Scope

### Included

- introduce an explicit billing feature-state structure
- move billing functional-state transitions into the controller
- move billing client-tracking decisions into the controller
- preserve `listenManual` as a temporary trigger mechanism
- simplify the widget to consume a single consolidated feature state
- keep billing rendering in presentation

### Excluded

- ServiceProvider redesign
- backend flow changes
- request contract changes
- navigation changes
- UI redesign
- provider architecture replacement
- global state layer introduction
- dashboard/auth/startup changes

---

## Root Cause Analysis

Phase 7.1 correctly extracted request orchestration first.

That exposed the next architectural residue:

- the widget no longer owned the request construction logic
- but it still owned the execution-state lifecycle of the feature

In billing, that residue was stronger than in the other features because the widget still coordinated:

- first-load bootstrap
- last selected client tracking
- client-change reload logic
- loading/error/data transitions

This is exactly the kind of ownership ambiguity that Phase 7.2 was opened to resolve.

The safe solution was not to introduce a new global state model.

The safe solution was to consolidate the existing billing feature state into an explicit controller-backed boundary.

---

## Files Affected

### Runtime files

- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`

### Documentation files

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_2_2_billing_state_boundary_consolidation.md`

---

## Implementation Characteristics

### 1. Explicit feature-state object introduced

A new feature-local state object was introduced:

- `BillingFeatureState`

It centralizes:

- `threadHashID`
- `isLoading`
- `dataModel`
- `error`
- `trackedClientIndex`

This replaced the prior dispersed widget variables.

---

### 2. Controller now owns billing state transitions

The controller now defines explicit transition builders:

- initial state
- loading state
- success state
- failure state

This means billing lifecycle semantics are now owned by the feature controller instead of being scattered across widget `setState` blocks.

---

### 3. Controller now owns client-tracking decisions

The controller now resolves:

- current tracked client index
- first bootstrap condition
- reload decision after client change

This reduces billing-specific coordination logic inside the widget without removing the current runtime trigger mechanism.

---

### 4. `listenManual` intentionally preserved

This step does **not** remove `listenManual`.

That choice is deliberate.

Reason:

- `listenManual` currently participates in a validated runtime behavior
- removing it in this subphase would increase risk unnecessarily
- the real issue was not the existence of the trigger itself, but the fact that billing logic was embedded inside the widget callback

After this change:

- the subscription still exists
- but the callback delegates feature-boundary decisions to the controller

---

### 5. Widget now owns only presentation plus one aggregated feature state

After this change, `BillingWidget` still owns:

#### Legitimate UI concerns

- scroll controllers
- visual composition
- window/frame rendering
- loading widget rendering
- error widget rendering
- table rendering

#### Aggregated feature state

- `_billingState`

It no longer owns the previous dispersed billing functional-state fields individually.

---

## Validation

### Runtime behavior expected to remain intact

The following behaviors must remain unchanged:

- initial billing load
- billing load for each supported `pType`
- correct thread reuse behavior
- correct reload when customer changes
- correct loading indicator visibility
- correct error rendering
- correct table rendering after successful load

### Focused validation points

#### Initial load

- open dashboard
- enter billing surface
- verify first customer triggers load
- verify table renders correctly

#### Customer change

- switch active customer from dashboard
- verify billing detects the change
- verify reload happens once
- verify new data replaces previous data

#### Error path

- simulate or reproduce a failing response path
- verify `CatchMainScreen` still renders correctly
- verify stale data is not rendered together with the error state

#### Recovery

- after an error, trigger a valid reload path
- verify loading state clears error state
- verify successful data rendering is restored

---

## Release Impact

This subphase does not change the release surface of the application.

It changes internal ownership only.

Impact is limited to:

- clearer feature-state boundary in billing
- simpler widget maintenance
- lower risk for future billing refactors
- stronger base for Phase 7.2.3 and 7.2.4

---

## Risks

### Risk 1 — customer-change reload regression

Because billing depends on selected client changes, any ownership move could break reload behavior.

#### Mitigation

- keep `listenManual`
- keep runtime trigger order
- move only the decision logic, not the trigger source

---

### Risk 2 — state duplication

Moving logic carelessly could duplicate state between controller and widget.

#### Mitigation

- widget now keeps a single aggregated feature state
- controller owns transition construction
- previous dispersed widget flags are removed

---

### Risk 3 — accidental hidden state-management redesign

A broader provider-based refactor here would have enlarged scope and risk.

#### Mitigation

- no new provider architecture introduced
- no global abstraction introduced
- no ServiceProvider redesign attempted

---

## What it does NOT solve

This subphase does not:

- replace billing with a dedicated Riverpod notifier
- remove `listenManual`
- normalize dashboard derived state
- clean startup/auth initial boundary
- redesign ServiceProvider
- unify application state globally

It solves only the billing feature-state ownership problem identified in Phase 7.2.1.

---

## Conclusion

Phase 7.2.2 successfully consolidates the billing feature state without altering the validated runtime contract.

The billing feature now has a clearer ownership boundary:

- presentation renders
- controller owns billing functional-state transitions and client-driven reload decisions
- ServiceProvider remains the protected runtime source

This is the intended outcome of the phase:

- safer
- more explicit
- still incremental
- still reversible

And it positions the project correctly for:

- `Phase 7.2.3 — Dashboard State Derivation Normalization`