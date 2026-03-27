# 🛠️ Development

## Objective

Define the development rules, constraints, and validation requirements for Mi IP·RED during and after Phase 7, ensuring that structural and application-layer improvements do not compromise runtime behavior, backend integrity, or system stability.

---

## Initial Context

At the end of Phase 5:

- ServiceProvider had been stabilized and internally decomposed
- Backend flow was fully operational and documented
- Application was already in production use
- Core flows (login, dashboard, billing, logout) were functioning correctly

However:

- presentation layer structure was inconsistent
- UI ownership boundaries were unclear
- imports did not reflect actual responsibilities
- future refactors would be risky without normalization

Phase 6 introduced structural changes to the presentation layer, requiring updated development conventions.

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

### No Behavioral Refactor During Structural Changes

Presentation refactors must not include:

- UI redesign
- navigation changes
- state management changes
- lifecycle changes

Only structural relocation was allowed during Phase 6. Phase 7 may additionally extract business-adjacent logic into controllers under the explicit constraints documented below.

---

## Presentation Layer Rules

### Phase 7 Extension Rule

Starting in Phase 7, structural normalization is already complete.

Therefore, controlled behavioral extraction is allowed only when all of the following are respected:

- backend request semantics remain unchanged
- ServiceProvider public behavior remains unchanged
- widget rendering output remains functionally equivalent
- lifecycle-sensitive flow is preserved
- extracted logic does not absorb UI rendering concerns

This means Phase 7 may move orchestration logic out of widgets, but may not redesign runtime behavior.

---

### Separation of Concerns

Presentation must be divided into:

Shared UI

- reusable components
- layout primitives
- generic containers

Feature UI

- auth
- dashboard
- billing

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

### Migration Order Rule

Presentation refactor must follow this order:

1. shared UI
2. feature UI
3. import normalization
4. documentation alignment

---

### Compatibility Shim Rule

During structural migration:

- legacy paths must remain functional
- files must be converted into export-only shims
- no duplication of logic is allowed

Example:

models/Login/widget.dart  
becomes  
export → features/auth/presentation/login_widget.dart

---

### Canonical Import Rule

After stabilization:

- all active imports must use canonical paths
- legacy paths are only fallback
- no new code should use legacy imports

---

## Import Management

### Allowed During Migration

- coexistence of old and new imports
- gradual migration of consumers
- selective migration for safety

---

### Required After Stabilization

- canonical imports must be dominant
- legacy imports must be reduced
- no new dependencies on legacy paths

---

## Validation Policy

Validation must be performed after each structural change.

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

---

### Additional Checks for Phase 6

- compatibility shim correctness
- canonical import correctness
- absence of broken imports
- absence of duplicate widgets
- dashboard to billing transitions
- login to dashboard transition
- logout to login transition

---

## Risk Management

### Identified Risks

- incomplete import migration
- hidden dependencies on legacy paths
- accidental removal of active shim
- duplicated class definitions
- runtime regressions

---

### Mitigation Strategy

- incremental commits
- validation after each step
- conservative migration order
- temporary redundancy via shims
- documentation alignment

---

## Code Modification Guidelines

### Allowed

- file relocation
- import updates
- creation of shared structures
- introduction of feature folders
- export-based shims
- controller extraction under feature boundaries
- response/result normalization for widget consumption

---

### Not Allowed

- backend protocol redesign
- ServiceProvider public contract changes
- navigation redesign mixed into controller introduction
- moving UI rendering concerns into non-UI classes

---

## Controller Layer Rules

Phase 7 introduces a controller layer inside feature boundaries.

### Allowed Responsibilities

Controllers may own:

- request orchestration
- input normalization
- session persistence coordination
- response interpretation for presentation use
- feature-local application decisions

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

### Introduction Rule

Controllers must be introduced incrementally:

1. extract one safe feature path
2. validate runtime behavior
3. document the extraction
4. continue with the next feature only after stability is confirmed

---

## Conclusion

Development after Phase 6 is no longer only about structure.

Starting in Phase 7, Mi IP·RED may evolve behaviorally at the application-layer level, but only through controlled, incremental, and fully validated extractions that preserve the production runtime contract.