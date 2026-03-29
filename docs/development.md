# 🛠️ Development Guidelines

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

These guidelines govern work touching:

- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/shared/widgets/**`
- `lib/shared/window/**`
- current Phase 9 docs
- later responsive/platform review work
- any future UI consistency adjustments proposed after 9.3.3 closure

These rules do not authorize by default:

- architecture redesign
- runtime redesign
- backend flow redesign
- broad theme redesign
- design-system replacement
- undocumented reopening of already-closed local visual work

## Root Cause Analysis

The project advanced through distinct layers for good reason:

### First layer — structure
Structure had to be clarified and stabilized before visible behavior could be treated coherently.

### Second layer — runtime semantics
Once structure stabilized, runtime failure boundaries, recovery policy, and observability had to be hardened before product polish could be trusted.

### Third layer — semantic product-surface consistency
Only then did it make sense to normalize:

- state meaning
- copy
- actions
- retry
- feedback

across Billing, Dashboard, and Auth.

### Fourth layer — local density/layout consistency
Once semantics were aligned, the product still showed visible mismatch in:

- shared surface breathing
- dashboard rhythm
- auth compactness
- billing embedded composition

Phase 9.3.3 solved that local visual layer.

Because those layers were solved in order, future work must respect that sequence and not collapse them back together.

## Files Affected

The retained baseline now directly governs interpretation of:

- `lib/shared/widgets/feature_error_state.dart`
- `lib/shared/widgets/feature_empty_state.dart`
- `lib/shared/widgets/info_card.dart`
- `lib/features/dashboard/presentation/dashboard_page.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/shared/window/window_widget.dart`

The documentary baseline also directly governs:

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase9_product_surface_consistency_ux_hardening.md`
- all `docs/phase9_product_surface_consistency_ux_hardening_9_3_*` files

## Implementation Characteristics

### 1. Architecture remains frozen

All future work must preserve:

- `presentation → controller → ServiceProvider`

Widgets remain presentation surfaces.
Controllers remain feature meaning/orchestration owners.
`ServiceProvider` remains runtime owner.

### 2. Phase 8 runtime hardening remains retained baseline

Nothing in later UI/product work authorizes bypassing or weakening:

- failure-boundary semantics
- recovery-trigger semantics
- runtime diagnostic behavior
- startup/runtime continuation ownership

Those remain frozen baseline assumptions.

### 3. Phase 9.2 semantic consolidation remains retained baseline

The semantic rules established in 9.2 and reinforced through 9.3.2 remain active:

- copy consistency
- action-label consistency
- retry wording consistency
- feedback hierarchy consistency
- clearer distinction between local feature surfaces and broader failures

Future work must not casually undo those gains.

### 4. Phase 9.3.3 local visual consolidation remains retained baseline

The following now represent the retained local visual baseline:

- shared state surfaces have aligned density
- dashboard has normalized section rhythm
- auth is no longer visually isolated from the product baseline
- billing embedded composition is more integrated and no longer ignores header rendering
- billing title-bar color is aligned to theme rather than per-type strong category colors
- the embedded billing height reservation was corrected to absorb the new internal structure

These are no longer experimental changes. They are part of the current repository baseline.

### 5. 9.3.3 must not be reopened casually

From this point forward, future work must not continue making small local density/layout adjustments as if 9.3.3 were still open.

Minor bug fixes are allowed.
Informal continuation is not.

### 6. The next concern must be treated as a different problem class

The remaining concerns after 9.3.3 closure are no longer primarily about local widget/panel/card density.

They are about:

- wide-screen composition
- viewport focus
- Web vs Android layout parity
- responsive behavior on large browser windows

Those concerns must be treated as a separate subphase concern, not as leftovers hidden inside 9.3.3.

### 7. Shared widgets remain narrow and presentation-only

The shared surfaces introduced or adjusted through Phase 9 remain legitimate only while they stay:

- presentation-only
- narrow in purpose
- feature-agnostic in logic
- reversible

They must not drift into:
- state ownership
- orchestration
- cross-feature business logic
- new hidden framework behavior

### 8. Billing embedded fit is a retained composition contract

The billing panel is no longer treated as a legacy surface accidentally dropped into the dashboard.

The current retained contract now includes:

- rendered header support when provided
- a more integrated header/body composition
- theme-aligned title bar treatment
- correct reserved height in dashboard for the additional header structure

Future work must preserve that unless a later justified phase explicitly changes it.

### 9. No hidden redesign under consistency language

Even after this visual consolidation, the following remain explicitly disallowed unless the ZIP later justifies a new phase:

- broad responsive framework introduction
- navigation redesign
- theme overhaul
- design-system replacement
- runtime engine redesign
- ownership drift from controller/service layers into widgets

## Validation

Future work remains aligned only if all of the following stay true:

- architecture remains unchanged
- `ServiceProvider` remains runtime owner
- semantic surface contracts remain respected
- 9.3.3 local visual baseline is treated as closed and retained
- later changes are justified under a new explicit concern rather than under leftover local tweaking
- no broad redesign is smuggled in as UX-hardening work

## Release Impact

These guidelines do not themselves change runtime behavior.

They protect:

- code/docs alignment
- phase traceability
- already-achieved UX consistency
- the clarity of the next step after 9.3.3

## Risks

If these rules are ignored, future work may:

- reopen 9.3.3 informally
- reintroduce local inconsistency by small undocumented tweaks
- mix responsive issues into old visual substeps
- weaken the current coherence gains
- blur the transition to the next justified phase

## What it does NOT solve

This document does not itself:

- implement the next responsive/platform review
- solve wide viewport focus
- redesign dashboard for every screen class
- guarantee total Web/Android parity by itself

It only defines the rules for development after the closure of 9.3.3.

## Conclusion

The active development baseline is now:

- Phase 7 closed
- Phase 8 closed
- Phase 9 semantic consistency baseline retained
- Phase 9.3.3 local visual consistency baseline retained
- local density/layout work no longer open
- the next justified concern shifted beyond local panel rhythm and into the next explicit review layer