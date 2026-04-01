# Phase 13.1 — Store Asset Readiness Baseline

## Objective

Introduce a deterministic local validation step that confirms whether the versioned Play Store surface for Mi IP·RED contains the minimum real visual assets required for a safe publication handoff.

## Initial Context

By the end of Phase 12.4, the repository already provided:

- validated release artifacts under `dist/`
- a versioned submission bundle under `distribution/submissions/<version>/`
- a versioned publication surface under `distribution/play_store/releases/<version>/`
- Android asset directories for phone, 7-inch, 10-inch, and feature-graphic material
- rollout contracts, post-upload evidence, and automation boundaries

That means the missing concern is no longer where assets belong.
It is whether the exact versioned surface actually contains the expected material.

## Problem Statement

Without a readiness validator, the repository can prepare a complete publication surface while the asset directories still contain only README guidance files.

That leaves several operational questions unanswered until very late:

- are the required phone screenshots really present?
- is there at least one real feature graphic for the active version?
- were invalid or empty files mixed into the asset directories?
- does the operator have a stored readiness result before upload?

## Scope

Phase 13.1 covers:

- a dedicated `validate_store_assets.dart` script
- minimum required asset rules for `phone_screenshots` and `feature_graphic`
- warning-only treatment of optional 7-inch and 10-inch groups
- versioned readiness manifest generation
- versioned readiness summary generation
- documentary alignment of release and store-operation guidance

Phase 13.1 does not cover:

- automatic screenshot capture
- image-dimension or aspect-ratio enforcement
- OCR or image-content analysis
- Play Console automation
- automatic promotion or production approval

## Root Cause Analysis

Phase 12 solved the publication-structure problem.
It did not validate the actual contents of the generated asset directories.

The root cause was therefore not missing rollout structure.
It was the absence of a local readiness gate for the real visual material tied to the active version.

## Files Affected

- `validate_store_assets.dart`
- `distribution/play_store/asset_requirements.md`
- `distribution/play_store/release_checklist.md`
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/phase13_store_execution_integrity_market_presence_hardening.md`
- `docs/phase13_store_execution_integrity_market_presence_hardening_13_1_store_asset_readiness_baseline.md`

## Implementation Characteristics

### 1. Dedicated local validator

The repository now includes `validate_store_assets.dart` as the canonical store-asset readiness validator.

It works against:

- `distribution/play_store/releases/<version>/`

and uses the same synchronized version source already established in the Phase 11 tooling baseline.

### 2. Minimum required groups

Phase 13.1 establishes required readiness for:

- `android/phone_screenshots/` with at least 2 valid images
- `android/feature_graphic/` with at least 1 valid image

Valid images are currently defined conservatively as non-empty files with supported extensions:

- `.png`
- `.jpg`
- `.jpeg`

### 3. Optional groups remain visible but non-blocking

The validator also evaluates:

- `android/seven_inch_screenshots/`
- `android/ten_inch_screenshots/`

Those groups are reported as optional and surface warnings when they are still empty, but they do not fail the release by themselves.

### 4. Readiness manifest and summary

The validator generates:

- `distribution/play_store/releases/<version>/asset_readiness_manifest_<version>.json`
- `distribution/play_store/releases/<version>/asset_readiness_summary.md`
- `distribution/play_store/asset_readiness_latest.json`

This makes the readiness result both machine-readable and operator-readable.

### 5. Warning-only naming guidance

Phase 13.1 introduces a recommended naming baseline such as:

- `phone_01_login.png`
- `phone_02_dashboard.png`
- `tablet7_01_dashboard.png`
- `tablet10_01_dashboard.png`
- `feature_graphic.png`

Naming mismatches generate warnings, not blocking failures.

## Validation

This subphase is correct only if the repository can now:

- preserve the Phase 11 and Phase 12 baselines untouched
- validate the current versioned publication surface without calling external services
- fail when required groups are missing or incomplete
- emit a readable summary that clearly explains the blocking gaps
- keep the result tied to the same version already used by release and publication tooling

## Risks

If this layer is skipped:

- required screenshots or feature graphic can still be missing at upload time
- operators must infer readiness manually from directory contents
- versioned publication surfaces can appear complete while still lacking real assets

## What it does NOT solve

This subphase does not:

- prove that the images are visually good or policy-compliant
- validate exact Play Console pixel requirements yet
- publish to Play Console
- replace human review of the final store listing

It only introduces the minimum deterministic readiness baseline for the asset surface.

## Conclusion

Phase 13.1 is the correct first implementation step of Phase 13 because it closes the real gap left after Phase 12.4.

The repository already knew how to prepare the publication surface.
Now it also knows how to verify whether that surface contains the minimum real visual assets required for a safe store handoff.
