# Phase 11.1 — Build & Versioning Standardization

## Objective

Establish the first concrete release/distribution baseline for Mi IP·RED by making release versioning and build outputs explicit, synchronized, and reproducible across Web and Android.

## Initial Context

Before this subphase, the repository already confirmed:

- product capability completion through Phase 10.2
- stable dashboard exposure of the supported financial capability set
- stable architecture/runtime/UX baselines that must not be reopened

The repository also contained these release-relevant files:

- `pubspec.yaml`
- `lib/config/version.dart`
- `build_and_commit.dart`
- `update_version.dart`
- Android Gradle configuration using Flutter version forwarding

That means the real next work was not feature implementation.
It was to normalize the release/versioning surface already present in the ZIP.

## Problem Statement

The pre-11.1 repository had a real release-standardization gap:

- duplicated version sources existed without a hard synchronization guarantee
- release automation was too narrow for the current delivery needs
- App Bundle output was not treated as a first-class standardized target in the main build flow
- git automation still depended on a retained hardcoded `master` push assumption
- version metadata still exposed a retained old generic title (`GERYON Software`) instead of Mi IP·RED

None of these are product-behavior issues, but all of them directly affect release trustworthiness.

## Scope

This subphase includes:

- version synchronization rules between `pubspec.yaml` and `lib/config/version.dart`
- build target standardization for:
  - Web
  - APK
  - AAB
- explicit release build forwarding of:
  - build-name
  - build-number
- safer optional git commit/push behavior
- version metadata branding alignment
- documentation updates reflecting the Phase 11 opening and the 11.1 baseline

This subphase does not include:

- UI changes
- business logic changes
- backend protocol changes
- responsive/layout changes
- Play Console asset work
- CI/CD platform integration

## Root Cause Analysis

The repository accumulated build/versioning utilities earlier as practical helpers, not as a formal release baseline.

That left several historical remnants:

- branch assumptions from older git habits
- overly coupled build/commit behavior
- Android output not yet normalized around both APK and AAB release needs
- version branding not fully aligned with the current product naming

Because these were not urgent while the dominant concern was product stabilization, they remained unresolved until now.

## Files Affected

### Runtime / release utility files
- `build_and_commit.dart`
- `update_version.dart`
- `lib/config/version.dart`

### Documentation
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase11_release_distribution.md`
- `docs/phase11_release_distribution_11_1_build_versioning_standardization.md`

## Implementation Characteristics

### 1. Version synchronization is now enforced before build

`build_and_commit.dart` now validates that:

- `pubspec.yaml`
- `lib/config/version.dart`

contain the same effective semantic version/build number before any release build starts.

### 2. Build targets are explicit

The standardized build entry point now supports:

- `--web`
- `--apk`
- `--aab`

If no target is specified, the default behavior is to generate:

- Web
- APK
- AAB

This matches the real release/distribution needs better than a partial Android-only flow.

### 3. Release flags are propagated explicitly

Flutter builds are now executed with explicit:

- `--build-name`
- `--build-number`

This keeps Web and Android release artifacts tied to the same declared version source.

### 4. Version bumping is controlled

`update_version.dart` now supports:

- build increment
- patch increment
- minor increment
- major increment
- explicit version set
- optional code-name update
- dry-run validation

### 5. Git mutation is no longer implicit

The build script no longer assumes that every release build should automatically mutate git history.

Instead:

- build is the default concern
- `--git-commit` is opt-in
- `--git-push` is opt-in and requires `--git-commit`
- push targets the current branch instead of a retained hardcoded branch value

### 6. Branding/version metadata is aligned

`lib/config/version.dart` now aligns the exposed title/version metadata with:

- **Mi IP·RED**

instead of the retained generic old label.

## Validation

This subphase is valid only if all of the following are true:

- the version parser can still read the current files
- `pubspec.yaml` remains the Flutter-visible version source
- `lib/config/version.dart` remains the in-app version metadata source
- release builds can be executed with synchronized build-name/build-number values
- no product behavior changed as a side effect of release normalization

The implemented changes are scoped to that baseline.

## Release Impact

Direct release impact:

- safer version management
- more reproducible release commands
- first-class Android AAB handling for store-oriented delivery
- removal of the outdated fixed `master` push assumption
- clearer release/documentation handoff into later distribution subphases

## Risks

### Low risk

The changes are low risk because they are isolated to:

- build utilities
- version metadata
- documentation

### Remaining caution

The repository still contains sensitive/signing materials in-tree and still lacks a later distribution/publishing closure.
Those concerns remain out of scope for 11.1 and should be handled by later Phase 11 steps.

## Git Commands

### Crear branch

    git checkout main
    git pull origin main
    git checkout -b phase-11-1-build-versioning-standardization

### Commit

    git add .
    git commit -m "Phase 11.1: build and versioning standardization"

### Merge

    git checkout main
    git pull origin main
    git merge phase-11-1-build-versioning-standardization

### Limpieza

    git branch -d phase-11-1-build-versioning-standardization
    git push origin --delete phase-11-1-build-versioning-standardization

## What it does NOT solve

This subphase does not yet solve:

- Play Console publication
- release signing policy cleanup
- store asset readiness
- automated remote pipeline execution
- release smoke-test matrix formalization

Those belong to later justified release/distribution work.

## Conclusion

Phase 11.1 is the correct first release/distribution implementation step because it improves trust in the release process without touching product behavior.

It standardizes versioning.
It standardizes build output.
It preserves all earlier baselines.
