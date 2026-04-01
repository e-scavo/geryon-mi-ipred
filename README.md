# Mi IP·RED

Customer self-service application for IP·RED.

Mi IP·RED is a Flutter application currently running on Web and Android, designed to allow customers to interact with the company backend in order to:

- view account and customer data
- check balances
- access payment information
- view invoices
- view receipts
- download supporting documents
- review account-related financial activity

The application is already functional and in production. The current engineering objective is not to redesign behavior, but to document, stabilize, and refactor the codebase safely without breaking the backend connection flow.

---

## Current status

- Product name: **Mi IP·RED**
- Technical package name: `geryon_web_app_ws_v2`
- Production status: **functional / in use**
- Current targets:
  - Web
  - Android
- Deferred target:
  - iOS

---

## Core engineering rule

The backend connection flow is the most critical part of the system and must be preserved during all refactor stages.

This includes:

- WebSocket bootstrap
- backend handshake
- token/session negotiation
- channel subscription
- RPC-style request/response handling
- login flow
- customer context selection
- data loading for billing and receipts

---

## Technology stack

- Flutter
- Dart
- Riverpod / flutter_riverpod
- WebSocket
- shared_preferences
- localStorage / platform storage abstractions
- cross-platform conditional imports for Web and IO

---

## Observed architecture

High-level boot flow:

    main.dart
      -> ProviderScope
      -> MyApp
      -> MyStartingPage
          -> notifierServiceProvider
              -> serviceProviderConfigProvider
              -> ServiceProvider
                  -> WebSocketClient
                  -> init()
                  -> subscribeChannel()
                  -> getBackendStatus()
                  -> doCheckLogin()
                  -> doLogin()
          -> DashboardPage
              -> BillingWidget

Main architectural blocks:

- `lib/main.dart`
  - application bootstrap
- `lib/common_vars.dart`
  - global providers, navigator key, theme, config bootstrap
- `lib/models/ServiceProvider/*`
  - central orchestration layer
- `lib/models/GeryonSocket/*`
  - WebSocket transport abstraction
- `lib/models/ServiceProviderConfig/*`
  - connection configuration
- `lib/models/SessionStorage/*`
  - local remembered login data
- `lib/models/Common*/*`, `lib/models/tbl_*/*`, `lib/models/GenericDataModel/*`
  - backend/domain models
- `lib/pages/*`
  - UI and user-facing workflows

---

## Functional overview

The current application provides, at minimum, the following customer-facing capabilities:

- login using DNI/CUIT
- optional local remembering of DNI
- display of current account information
- display of current balance
- display of payment information:
  - alias
  - payment code
  - barcode
- display of latest payment date
- display of invoices
- display of receipts
- customer switching when multiple customer records are associated to the same login

---

## Important implementation notes

### 1. Backend-centric architecture
The app is strongly coupled to a custom backend protocol transported over WebSocket.

### 2. Centralized global state
`ServiceProvider` currently acts as the main application orchestrator and contains connection, session, login, message tracking, and business context state.

### 3. Cross-platform support
The project already uses conditional imports for:
- WebSocket implementation
- configuration persistence
- session storage
- file saving

### 4. Current documentation stage
The repository has completed the following baselines:

- Phase 7 — Application Layer Consolidation
- Phase 8 — Runtime Reliability & Failure Semantics
- Phase 9 — Product Surface Consistency & UX Hardening
- Phase 10 — Product Capability Completion

The repository has now completed:

- Phase 11 — Release & Distribution
- Phase 11.1 — Build & Versioning Standardization
- Phase 11.2 — Packaging & Artifact Structuring
- Phase 11.3 — Distribution Readiness & Publication Surface Validation
- Phase 11.4 — Final Release Operations & Submission Checklist

The repository is now entering:

- Phase 12 — Store Publication Assets & Operational Rollout
- Phase 12.1 — Store Asset Baseline & Publication Surface Structuring

See:

