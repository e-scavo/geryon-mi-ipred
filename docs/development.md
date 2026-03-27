# 🛠️ Development

## Objective

Define the development rules, constraints, and validation requirements for Mi IP·RED during and after Phase 6, ensuring that structural improvements to the presentation layer do not compromise runtime behavior, backend integrity, or system stability.

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

Only structural relocation is allowed.

---

## Presentation Layer Rules

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

---

### Not Allowed

- logic changes
- renaming public classes
- modifying ServiceProvider behavior
- altering backend interaction
- introducing new architecture layers

---

## Development Workflow

### Recommended Sequence

1. identify target files
2. create canonical destination
3. copy file without modification
4. replace original file with export shim
5. validate compilation
6. migrate safe imports
7. validate runtime
8. commit

---

## Phase 6 Outcome Alignment

After Phase 6:

- presentation structure is explicit
- shared vs feature UI is clearly separated
- canonical paths are established
- imports reflect real ownership
- legacy paths remain as compatibility layer

---

## What Development Must Avoid Next

Do not immediately:

- delete shims
- refactor domain layer
- change ServiceProvider structure
- introduce new abstractions

These belong to future phases.

---

## Conclusion

Development during Phase 6 enforces:

- structural clarity without behavioral change
- strict protection of runtime-critical flows
- controlled and reversible migration strategy
- disciplined separation between presentation layers

This creates a stable foundation for:

- Phase 6.3 (legacy cleanup)
- Phase 7 (domain organization)
- Phase 8 (session and configuration hardening)

---

## Post-Phase 6 Rule — No Legacy Paths Allowed

After Phase 6 completion:

- no legacy presentation paths must exist
- no export-based shims must remain
- all imports must use canonical paths

Any new code introducing legacy-style paths is considered a violation of architecture rules.

---