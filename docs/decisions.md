# 🧠 Decisions — Phase 7 Alignment

## Decision 1 — Preserve Backend Flow as Immutable Constraint

The backend communication model remains the highest-priority invariant of the system.

This includes:

- handshake lifecycle
- token negotiation
- message envelope structure
- tracked request flow (messageID)
- login request semantics

### Implication

All presentation-layer and application-layer refactoring must:

- avoid modifying request generation
- avoid modifying response parsing
- avoid altering timing or sequencing of calls
- avoid introducing side effects in ServiceProvider

This constraint governed every earlier phase and remains active for Phase 7.2.

---

## Decision 2 — Refactor Structure and Application Layer Without Behavioral Change

The system is already functional in production.

Therefore:

structural and application-layer improvements must not introduce runtime changes unless they are explicitly intended, justified, and validated.

### Implication

Phase 6 explicitly avoided:

- UI redesign
- navigation changes
- widget lifecycle redesign
- state-management redesign

Phase 7.1 preserved the same rule while extracting business-adjacent orchestration into controllers.

Phase 7.2 preserves the same rule while clarifying state ownership boundaries.

---

## Decision 3 — Separate Shared UI from Feature UI

A core structural deficiency was the lack of separation between:

- reusable UI components
- feature-owned presentation

### Decision

Introduce two explicit layers:

Shared Presentation

Located under:

- lib/shared/widgets
- lib/shared/layouts
- lib/shared/window

Contains:

- reusable components
- layout primitives
- generic UI containers

Feature Presentation

Located under:

- lib/features/auth/presentation
- lib/features/dashboard/presentation
- lib/features/billing/presentation

Contains:

- feature-specific UI
- screens
- UI tied to business context

---

## Decision 4 — Introduce Canonical Paths Before Removing Legacy Paths

Instead of moving files and breaking imports:

canonical paths must be introduced first, while preserving legacy access.

### Strategy

- create new canonical file locations
- keep original paths
- convert original files into export shims

### Example

models/Login/widget.dart  
→ becomes  
export → features/auth/presentation/login_widget.dart

### Result

- no broken imports
- safe incremental migration
- rollback capability preserved

---

## Decision 5 — Use Export-Based Compatibility Shims

Compatibility between old and new paths is maintained via:

export 'package:...';

### Rationale

- zero runtime overhead
- zero behavioral change
- transparent for consumers
- avoids wrapper duplication

### Constraint

Shim files must:

- contain only export
- not include logic
- not duplicate classes

---

## Decision 6 — Normalize Shared UI Before Feature UI

The migration order was not arbitrary.

### Decision

Refactor order:

1. Shared UI (Phase 6.1)
2. Feature UI (Phase 6.2)

### Rationale

- shared UI has lower risk
- feature UI depends on shared UI
- reduces cascading changes
- stabilizes foundation first

---

## Decision 7 — Feature Migration Order Must Be Risk-Aware

Within feature presentation normalization, the following order was enforced:

1. Billing
2. Dashboard
3. Login

### Rationale

Billing

- most isolated
- lowest coupling
- minimal impact radius

Dashboard

- central screen
- depends on shared + billing
- stable after shared normalization

Login

- directly tied to ServiceProvider
- part of application entry flow
- highest sensitivity

---

## Decision 8 — Treat Auth Presentation as Infrastructure-Adjacent

Although login UI is part of presentation:

it behaves as infrastructure-adjacent due to its integration with ServiceProvider.

### Implication

- migration must be delayed until other features stabilize
- compatibility must be preserved first
- validation must be stricter than other UI moves

This remains relevant in Phase 7.2 because auth still shares a boundary with startup and session-driven entry behavior.

---

## Decision 9 — Normalize Imports Only After Structural Stability

Canonical imports were not introduced immediately.

### Decision

Only after:

- feature paths exist
- compatibility is validated

Then:

- migrate active imports to canonical paths

### Result

- reduced migration risk
- ensured all paths are valid before usage
- avoided mid-refactor breakage

---

## Decision 10 — Legacy Paths Become Compatibility Layer Only

After import normalization:

legacy paths are no longer primary access points.

### They become:

- compatibility fallback
- temporary support layer

### They are NOT:

