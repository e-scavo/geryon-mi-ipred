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
- `docs/phase11_release_distribution_11_3_distribution_readiness_validation.md`

## Phase 11 release baseline

Phase 11.1 established the version/build baseline, Phase 11.2 formalized how generated outputs are packaged, Phase 11.3 validated that packaged release set against the repository's real publication surfaces, and Phase 11.4 closed the final local/manual submission handoff.

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


### Problem solved by 11.3

Before this subphase, the ZIP still carried a last-mile distribution gap:

- `web/manifest.json` still exposed generic technical metadata
- `web/index.html` still contained generic publication description values
- the Cupertino font warning remained justified by a missing dependency declaration
- the repository had no dedicated release-validation command to verify the structured dist output and local signing contract together
- there was no tracked operator-facing Play Store metadata scaffold

### Standardized result after 11.3

The repository now standardizes:

- branded Web publication metadata in `web/index.html` and `web/manifest.json`
- explicit `cupertino_icons` dependency declaration to match the runtime surface already in use
- `android/key.properties.example` as the tracked local signing contract template
- `validate_release.dart` as the canonical post-build validation command
- JSON release validation reports at:
  - `dist/release_validation_<version>.json`
  - `dist/release_validation_latest.json`
- `distribution/submissions/<version>/submission_bundle_<version>.json`
- `distribution/submissions/<version>/submission_summary.md`
- `distribution/play_store/releases/<version>/publication_surface_<version>.json`
- `distribution/play_store/releases/<version>/publication_summary.md`
- tracked Play Store metadata scaffolding under `distribution/play_store/`

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

### Validate a generated release set

    dart run validate_release.dart

### Validate a custom distribution root

    dart run validate_release.dart --dist-root=release

### Prepare the final submission bundle

    dart run prepare_submission_bundle.dart

### Prepare the versioned store publication surface

    dart run prepare_store_publication.dart

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
- `dist/release_validation_<version>.json`
- `dist/release_validation_latest.json`
- `distribution/submissions/<version>/submission_bundle_<version>.json`
- `distribution/submissions/<version>/submission_summary.md`

## Release validation expectations

Every release execution under this baseline should validate at least:

- version in `pubspec.yaml` matches `lib/config/version.dart`
- Web build succeeds with the same build-name/build-number used by Android
- APK build succeeds
- AAB build succeeds when Play-distribution preparation is required
- no manual branch-name assumption exists in the automation
- structured artifacts are copied to the configured dist root
- the manifest truthfully reflects the generated version and targets
- release validation passes against web metadata, Android application id, local signing contract, and structured artifacts
- final operator handoff can be materialized as a versioned submission bundle
- the same validated version can be expanded into a structured store-publication surface

## What this phase does not yet solve

Phase 11.3 still does not yet complete:

- actual Play Console publication execution
- signing-material hygiene cleanup from historical local repositories
- CI/CD remote pipeline orchestration
- screenshot/image asset production for store listing
- post-build smoke test matrix
- release candidate approval workflow
- signed artifact verification policy

Those remain justified follow-up concerns only if they justify automation beyond the now-complete local/manual release baseline.

Phase 11.4 closes the current local/manual release track by introducing a final submission bundle that snapshots the validated release, metadata, and checklist into one versioned handoff root.

Phase 12.1 begins the next justified release-adjacent layer by structuring the publication surface itself under `distribution/play_store/releases/<version>/`, linking the validated submission bundle with track-specific rollout notes and store-asset directories.

Phase 12.2 hardens that surface by formalizing the rollout contract for `internal`, `closed`, and `production`, adding explicit active-track, checklist, promotion-gate, and evidence expectations inside the generated publication root.

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


## Final submission handoff baseline

The repository now provides a final handoff command:

    dart run prepare_submission_bundle.dart

This command is expected to:

- consume an already validated `dist/` root
- copy the current version artifacts into `distribution/submissions/<version>/`
- snapshot release reports beside the copied artifacts
- snapshot Play Store metadata/checklist files for the same version
- preserve the final handoff as an immutable operator bundle


