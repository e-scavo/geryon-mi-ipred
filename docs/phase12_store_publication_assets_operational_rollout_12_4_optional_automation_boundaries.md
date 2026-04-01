# Phase 12.4 — Optional Automation Boundaries

## Objective

Define a safe automation boundary for store-publication support so Mi IP·RED can keep benefiting from repository-side tooling without allowing scripts to silently upload, promote, or publish a release in Play Console.

## Initial Context

By the end of Phase 12.3, the repository already provided:

- validated release artifacts under `dist/`
- a versioned submission handoff under `distribution/submissions/<version>/`
- a versioned publication surface under `distribution/play_store/releases/<version>/`
- rollout contracts for `internal`, `closed`, and `production`
- post-upload evidence and a publication ledger

That means the remaining justified gap is no longer release preparation or rollout traceability.
It is the explicit boundary that says what the repository may automate and what must remain human-controlled.

## Problem Statement

Without an explicit automation boundary, future tooling can drift into unsafe territory.
Even if today the repository only prepares materials, a later script could be misread as permission to:

- upload directly to Play Console
- promote a version between tracks automatically
- treat generated templates as approval for production rollout
- collapse operator review into a single scripted action

That would be inconsistent with the current baseline, where Play Console actions still require manual verification and human go/no-go decisions.

## Scope

Phase 12.4 covers:

- automation-boundary files generated inside the publication surface
- a matrix that classifies work as automatic, assisted, or manual-required
- explicit guardrails for future publication tooling
- release-documentation alignment for the new safety contract

Phase 12.4 does not cover:

- direct Play Console API integration
- credential storage for publication automation
- automated release promotion
- automated production rollout percentage management
- application/runtime/business-logic changes

## Root Cause Analysis

Phase 12.1 solved the publication-surface structure problem.
Phase 12.2 solved the track rollout contract problem.
Phase 12.3 solved the post-upload evidence problem.

What still remained implicit was the limit of automation itself.
The repository could generate increasingly strong publication scaffolding, but it still needed a clear statement that scaffolding is not the same thing as autonomous publishing.

## Files Affected

- `prepare_store_publication.dart`
- `distribution/play_store/release_checklist.md`
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/phase12_store_publication_assets_operational_rollout.md`
- `docs/phase12_store_publication_assets_operational_rollout_12_4_optional_automation_boundaries.md`

## Implementation Characteristics

### 1. Automation boundary matrix

The generated publication surface now includes an automation matrix that classifies publication work as:

- automatic
- assisted
- manual-required

This gives operators and future maintainers a stable contract for what the repository is allowed to do.

### 2. Manual-required publication control

The generated files explicitly preserve human control over:

- Play Console uploads
- track promotions
- production approvals
- visual/store-listing review
- final go/no-go decisions

### 3. Guardrails for future tooling

The repository now generates a dedicated guardrail document so future automation changes can be evaluated against a written policy instead of tribal knowledge.

### 4. Release-checklist alignment

The Play Store release checklist now references the automation-boundary contract so operational handoff remains aligned with the generated publication surface.

## Validation

This subphase is correct only if the repository can now:

- preserve the Phase 11 and Phase 12.1–12.3 baselines untouched
- generate publication-surface files that define the automation boundary
- make manual-required actions explicit for `internal`, `closed`, and `production`
- keep the publication process repository-assisted but not repository-driven

## Risks

If this layer is skipped:

- future scripts can overstep into unsafe publication behavior
- operators can assume generation equals approval
- the difference between preparation and publishing can become blurry
- production promotion can drift toward implicit rather than explicit control

## What it does NOT solve

This subphase does not:

- publish to Play Console
- store or manage remote publication credentials
- replace operator review
- approve a rollout automatically

It only defines the safe boundary within which publication-support automation may exist.

## Conclusion

Phase 12.4 is the correct closure step for Phase 12 because it formalizes the limit of automation after the repository already learned how to prepare, organize, and document the publication process.
