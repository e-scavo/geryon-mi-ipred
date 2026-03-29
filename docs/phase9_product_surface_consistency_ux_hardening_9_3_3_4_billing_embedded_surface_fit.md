# 🧾 Phase 9.3.3.4 — Billing Embedded Surface Fit

## Objective

Improve billing as an embedded dashboard surface so it feels integrated with the consolidated product rather than like a legacy window dropped inside the page.

## Initial Context

After shared widgets, dashboard rhythm, and auth density were aligned, the most visible remaining mismatch was billing’s embedded composition.

## Problem Statement

Billing still carried a more isolated embedded-window feel, and its internal composition showed a real structural inconsistency: header support existed in the model/caller but was not being rendered.

## Scope

Included:

- `lib/features/billing/presentation/billing_widget.dart`
- `lib/shared/window/window_widget.dart`

Did not include:

- billing controller logic
- billing semantics
- data tables
- runtime behavior
- global responsive review

## Root Cause Analysis

Billing retained a legacy embedded composition style and an incomplete implementation path around `headerWidget`.

## Files Affected

- `lib/features/billing/presentation/billing_widget.dart`
- `lib/shared/window/window_widget.dart`

## Implementation Characteristics

The implementation remained narrow:

- `headerWidget` now renders when present
- embedded composition became more coherent
- header/body transition improved
- title-bar color was later aligned to theme
- reserved height from dashboard was corrected to prevent overflow

## Validation

Success criteria were:

- billing feels more integrated
- header/body composition is truthful to the model
- no overflow remains from the added header
- billing still preserves its section identity

## Release Impact

Low-risk embedded surface improvement with visible polish gain.

## Risks

- duplicate visual hierarchy
- affecting other `WindowWidget` consumers
- mixing resize policy with composition

## What it does NOT solve

This subphase did not solve:

- wide-screen dashboard focus
- cross-platform consistency review
- future responsive strategy

## Conclusion

9.3.3.4 closed the major remaining local fit issue of billing as an embedded surface.