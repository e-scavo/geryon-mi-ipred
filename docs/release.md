# Release

## Objective

Define the current release baseline for Mi IP·RED using the real repository state after the completion of Phase 10.2 and the opening of Phase 11.1.

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

## Phase 11.1 release baseline

Phase 11.1 establishes the first release/distribution step.

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

## Canonical release commands

### Bump build only

    dart run update_version.dart --build

### Bump patch

    dart run update_version.dart --patch

### Set exact version

    dart run update_version.dart --set-version=1.0.0+82

### Build Web + APK + AAB with current synchronized version

    dart run build_and_commit.dart

### Build Web + AAB and bump build first

    dart run build_and_commit.dart --web --aab --bump --build

### Build APK only

    dart run build_and_commit.dart --apk

### Build and commit on the current branch

    dart run build_and_commit.dart --web --aab --git-commit

## Output expectations

Phase 11.1 does not yet define the full deployment pipeline, but it does define the expected release artifacts:

### Web
- `build/web/`

### Android APK
- Flutter release APK output under `build/app/outputs/flutter-apk/`

### Android App Bundle
- Flutter release AAB output under `build/app/outputs/bundle/release/`

## Release validation expectations

Every release execution under this baseline should validate at least:

- version in `pubspec.yaml` matches `lib/config/version.dart`
- Web build succeeds with the same build-name/build-number used by Android
- APK build succeeds
- AAB build succeeds when Play-distribution preparation is required
- no manual branch-name assumption exists in the automation

## What this phase does not yet solve

Phase 11.1 does not yet complete:

- Play Console publication metadata
- signing-material hygiene cleanup
- CI/CD remote pipeline orchestration
- store listing assets
- post-build smoke test matrix
- release candidate approval workflow

Those remain justified follow-up concerns for later Phase 11 subphases.

## Conclusion

The repository is no longer blocked by functional incompleteness.

The real remaining release concern is consistency and reproducibility.

Phase 11.1 therefore establishes the correct current release baseline:

- versioning is synchronized
- release commands are explicit
- Web/APK/AAB output is standardized
- release automation no longer depends on an implicit outdated branch assumption
- branding/version metadata is aligned with Mi IP·RED
