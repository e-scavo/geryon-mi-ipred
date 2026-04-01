# Phase 13.3 — Publication Readiness Gate

## Objective

Add a single repository-side publication-readiness gate that consolidates the already generated release, submission, publication-surface, and store-asset evidence into one final decision per version.

## Initial context

Before Phase 13.3, Mi IP·RED already had all of the following:

- release validation through `validate_release.dart`
- submission bundle preparation through `prepare_submission_bundle.dart`
- publication-surface preparation through `prepare_store_publication.dart`
- store asset readiness and listing-consistency checks through `validate_store_assets.dart`

The gap was no longer missing evidence.
The gap was the lack of a final consolidated decision that answered whether the current version was ready, ready with warnings, or not ready for a controlled Play Console upload.

## Problem statement

The repository had multiple useful manifests and summaries, but the operator still had to read them separately to determine final publication readiness.
That manual interpretation step was the remaining operational ambiguity after 13.2.

## Scope

Phase 13.3 includes:

- a new final gate script: `evaluate_publication_readiness.dart`
- a versioned final gate manifest
- a versioned final gate summary
- a rolling latest publication-readiness manifest
- release documentation and checklist updates so the final gate becomes part of the normal store workflow

Phase 13.3 does not include:

- automatic Play Console upload
- automatic track promotion
- screenshot generation
- visual scoring from image pixels
- production approval automation

## Root cause

Earlier phases intentionally solved separate concerns:

- Phase 11 solved reproducible release preparation
- Phase 12 solved versioned publication-surface and rollout/evidence structure
- Phase 13.1 solved minimum asset readiness
- Phase 13.2 solved listing-consistency guidance and warnings

None of those phases was responsible for emitting one final consolidated publication decision.

## Implementation characteristics

The new gate:

- reads the synchronized active version from `pubspec.yaml` and `lib/config/version.dart`
- verifies the release/publication roots expected for that version
- reads the existing machine-readable manifests instead of re-implementing all previous checks
- emits `PASS`, `WARNING`, or `FAIL`
- writes:
  - `distribution/play_store/releases/<version>/publication_readiness_gate_<version>.json`
  - `distribution/play_store/releases/<version>/publication_readiness_gate_summary.md`
  - `distribution/play_store/publication_readiness_latest.json`

`FAIL` is reserved for missing or invalid critical evidence.
`WARNING` keeps the flow human-controlled for non-blocking store observations.
`PASS` is available only when the consolidated publication evidence contains no remaining warnings.

## Validation

Phase 13.3 is correct only if the repository can now produce one final consolidated answer that integrates:

- release validation
- submission bundle
- publication surface
- asset readiness
- publication structure (`rollout/` and `evidence/`)

The current implementation does that without reopening application behavior.

## Risks

Main risks:

- duplicating logic already owned by earlier scripts
- turning warning-level publication observations into unnecessary blockers

Mitigation applied:

- the gate reads earlier manifests instead of recreating their internal rules
- warnings remain warnings unless a critical artifact is missing or invalid

## Conclusion

Phase 13.3 closes the remaining local operational ambiguity of the store workflow.
Mi IP·RED now has a final repository-side publication-readiness decision that stays human-controlled while making the pre-upload state auditable and explicit.
