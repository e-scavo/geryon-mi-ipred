# Phase 1 — Audit and Baseline Documentation

## Phase goal

Understand the current codebase as it really exists, identify critical modules, map the backend flow, and establish the first maintainable documentation layer.

---

## Project identification

- Product name: **Mi IP·RED**
- Technical package name: `geryon_web_app_ws_v2`
- Current targets:
  - Web
  - Android
- Future target:
  - iOS
- Current status:
  - functional
  - production in use

---

## Executive summary

The application is working and already implements the core customer workflow successfully.

The main engineering issue is not functionality, but maintainability:

- the codebase is structurally disordered
- there is little/no formal documentation
- central classes have become oversized
- legacy and experimental code still coexists with production code

Despite this, the project has a clear working architecture centered around a custom WebSocket backend protocol and a global orchestration layer.

---

## Main findings

### 1. Critical runtime backbone
The app depends heavily on `ServiceProvider` as the central runtime orchestrator.

This object currently handles:
- connection lifecycle
- token negotiation
- channel subscription
- login
- message tracking
- user/company context
- listener notifications

This is the most critical code area in the project.

### 2. Cross-platform groundwork already exists
The codebase already includes useful platform abstractions for:
- WebSocket
- session storage
- config storage
- file saving

This is a good base for long-term maintainability.

### 3. Documentation was missing
Before this phase:
- `README.md` did not describe the real system
- no effective `docs/*` baseline existed

### 4. Product naming and package naming differ
Visible product identity is **Mi IP·RED**, while the package still uses the historical technical identity `geryon_web_app_ws_v2`.

This is acceptable for now but should be tracked.

### 5. Login/session behavior is pragmatic, not fully finalized
The current implementation remembers DNI locally, but does not appear to persist a reusable validated authenticated backend session.

The login verification path currently forces the user through login rather than fully revalidating a prior session.

---

## Current startup sequence

```text
main.dart
  -> ProviderScope
  -> MyApp
  -> MyStartingPage
  -> notifierServiceProvider
  -> ServiceProviderConfigModel.loadConfig()
  -> ServiceProvider
  -> WebSocket init
  -> handshake
  -> channel subscription
  -> backend status
  -> login check
  -> login popup if needed
  -> dashboard
```

---

## Current backend communication sequence

```text
connect socket
  -> wait for backend bootstrap message
  -> receive TokenID
  -> mark connection as no longer new
  -> subscribe to channels
  -> request backend status
  -> verify login state
  -> perform login
  -> load user/customer context
  -> allow business screens to query data
```

---

## Current subscribed channels

- `GERYON_General`
- `GERYON_General_SCRUD`

---

## Main user-facing flows confirmed

- login with DNI/CUIT
- optional remembered DNI
- dashboard visualization
- payment information display
- invoice listing
- receipt listing
- customer switching
- logout

---

## Technical debt identified

### High priority
- oversized `ServiceProvider/data_model.dart`
- undocumented architecture
- package/product naming mismatch
- active legacy/commented code in critical areas

### Medium priority
- config loader behavior is currently closer to "write default config" than true persisted config loading
- session persistence semantics are limited
- project folder structure does not clearly separate app/core/features/shared layers

### Low priority
- visual/UI cleanup consistency
- dead file cleanup
- naming normalization across models

---

## Protected zones for future refactor

The following areas must be treated as high-risk refactor zones:

- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/GeryonSocket/*`
- `lib/models/CommonDataModel/*`
- `lib/models/GenericDataModel/*`
- widgets depending on provider-driven backend data loading

---

## Phase 1 decision

Refactoring will proceed only after documentation and architectural mapping are in place.

No behavior-first rewrite is allowed.

---

## Output of Phase 1

This phase establishes:
- a real project README
- documentation index
- architecture summary
- flow documentation
- decision record
- development/release/security notes
- this audit document

---

## Recommended next phase

### Phase 2 — Documentation alignment and structural planning

Objectives:
- expand architecture deep-dive
- inventory major modules and files
- define target refactor boundaries
- begin non-destructive cleanup plan