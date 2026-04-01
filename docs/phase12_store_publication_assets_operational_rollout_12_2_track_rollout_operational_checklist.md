# Phase 12.2 — Track Rollout Operational Checklist

## Objective

Formalize a repeatable, version-aligned rollout contract for `internal`, `closed`, and `production` Play Console tracks without changing any functional behavior of Mi IP·RED.

## Initial Context

By the end of Phase 12.1, the repository already provided:

- a validated release baseline under `dist/`
- a final submission handoff under `distribution/submissions/<version>/`
- a generated publication surface under `distribution/play_store/releases/<version>/`
- store asset directories and rollout-note roots per track

That means the remaining publication gap is no longer structural asset organization.
It is the operator decision contract for how a version is advanced across tracks.

## Problem Statement

Before this subphase, the publication surface had rollout directories, but it still lacked a canonical operational contract that answered:

- what must be checked before uploading to `internal`
- what evidence must exist before promoting to `closed`
- what gates must be satisfied before `production`
- how the active target track is recorded for the current generated surface

Without those contracts, the versioned publication surface exists, but promotion between tracks still depends too heavily on memory and manual interpretation.

## Scope

Phase 12.2 covers:

- per-track operational checklists for `internal`, `closed`, and `production`
- promotion-gate documentation between tracks
- active-track registration inside the generated publication surface
- evidence templates for rollout validation and upload notes
- release-documentation alignment for the new rollout contract

Phase 12.2 does not cover:

- actual Play Console upload automation
- review-result parsing from Google Play
- screenshot generation
- product/runtime/business-logic changes
- CI/CD credential management

## Root Cause Analysis

Phase 12.1 correctly solved the publication-surface structure problem.

However, simply having folders for rollout notes is not enough.
Operators still need an explicit contract for:

- when a version can start in a given track
- what must be validated before promotion
- what evidence should remain inside the surface after each rollout step

The missing layer was therefore procedural, not technical.

## Files Affected

- `prepare_store_publication.dart`
- `distribution/play_store/release_checklist.md`
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/phase12_store_publication_assets_operational_rollout.md`
- `docs/phase12_store_publication_assets_operational_rollout_12_2_track_rollout_operational_checklist.md`

## Implementation Characteristics

### 1. Active-track aware publication surface

`prepare_store_publication.dart` already accepted `--release-track`.

Phase 12.2 turns that option into a stronger operational contract by generating:

- `rollout/active_track.md`
- track-scoped checklists
- promotion-gate documents
- evidence templates per track

That reduces ambiguity about which track the current publication surface is being prepared for.

### 2. Per-track checklist generation

Each generated rollout track directory now contains explicit operator guidance for:

- upload readiness
- smoke validation
- metadata / asset consistency
- promotion conditions for the next track

### 3. Promotion-gate formalization

The generated surface now documents the gates that must be met before a version moves from:

- `internal` → `closed`
- `closed` → `production`

This keeps rollout progression tied to a stable versioned contract rather than informal memory.

### 4. Evidence capture template

Each track now receives an evidence template so the operator can record:

- upload date/time
- console state
- testers or audience reached
- approval / blocker observations
- promotion decision

## Validation

This subphase is correct only if the repository can now:

- preserve the Phase 11 and Phase 12.1 baselines untouched
- generate a publication surface that explicitly identifies the active track
- generate track-specific rollout contracts for `internal`, `closed`, and `production`
- leave operator evidence placeholders aligned with the exact version being promoted

## Risks

If this layer is skipped:

- the publication surface exists but still depends on operator memory for promotion decisions
- rollout criteria can drift between versions
- publication evidence becomes inconsistent across tracks
- `production` promotion can happen without a stable repository-side contract

## What it does NOT solve

This subphase does not:

- publish directly to Play Console
- fetch review feedback from Google Play
- automate screenshots or asset rendering
- decide business rollout strategy automatically

It only formalizes the operational contract that must exist before those later concerns are justified.

## Conclusion

Phase 12.2 is the correct next implementation step after Phase 12.1 because it hardens the rollout process without touching application behavior, runtime, UI, or business logic.
