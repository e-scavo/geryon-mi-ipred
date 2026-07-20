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

## Next Identifier

- `004`
