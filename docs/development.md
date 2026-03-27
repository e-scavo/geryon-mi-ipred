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

The project is now inside Phase 7.2.

That means development is no longer focused on moving request logic out of widgets.

That part has already been done.

The current focus is:

- clarifying state ownership
- normalizing derivation boundaries
- clarifying initial runtime boundaries
- reducing coordination ambiguity
- keeping changes incremental and reversible

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

### Phase 7.2 Ownership Rule

Phase 7.2 introduces an additional rule:

widgets must not continue accumulating feature functional state once that state has been identified as non-UI state.

This does **not** mean all local state is forbidden.

It means every state value should now be judged explicitly as one of:

- UI state
- feature functional state
- derived state
- global source state

If ownership is unclear, document first and move later.

---

### Billing-Specific Rule After 7.2.2

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

### Dashboard-Specific Rule After 7.2.3

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

### Auth/Startup-Specific Rule After 7.2.4

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

### Phase 7.2-specific checks

- moved state still preserves runtime order
- feature functional state is not duplicated between widget and controller
- derived state is not confused with source-of-truth
- customer-change semantics remain intact

### Billing-specific checks after 7.2.2

- first billing load still occurs correctly
- billing reload still happens after customer switch
- loading state still appears
- error state still clears previous happy-path rendering
- success state restores normal rendering after reload

### Dashboard-specific checks after 7.2.3

- the active client name still matches the selected client
- the customer selector still lists the expected client options
- changing customer still updates dashboard content
- logout still behaves identically
- embedded billing widgets still react correctly after dashboard-driven client changes

### Auth/Startup-specific checks after 7.2.4

- startup still exits bootstrap correctly
- remembered DNI still hydrates correctly
- autologin still executes when expected
- manual login still works identically
- invalid manual login still produces the same visible feedback
- login popup still closes correctly after success
- authenticated runtime still opens correctly after the initial boundary completes

---

## Risk Management

### Current risks

- reintroducing logic into widgets
- widening a local refactor into a global redesign
- breaking customer-driven reload behavior
- breaking dashboard-derived render state
- breaking startup/auth initial-entry semantics
- mixing state cleanup with unrelated navigation/runtime changes

### Mitigation

- one feature boundary at a time
- one subphase at a time
- preserve current runtime trigger order
- keep reactivity where it already works
- prefer explicit ownership over clever abstractions
- document each ownership decision

---

## Allowed Changes

- feature-local controller extension
- feature-local state objects
- feature-local source snapshot models
- derived-state normalization
- initial-boundary normalization
- manual coordination reduction when runtime-equivalent
- documentation alignment
- explicit ownership cleanup inside already-scoped features

---

## Not Allowed Changes

- global application service layer introduction during Phase 7.2
- full provider architecture replacement
- ServiceProvider redesign
- backend flow redesign
- navigation redesign mixed into feature-boundary cleanup
- hidden state-management migration
- broad lifecycle redesign during 7.2.4

---

## Phase 7.2 Execution Order

Validated order:

1. `7.2.1 — Feature State Inventory & Ownership Definition`
2. `7.2.2 — Billing State Boundary Consolidation`
3. `7.2.3 — Dashboard State Derivation Normalization`
4. `7.2.4 — Auth & Startup Initial State Boundary Cleanup`
5. `7.2.5 — Formal Closure of Phase 7.2`

Reasoning:

- billing had the highest concentration of dispersed feature state
- dashboard mainly had derived-state boundary debt
- auth/startup shared the same initial-boundary concern

This order should only change with code-backed justification.

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

It is about tightening boundaries safely.

After Phase 7.2.4, auth/startup now join billing and dashboard as areas with materially stronger architectural boundaries in code.

The next implementation step should continue that same discipline in:

- `Phase 7.2.5 — Formal Closure of Phase 7.2`