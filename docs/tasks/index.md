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

## Next Identifier

- `008`
