# Phase 11.2 — Packaging & Artifact Structuring

## Objective

Establish the second concrete release/distribution baseline for Mi IP·RED by transforming raw Flutter/Gradle build outputs into stable, versioned, operator-facing artifacts.

## Initial Context

Before this subphase, the repository already confirmed:

- Phase 10.2 completed the controlled exposure of the supported financial capability surface
- Phase 11.1 standardized synchronized versioning and reproducible Web / APK / AAB builds
- no product, runtime, layout, or responsive baseline should be reopened

That means the next real work was not feature implementation and no longer basic release generation.
It was packaging structure.

## Problem Statement

The post-11.1 repository could compile reproducibly, but it still left release handoff too dependent on native output folders such as:

- `build/web/`
- `build/app/outputs/flutter-apk/`
- `build/app/outputs/bundle/release/`

That meant the technical build step was standardized while the operational delivery step remained weak:

- artifact names were still generic
- outputs remained dispersed by toolchain defaults
- release handoff still required manual identification
- there was no manifest describing the generated release set

## Scope

This subphase includes:

- structured artifact copying into `dist/` by default
- version-aware naming for:
  - Web
  - APK
  - AAB
- release manifest generation per version
- rolling latest manifest generation
- optional dist cleanup for the current version
- optional dist-root override for alternate output destinations
- documentation updates reflecting the 11.2 baseline

This subphase does not include:

- UI changes
- business logic changes
- backend protocol changes
- responsive/layout changes
- Play Console publication
- release signing policy cleanup
- CI/CD platform integration

## Root Cause Analysis

Phase 11.1 correctly solved build reproducibility, but reproducible builds are not the same as reproducible release handoff.

The repository still depended on raw toolchain output conventions, which are acceptable for local engineering work but weaker for operator-facing distribution steps.

Because earlier phases were focused on functionality, runtime, UX, and capability exposure, this packaging layer was intentionally deferred until the product and build baselines were already stable.

## Files Affected

### Runtime / release utility files
- `build_and_commit.dart`
- `.gitignore`

### Documentation
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase11_release_distribution.md`
- `docs/phase11_release_distribution_11_2_packaging_artifact_structuring.md`

## Implementation Characteristics

### 1. Structured dist root

The release script now copies artifacts into a stable distribution root:

- default: `dist/`
- override: `--dist-root=...`

This creates a packaging surface intended for operator handoff rather than raw build internals.

### 2. Versioned artifact naming

The script now renames and structures artifacts using stable version-aware names:

- `dist/web/mi-ipred-web-<version>/`
- `dist/android/apk/mi-ipred-android-apk-<version>.apk`
- `dist/android/aab/mi-ipred-android-aab-<version>.aab`

### 3. Web packaging is folder-based

Web output remains a copied folder instead of a compressed archive so the structure stays transparent, easy to inspect, and independent of platform-specific compression tooling.

### 4. Release manifest generation

Every structured release now generates:

- `dist/release_manifest_<version>.json`
- `dist/release_manifest_latest.json`

These files provide an operator-facing summary of:

- app identity
- version
- generation timestamp
- configured dist root
- generated artifact paths

### 5. Controlled dist cleanup

`--clean-dist` only cleans the current version outputs before copying, avoiding unnecessary destruction of other previously generated version folders.

### 6. Repository hygiene alignment

`.gitignore` now ignores `dist/` because structured packaging outputs are generated artifacts rather than source-of-truth repository content.

## Validation

This subphase is valid only if all of the following are true:

- existing build/versioning behavior from 11.1 remains intact
- no product behavior changes as a side effect of packaging work
- structured artifact paths are deterministic for a given version
- the manifest truthfully reflects the artifacts produced in the current run
- the repository still treats packaging as release work rather than product redesign

## Release Impact

Direct release impact:

- easier artifact identification
- safer handoff to operators or publication workflows
- clearer separation between raw build folders and distribution-ready outputs
- better preparation for later store/distribution steps

## Risks

### Low risk

The changes are low risk because they are isolated to:

- build packaging utilities
- generated artifact paths
- documentation

### Remaining caution

This subphase still does not solve:

- release signing policy cleanup
- publication metadata readiness
- post-build smoke-test orchestration
- remote CI/CD execution

Those concerns remain out of scope for 11.2 and belong to later Phase 11 work.

## Git Commands

### Crear branch

    git checkout main
    git pull origin main
    git checkout -b phase-11-2-packaging-artifact-structuring

### Commit

    git add .
    git commit -m "Phase 11.2: packaging and artifact structuring"

### Merge

    git checkout main
    git pull origin main
    git merge phase-11-2-packaging-artifact-structuring

### Limpieza

    git branch -d phase-11-2-packaging-artifact-structuring
    git push origin --delete phase-11-2-packaging-artifact-structuring

## What it does NOT solve

This subphase does not yet solve:

- Play Console publication
- signed artifact verification
- store asset readiness
- automated remote pipeline execution
- release smoke-test matrix formalization

Those belong to later justified release/distribution work.

## Conclusion

Phase 11.2 is the correct second release/distribution implementation step because it improves artifact handoff quality without touching product behavior.

It standardizes packaging structure.
It standardizes artifact naming.
It preserves all earlier baselines.
