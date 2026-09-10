# Phase X — Task Index

## Purpose

This directory is the canonical index for Phase X: the permanent cross-phase correction lane of the Mi IP·RED Customers frontend.

Phase X remains independent from the numbered product roadmap. It records corrections that are necessary and repository-grounded but do not belong to the numbered phase currently in progress.

## Rules

- Every task uses the current attached ZIP as its only implementation source of truth.
- Every intervention receives a sequential three-digit identifier.
- Every delivery updates this index.
- Phase X does not renumber, replace, or silently reopen ordinary phases.
- Each implementation delivery is a partial ZIP containing only modified/new files.

## Tasks

### 001 — Phase X Cross-Phase Corrections Baseline

Document:

- `docs/tasks/001_phase_x_cross_phase_corrections_baseline.md`

Status:

- completed

Result:

- Phase X is formally established as an independent, continuously open workstream
- admission, architecture, analysis, documentation, validation, and delivery contracts are defined
- the initial repository baseline is recorded without modifying application behavior

### 002 — Login Popup Global Exclusion and Runtime Generation

Document:

- `docs/tasks/002_login_popup_global_exclusion_runtime_generation.md`

Status:

- completed

Result:

- ServiceProvider is the global owner of the interactive login route and continuation
- repeated login requirements reuse the same active future instead of opening another popup
- runtime recovery invalidates and removes obsolete login presentations before loading/rebootstrap
- recovery generations prevent stale login continuations from mutating a newer runtime cycle
- loading startup now waits for configuration on every platform and closes through deferred navigation

### 003 — Canonical Initialization Single-Flight and Retry Limit

Document:

- `docs/tasks/003_canonical_initialization_single_flight_retry_limit.md`

Status:

- completed

Result:

- all startup, handshake, and recovery callers reuse one active ServiceProvider initialization Future
- WebSocket and backend-validation retries execute inside one bounded canonical loop
- `_onDone()` cannot create a parallel recovery while initialization already owns the failed attempt
- automatic attempts stop at `maxConnRetry` and expose manual retry instead of continuing indefinitely
- loading retry presentation reads the ServiceProvider retry contract instead of a hardcoded value

### 004 — Global Loading Popup Route Exclusion

Document:

- `docs/tasks/004_global_loading_popup_route_exclusion.md`

Status:

- completed

Result:

- ServiceProvider globally owns the loading route and its completion Future
- startup and runtime recovery reuse the same active loading popup
- `isProgress` no longer acts as an unreliable proxy for Navigator route existence
- manual retries cannot stack new modal barriers over the existing retry surface
- loading ownership is cleared only when the exact owned route completes

### 005 — Progress and Login Theme Normalization

Document:

- `docs/tasks/005_progress_login_theme_normalization.md`

Status:

- completed

Result:

- the global startup/recovery progress surface now derives colors and typography from the active application theme
- retry copy, action styling, progress indicators, and state messaging are normalized and accessible
- progress content is presented in a responsive Material card without changing ServiceProvider ownership
- the login action, DNI/CUIT field, keyboard submission, spinner, and route semantics are aligned with the same Material 3 contract
- no parallel startup, recovery, loading, or login coordinator was introduced

### 006 — Logout Re-entry and Stale Queued Response Isolation

Document:

- `docs/tasks/006_logout_reentry_stale_queued_response_isolation.md`

Status:

- completed

Result:

- logout now re-enters startup/auth through the globally owned loading boundary
- tracked requests record the runtime generation in which they were created
- late, untracked, and obsolete-generation replies are discarded before callback dispatch
- queued/processing acknowledgements may omit `ChannelName` without corrupting ServiceProvider state
- final application messages retain the strict channel validation contract

### 007 — Logout Final Response Completion Contract

Document:

- `docs/tasks/007_logout_final_response_completion_contract.md`

Status:

- completed

Result:

- final tracked responses may omit `ChannelName` when a valid non-empty `MessageID` provides canonical correlation
- the same validation contract now covers queued, processing, and final tracked responses
- asynchronous tracked callbacks are awaited before incoming-message processing is considered complete
- callback exceptions remain inside the tracker execution error boundary
- logout recovery can advance from backend status completion to the globally owned login continuation

### 008 — Handshake Completion and Channel Serialization

Document:

- `docs/tasks/008_handshake_completion_channel_serialization.md`

Status:

- completed

Result:

