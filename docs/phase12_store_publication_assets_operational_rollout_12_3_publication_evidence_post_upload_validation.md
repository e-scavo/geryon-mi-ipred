# Phase 12.3 — Publication Evidence & Post-Upload Validation

## Objective

Complete the repository-side publication trail by generating version-aligned post-upload evidence and validation records for `internal`, `closed`, and `production`, without changing any functional behavior of Mi IP·RED.

## Initial Context

By the end of Phase 12.2, the repository already provided:

- a validated release baseline under `dist/`
- a final submission handoff under `distribution/submissions/<version>/`
- a generated publication surface under `distribution/play_store/releases/<version>/`
- track-scoped rollout notes, checklists, promotion gates, and evidence templates
- active-track guidance for the exact generated surface

That means the next remaining publication gap is no longer structure or rollout gating.
It is the repository-side evidence that remains after the upload and validation actually happen.

## Problem Statement

Before this subphase, the publication surface already had versioned rollout preparation, but it still lacked a canonical post-upload record that answered:

- when the version was uploaded to a given track
- what the operator observed in Play Console after the upload
- what manual validation was executed after the upload
- whether the version was blocked, approved, or promoted
- where the final operator decision should remain inside the versioned surface

Without that layer, the repository can prepare publication work, but it cannot keep a stable audit trail of what actually happened afterward.

## Scope

Phase 12.3 covers:

- a publication ledger inside the generated publication surface
- post-upload evidence directories for `internal`, `closed`, and `production`
- upload-receipt templates per track
- post-upload validation templates per track
- promotion-decision templates per track
- release-documentation alignment for the new evidence contract

Phase 12.3 does not cover:

- direct Play Console API automation
- polling Google Play review status
- automated crash or analytics ingestion
- application/runtime/business-logic changes
- external incident-management integration

## Root Cause Analysis

Phase 12.1 solved the publication-surface structure problem.
Phase 12.2 solved the track rollout contract problem.

However, operators still needed a canonical place to record what happened after the upload and validation steps.

The missing layer was therefore not structural and not behavioral.
It was operational traceability.

## Files Affected

- `prepare_store_publication.dart`
- `distribution/play_store/release_checklist.md`
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/phase12_store_publication_assets_operational_rollout.md`
- `docs/phase12_store_publication_assets_operational_rollout_12_3_publication_evidence_post_upload_validation.md`

## Implementation Characteristics

### 1. Publication ledger generation

The generated publication surface now includes `publication_ledger.md`.

Its purpose is to centralize the repository-side audit trail for the version, including the active track, expected evidence files, and final operator summary notes.

### 2. Post-upload evidence per track

Each track now receives dedicated files under `evidence/<track>/` for:

- upload receipt
- post-upload validation
- promotion decision

That separates post-upload facts from pre-upload rollout preparation.

### 3. Validation-specific contract

The generated post-upload validation files keep the operator aligned on what must be checked after upload, such as:

- console state
- audience / tester reach
- smoke validation
- blockers, incidents, or regressions
- next action for the track

### 4. Promotion-decision persistence

Promotion is no longer documented only as an idea inside a gate or evidence template.
It now has its own versioned file per track so the final decision remains explicit and auditable.

## Validation

This subphase is correct only if the repository can now:

- preserve the Phase 11, Phase 12.1, and Phase 12.2 baselines untouched
- generate a publication surface with a stable `evidence/` root
- generate upload, validation, and promotion-decision files for `internal`, `closed`, and `production`
- keep the publication ledger aligned with the exact version and active track

## Risks

If this layer is skipped:

- uploads can happen without a stable repository-side record
- validation outcomes can remain scattered across ad hoc notes
- promotion decisions can become ambiguous between tracks
- the rollout trail becomes harder to audit after the fact

## What it does NOT solve

This subphase does not:

- publish directly to Play Console
- read Google Play review outcomes automatically
- consume external analytics or crash signals
- decide rollout strategy automatically

It only formalizes the repository-side evidence that must remain after the upload and validation work.

## Conclusion

Phase 12.3 is the correct next implementation step after Phase 12.2 because it closes the post-upload evidence gap without touching application behavior, runtime, UI, or business logic.
