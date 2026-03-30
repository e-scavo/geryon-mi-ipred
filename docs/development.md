
# 🧠 Development Guidelines

## Objective

Define the active development rules for Mi IP·RED after the completion and formal closure of Phase 9.3.3 so that future changes:

- preserve the current architecture
- preserve the retained runtime baseline from Phase 8
- preserve the semantic consistency baseline from Phase 9.2
- preserve the local visual consistency baseline established through 9.3.3
- move into the next justified phase without reopening already-resolved concerns implicitly

## Initial Context

The current ZIP confirms the following active baseline:

- architecture remains `presentation → controller → ServiceProvider`
- Phase 7 is closed
- Phase 8 is closed
- runtime ownership remains with `ServiceProvider`
- Phase 9 is active as product-surface consistency and UX hardening

Within Phase 9, the repository now confirms:

### Semantic baseline already completed
- product-surface inventory completed
- shared state surface contract completed
- Billing state surface normalization completed
- Dashboard state presentation normalization completed
- Auth interaction feedback normalization completed
- cross-feature UX consistency inventory completed
- copy / action / feedback consolidation completed

### Local visual baseline already completed
- shared surface density baseline completed
- dashboard layout rhythm normalization completed
- auth surface density alignment completed
- billing embedded surface fit completed
- formal closure of 9.3.3 now required to keep docs aligned with code

This means the repository is no longer inside a phase whose dominant concern is:

- structural layering
- runtime semantics
- semantic wording consistency
- local density/layout drift

That local density/layout layer is now part of the retained baseline.

## Problem Statement

After 9.3.3 closure, the project needs stricter guidance so future work does not accidentally:

- keep doing local spacing tweaks under the old subphase
- reopen dashboard, auth, shared widgets, or billing embedded fit without explicit reason
- mix responsive cross-platform issues into already-closed local UI work
- treat visual polish as permission for global redesign

The current baseline is mature enough that the next work must be more tightly bounded by phase intent.

## Scope

### Included

- development rules governing Phase 9 continuation
- constraints derived from already-closed baselines
- explicit guardrails preventing implicit reopening of 9.3.3 concerns

### Excluded

- architecture redesign
- runtime ownership changes
- semantic system redesign
- design system replacement
- speculative global UI refactor

## Root Cause Analysis

The need for this document emerges from a transition point in the project:

- Phase 9.2 resolved semantic inconsistency
- Phase 9.3.2 resolved cross-feature wording inconsistency
- Phase 9.3.3 resolved local visual density/layout inconsistency

At this point, the project risk shifts from:

“inconsistency across layers”

to:

“uncontrolled continuation without clear boundaries”

Without explicit development rules:

- local UI tweaks could continue indefinitely without phase justification
- responsive/platform concerns could be incorrectly mixed with already-closed local concerns
- developers could accidentally reopen closed work under the same phase name

## Files Affected

This document governs how future changes interact with:

- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/shared/widgets/**`
- `lib/shared/window/**`

No direct code changes are introduced by this document.

## Implementation Characteristics

### Rule 1 — Do not reopen 9.3.3 implicitly

No change should:

- alter card density
- rework spacing cadence
- re-tune dashboard rhythm
- adjust auth compactness
- re-fit billing embedding

unless a **new explicit phase** justifies it.

### Rule 2 — Separate problem classes

Future changes must distinguish between:

- local visual problems (already solved)
- cross-context problems (new phase)

They must not be merged.

### Rule 3 — Respect retained baselines

All work must assume:

- semantic baseline is stable
- wording baseline is stable
- local visual baseline is stable

### Rule 4 — Explicit phase progression only

Any new work must:

- declare its phase
- justify why it is not reopening previous work
- remain consistent with documented progression

## Validation

Correct application of this document means:

- no regressions in 9.3.3 surfaces
- no “invisible” layout drift
- no mixing of concerns between local UI and responsive behavior
- new work appears as clearly defined phase extensions

## Release Impact

This document stabilizes:

- development direction
- phase boundaries
- future decision clarity

It reduces:

- accidental regressions
- undocumented UI drift
- misclassification of work

## Risks

If this document is ignored:

- 9.3.3 may be silently reopened
- responsive issues may be incorrectly patched as local fixes
- UI may drift without documentation
- phase traceability will degrade

## What it does NOT solve

This document does not:

- define responsive rules
- define cross-platform layout behavior
- define future UX improvements

It only protects the already-established baseline.

## Conclusion

At this point, development must transition from:

“fixing inconsistencies”

to:

“protecting baselines and advancing in controlled phases”

The next justified layer must be explicitly defined rather than implicitly continued.

---

## Phase 9.3.4 — Development Extension

After the formal closure of Phase 9.3.3, the repository confirms a shift in the nature of the remaining problem space.

### Problem Class Shift

The system is no longer primarily affected by:

- local surface density
- panel spacing
- component-level layout rhythm

Instead, the remaining inconsistencies are now driven by:

- viewport width variation
- cross-context rendering behavior (Web vs mobile)
- container vs constrained content interaction

### Development Rule Extension

From this point forward:

- responsive behavior must be treated as a separate concern
- width must be treated as a primary driver of layout decisions
- platform detection alone is insufficient

### Implementation Constraints (Extended)

The following remain enforced:

- no global responsive framework introduction
- no architectural changes
- no reopening of 9.3.3 local adjustments

### Allowed Adjustments

Only the following are justified under this extension:

- width-aware layout behavior
- adaptive container constraints
- surface fit corrections under constrained viewport
- overflow elimination

### Resulting Baseline

The repository now establishes:

- stable local visual baseline (9.3.3)
- stable cross-context behavior baseline (9.3.4)

Future work must build on this without collapsing both layers.