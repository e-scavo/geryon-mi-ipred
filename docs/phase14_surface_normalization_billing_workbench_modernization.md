# Phase 14 — Surface Normalization & Billing Workbench Modernization

## Objective

Open the next justified implementation layer after the formal closure of Phase 13 by normalizing the remaining legacy widget and overlay surface that still lives outside the already consolidated `features` and `shared` structure, while also preparing a safer foundation for the future billing workbench modernization.

## Initial Context

The current ZIP confirms the following closed baselines:

- Phase 7 — Application Layer Consolidation
- Phase 8 — Runtime Reliability
- Phase 9 — Product Surface Consistency & UX Hardening
- Phase 10 — Capability Completion
- Phase 11 — Release & Distribution
- Phase 12 — Store Publication Assets & Operational Rollout
- Phase 13 — Store Execution Integrity & Market Presence Hardening

That means the repository is no longer blocked by:

- feature extraction
- runtime coordination
- responsive alignment
- product capability completion
- release reproducibility
- publication scaffolding
- publication readiness validation

What remains open in the real ZIP is a structural surface inconsistency:

- some reusable widgets still live under `lib/models/`
- some fallback/error UI still lives under `lib/pages/`
- some billing-specific widgets still live under legacy generic locations
- some global overlays still expose active legacy import paths even though the app already has a stable `shared/` area

## Problem Statement

The project already reached a mature architecture baseline, but the widget surface still contains legacy placement decisions from earlier stages.

That creates several practical problems:

- active imports still cross from `features` into legacy `models/` UI files
- `shared` code still depends on a fallback surface stored under `pages/`
- billing keeps depending on a table and download surface that are not placed inside the billing feature boundary
- future modernization of the billing workbench would have to start from a partially normalized UI surface instead of a clean one

The problem is not behavioral instability.
The problem is final structural normalization of the remaining active UI surface.

## Scope

Phase 14 covers:

- normalization of remaining legacy widget and overlay placement
- controlled migration of active shared surfaces to `lib/shared/`
- controlled migration of active billing-specific surfaces to `lib/features/billing/`
- retention of compatibility wrappers where required to reduce migration risk
- documentary closure of the first normalization cut before any larger billing workbench redesign

Phase 14 does not cover:

- Riverpod architecture changes
- navigation redesign
- backend communication changes
- business-logic changes
- billing workbench visual redesign in the same step
- aggressive deletion of dormant legacy code without validation

## Root Cause Analysis

The project evolved through multiple baselines.
Earlier phases correctly focused on getting the app stable, structured, and publishable.
That work left behind a smaller class of debt: UI surfaces that still occupy legacy folders even though the repository now already has the target structural vocabulary.

This happened because:

- some widgets were normalized behaviorally before they were normalized structurally
- some overlays remained in their original folders to avoid destabilizing runtime during earlier closure phases
- billing-specific widgets were made operational before the final billing presentation boundary was fully cleaned up

By the end of Phase 13, those tradeoffs remained acceptable.
After Phase 13 closure, they became the next justified target.

## Implemented Subphases

### Phase 14.1 — Legacy Widget Surface Audit & Final Normalization

Implemented.

Focus:

- audit the active legacy widget surface present in the ZIP
- classify what is really shared versus billing-specific
- move active shared UI surfaces into `lib/shared/`
- move active billing presentation surfaces into `lib/features/billing/`
- keep compatibility wrappers on the old import paths to reduce migration risk during the transition
- avoid any logic rewrite while normalizing paths and ownership

## Final Baseline After Phase 14.1

After Phase 14.1, the repository now has a cleaner active surface contract:

- `LoadingGeneric` now has a canonical shared path under `lib/shared/widgets/`
- the fallback system error surface now has a canonical shared path under `lib/shared/widgets/`
- the active shared error/loading/progress overlays now have canonical paths under `lib/shared/overlays/`
- the billing documents table now has a canonical feature path under `lib/features/billing/presentation/widgets/`
- the billing document download popup route now has canonical feature paths under `lib/features/billing/presentation/overlays/`
- legacy paths are preserved as compatibility exports for a controlled migration boundary

This means the app can continue to run without reopening old imports everywhere at once, while the normalized destination paths now become the source of truth for future work.

## Constraints

The following constraints remain mandatory across all Phase 14 work:

- do not reopen Phase 7 architecture
- do not reopen Phase 8 runtime semantics
- do not reopen Phase 9 responsive/layout baselines
- do not reopen Phase 10 product contracts
- do not reopen Phase 11 release/distribution baselines
- do not reopen Phase 12 publication rollout rules
- do not reopen Phase 13 publication-readiness gates
- do not mix surface normalization with uncontrolled behavior changes

## Impact

Positive impact of Phase 14.1:

- active imports now point more clearly to their real structural ownership
- billing is better positioned for the next workbench-oriented phase
- shared/runtime overlays no longer depend on `models/` as their canonical UI home
- the repository is easier to reason about because feature-specific and shared surfaces are more explicit
- compatibility wrappers reduce regression risk while the normalized paths become established

Risk if this phase had been skipped:

- future billing modernization would start from a mixed legacy surface
- active code would continue to normalize behavior without normalizing ownership
- more features would keep importing legacy UI paths by inertia

## Validation

Phase 14 is correctly represented only if the current ZIP now supports all of the following:

- active shared imports can target new canonical files under `lib/shared/`
- billing can target a new canonical table widget under `lib/features/billing/presentation/widgets/`
- the billing download popup route has a feature-local canonical path
- legacy paths remain available as compatibility wrappers rather than being deleted aggressively
- no business-logic or backend contract changes were required to complete the normalization

The current ZIP supports that reading.

## Conclusion

Phase 14 is now open and its first justified implementation cut is completed.

The repository did not need a new behavioral redesign first.
It needed the remaining active widget surface to catch up with the architecture that had already been stabilized by earlier phases.
Phase 14.1 completes that first normalization layer and leaves the project in a safer position for the later billing workbench modernization steps.
