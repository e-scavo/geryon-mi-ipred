# Release

## Objective

Define the current release baseline for Mi IP·RED using the real repository state after the completion of Phase 10.2 and the implementation of Phase 11.2.

This document is no longer limited to structural refactor aftermath.

The ZIP now confirms that the product is functionally complete for the current customer-facing scope and that the dominant remaining concern is release readiness:

- synchronized versioning
- reproducible builds
- Android release artifacts
- Web release artifacts
- controlled distribution preparation

## Current release state

Product:
- **Mi IP·RED**

Technical package:
- `geryon_web_app_ws_v2`

Android application id:
- `com.geryon.mi_ipred`

Current supported targets:
- Web
- Android

Deferred target:
- iOS

Current product state:
- functional
- production in use
- capability-complete for the current billing/dashboard surface after Phase 10.2
- entering release/distribution hardening through Phase 11

## Closed baseline before release work

The current ZIP confirms these baselines as already closed and therefore not reopenable under release work:

- Phase 7 — Application Layer Consolidation
- Phase 8 — Runtime Reliability & Failure Semantics
- Phase 9 — Product Surface Consistency & UX Hardening
- Phase 10 — Product Capability Completion

That means release work must not be used as an excuse to reopen:

- backend-sensitive runtime ownership
- layout baseline
- responsive baseline
- semantic consistency baseline
- billing capability exposure baseline

## Current engineering focus

The current focus is now explicitly:

- prepare consistent release versioning
- produce reproducible release artifacts
- align Web and Android build commands with the same version source
- reduce manual release mistakes before packaging/distribution work continues

This is the concern shift introduced by:

- `docs/phase11_release_distribution.md`
- `docs/phase11_release_distribution_11_1_build_versioning_standardization.md`
- `docs/phase11_release_distribution_11_2_packaging_artifact_structuring.md`

## Phase 11 release baseline

Phase 11.1 established the version/build baseline and Phase 11.2 now formalizes how those generated outputs are packaged for distribution use.

### Problem solved by 11.1

Before this subphase, the ZIP contained:

- a basic `build_and_commit.dart`
- a basic `update_version.dart`
- version data duplicated across files
- a branding/version title mismatch inside `lib/config/version.dart`
- no explicit guarantee that Web, APK and AAB builds were using the same synchronized release version through one controlled flow
- git push behavior coupled to an outdated fixed branch name (`master`)

### Standardized result after 11.1

The repository now standardizes:

- synchronized version source in `pubspec.yaml` and `lib/config/version.dart`
- explicit build targeting for:
  - Web
  - Android APK
  - Android App Bundle
- explicit release build flags:
  - `--build-name`
  - `--build-number`
- optional version bumping before build
- optional git commit / push behavior instead of implicit history mutation
- branding alignment in version metadata with **Mi IP·RED** instead of the retained old generic label


### Problem solved by 11.2

Before this subphase, the ZIP still left release outputs dispersed in native Flutter/Gradle folders:

- `build/web/`
- `build/app/outputs/flutter-apk/`
- `build/app/outputs/bundle/release/`

That meant builds were reproducible, but the delivery outputs were not yet normalized for handoff, upload, or operator review.

### Standardized result after 11.2

The repository now standardizes:

- a stable `dist/` root for structured release outputs
- versioned Web output copied to `dist/web/mi-ipred-web-<version>/`
- renamed APK output copied to `dist/android/apk/mi-ipred-android-apk-<version>.apk`
- renamed AAB output copied to `dist/android/aab/mi-ipred-android-aab-<version>.aab`
- JSON release manifests at:
  - `dist/release_manifest_<version>.json`
  - `dist/release_manifest_latest.json`
- optional `--clean-dist` cleanup for the current version
- optional `--dist-root=...` override for alternate packaging roots

## Canonical release commands

### Bump build only

    dart run update_version.dart --build

### Bump patch

    dart run update_version.dart --patch

### Set exact version

    dart run update_version.dart --set-version=1.0.0+82

### Build Web + APK + AAB with current synchronized version and structured dist output

    dart run build_and_commit.dart

### Build Web + AAB and bump build first

    dart run build_and_commit.dart --web --aab --bump --build

### Build APK only

    dart run build_and_commit.dart --apk

### Build APK only and clean the current version under dist first

    dart run build_and_commit.dart --apk --clean-dist

### Build using a custom packaging root

    dart run build_and_commit.dart --web --aab --dist-root=release

### Build and commit on the current branch

    dart run build_and_commit.dart --web --aab --git-commit

## Output expectations

Phase 11.2 now defines the structured release artifacts expected after build completion:

### Web
- `dist/web/mi-ipred-web-<version>/`

### Android APK
- `dist/android/apk/mi-ipred-android-apk-<version>.apk`

### Android App Bundle
- `dist/android/aab/mi-ipred-android-aab-<version>.aab`

### Release manifest
- `dist/release_manifest_<version>.json`
- `dist/release_manifest_latest.json`

## Release validation expectations

Every release execution under this baseline should validate at least:

- version in `pubspec.yaml` matches `lib/config/version.dart`
- Web build succeeds with the same build-name/build-number used by Android
- APK build succeeds
- AAB build succeeds when Play-distribution preparation is required
- no manual branch-name assumption exists in the automation
- structured artifacts are copied to the configured dist root
- the manifest truthfully reflects the generated version and targets

## What this phase does not yet solve

Phase 11.1 does not yet complete:

- Play Console publication metadata
- signing-material hygiene cleanup
- CI/CD remote pipeline orchestration
- store listing assets
- post-build smoke test matrix
- release candidate approval workflow
- signed artifact verification policy

Those remain justified follow-up concerns for later Phase 11 subphases.

## Conclusion

The repository is no longer blocked by functional incompleteness.

The real remaining release concern is consistency and reproducibility.

Phase 11 therefore establishes the correct current release baseline:

- versioning is synchronized
- release commands are explicit
- Web/APK/AAB output is standardized
- structured artifacts are copied into a stable dist tree
- release manifests are generated for operator handoff
- release automation no longer depends on an implicit outdated branch assumption
- branding/version metadata is aligned with Mi IP·RED
