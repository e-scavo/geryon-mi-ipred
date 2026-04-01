# Phase 11.4 — Final Release Operations & Submission Checklist

## Objective

Close the remaining operational gap after Phase 11.3 by generating a final submission bundle that snapshots the validated release, the store metadata, and the operator checklist into one versioned handoff surface.

## Initial Context

Before this subphase, the repository already provided:

- synchronized version data
- reproducible Web / APK / AAB builds
- structured release artifacts in `dist/`
- release manifest and validation JSON reports
- local Android signing contract documentation
- Play Store metadata scaffolding

That means the remaining issue was no longer technical build reproducibility, but operational release handoff.

## Problem Statement

Even after 11.3, the operator still had to manually gather:

- the validated artifact set
- the corresponding manifest and validation reports
- the Play Store listing text
- the final checklist describing what to upload and verify

This left the repository one step short of a clean final release handoff.

## Scope

Phase 11.4 includes:

- `prepare_submission_bundle.dart` as the canonical final handoff command
- optional integration with `build_and_commit.dart`
- versioned submission bundles under `distribution/submissions/`
- tracked Play Store asset requirements documentation
- stricter validation that the keystore referenced by `android/key.properties` actually exists
- updated release checklist for final operator workflow
- documentation alignment for the final operational release baseline

Phase 11.4 does not include:

- automatic screenshot capture
- direct Play Console API publication
- CI/CD secret storage redesign
- binary asset storage inside the repository
- product/runtime/UI changes

## Root Cause Analysis

The previous Phase 11 subphases solved:

- build/versioning consistency
- artifact structuring
- publication-surface validation

However, the handoff itself was still fragmented.

A release could be valid and still be awkward operationally if the operator must manually reassemble the final submission package every time.

## Files Affected

- `build_and_commit.dart`
- `validate_release.dart`
- `prepare_submission_bundle.dart`
- `.gitignore`
- `distribution/play_store/release_checklist.md`
- `distribution/play_store/asset_requirements.md`
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase11_release_distribution.md`
- `docs/phase11_release_distribution_11_4_final_release_operations_submission_checklist.md`

## Implementation Characteristics

### 1. Final submission bundle command

A new canonical command is introduced:

    dart run prepare_submission_bundle.dart

It creates a versioned handoff root under:

    distribution/submissions/<version>/

The bundle includes:

- copied release artifacts
- release manifest JSON
- release validation JSON
- Play Store checklist
- Play Store metadata text
- submission summary markdown
- submission bundle manifest JSON

### 2. Optional integration with build automation

`build_and_commit.dart` now supports:

- `--prepare-submission-bundle`
- `--prepare-submission-only`
- `--submission-root=...`

This preserves the validated build pipeline while allowing a final operator bundle to be created from either a fresh build or an already validated dist tree.

### 3. Stricter release validation

`validate_release.dart` now also verifies:

- the keystore path referenced by `android/key.properties` resolves to an existing local file
- the minimum Play Store metadata/checklist baseline exists in `distribution/play_store/`

### 4. Play Store asset requirements baseline

A tracked file now documents the minimum visual asset expectations:

- screenshots
- feature graphic
- release-version alignment of the captured material

This keeps the repository honest about what is still manually required for final publication.

## Validation

This subphase is correct only if the repository can now:

- build and validate a release as before
- prepare a final versioned submission bundle from that release
- prove that the local keystore path is real
- preserve the final handoff as an immutable versioned snapshot

## Risks

If this layer is skipped:

- operators may upload the correct AAB but the wrong text/checklist combination
- release evidence remains fragmented across directories
- manual handoff remains error-prone

## What it does NOT solve

This subphase does not:

- publish to Play Console automatically
- generate screenshots
- manage signing secrets remotely
- replace human final review

It only closes the operator handoff gap.

## Conclusion

Phase 11.4 completes the current release/distribution track by turning the validated release output into a final versioned submission bundle.

At this point, Phase 11 becomes operationally complete for local/manual release readiness.
