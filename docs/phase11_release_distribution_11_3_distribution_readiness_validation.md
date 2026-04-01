# Phase 11.3 — Distribution Readiness & Publication Surface Validation

## Objective

Close the immediate last-mile release gap after Phase 11.2 by validating the generated release set, aligning public-facing metadata with Mi IP·RED branding, and documenting the local Android signing contract without changing runtime behavior.

## Initial Context

Before this subphase, the repository had already achieved:

- synchronized release versioning (`pubspec.yaml` + `lib/config/version.dart`)
- reproducible Web / APK / AAB build commands
- structured release artifacts under `dist/`
- release manifests for versioned artifacts

That means the dominant remaining concern was no longer how to build or package the application, but how to prove that the packaged release is actually ready for operator handoff and publication preparation.

## Problem Statement

The ZIP still contained a real distribution-readiness gap:

- Web publication metadata remained partially generic
- the repository emitted a justified Cupertino icon packaging warning during Web build
- there was no single post-build validation command for the structured release output
- the local Android signing contract existed, but without a tracked example template for new environments
- Play Store handoff text did not yet exist as tracked project assets

## Scope

Phase 11.3 includes:

- branding alignment of `web/index.html`
- branding alignment of `web/manifest.json`
- explicit `cupertino_icons` declaration in `pubspec.yaml`
- `android/key.properties.example` as local signing template
- `validate_release.dart` as canonical validation command
- generation of release validation JSON reports
- tracked Play Store metadata scaffolding under `distribution/play_store/`
- documentation alignment for the new release-validation baseline

Phase 11.3 does not include:

- actual Play Console publication
- screenshot production
- keystore rotation or secret-management redesign
- backend changes
- UI/layout/responsive changes
- business logic changes

## Root Cause Analysis

Earlier Phase 11 work correctly solved:

- version synchronization
- build reproducibility
- artifact structuring

However, packaging alone is not the same as distribution readiness.

A release can be packaged correctly and still remain weak if:

- publication metadata is outdated or generic
- the signing contract is undocumented for new environments
- there is no explicit command to verify the produced release set

That is exactly the gap this subphase closes.

## Files Affected

- `pubspec.yaml`
- `web/index.html`
- `web/manifest.json`
- `build_and_commit.dart`
- `validate_release.dart`
- `android/key.properties.example`
- `distribution/play_store/metadata/es-AR/short_description.txt`
- `distribution/play_store/metadata/es-AR/full_description.txt`
- `distribution/play_store/metadata/es-AR/release_notes.txt`
- `distribution/play_store/release_checklist.md`
- `README.md`
- `docs/index.md`
- `docs/release.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase11_release_distribution.md`
- `docs/phase11_release_distribution_11_3_distribution_readiness_validation.md`

## Implementation Characteristics

### 1. Web publication branding alignment

The public Web metadata now reflects Mi IP·RED instead of generic project placeholders:

- `web/index.html`
- `web/manifest.json`

This improves publication readiness without modifying any runtime behavior.

### 2. Cupertino icon dependency declaration

The dependency list now explicitly declares `cupertino_icons` so that the runtime icon surface already in use is represented in the package configuration.

### 3. Release validation command

A new canonical command is introduced:

    dart run validate_release.dart

This command validates:

- synchronized version state
- branded Web metadata
- Android application id / release signing configuration presence
- local signing contract file presence
- expected structured artifacts for the active version

### 4. Validation reports

The validation command writes:

- `dist/release_validation_<version>.json`
- `dist/release_validation_latest.json`

This makes the release package not only structured but also explicitly verifiable.

### 5. Local Android signing contract template

`android/key.properties.example` now documents the local file shape expected by Android release builds.

This improves reproducibility for new workstations without forcing a secret-management redesign inside this subphase.

### 6. Store metadata scaffold

The repository now tracks a minimal Play Store handoff scaffold under:

- `distribution/play_store/metadata/es-AR/`
- `distribution/play_store/release_checklist.md`

This avoids leaving distribution handoff as purely oral or ad hoc knowledge.

## Validation

Phase 11.3 is considered correct only if all of the following are true:

- `flutter build web` no longer warns about missing Cupertino icon packaging contract
- `validate_release.dart` succeeds against the structured output for the active version
- release validation JSON reports are generated
- Web metadata reflects Mi IP·RED branding
- Android release setup remains compatible with the existing local signing flow
- no business logic or UI/runtime baseline is changed

## Release Impact

Positive impact:

- stronger last-mile release confidence
- clearer operator handoff into Play Store preparation
- better reproducibility on new local environments
- cleaner public metadata on the Web surface

## Risks

Main risks:

- overreaching into secret-management redesign too early
- breaking the user's current Android signing flow
- mixing publication concerns with product changes

Mitigation:

- keep the existing local signing path intact
- add only a documented example contract
- restrict all changes to metadata, validation, and release-surface tooling

## What it does NOT solve

This subphase does not itself solve:

- Play Console submission execution
- screenshot asset generation
- store-review workflow
- remote CI/CD publishing
- signed artifact verification after upload
- secret rotation / secret-storage redesign

Those remain justified later concerns.

## Conclusion

Phase 11.3 is the correct next release/distribution step after packaging because it transforms the release set from merely structured into explicitly validated and better aligned for publication handoff.
