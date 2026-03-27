# 🛠️ Development Rules

## Objective

Define the active engineering rules of Mi IP·RED so that the project can continue improving its internal architecture without breaking the validated runtime behavior that already exists.

---

## Initial Context

Mi IP·RED has already completed:

- backend/runtime stabilization
- ServiceProvider decomposition
- presentation structure cleanup
- feature-local controller extraction for auth, dashboard, and billing
- state-coordination boundary clarification in Phase 7.2

That means development is no longer focused on moving request logic out of widgets.

That part has already been done.

The current architectural baseline now includes:

- controller-backed feature orchestration
- explicit billing feature-state boundaries
- explicit dashboard source-to-derived boundaries
- explicit auth/startup initial-boundary modeling

---

## Development Principle

The primary rule remains:

**improve structure without breaking runtime behavior**

This rule overrides convenience and elegance.

---

## Core Constraints

### Backend Flow Protection

The following must remain stable unless a phase explicitly and safely targets them:

- handshake lifecycle
- login flow sequencing
- tracked request behavior
- message structure
- response parsing semantics

---

### ServiceProvider Protection

`ServiceProvider` remains protected infrastructure.

Rules:

- do not redesign it casually
- do not change its public runtime contract
- do not use structural cleanup as an excuse to alter behavior
- do not move hidden state semantics into or out of it without scoped justification

---

### No Hidden Runtime Redesign

Refactors must not silently include:

- UI redesign
- navigation redesign
- backend protocol changes
- broad lifecycle rewrites
- state-management migrations disguised as cleanup

Every change must stay within its declared phase boundary.

---

## Presentation Layer Rules

### Post-Phase 7.1 Rule

Once a feature already has a controller, widgets must not reabsorb business-adjacent orchestration inline.

This currently applies to:

- auth
- dashboard
- billing

---

### Post-Phase 7.2 Ownership Rule

Phase 7.2 is now complete.

Its resulting rule remains active:

widgets must not continue accumulating feature functional state once that state has already been identified as non-UI state and successfully normalized behind an explicit feature-local boundary.

This does **not** mean all local state is forbidden.

It means every state value should be judged explicitly as one of:

- UI state
- feature functional state
- derived state
- global source state

If ownership is unclear, document first and move later.

---

### Billing-Specific Rule After Phase 7.2

Billing now has an explicit feature-state boundary.

That means new billing changes must preserve this split:

#### Presentation owns

- rendering
- visual composition
- scroll controllers
- view-specific UI behavior

#### Controller owns

- billing functional-state transitions
- tracked client resolution
- reload decisions
- feature-state construction

Do not reintroduce scattered billing lifecycle flags inside the widget.

---

### Dashboard-Specific Rule After Phase 7.2

Dashboard now has an explicit source-to-derived boundary.

That means new dashboard changes must preserve this split:

#### Presentation owns

- `ref.watch(...)` reactivity
- rendering
- title/actions/body composition
- user interaction dispatch

#### Controller owns

- dashboard source snapshot construction
- active-client resolution
- client-option derivation
- display-name derivation
- render-ready derived-state construction

Do not reintroduce direct `WidgetRef`-based derivation inside the controller.

Do not mix source state back into `DashboardResolvedState` unless strictly necessary and explicitly justified.

---

### Auth/Startup-Specific Rule After Phase 7.2

Auth and startup now have an explicit initial-boundary split.

That means new changes must preserve this distinction:

#### Startup presentation/runtime surface owns

- rendering the initial loading surface
- triggering the existing startup flow
- consuming the local startup boundary state

#### Auth presentation owns

- `_dniController`
- `_shakeKey`
- direct user interaction
- rendering login UI

#### Auth controller owns

- login feature-state construction
- bootstrap-prepared auth state
- bootstrap-ready auth state
- manual submit loading state
- submit failure recovery state

Do not collapse bootstrap loading and submit loading back into a single ambiguous widget flag.

Do not replace the explicit startup boundary with a generic boolean again without clear justification.

---

## Controller Layer Rules

Controllers may own:

- request orchestration
- input normalization
- feature lifecycle decisions
- derived state construction
- feature-local state transition helpers
- session/runtime coordination when feature-scoped

Controllers must not own:

- rendering concerns
- widget-specific animation behavior
- decorative UI rules
- broad global orchestration unless a later phase explicitly introduces it

---

## Validation Policy

Validation remains mandatory after each implementation step.

### Core checks

- app startup
- login failure
- login success
- dashboard render
- customer switching
- billing load
- billing reload on customer change
- logout

### Consolidated Phase 7 baseline

Any future phase starting from this point should preserve:

- startup exits bootstrap correctly
- remembered DNI hydrates correctly
- autologin executes when expected
- manual login works identically
- invalid manual login produces the same visible feedback
- dashboard active-client rendering stays correct
- customer switching still updates dependent content
- billing still loads and reloads correctly
- logout still behaves correctly

---

## Risk Management

### Current risks

- reintroducing logic into widgets
- widening a local refactor into a global redesign
- breaking customer-driven reload behavior
- breaking dashboard-derived render state
- breaking startup/auth initial-entry semantics
- mixing ownership cleanup with unrelated navigation/runtime changes

### Mitigation

- preserve current runtime trigger order
- keep reactivity where it already works
- prefer explicit ownership over clever abstractions
- document each ownership decision
- do not reopen Phase 7.2 implicitly unless a real new problem justifies it

---

## Allowed Changes

- feature-local controller extension
- feature-local state objects
- feature-local source snapshot models
- derived-state normalization where a new feature actually needs it
- manual coordination reduction when runtime-equivalent
- documentation alignment
- explicit ownership cleanup inside already-scoped features

---

## Not Allowed Changes

- global application service layer introduction without explicit phase scope
- full provider architecture replacement
- ServiceProvider redesign
- backend flow redesign
- navigation redesign mixed into feature-boundary cleanup
- hidden state-management migration
- reopening closed Phase 7.2 work without real code-backed justification

---

## Current Working Rule

Before moving any state, answer these questions:

1. Is it purely UI state?
2. Is it feature functional state?
3. Is it derived from another source-of-truth?
4. Is it still manually coordinated only because the boundary has not yet been formalized?

If the answer is unclear, do not move it yet.

---

## Conclusion

Development at this stage is not about rewriting Mi IP·RED.

It is about continuing from a clearer baseline.

Phase 7.2 is now complete and closed.

That means future work should build on its results, not keep extending the same cleanup phase indefinitely.