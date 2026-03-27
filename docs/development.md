# 🛠️ Development Rules

## Objective

Define the active engineering constraints and safe implementation rules for Mi IP·RED after Phase 7.2.1 kickoff, preserving runtime behavior while allowing incremental architectural improvement.

---

## Initial Context

Mi IP·RED reached Phase 7 after completing:

- backend/runtime stabilization
- ServiceProvider decomposition and documentation
- presentation structure cleanup
- controller extraction for the main features

At the end of Phase 7.1:

- auth, dashboard, and billing already use feature-local controllers
- business-adjacent request orchestration was removed from the main widgets
- runtime behavior was preserved

Phase 7.2 has now started, but it has not started as a code-heavy consolidation phase.

It has started as an ownership-definition phase.

The current development rules must therefore protect two things at the same time:

- the runtime already validated in production-oriented flows
- the clarity needed to continue state-boundary work safely

---

## Development Principle

Mi IP·RED must evolve under the following rule:

improve structure without breaking runtime behavior

This principle overrides all other concerns.

---

## Core Constraints

### Backend Flow Protection

The following must never be altered unintentionally:

- handshake lifecycle
- authentication sequence
- message structure
- tracked request handling (messageID)
- response parsing behavior

Any change affecting these requires explicit analysis and validation.

---

### ServiceProvider Protection

ServiceProvider is considered critical infrastructure.

Rules:

- do not split it across files prematurely
- do not modify its public behavior
- do not introduce side effects from UI refactors
- do not alter request/response timing

---

### No Runtime Redesign Hidden Inside Structural Work

Application-layer improvements must not smuggle in:

- UI redesign
- backend contract changes
- hidden navigation redesign
- unvalidated lifecycle changes
- uncontrolled state model replacement

Every change must remain explicitly scoped and validated.

---

## Presentation Layer Rules

### Phase 7.1 Closure Rule

Phase 7.1 is now formally closed.

This means the baseline rule for the main feature widgets is now:

presentation widgets should not own backend-adjacent orchestration inline when a feature-local controller already exists.

This rule already applies to:

- auth
- dashboard
- billing

Any new code added to these feature widgets must preserve that separation.

---

### Phase 7.2 Ownership Rule

Phase 7.2 adds a second rule:

presentation widgets should not continue accumulating feature functional state once ownership has been identified as non-UI state.

This does not mean all local state must be removed.

It means local widget state must now be evaluated explicitly under ownership categories:

- UI state
- feature functional state
- derived state
- global source state

Any change during Phase 7.2 must justify where a state value belongs before moving it.

---

### Separation of Concerns

Presentation must remain divided into:

Shared UI

- reusable components
- layout primitives
- generic containers

Feature UI

- auth
- dashboard
- billing

Controllers must remain feature-local unless a later phase explicitly introduces a broader application service layer.

---

### Shared UI Location

All reusable UI must live under:

- lib/shared/widgets
- lib/shared/layouts
- lib/shared/window

---

### Feature UI Location

All feature-owned UI must live under:

- lib/features/auth/presentation
- lib/features/dashboard/presentation
- lib/features/billing/presentation

---

### Controller Location

All feature-local controllers introduced in Phase 7.1 live under:

- lib/features/auth/controllers
- lib/features/dashboard/controllers
- lib/features/billing/controllers

New work in these features must prefer extending these boundaries instead of pushing orchestration back into widgets.

---

## Import Management

### Required State After Stabilization

- canonical imports must remain dominant
- legacy imports must not be reintroduced
- new code must respect current ownership boundaries
- residual transitional documentation paths must not be treated as active architecture

---

## Validation Policy

Validation must be performed after each change.

### Mandatory Checks

- flutter analyze
- application startup
- login popup rendering
- login failure behavior
- login success flow
- dashboard rendering
- customer switching
- billing access
- invoice/receipt rendering
- logout behavior
- return to initial state

### Additional Post-7.1 Checks

- widgets do not reabsorb logic already extracted into controllers
- controller boundaries remain coherent
- no controller starts owning rendering concerns
- state-related refactors do not break customer-switch semantics
- billing refresh behavior remains correct after customer changes

### Additional Phase 7.2 Checks

- moved state must have explicitly documented ownership
- feature functional state must not be disguised as visual widget state
- derived state normalization must not duplicate source-of-truth
- startup/auth boundary changes must preserve current entry behavior
- manual coordination reduction must not change runtime ordering

---

## Risk Management

### Identified Risks

- reintroducing orchestration into widgets
- growing controllers without clear responsibility boundaries
- mixing state redesign with unrelated refactors
- hidden runtime regression during future consolidation
- collapsing startup and auth behavior into an unvalidated shortcut
- moving billing coordination too aggressively

### Mitigation Strategy

- incremental commits
- validation after each step
- preserve current feature-local controller boundaries
- treat 7.2.1 as the ownership contract
- start implementation with the highest-value but still bounded hotspot
- keep documentation aligned with the real codebase

---

## Code Modification Guidelines

### Allowed

- controller extension inside existing feature boundaries
- feature-local state abstractions in later phases
- import updates aligned with ownership boundaries
- response/result normalization for widget consumption
- documentation consolidation and cleanup
- startup/auth boundary clarification when explicitly scoped
- manual coordination reduction when runtime-equivalent behavior is preserved

### Not Allowed

- backend protocol redesign
- ServiceProvider public contract changes
- navigation redesign mixed into unrelated controller work
- moving UI rendering concerns into non-UI classes
- reintroducing duplicated documentation surfaces as active references
- silent state-management migration
- global ownership abstractions introduced without prior scoped justification

---

## Controller Layer Rules

### Allowed Responsibilities

Controllers may own:

- request orchestration
- input normalization
- session persistence coordination
- response interpretation for presentation use
- feature-local application decisions
- active user/customer resolution
- feature-local derived state building
- feature-local state-boundary normalization support

### Not Allowed Responsibilities

Controllers must not own:

- direct rendering
- widget-specific animation behavior
- view-only decoration logic
- broad cross-feature global orchestration unless explicitly introduced in a later phase
- hidden navigation redesign

---

## Phase 7.2 Sequencing Rule

The validated execution order after the real inventory is:

1. 7.2.1 — Feature State Inventory & Ownership Definition
2. 7.2.2 — Billing State Boundary Consolidation
3. 7.2.3 — Dashboard State Derivation Normalization
4. 7.2.4 — Auth & Startup Initial State Boundary Cleanup
5. 7.2.5 — Formal Closure of Phase 7.2

This order should not be altered without code-backed justification.

Reason:

- billing contains the highest concentration of widget-owned feature functional state and manual coordination
- dashboard mainly needs derivation normalization
- auth and startup share the same initial-boundary concern and should be treated together

---

## Current Working Rule

From this point forward, any discussion about state in Mi IP·RED must answer three questions before implementation:

1. Is this state purely UI?
2. Is this state feature functional state?
3. Is this state derived from another source-of-truth?

If the answer is unclear, do not move the state yet.

Document it first.

---

## Conclusion

Development after Phase 7.2.1 must remain conservative, explicit, and ownership-driven.

The project is not in a “rewrite” stage.

It is in a “boundary clarification and safe consolidation” stage.

That means:

- no impulsive state migration
- no hidden architecture switch
- no runtime-risky cleanup disguised as simplification

The next implementation step should therefore focus on the most obvious coordination hotspot:

- billing