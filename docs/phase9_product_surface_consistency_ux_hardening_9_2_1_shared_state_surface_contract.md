# 🧩 Phase 9.2.1 — Shared State Surface Contract

## Objective

Introduce the minimal shared UI contract required to present loading, recoverable error, and empty states consistently across features without redesigning the application or creating a new UI framework.

## Initial Context

The ZIP already contains:

- `LoadingGeneric`
- `CatchMainScreen`
- feature-local state rendering in auth, dashboard, and billing

However, those pieces are not yet governed by a single visible product-surface contract.

## Problem Statement

Equivalent user-facing states are currently rendered through different UI surfaces depending on feature history rather than product policy.

This makes the product feel uneven even when the underlying feature logic is already sound.

## Scope

This step includes:

- a shared loading surface widget
- a shared recoverable feature-error surface widget
- a shared empty-state surface widget
- compatibility preservation for `LoadingGeneric`

This step does not include:

- applying the new widgets to every feature yet
- replacing `CatchMainScreen`
- redesigning auth, dashboard, or billing in the same step
- introducing a global UI framework

## Root Cause Analysis

The existing repository has partial reusable pieces but no explicit contract for:

- what a loading surface should look like
- what a recoverable feature error should look like
- what a true empty state should look like

The correct minimal response is therefore to define a shared surface contract before feature-by-feature adoption.

## Files Affected

This step introduces or updates:

- `lib/shared/widgets/feature_loading_state.dart`
- `lib/shared/widgets/feature_error_state.dart`
- `lib/shared/widgets/feature_empty_state.dart`
- `lib/models/LoadingGeneric/widget.dart`

## Implementation Characteristics

### 1. Minimal shared widgets only

The new widgets are intentionally small.

They solve presentation consistency, not state ownership.

### 2. Compatibility retained

`LoadingGeneric` remains usable and now delegates to the shared loading surface.

### 3. Feature-local adoption remains a later step

This phase foundation does not yet rewrite auth, dashboard, or billing.

It prepares the shared surfaces that those features can adopt safely in later substeps.

### 4. Technical/system failure surfaces remain distinct

`CatchMainScreen` remains available for higher-severity or system-oriented cases.

This step does not collapse system failures and recoverable feature failures into the same UI surface.

## Validation

This step is valid only if:

- the new widgets compile cleanly
- `LoadingGeneric` remains compatible
- no architecture change is introduced
- no feature ownership moves into shared widgets
- later feature normalization is now possible without duplicating surface logic

## Release Impact

This step has low direct user-facing impact until adoption begins, but it materially improves implementation readiness for consistent UX hardening.

## Risks

If overextended, this step could:

- become a hidden UI framework
- absorb logic that belongs in controllers
- prematurely replace feature-local semantics

The implementation must therefore remain narrow and presentation-only.

## What it does NOT solve

This step does not yet:

- normalize billing rendering
- normalize dashboard rendering
- improve login visible feedback directly
- resolve retry wiring in existing screens

Those belong to later Phase 9.2 substeps.

## Conclusion

Phase 9.2.1 correctly establishes the smallest safe shared-state surface contract needed for consistent product-surface hardening in later steps.