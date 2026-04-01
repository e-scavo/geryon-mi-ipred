# Phase 12.1 — Store Asset Baseline & Publication Surface Structuring

## Objective

Create the first justified implementation step of Phase 12 by introducing a canonical versioned publication surface that organizes store assets, rollout notes, policy references, metadata copies, and publication summaries for the exact validated Mi IP·RED release.

## Initial Context

Before this subphase, the repository already provided:

- synchronized version information
- structured `dist/` release artifacts
- release validation reports
- final submission bundles under `distribution/submissions/<version>/`
- Play Store metadata files and release/operator checklists
- privacy policy source files in the repository root

That means the remaining gap was not the release bundle.

The remaining gap was the store-publication surface that must sit beside that bundle.

## Problem Statement

The ZIP already documented that screenshots and the feature graphic are required, but it still did not provide a canonical, versioned surface where those materials, the rollout notes, and the validated submission handoff could be organized together.

This made publication work vulnerable to:

- version mixing
- track confusion
- externalized notes with weak traceability

## Scope

Phase 12.1 includes:

- `prepare_store_publication.dart` as the canonical publication-surface generator
- versioned publication roots under `distribution/play_store/releases/<version>/`
- copied metadata/checklist/policy inputs for the same version
- standardized Android store asset directories
- track-scoped rollout note directories for `internal`, `closed`, and `production`
- JSON and Markdown summaries that link the publication surface with the validated submission bundle
- documentation alignment for the new baseline

Phase 12.1 does not include:

- actual Play Console upload
- screenshot capture automation
- binary image storage requirements inside Git
- runtime/UI/business-logic changes

## Root Cause Analysis

Phase 11.4 solved the final local/manual release handoff.

However, that still left publication work one layer outside the repository baseline because the operator had no canonical versioned surface for the store assets and rollout notes that must match the validated handoff.

## Files Affected

- `prepare_store_publication.dart`
- `.gitignore`
- `distribution/play_store/asset_requirements.md`
- `distribution/play_store/release_checklist.md`
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/phase12_store_publication_assets_operational_rollout.md`
- `docs/phase12_store_publication_assets_operational_rollout_12_1_store_asset_baseline_publication_surface_structuring.md`

## Implementation Characteristics

### 1. Canonical publication-surface command

A new canonical command is introduced:

    dart run prepare_store_publication.dart

It creates a versioned publication root under:

    distribution/play_store/releases/<version>/

### 2. Publication surface aligned with validated release

The generator requires the already prepared submission bundle for the active version and links both surfaces together.

That prevents publication work from drifting away from the validated release handoff.

### 3. Standardized store-asset directories

The generated publication surface now includes Android asset roots for:

- phone screenshots
- 7-inch screenshots
- 10-inch screenshots
- feature graphic

Each directory contains tracked guidance for how to place the required material without forcing binary assets into the repository baseline.

### 4. Track rollout structuring

The generated publication surface now includes rollout-note roots for:

- internal
- closed
- production

This keeps rollout decisions versioned and explicit.

## Validation

This subphase is correct only if the repository can now:

- preserve the Phase 11 release/submission baseline untouched
- generate a versioned publication surface for the active version
- copy the publication inputs required for operator work into that surface
- keep rollout notes and store-asset expectations aligned with the exact validated submission bundle

## Risks

If this layer is skipped:

- operators may prepare screenshots and rollout notes outside the repository baseline
- different versions can be mixed accidentally during Play Console upload work
- later publication evidence work will start without a stable root

## What it does NOT solve

This subphase does not:

- upload the release to Play Console
- generate screenshots automatically
- validate store-review results
- replace human rollout review

It only creates the canonical publication surface required before those later steps.

## Conclusion

Phase 12.1 is the correct first implementation step after Phase 11.4 because it closes the store-publication structure gap without reopening application behavior or release reproducibility.
