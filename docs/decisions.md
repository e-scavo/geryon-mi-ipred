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

This constraint governed every step of Phase 6 and remains active for later phases.

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

Phase 7.1 preserved the same rule while extracting business-adjacent orchestration into controllers.

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

The same rule applies to Phase 7 closure documents.

---

## Decision 12 — Avoid Mixing Structural Refactor with Logical Refactor

A key constraint:

do not combine presentation restructuring with logic changes.

### Avoided during Phase 6:

- splitting ServiceProvider
- changing login logic
- altering request builders
- modifying state handling

### Controlled exception in Phase 7.1

After presentation normalization was complete, logical extraction became allowed, but only under strict scope control and without backend behavior changes.

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

Phase 6 did not remove legacy paths immediately.

### Instead it prepared:

- identification of unused shims
- confirmation of canonical import adoption
- safe conditions for removal

This led into:

Phase 6.3 — Legacy shim audit

---

## Decision 15 — Prioritize Safety Over Structural Purity

Throughout Phase 6 and Phase 7.1:

safety was prioritized over ideal structure.

### This includes:

- keeping temporary redundancy when needed
- delaying certain migrations
- avoiding aggressive cleanup before validation
- preserving widget lifecycle ownership where extraction risk was higher

### Outcome

- zero intentional runtime regressions
- controlled evolution
- maintainable transition path

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

Phase 7 did not begin by changing backend interaction.

It began by introducing an explicit controller layer only after Phase 6 completed structural normalization.

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

The first Phase 7 priority was not global state redesign.
It was UI / logic decoupling through feature-level controllers.

Phase 7.1 is now formally closed under this decision.

---

## Decision 19 — Controllers Must Stay Feature-Local Initially

Controller introduction must start inside feature boundaries instead of as a global application service layer.

### Rationale

- lower migration risk
- easier ownership
- easier rollback
- clearer mapping from widget to extracted logic

### Implication

Initial controller locations are:

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

## Decision 21 — Dashboard Customer Resolution Must Leave the Widget Before State Refactor

Dashboard is the main authenticated screen and directly reflects the currently selected customer.

### Rationale

As long as `dashboard_page.dart` resolves the active customer inline:

- the screen keeps owning application decisions
- customer-switch behavior remains UI-coupled
- state coordination work in Phase 7.2 would start from a blurred responsibility boundary

### Implication

Dashboard customer resolution, customer-option normalization, and logout orchestration had to be extracted before beginning Phase 7.2.

This was completed in Phase 7.1.2.

---

## Decision 22 — Presentational Dialogs Remain in the Widget

Not every dashboard concern should move to the controller.

### Rationale

Dialogs such as “Métodos de pago” are presentation concerns because they:

- format visual content
- depend directly on `BuildContext`
- define modal composition and button arrangement
- do not own backend-adjacent coordination

### Implication

The controller may prepare application data, but `AlertDialog` construction remains in presentation.

---

## Decision 23 — Billing Request Preparation Must Leave the Widget Before Closing Phase 7.1

Billing is part of the authenticated runtime surface and still depended on widget-owned request preparation.

### Rationale

As long as `billing_widget.dart` prepared thread-bound models, request parameters, and typed backend decoding inline:

- the widget remained an execution coordinator
- feature behavior stayed only partially decoupled
- Phase 7.1 would be incomplete compared to auth and dashboard

### Implication

Billing request preparation, typed response validation, and row normalization had to be extracted before considering Phase 7.1 functionally complete.

This was completed in Phase 7.1.3.

---

## Decision 24 — Billing Widget Keeps Lifecycle Ownership

Billing has stronger lifecycle coupling than auth and dashboard because it depends on:

- provider subscription
- customer-change detection
- `mounted` checks
- `setState(...)`
- render switching between loading, error, and table modes

### Rationale

Moving all of this into a controller during Phase 7.1 would increase risk and blur the UI/application boundary in a different way.

### Implication

During Phase 7.1.3:

- the widget keeps lifecycle and rendering ownership
- the controller absorbs data preparation and backend-facing coordination
- no hidden lifecycle orchestration should be introduced into the controller

---

## Decision 25 — Close Phase 7.1 Without Reopening Feature Extraction

Once auth, dashboard, and billing were all extracted and validated, Phase 7.1 should be formally closed instead of kept artificially open.

### Rationale

Keeping Phase 7.1 open after its original objective is already met would:

- blur milestone boundaries
- delay transition to state work unnecessarily
- keep transitional documents alive longer than needed

### Implication

The correct next step after validation is:

- formal documentation closure of Phase 7.1
- removal of residual umbrella documentation from the active set
- transition to Phase 7.2

---

## Conclusion

The decisions established across Phases 6 and 7.1 collectively ensure that:

- presentation structure is explicit and normalized
- backend behavior remains stable
- feature-local controller boundaries are now established
- the first behavioral decoupling layer is complete
- the project is ready to move into Phase 7.2 from a cleaner baseline

This preserves safety while enabling further architectural evolution.