- canonical initialization now waits for the WebSocket handshake and channel subscription before requesting backend status
- the handshake callback no longer recursively re-enters `init()`
- outgoing channel serialization is controlled by the request action contract instead of the mutable `isNew` transport flag
- `Get:Status` always carries `GERYON_General` when built with that channel
- obsolete handshake completions are isolated by runtime generation

### 009 — Fresh Transport Handshake after Runtime Reset

Document:

- `docs/tasks/009_fresh_transport_handshake_after_runtime_reset.md`

Status:

- completed

Result:

- logout and manual retry no longer wait for a new handshake on an already-open WebSocket
- ServiceProvider explicitly requires a fresh transport whenever recovery resets the session token
- web and IO transports expose the same intentional `resetConnection()` contract
- expected close events from a retired transport do not start a parallel runtime recovery
- delayed close events are isolated by concrete socket identity
- canonical initialization resumes only after the newly established transport completes handshake and channel subscription

### 010 — Login Vertical Viewport Overflow Stabilization

Document:

- `docs/tasks/010_login_vertical_viewport_overflow_stabilization.md`

Status:

- completed

Result:

- the login surface now owns a scrollable vertical viewport instead of a fixed centered column
- the card remains centered when it fits and becomes naturally scrollable when validation content exceeds the available height
- reduced-height and narrow viewports use compact padding, logo sizing, spacing, and error-state density
- browser DevTools, mobile keyboards, and short windows no longer make the submit action inaccessible
- `FeatureErrorState` keeps its existing default presentation and exposes compact density only as an opt-in contract


### 011 — Mandatory DBVersion 10 Request Contract

Document:

- `docs/tasks/011_mandatory_dbversion_10_request_contract.md`

Status:

- completed

Result:

- DBVersion 10 is centralized in `BackendContract` instead of duplicated as request-level magic numbers
- every active CommonDataModel/GenericDataModel backend request is finally enforced as `LocalParams.DBVersion = 10`
- HeaderParamsRequest precedence can no longer accidentally remove or downgrade the mandatory DB version
- ServiceProvider `Get:Status` and `Auth:Login` direct requests now carry DBVersion 10
- Task 011 initially treated `Subscribe_Channel` as transport-only; backend evidence later disproved that assumption and Task 012 supersedes it
- existing explicit Clientes, DetServiciosDATOSClientes, NAS, and billing callers use the canonical backend contract
- repository-wide request-path audit found no active widget bypassing the canonical request owners
### 012 — Mandatory DBVersion Transport Boundary and Error Surface

Document:

- `docs/tasks/012_mandatory_dbversion_transport_boundary_and_error_surface.md`

Status:

- completed

Result:

- `Subscribe_Channel` now explicitly carries `LocalParams.DBVersion = 10`
- `ServiceProvider.sendMessageV2()` enforces DBVersion 10 at the final serialization boundary for every outgoing application action
- missing, zero, or stale caller DBVersion values can no longer reach the backend through direct ServiceProvider requests
- the global loading surface recognizes subscription/status/backend/login error stages in addition to transport connection errors
- concrete backend `ErrorHandler.errorDsc` values are visible in the progress UI without exposing stack traces or raw diagnostics

### 013 — Billing Document Download Overlay Theme and Responsive Normalization

Document:

- `docs/tasks/013_billing_document_download_overlay_theme_responsive_normalization.md`

Status:

- completed

Result:

- the billing download popup is now physically bounded to a responsive modal size instead of expanding to the full viewport
- the temporary `Header for ...` development placeholder was removed
- progress, voucher information, errors, and actions now use the application Material 3 theme
- the modal body scrolls when vertical space is reduced
- `AppOverlayPanel` now derives its shared surface, border, typography, title, and shadow treatment from the active theme
- download business logic and DBVersion 10 behavior remain unchanged

### 014 — Android 16 / API 36 Google Play Target Upgrade

Document:

- `docs/tasks/014_android_16_api36_google_play_target_upgrade.md`

Status:

- completed

Result:

- Android releases now compile explicitly against API 36
- Android releases now explicitly target Android 16 / API 36
- Android Gradle Plugin was raised from 8.7.0 to the API-36-compatible 8.9.1 baseline
- Gradle wrapper was raised from 8.10.2 to 8.11.1 to match AGP 8.9.x requirements
- `minSdk`, signing, versioning, and the existing `build_and_commit.dart` release workflow remain unchanged
- Google Play's native debug-symbol warning remains a separate, non-blocking release-quality item

## Next Identifier

- `015`