- preferred import paths
- part of final architecture
- a valid place for new logic

---

## Decision 11 — Introduce Feature-Local Controllers Before Touching State Boundaries

Application-layer extraction had to occur before state-boundary consolidation.

### Decision

Phase 7.1 introduces controllers first.

Only after that baseline is validated may Phase 7.2 start.

### Rationale

- ownership cannot be normalized while widgets still own request orchestration
- state cleanup before logic extraction would mix two concerns
- later state work becomes safer once feature-local controller boundaries exist

### Result

Phase 7.1 is the prerequisite foundation for Phase 7.2.

---

## Decision 12 — Treat State Ownership as an Explicit Architectural Concern

State ownership must not remain implicit after Phase 7.1.

### Decision

Phase 7.2 begins with a formal ownership inventory.

State must be classified into:

- UI state
- feature functional state
- derived state
- global source state

### Rationale

Without this classification:

- local state could be moved incorrectly
- derived state could be duplicated
- widgets could continue owning feature coordination by inertia
- future abstractions would rest on assumptions instead of code-backed analysis

### Result

7.2.1 is required before any implementation-focused consolidation step.

---

## Decision 13 — Billing Is the First State-Boundary Consolidation Target

The order inside Phase 7.2 is not arbitrary.

### Decision

After the inventory step, the first implementation-focused state-boundary subphase must target billing.

### Rationale

Billing currently concentrates the greatest amount of:

- widget-owned feature functional state
- manual reload coordination
- client-change synchronization logic
- mixed local coordination around loading/error/data state

### Result

The first practical consolidation target after 7.2.1 is:

- 7.2.2 — Billing State Boundary Consolidation

---

## Decision 14 — Dashboard Is Primarily a Derived-State Normalization Problem

Dashboard remains important, but its main debt is narrower than billing.

### Decision

Treat dashboard as a derived-state normalization subphase rather than as the first broad state-consolidation step.

### Rationale

The dashboard controller already centralizes relevant behavior more effectively than billing.

What remains is mainly:

- source/derived boundary clarity
- normalization of how resolved state is consumed

### Result

Dashboard is positioned after billing in the validated Phase 7.2 order.

---

## Decision 15 — Auth Cleanup Must Include Startup Boundary Cleanup

The real codebase does not isolate auth initial-state concerns inside the login feature alone.

### Decision

The original wording:

- Auth Initial State Boundary Cleanup

is expanded to:

- Auth & Startup Initial State Boundary Cleanup

### Rationale

The initial boundary is currently distributed across:

- lib/main.dart
- auth presentation
- session persistence
- ServiceProvider-backed readiness/auth state

Cleaning only the auth widget would leave the boundary architecturally incomplete.

### Result

Phase 7.2 scope is clarified without broadening into a redesign.

This is a scope correction, not a scope expansion into a new architecture.

---

## Decision 16 — Do Not Introduce a Global Application Service Layer During Phase 7.2

A tempting next step after inventory would be to centralize more behavior globally.

### Decision

Do not introduce a new global application service layer during Phase 7.2.

### Rationale

- it would widen the blast radius unnecessarily
- it would blur the existing controller boundaries
- it would mix ownership clarification with architecture expansion
- the current goal is boundary normalization, not platform redesign

### Result

Phase 7.2 remains feature-local and startup-boundary-focused.

---

## Decision 17 — Manual Coordination Reduction Must Preserve Runtime Order

Reducing `listenManual`, local reload checks, and widget-coordinated loading state is desirable.

But it must not change runtime ordering implicitly.

### Decision

Any manual coordination reduction in later subphases must preserve:

- trigger timing
- user-visible loading sequence where relevant
- feature reload semantics
- customer-switch behavior
- startup/login entry ordering

### Result

Implementation choices during 7.2.2 onward must be evaluated by runtime-equivalent behavior, not only by code cleanliness.

---

## Conclusion

Phase 7 decisions now form a coherent chain:

- normalize structure
- introduce controllers
- classify ownership
- consolidate the riskiest state hotspot first
- normalize derived state next
- clean startup/auth boundary after that
- preserve runtime at every step

This sequence is now the active architectural contract for the continuation of Mi IP·RED in Phase 7.2.