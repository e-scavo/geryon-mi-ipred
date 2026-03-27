# 🧭 Phase 7.2.3 — Dashboard State Derivation Normalization

## Objective

Normalize the dashboard state-derivation boundary by explicitly separating source state from derived feature state, so that dashboard rendering consumes a cleaner feature-local resolved model without changing runtime behavior, global state ownership, or the current reactive flow.

---

## Initial Context

After Phase 7.1.2:

- dashboard request-adjacent actions were already extracted into `DashboardController`
- customer selection and logout delegation were no longer inline in the page
- dashboard rendering remained in presentation

After Phase 7.2.1:

- dashboard was identified as a derived-state boundary problem rather than a feature-lifecycle-state hotspot
- unlike billing, dashboard did not primarily suffer from scattered loading/error state
- its remaining architectural ambiguity was centered on how state was derived from `ServiceProvider`

After Phase 7.2.2:

- billing feature-state ownership was consolidated
- the next safe feature-local target was dashboard

This subphase executes that next step conservatively.

---

## Problem Statement

Before this step, dashboard derivation had already been partially centralized, but the boundary was still not explicit enough.

The main issues were:

- `DashboardController` resolved state directly from `WidgetRef`
- `DashboardResolvedState` mixed source state (`loggedUser`) with derived state
- the feature did not expose a distinct source snapshot model
- the dashboard page consumed derived values, but the controller still reached directly into the global reactive source to build them

The problem was therefore not request orchestration anymore.

The problem was the lack of a clean and explicit `source → derived` dashboard boundary.

---

## Scope

### Included

- introduce an explicit dashboard source snapshot
- normalize dashboard derived-state construction
- remove the direct `WidgetRef`-based state resolution path from the dashboard controller
- keep dashboard reactivity in presentation
- preserve existing customer selection and logout behavior
- keep dashboard rendering unchanged

### Excluded

- ServiceProvider redesign
- new provider architecture
- new notifier architecture
- navigation changes
- dashboard UI redesign
- billing/auth/startup changes
- global application state redesign

---

## Root Cause Analysis

Phase 7.1 correctly prioritized orchestration extraction first.

That left dashboard in a relatively good state compared to billing, but it exposed a second-order boundary issue:

- the feature already had a controller
- the feature already had a resolved state object
- but source state and derived state were still not clearly separated

This happened naturally because the first dashboard goal was to remove action logic from the widget, not yet to formalize derivation semantics.

Once billing state ownership was clarified in 7.2.2, the next lowest-risk improvement was to clarify dashboard derivation without widening into a larger state-management redesign.

---

## Files Affected

### Runtime files

- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`

### Documentation files

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_2_3_dashboard_state_derivation_normalization.md`

---

## Implementation Characteristics

### 1. Explicit dashboard source snapshot introduced

A new feature-local source model was introduced:

- `DashboardSourceState`

It captures the source input consumed by the dashboard feature:

- `loggedUser`
- `selectedClientIndex`

This makes the feature input explicit instead of implicit.

---

### 2. `DashboardResolvedState` is now truly derived

The previous resolved state mixed source state and derived state.

After this change, the resolved state contains only dashboard-ready derived values:

- `activeClient`
- `activeClientIndex`
- `activeClientDisplayName`
- `clientOptions`

This makes the name `DashboardResolvedState` accurate.

---

### 3. Derivation moved to a two-step boundary

The new dashboard flow is:

1. presentation watches `ServiceProvider`
2. presentation builds a `DashboardSourceState` through the controller
3. controller resolves `DashboardResolvedState` from that source snapshot
4. presentation renders from the resolved state

This preserves current reactivity while making the feature boundary clearer.

---

### 4. `WidgetRef` is no longer used to resolve dashboard state

The controller still uses `WidgetRef` where it is appropriate:

- `selectClient(...)`
- `logout(...)`

But it no longer uses `WidgetRef` as the direct input for dashboard state derivation.

This is a meaningful boundary improvement without changing runtime behavior.

---

### 5. Dashboard rendering remains unchanged

This subphase deliberately avoids UI redesign.

The dashboard page still:

- renders the same title/actions/body structure
- uses the same customer selector behavior
- uses the same logout flow
- shows the same active customer data
- continues rendering billing widgets exactly as before

The change is architectural, not visual.

---

## Validation

### Runtime behavior expected to remain intact

The following behavior must remain unchanged:

- dashboard opens after login as before
- active customer is shown correctly
- customer-switch popup still lists the expected options
- switching customer still updates dashboard data
- logout still works correctly
- billing widgets inside dashboard still react to customer changes as before

### Focused validation points

#### Dashboard initial render

- login successfully
- open the dashboard
- verify the displayed customer name matches the selected customer
- verify the main content renders correctly

#### Customer selector

- open the customer selector
- verify all options are listed
- change customer
- verify the active customer label updates
- verify dependent dashboard content updates accordingly

#### Logout

- trigger logout from web and/or mobile actions
- verify session is cleared as before
- verify the app returns to the expected unauthenticated state

#### Billing interaction

- after changing customer from the dashboard
- verify embedded billing widgets still reload correctly
- verify this dashboard refactor did not break downstream feature reactivity

---

## Release Impact

This subphase does not change the release surface of the application.

Its impact is internal and architectural:

- cleaner feature boundary
- clearer separation between source and derived state
- lower future refactor risk in dashboard
- better preparation for Phase 7.2.4

---

## Risks

### Risk 1 — break active customer resolution

If source and derived boundaries are modeled incorrectly, the dashboard could display the wrong client.

#### Mitigation

- keep the same current source-of-truth
- only normalize how it is represented and consumed
- preserve the same selected-client semantics

---

### Risk 2 — break reactivity

If derivation is moved too far away from the watched source, updates might stop propagating.

#### Mitigation

- keep `ref.watch(notifierServiceProvider)` in the page
- do not introduce a new reactivity mechanism
- normalize only the feature boundary

---

### Risk 3 — widen into an unnecessary redesign

A bigger abstraction here could push the project into premature state-management redesign.

#### Mitigation

- no new notifier/provider architecture
- no ServiceProvider changes
- no global application layer introduction

---

## What it does NOT solve

This subphase does not:

- redesign dashboard UI
- redesign ServiceProvider
- remove all feature dependence on global runtime state
- address billing state ownership again
- address auth/startup initial-boundary cleanup
- introduce global application state normalization

It solves only the dashboard derivation-boundary problem identified in Phase 7.2.1.

---

## Conclusion

Phase 7.2.3 strengthens the dashboard feature boundary without altering the validated runtime contract.

The dashboard now has a clearer architecture:

- presentation owns reactivity and rendering
- controller owns feature-local derivation
- `ServiceProvider` remains the protected global source

This is the intended result of the phase:

- explicit
- incremental
- low risk
- compatible with the current app flow

And it positions the project correctly for:

- `Phase 7.2.4 — Auth & Startup Initial State Boundary Cleanup`