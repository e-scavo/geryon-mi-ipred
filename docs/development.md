# 🛠️ Development

## Objective

Define the development rules, constraints, and validation requirements for Mi IP·RED after formal closure of Phase 7.1, ensuring that further application-layer improvements do not compromise runtime behavior, backend integrity, or system stability.

---

## Initial Context

At the end of Phase 5:

- ServiceProvider had been stabilized and internally decomposed
- backend flow was fully operational and documented
- application was already in production use
- core flows (login, dashboard, billing, logout) were functioning correctly

Phase 6 introduced structural normalization of the presentation layer.

Phase 7.1 then completed the first behavioral consolidation pass by extracting business-adjacent logic from the main feature widgets into feature-local controllers.

The development rules now need to reflect that Phase 7.1 is closed and that the next safe step is state coordination work.

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

---

## Risk Management

### Identified Risks

- reintroducing orchestration into widgets
- growing controllers without clear responsibility boundaries
- mixing state redesign with unrelated refactors
- hidden runtime regression during future consolidation

### Mitigation Strategy

- incremental commits
- validation after each step
- preserve current feature-local controller boundaries
- start Phase 7.2 conservatively
- keep documentation aligned with the real codebase

---

## Code Modification Guidelines

### Allowed

- controller extension inside existing feature boundaries
- feature-local state abstractions in later phases
- import updates aligned with ownership boundaries
- response/result normalization for widget consumption
- documentation consolidation and cleanup

### Not Allowed

- backend protocol redesign
- ServiceProvider public contract changes
- navigation redesign mixed into unrelated controller work
- moving UI rendering concerns into non-UI classes
- reintroducing duplicated documentation surfaces as active references

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
- logout coordination
- feature-local option list normalization
- data-model preparation
- typed backend response validation for feature consumption
- feature-local table-row normalization when it is part of data shaping

### Forbidden Responsibilities

Controllers must not own:

- widget rendering
- BuildContext-driven rendering decisions
- visual styling
- direct dialog construction
- direct snackbar rendering
- navigation tree redesign

### Dependency Rule

Preferred direction:

presentation → controller → ServiceProvider / core

Avoid:

- presentation duplicating controller logic
- controller depending on widget classes
- controller depending on presentation widgets

### Preservation Rule After Phase 7.1 Closure

Because Phase 7.1 is closed:

- extracted responsibilities should stay outside the widgets
- new state work must build on the existing controller boundaries
- widgets remain owners of lifecycle/render/UI feedback
- controllers remain owners of feature-local application coordination

---

## Next Phase Rule

The next correct step is:

Phase 7.2 — State Coordination Boundaries

This means future work should focus on clarifying:

- what belongs to widget-local state
- what belongs to feature/application state
- where customer-dependent runtime state should live
- how to reduce ad-hoc coordination without redesigning backend flow

Phase 7.2 must start from the closed Phase 7.1 baseline and not reopen already-settled UI / logic extraction work unless a validated defect requires it.

---

## Conclusion

Development after formal closure of Phase 7.1 is no longer about first-pass UI / logic separation.

That work is complete for the main runtime surfaces.

Starting now, Mi IP·RED should evolve by clarifying state ownership on top of the controller boundaries already established, while preserving the production runtime contract and the architectural safety achieved in Phases 6 and 7.1.