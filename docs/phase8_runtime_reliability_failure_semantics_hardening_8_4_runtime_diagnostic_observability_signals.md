# 📡 Phase 8.4 — Runtime Diagnostic & Observability Signals

## Objective

Introduce explicit, structured, and readonly runtime diagnostic signals for Mi IP·RED so that the current runtime state, the latest relevant recovery decisions, and the most recent operational events can be inspected without depending only on scattered `developer.log(...)` output.

## Initial Context

The current ZIP confirms the following baseline:

- Phase 7 is formally closed
- Phase 8 is active
- Phase 8.1 documented runtime failure surfaces
- Phase 8.2 normalized failure-boundary semantics
- Phase 8.3 hardened retry / reboot / reconnect policy execution
- the architecture remains:
  - `presentation → controller → ServiceProvider`
- `ServiceProvider` already owns:
  - runtime connectivity baseline
  - startup/runtime continuation
  - authenticated runtime context
  - active operational context
  - trigger-aware recovery policy execution

That means the correct next step is not more structural work.

The correct next step is to make runtime diagnostics explicit.

## Problem Statement

Before 8.4, the repository already had:

- explicit failure-boundary semantics
- explicit recovery triggers
- explicit recovery policy decisions

However, those runtime semantics were still only partially visible operationally.

The project still lacked a structured answer to questions like:

- what is the latest significant runtime event?
- what was the latest failure boundary captured as an operational signal?
- what was the latest recovery policy decision?
- what trigger initiated the latest recovery request?
- how many recent runtime diagnostic events are available for inspection?

Without those explicit signals, diagnosing runtime behavior still depended too heavily on debugger logs and reading raw code paths.

## Scope

Phase 8.4 includes:

- explicit runtime diagnostic event type model
- explicit runtime diagnostic event model
- explicit runtime diagnostic snapshot model
- bounded in-memory runtime diagnostic event buffer inside `ServiceProvider`
- readonly getters for runtime diagnostic events and runtime diagnostic snapshot
- minimal runtime instrumentation in `ServiceProvider` around:
  - failure-boundary capture
  - transport disconnect
  - recovery request
  - recovery decision blocked/applied
  - recovery completion
  - runtime reset after logout
- documentation updates that freeze the new runtime observability baseline

Phase 8.4 does not include:

- remote telemetry
- persistent logging
- analytics pipeline
- dedicated debug screen
- transport redesign
- startup redesign
- runtime policy redesign
- `ServiceProvider` replacement

## Root Cause Analysis

By the end of Phase 8.3, the runtime already had explicit semantics and explicit trigger-aware policy execution.

What it still lacked was explicit observability.

The root cause was not absence of logs.

The root cause was absence of structured diagnostic signals that could be:

- stored in bounded memory
- inspected through readonly getters
- interpreted through the same runtime language already introduced in 8.2 and 8.3

That is why 8.4 focuses on diagnostic event emission and snapshot exposure rather than on new policy changes.

## Files Affected

### New code

- `lib/models/ServiceProvider/runtime_diagnostic_event_type_model.dart`
- `lib/models/ServiceProvider/runtime_diagnostic_event_model.dart`
- `lib/models/ServiceProvider/runtime_diagnostic_snapshot_model.dart`

### Updated code

- `lib/models/ServiceProvider/data_model.dart`

### Updated documentation

- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_4_runtime_diagnostic_observability_signals.md`
- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`

## Implementation Characteristics

### 1. Runtime diagnostic event type is now explicit

`ServiceProviderRuntimeDiagnosticEventType` defines the current significant runtime diagnostic categories.

The initial event types are:

- `failureBoundaryEvaluated`
- `recoveryRequested`
- `recoveryDecisionApplied`
- `recoveryDecisionBlocked`
- `recoveryCompleted`
- `transportDisconnected`
- `runtimeReset`

This is intentionally narrow and focused on the current Phase 8 baseline.

### 2. Runtime diagnostic event is now explicit

`ServiceProviderRuntimeDiagnosticEvent` captures a single structured runtime event, including:

- timestamp
- event type
- reason code
- description
- init stage
- optional recovery trigger
- optional boundary scope
- optional recovery expectation
- optional recovery policy decision
- class and function origin metadata

This gives the runtime a concrete observability unit that is richer than raw logs but still lightweight.

### 3. Runtime diagnostic snapshot is now explicit

`ServiceProviderRuntimeDiagnosticSnapshot` exposes a compact readonly runtime summary including:

- current failure boundary state
- last captured failure boundary state
- last recovery policy decision
- last recovery trigger
- last diagnostic event
- whether recovery is currently in progress
- active recovery trigger
- current init stage
- current bounded event count

This provides a stable inspection surface without changing runtime behavior.

### 4. `ServiceProvider` now owns bounded diagnostic event history

`ServiceProvider` now maintains a bounded in-memory list of runtime diagnostic events.

The buffer is intentionally capped so this phase remains lightweight and operationally safe.

No persistence was added.

No remote emission was added.

### 5. Failure-boundary capture can now emit an explicit signal

`captureFailureBoundaryDiagnosticState(...)` preserves the pure evaluation model while allowing the runtime to emit an explicit diagnostic event when the current boundary should be captured as an operational signal.

This avoids turning `evaluateFailureBoundaryState()` itself into a noisy implicit event emitter.

### 6. Recovery execution now emits structured diagnostic events

The runtime now emits explicit events when:

- recovery is requested
- recovery is blocked
- recovery is applied
- recovery completes

This means trigger-aware recovery is now also diagnostically visible.

### 7. Transport disconnect and logout reset now emit structured signals

`_onDone()` now captures and emits transport-disconnect diagnostic signals before requesting transport recovery.

`logout()` now captures and emits runtime-reset diagnostic signals before requesting runtime-reset recovery.

This preserves current behavior while improving operational visibility.

## Validation

The implementation is valid for 8.4 because it satisfies all of the following:

- it preserves the active architecture
- it keeps observability owned by `ServiceProvider`
- it introduces only explicit models plus bounded in-memory state
- it does not redesign recovery policy
- it does not redesign startup or transport
- it exposes readonly diagnostic access without changing the user-facing flow

## Release Impact

User-visible behavior should remain effectively unchanged.

The impact of 8.4 is operational and architectural:

- runtime diagnostics are now structured
- recent runtime events are now bounded and inspectable
- the runtime now exposes a compact diagnostic snapshot
- recovery and boundary transitions are more observable without requiring raw log inspection

## Risks

The main risk is overusing diagnostic events and turning the buffer into noisy pseudo-logging.

This phase mitigates that by:

- keeping the event categories small
- emitting only at meaningful runtime points
- maintaining bounded history

Another risk is assuming the snapshot is a new policy source.

It is not.

The snapshot is readonly observability data.

## What it does NOT solve

Phase 8.4 does not yet:

- add persistent runtime logs
- add remote telemetry
- add a debug UI screen
- redesign reconnect timing or retry backoff
- fix older hotspots such as `setCurrentCliente()`
- close Phase 8 formally

Those remain outside this subphase.

## Conclusion

Phase 8.4 is the correct next step after failure-boundary normalization and trigger-aware recovery hardening.

The repository now has:

- explicit runtime diagnostic event types
- explicit runtime diagnostic events
- explicit runtime diagnostic snapshot exposure
- bounded runtime diagnostic history inside `ServiceProvider`
- structured observability around boundary capture, transport disconnect, recovery execution, and runtime reset

That creates the correct baseline for:

- `8.5 — Formal Closure of Phase 8`