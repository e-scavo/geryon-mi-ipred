# Phase 13.2 — Store Listing Visual Consistency Contract

## Objective

Formalize the visual consistency contract for Mi IP·RED Play Store assets so each versioned publication surface preserves a coherent screenshot narrative, recommended naming baseline, and a stable relationship between screenshots, feature graphic, and public metadata.

## Initial Context

The current ZIP already confirms that Phase 13.1 is implemented and working:

- `validate_store_assets.dart` validates minimum real asset readiness
- the versioned publication surface already exists under `distribution/play_store/releases/<version>/`
- the active release already includes minimum required phone screenshots and a feature graphic
- readiness reports already distinguish required failures from optional warnings

That means the next justified gap is no longer whether assets exist.
It is whether the selected assets form a stable, representative, and repeatable listing baseline.

## Problem Statement

After Phase 13.1, the repository can confirm the presence of minimum assets, but it still cannot formally answer:

- whether the phone screenshots reflect the most important application surfaces
- whether the screenshot set follows a stable ordering and naming contract
- whether the feature graphic remains aligned with the same visual narrative
- whether a release can drift into an arbitrary listing even while technically passing readiness

Without this layer, store presence can remain structurally valid but editorially inconsistent.

## Scope

Phase 13.2 covers:

- a documented visual selection contract for store assets
- recommended screenshot ordering and coverage expectations
- naming guidance by asset group
- alignment rules between screenshots and feature graphic
- non-blocking validator warnings for visual consistency gaps

Phase 13.2 does not cover:

- UI changes
- automatic screenshot capture
- OCR or image-content inspection
- dimension/aspect-ratio enforcement
- automatic publication through Play Console

## Root Cause Analysis

Phase 13.1 intentionally solved the minimum readiness problem only.
That was the correct first step.

However, once the repository can verify that assets exist, the remaining operational gap becomes editorial consistency:

- selection
- ordering
- naming
- narrative stability

This gap must be closed without turning the validator into a rigid visual-review engine.

## Files Affected

Phase 13.2 updates or introduces:

- `validate_store_assets.dart`
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/phase13_store_execution_integrity_market_presence_hardening.md`
- `distribution/play_store/asset_requirements.md`
- `distribution/play_store/release_checklist.md`
- `distribution/play_store/visual_selection_contract.md`
- `docs/phase13_store_execution_integrity_market_presence_hardening_13_2_store_listing_visual_consistency_contract.md`

## Implementation Characteristics

Phase 13.2 keeps the current technical gate intact:

- missing required groups still produce `FAIL`
- optional tablet groups can still remain warning-only

What changes is the richness of the consistency guidance:

- recommended phone baseline becomes 4 screenshots or more
- filename-derived coverage is checked for login and dashboard
- filename-derived warnings highlight missing billing / receipts / payment coverage
- feature graphic naming remains aligned with `feature_graphic.png`

These rules intentionally remain warning-based.
They improve the store baseline without prematurely blocking the release flow.

## Validation

Phase 13.2 is correctly implemented only if the ZIP confirms all of the following:

- Phase 13.1 is already working and unchanged as the minimum gate
- the new store document map includes a dedicated visual-selection contract
- the validator produces richer consistency warnings without changing required failure semantics
- documentation now distinguishes minimum readiness from listing coherence

## Risks

If this layer is skipped:

- a technically valid release can still carry a weak or arbitrary screenshot set
- visual drift between releases becomes harder to detect
- the feature graphic can remain disconnected from the rest of the publication narrative

If it is overdone too early:

- the validator can become brittle
- publication can be blocked for editorial reasons that still require human judgment

Phase 13.2 avoids that by keeping consistency checks in the warning tier.

## What it does NOT solve

This subphase does not:

- guarantee that screenshots are visually “good” in a subjective sense
- inspect text, layout, or composition inside the image pixels
- guarantee Play Console compliance by itself
- replace manual store-listing review

It formalizes the consistency contract the repository can safely enforce from filenames, structure, and documented selection policy.

## Conclusion

Phase 13.2 is the correct continuation of Phase 13 because it turns minimum store readiness into a governed listing baseline.

The repository already knew how to verify the presence of assets.
Now it also knows how those assets should be selected, ordered, and kept consistent across releases.