- `docs/index.md`
- `docs/release.md`
- `docs/phase11_release_distribution.md`
- `docs/phase11_release_distribution_11_1_build_versioning_standardization.md`
- `docs/phase11_release_distribution_11_2_packaging_artifact_structuring.md`
- `docs/phase11_release_distribution_11_3_distribution_readiness_validation.md`
- `docs/phase11_release_distribution_11_4_final_release_operations_submission_checklist.md`
- `docs/phase12_store_publication_assets_operational_rollout.md`
- `docs/phase12_store_publication_assets_operational_rollout_12_1_store_asset_baseline_publication_surface_structuring.md`

---

## Development goals

The current roadmap completed these major layers:

1. Full codebase audit
2. Baseline documentation
3. Safe refactor plan
4. Incremental structural cleanup
5. ServiceProvider internal decomposition
6. Application-layer consolidation
7. Runtime reliability hardening
8. Product-surface consistency hardening
9. Product capability completion

The active roadmap layer is now:

10. Store publication assets & operational rollout
11. Store asset baseline & publication surface structuring
12. Track rollout operational checklist
13. Publication evidence & post-upload validation
14. Optional automation boundaries

---

## Running the project

### Web

    flutter pub get
    flutter run -d chrome

### Android

    flutter pub get
    flutter run -d android

### Standardized release build flow

Version bump only:

    dart run update_version.dart --build

Web + APK + AAB release build with the current synchronized version:

    dart run build_and_commit.dart

Web + AAB release build with version bump:

    dart run build_and_commit.dart --web --aab --bump --build

APK only with artifact structuring cleanup for the current version:

    dart run build_and_commit.dart --apk --clean-dist

Custom dist root:

    dart run build_and_commit.dart --web --aab --dist-root=release

Validar una salida ya generada:

    dart run validate_release.dart

Preparar el surface operativo de publicación para la versión actual validada:

    dart run prepare_store_publication.dart

---

## Documentation structure

    docs/
      index.md
      architecture.md
      architecture-deep.md
      flows.md
      decisions.md
      development.md
      features.md
      release.md
      secutiry.md
      service-provider-decomposition.md
      phase1_audit.md
      phase2_structural_plan.md
      phase3_cleanup_hygene.md
      phase4_infra_normalization.md
      phase5_service_provider_decomposition.md

---

## Current engineering policy

- do not break backend communication
- do not rewrite working business behavior without necessity
- prefer staged refactors over large rewrites
- document every relevant architectural step
- maintain continuity between chats through repository documentation

---

## Notes about repository hygiene

Future shared project packages should avoid including:

- keystores
- signing material
- generated build artifacts
- unnecessary caches

These are not required for source-level analysis and should be treated as sensitive.

Additionally, Phase 11.1 confirms that release versioning must remain synchronized between:

- `pubspec.yaml`
- `lib/config/version.dart`
- release commands executed through `build_and_commit.dart`


Additionally, Phase 11.2 confirms that release packaging must now produce structured artifacts under a stable distribution root:

- `dist/web/mi-ipred-web-<version>/`
- `dist/android/apk/mi-ipred-android-apk-<version>.apk`
- `dist/android/aab/mi-ipred-android-aab-<version>.aab`
- `dist/release_manifest_<version>.json`


Additionally, Phase 11.3 confirms that distribution readiness now requires:

- branded publication metadata in `web/index.html` and `web/manifest.json`
- a local `android/key.properties` contract documented by `android/key.properties.example`
- a repeatable release validation step through `validate_release.dart`
- store-facing metadata scaffolding under `distribution/play_store/`


Additionally, Phase 11.4 confirms that final release operations now require:

- a final submission handoff created through `prepare_submission_bundle.dart`
- versioned immutable bundles under `distribution/submissions/<version>/`
- explicit Play Store asset requirements tracked in `distribution/play_store/asset_requirements.md`
- keystore-path validation against the local environment before final handoff


Additionally, Phase 12.1 confirms that publication-readiness now also requires:

- a versioned publication surface generated through `prepare_store_publication.dart`
- normalized store asset directories under `distribution/play_store/releases/<version>/`
- explicit rollout notes per active Play track
- alignment between the validated submission bundle and the store-facing asset set
