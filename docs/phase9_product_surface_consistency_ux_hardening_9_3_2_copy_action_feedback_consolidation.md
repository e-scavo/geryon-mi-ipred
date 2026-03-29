# 🧩 Phase 9.3.2 — Copy / Action / Feedback Consolidation

## Objective

Define the cross-feature UX contract that should govern visible consistency across:

- Auth
- Dashboard
- Billing

with emphasis on:

- copy tone
- action labels
- loading wording
- recoverable error wording
- retry wording
- feedback hierarchy

This step exists so that future visible adjustments can be guided by an explicit documented baseline rather than by isolated wording edits.

## Initial Context

Phase 9.3.1 documented that the remaining justified concern after Phase 9.2 is not a single feature surface.

It is the consistency between already-normalized surfaces.

The current ZIP confirms that:

- Billing has already been normalized as a feature surface
- Dashboard has already been normalized as a feature surface
- Auth has already been normalized as a feature surface
- the architecture remains `presentation → controller → ServiceProvider`
- `ServiceProvider` remains the runtime owner
- no architecture or runtime redesign is justified

That means this step should define the consolidation contract before broader visual adjustments are proposed.

## Problem Statement

Without a documented cross-feature contract, later wording or feedback changes can become:

- inconsistent between features
- hard to review
- hard to justify
- easy to overextend into redesign

The repository therefore needs explicit documentation of how equivalent visible situations should be expressed across the critical product surfaces.

## Scope

This step defines baseline rules for:

- user-facing tone
- action naming
- loading wording
- recoverable error wording
- retry labels
- feedback hierarchy

This step applies to:

- Auth
- Dashboard
- Billing

This step does not include:

- architecture changes
- runtime changes
- backend-flow changes
- navigation redesign
- broad visual redesign
- speculative design-system expansion
- claiming code implementation that is not yet explicitly validated and applied

## Root Cause Analysis

The repository reached Phase 9.3 only after feature-by-feature normalization.

That means the remaining inconsistency is no longer primarily structural or runtime-related.

It is perceptual and semantic:

- similar situations are still described differently
- action affordances may still feel uneven
- retry and feedback language may still drift feature by feature

A documented contract is the safest way to consolidate those semantics without creating ownership drift.

## Files Affected

This step updates interpretation of:

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase9_product_surface_consistency_ux_hardening.md`
- `docs/phase9_product_surface_consistency_ux_hardening_9_3_1_cross_feature_ux_consistency_inventory.md`

This step introduces:

- `docs/phase9_product_surface_consistency_ux_hardening_9_3_2_copy_action_feedback_consolidation.md`

## Implementation Characteristics

### 1. Tone should remain product-local and natural

User-facing wording should prefer:

- clear Spanish
- direct user guidance
- minimal technical language
- natural phrasing over robotic phrasing

### 2. Action labels should be explicit

When practical, action labels should express:

- what the user can do
- enough context to reduce ambiguity

That avoids uneven action naming across features.

### 3. Loading wording should stay meaningful

Loading states should avoid generic ambiguity when a narrower wording is possible.

The wording should reflect the feature context without becoming overly verbose.

### 4. Recoverable errors should explain both problem and next action

Where a recoverable visible error is shown, the preferred pattern is:

- what happened
- what the user can do next

This keeps retry discoverability aligned across features.

### 5. Retry wording should remain consistent

Equivalent recoverable retry actions should not drift into unrelated labels unless the feature context truly requires it.

### 6. Feedback hierarchy should remain proportional

The repository should continue to prefer:

- inline feedback for feature-local recoverable issues
- feature-level error surfaces for durable recoverable failures
- heavier outer failure surfaces only for broader or unexpected failures

### 7. This document defines the contract, not a hidden redesign

This step records the baseline rules.

Any later code application must still remain:

- incremental
- explicitly reviewed
- consistent with current ownership boundaries

## Validation

This document is valid if it provides a stable review baseline for future visible changes and if it remains aligned with all of the following:

- architecture remains unchanged
- `ServiceProvider` remains the runtime owner
- controllers remain owners of feature-state meaning
- widgets remain presentation-focused
- cross-feature consistency is improved without redesign

## Release Impact

This step has no direct runtime impact by itself.

Its value is documentary and governance-oriented:

- it reduces future wording drift
- it improves reviewability of later UX adjustments
- it preserves traceability between inventory and implementation

## Risks

If this contract is ignored or overextended, future work may either:

- continue drifting feature by feature, or
- overreact with a redesign that is not justified by the real ZIP

Both outcomes are undesirable.

## What it does NOT solve

This document does not itself:

- guarantee that all wording is already unified in code
- implement spacing changes
- implement layout changes
- implement platform parity changes
- close Phase 9 formally

It only defines the cross-feature copy / action / feedback baseline.

## Conclusion

Phase 9.3.2 is the correct documentary continuation after the inventory baseline of Phase 9.3.1.

It gives the repository an explicit cross-feature UX contract that later implementation work can follow without reopening architecture or runtime concerns.