## Phase 12 publication baseline

Phase 12 no longer changes how Mi IP·RED is built or validated locally.

It standardizes how the already validated release is prepared for real publication work.

### Problem solved by 12.1

Before this subphase, the ZIP already contained:

- structured release artifacts in `dist/`
- validation reports for the current release
- versioned submission bundles under `distribution/submissions/<version>/`
- Play Store metadata text and operator checklists under `distribution/play_store/`

However, the publication surface itself was still implicit.

There was no canonical versioned location for:

- phone screenshots
- 7-inch screenshots
- 10-inch screenshots
- feature graphic material
- track-specific rollout notes
- publication summary/evidence for the exact validated version

### Standardized result after 12.1

The repository now standardizes:

- `prepare_store_publication.dart` as the canonical publication-surface generator
- versioned publication surfaces under `distribution/play_store/releases/<version>/`
- copied metadata/checklist/policy files aligned with the active validated version
- Android asset directories for:
  - `phone_screenshots`
  - `seven_inch_screenshots`
  - `ten_inch_screenshots`
  - `feature_graphic`
- rollout note roots for:
  - `internal`
  - `closed`
  - `production`
- JSON publication manifest plus Markdown summary for operator handoff

## Phase 12.2 rollout-contract baseline

Phase 12.2 does not change how the release is built, validated, or packaged.

It changes how the already generated publication surface is interpreted operationally.

### Problem solved by 12.2

Before this subphase, the publication surface already provided versioned directories for rollout notes, but it still did not fully answer:

- what must be checked before starting with `internal`
- what must be true before promoting to `closed`
- what must be true before promoting to `production`
- where the operator should leave evidence for each track

### Standardized result after 12.2

The repository now standardizes:

- `prepare_store_publication.dart --release-track=<track>` as the active-track-aware publication command
- `rollout/active_track.md` inside the generated publication surface
- `track_checklist.md` per Play track
- `promotion_gate.md` per Play track
- `evidence_template.md` per Play track
- a top-level `rollout/track_matrix.md` summarizing how the version is expected to move between tracks

### What this phase still does not solve

Phase 12.2 still does not yet complete:

- direct Play Console publication execution
- automatic screenshot capture
- CI/CD publication credentials
- store-review outcome tracking
- post-upload evidence persistence beyond the generated templates

Those remain justified follow-up concerns only if they are supported by later evidence.


## Phase 12.3 evidence and post-upload validation baseline

Phase 12.3 still does not change how Mi IP·RED is built, validated, or packaged locally.

Its purpose is to complete the repository-side publication trail after the publication surface and per-track rollout contract already exist.

The generated publication surface must now also carry a stable `evidence/` root with:

- `publication_ledger.md`
- `evidence/<track>/upload_receipt.md`
- `evidence/<track>/post_upload_validation.md`
- `evidence/<track>/promotion_decision.md`

This baseline exists so the operator can record, for the exact version and track:

- when the upload happened
- what console state was observed
- what validation was executed after the upload
- what incidents or blockers were detected
- whether the version is approved, blocked, or promoted

Phase 12.3 therefore closes the gap between:

- a prepared publication surface
- a track-scoped operational contract
- a repository-side post-upload audit trail

Phase 12.3 still does not complete:

- direct Play Console automation
- review scraping from Google Play
- policy or rollout strategy automation
- external notification pipelines


## Phase 12.4 — Optional Automation Boundaries

The repository now also formalizes which publication steps are safe to automate and which must remain human-controlled.

Safe repository-side automation includes:

- version synchronization validation
- release artifact validation
- submission bundle preparation
- publication-surface preparation
- rollout scaffolding generation
- evidence and ledger template generation

Manual-required work remains explicit for:

- final Play Console upload
- store listing visual review
- tester/audience selection
- rollout percentage and promotion decisions
- production go/no-go approval

This boundary is deliberate. It keeps the repository operationally strong without allowing tooling to silently publish or promote a release.
