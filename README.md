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
This repository has completed the initial ServiceProvider decomposition phase.

See:

- `docs/index.md`
- `docs/phase5_service_provider_decomposition.md`

---

## Development goals

The current roadmap is:

1. Full codebase audit
2. Baseline documentation
3. Safe refactor plan
4. Incremental structural cleanup
5. ServiceProvider internal decomposition
6. Continued feature-oriented cleanup

---

## Running the project

### Web

    flutter pub get
    flutter run -d chrome

### Android

    flutter pub get
    flutter run -d android

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
