# 🧠 Decisions — Phase 6 Alignment

## Decision 1 — Preserve Backend Flow as Immutable Constraint

The backend communication model remains the highest-priority invariant of the system.

This includes:

- handshake lifecycle
- token negotiation
- message envelope structure
- tracked request flow (messageID)
- login request semantics

### Implication

All presentation-layer refactoring must:

- avoid modifying request generation
- avoid modifying response parsing
- avoid altering timing or sequencing of calls
- avoid introducing side effects in ServiceProvider

This constraint governed every step of Phase 6.

---

## Decision 2 — Refactor Presentation Without Behavioral Change

The system is already functional in production.

Therefore:

structural improvements must not introduce runtime changes.

### Implication

Phase 6 explicitly avoided:

- UI redesign
- navigation changes
- widget lifecycle changes
- state management changes

Only structural relocation was allowed.

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

---

## Decision 11 — Documentation Must Reflect Real Structure

Documentation is treated as:

a reflection of actual implementation, not an idealized model.

### Therefore Phase 6 documentation:

- includes historical structure
- explains migration steps
- documents shim strategy
- defines canonical structure
- preserves rationale

---

## Decision 12 — Avoid Mixing Structural Refactor with Logical Refactor

A key constraint:

do not combine presentation restructuring with logic changes.

### Avoided during Phase 6:

- splitting ServiceProvider
- changing login logic
- altering request builders
- modifying state handling

This ensures:

- isolated change scope
- easier validation
- predictable outcomes

---

## Decision 13 — Maintain Full Backward Compatibility During Migration

At no point should the system require:

- simultaneous refactor of all imports
- atomic migration across all files

### Instead:

- old paths continue working
- new paths gradually adopted
- system remains stable at every step

---

## Decision 14 — Prepare for Controlled Shim Removal (Future Phase)

Phase 6 does NOT remove legacy paths.

### Instead it prepares:

- identification of unused shims
- confirmation of canonical import adoption
- safe conditions for removal

This leads into:

Phase 6.3 — Legacy shim audit

---

## Decision 15 — Prioritize Safety Over Structural Purity

Throughout Phase 6:

safety was prioritized over ideal structure.

### This includes:

- keeping temporary redundancy (shims)
- delaying certain migrations
- avoiding aggressive cleanup

### Outcome

- zero regressions
- controlled evolution
- maintainable transition path

---

## Conclusion

The decisions in Phase 6 collectively ensure that:

- presentation structure becomes explicit and correct
- runtime behavior remains unchanged
- migration risk is minimized
- future architectural phases can proceed safely

The system now has:

- clear ownership boundaries
- controlled import surface
- documented migration strategy
- stable foundation for further refactoring

---

## Decision 16 — Remove Compatibility Layer After Full Validation

Once:

- canonical imports are fully adopted
- no active usage of legacy paths remains
- runtime validation is complete

Then:

all compatibility shims must be removed.

### Rationale

- prevents structural duplication
- enforces single source of truth
- eliminates hidden dependencies

This was executed in Phase 6.3.

---

## Decision 17 — Introduce a Controller Layer Only After Presentation Normalization

Phase 7 does not begin by changing backend interaction.

It begins by introducing an explicit controller layer only after Phase 6 completed structural normalization.

### Rationale

Before Phase 6, responsibility extraction would have been mixed with path cleanup and import migration.

After Phase 6:

- presentation ownership is clear
- canonical paths already exist
- extraction can happen without structural ambiguity

### Implication

Application-layer consolidation must happen after presentation normalization, not before it.

---

## Decision 18 — Extract Business-Adjacent Logic Before Redesigning State

State redesign is deferred until business-adjacent logic leaves widgets.

### Rationale

If widgets still own orchestration logic:

- state redesign would hide coupling instead of removing it
- feature boundaries would remain behaviorally weak
- future state abstractions would be harder to validate

### Implication

The first Phase 7 priority is not global state redesign.
It is UI / logic decoupling through feature-level controllers.

---

## Decision 19 — Controllers Must Stay Feature-Local Initially

Controller introduction must start inside feature boundaries instead of as a global application service layer.

### Rationale

- lower migration risk
- easier ownership
- easier rollback
- clearer mapping from widget to extracted logic

### Implication

Initial controller locations must be:

- lib/features/auth/controllers
- lib/features/dashboard/controllers
- lib/features/billing/controllers

Global application services are not introduced yet.

---

## Decision 20 — Widgets Remain Responsible for Rendering and UI Feedback

Controllers must not absorb rendering responsibilities.

### Rationale

The goal is to separate responsibilities, not to move UI code into non-UI classes.

Therefore controllers may return:

- normalized results
- action outcomes
- error descriptions for presentation use

But widgets remain responsible for:

- snackbars
- dialogs
- pop / push decisions tied to UI lifecycle
- visual response to controller outcomes

### Implication

Phase 7 extraction is application-layer decoupling, not headless UI conversion.

---

## Conclusion

Phase 7 extends the decision system already established in Phase 6.

The repository is no longer only structurally normalized; it now begins to formalize behavioral ownership as well.

That means future refactors must preserve:

- backend invariants
- ServiceProvider stability
- feature-local ownership
- strict separation between controller responsibility and UI rendering responsibility

This preserves safety while enabling further architectural evolution.