# 📊 Phase 9.3.1 — Cross-Feature UX Consistency Inventory

## Objective

Document the real cross-feature UX consistency gaps that remain after:

- Phase 9.2.2 Billing state surface normalization
- Phase 9.2.3 Dashboard state presentation normalization
- Phase 9.2.4 Auth interaction feedback normalization

The purpose of this step is to establish an explicit inventory of what still feels heterogeneous across those already-hardened surfaces before any broader visual or wording change is proposed.

## Initial Context

The current ZIP confirms:

- Phase 7 closed
- Phase 8 closed
- Phase 9 opened as product surface consistency and UX hardening
- Billing has already been normalized as a feature surface
- Dashboard has already been normalized as a feature surface
- Auth has already been normalized as a feature surface
- the active architecture remains `presentation → controller → ServiceProvider`
- `ServiceProvider` remains the runtime owner

That means the remaining justified concern is no longer an isolated feature state surface.

It is the consistency between those surfaces.

## Problem Statement

Even after the independent normalization of Billing, Dashboard, and Auth, the product may still feel partially fragmented if equivalent visible situations are expressed through different:

- copy
- action labels
- loading semantics
- retry semantics
- recoverable error semantics
- spacing / density decisions
- feedback patterns
- Web vs Android behavior expectations

Without an explicit inventory, later changes risk becoming arbitrary wording edits instead of controlled consistency work.

## Scope

This inventory includes review of:

- Auth
- Dashboard
- Billing

and compares them across:

- visible wording
- action naming
- loading feedback
- error feedback
- retry discoverability
- empty / unavailable communication
- local spacing / density differences when they affect perceived consistency
- Web vs Android visible parity where relevant

This inventory does not include:

- architecture redesign
- runtime redesign
- backend flow changes
- `ServiceProvider` ownership changes
- immediate visual implementation changes
- speculative design-system expansion

## Root Cause Analysis

Phase 9.2 solved the dominant problem at the feature level.

Each critical surface now has clearer internal state presentation.

However, those improvements were intentionally delivered feature by feature.

That means the repository still lacks an explicit cross-feature contract for:

- shared tone
- shared visible semantics
- shared retry wording
- shared action naming expectations
- shared feedback hierarchy

The next justified step is therefore to inventory those cross-feature differences explicitly.

## Files Affected

This step documents interpretation of:

- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/shared/widgets/**`
- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase9_product_surface_consistency_ux_hardening.md`

This step introduces:

- `docs/phase9_product_surface_consistency_ux_hardening_9_3_1_cross_feature_ux_consistency_inventory.md`

## Implementation Characteristics

### 1. This step is inventory-first

The purpose here is to describe inconsistency precisely before applying broader adjustments.

### 2. The architecture remains untouched

All analysis continues to preserve:

- `presentation → controller → ServiceProvider`

### 3. Runtime ownership remains untouched

The inventory does not reinterpret `ServiceProvider`, runtime recovery, or transport ownership.

### 4. The target is coherence, not redesign

The goal is to identify how already-hardened surfaces can behave more like parts of one product.

### 5. Findings must stay grounded in the real ZIP

No inconsistency should be documented purely by assumption.

The inventory must remain tied to the current repository state.

## Validation

This inventory is valid if it helps distinguish between:

- what has already been normalized per feature
- what remains inconsistent across features
- what later work may standardize safely
- what remains deliberately out of scope

The current repository state justifies this inventory because the three critical features have already been normalized independently.

## Release Impact

This step has no direct runtime impact.

It improves:

- clarity of the active Phase 9 roadmap
- justification for later cross-feature UX work
- documentation traceability

## Risks

If this step is skipped or documented loosely, later work may:

- overcorrect non-problems
- introduce wording drift
- mix local UI preference with justified consistency work
- treat redesign as a small UX adjustment

## What it does NOT solve

This document does not itself:

- change copy in code
- change spacing in code
- change layout in code
- alter runtime semantics
- close Phase 9 formally

It only records the cross-feature inventory baseline.

## Conclusion

Phase 9.3.1 is the correct next documented step after the closure of the independent Billing, Dashboard, and Auth normalization work.

It establishes the inventory baseline required for controlled cross-feature UX consolidation.