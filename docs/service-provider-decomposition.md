# ServiceProvider Decomposition

## Purpose

This document defines how `ServiceProvider` was decomposed internally in Mi IP·RED during Phase 5.

The goal was not to replace it immediately, but to make it smaller, clearer, and safer to maintain.

---

## Current Problem

`ServiceProvider` remains the runtime backbone of the application and still concentrates many responsibilities.

Today it still acts as:

- connection manager
- backend bootstrap coordinator
- session/login manager
- message sender
- async response tracker
- customer/company context holder
- partial UI trigger source
- state notifier

This centralization still exists, but its most fragile internal flows are now better structured.

---

## What Phase 5 Was NOT

Phase 5 was **not**:

- a full rewrite
- a protocol redesign
- a login redesign
- a provider replacement
- a change to the backend contract

It was a controlled internal decomposition.

---

## What Phase 5 Actually Did

Phase 5 focused on extracting and stabilizing internal helper groups while keeping behavior frozen.

The most relevant results were:

### 1. Auth/context helper extraction
Examples:
- reset authenticated runtime state
- apply authenticated user context

### 2. Handshake helper extraction
Examples:
- handshake detection
- token validation
- session token application
- post-handshake initialization continuation

### 3. Tracked wait/helper extraction
Examples:
- tracked response retrieval
- tracked message wait orchestration
- post-processing wait helpers

### 4. Callback utility extraction
Examples:
- callback payload parsing
- queued-message handling
- tracked callback finalization helpers

### 5. Request builder extraction
Examples:
- backend status request builder
- subscribe request builder
- login request builder

### 6. Post-send tracked request preparation
Examples:
- extract tracked response object after send
- normalize "message not found after send" handling

### 7. `_onData(...)` decomposition
The incoming-message router now clearly separates:
- handshake path
- tracked incoming message path
- tracked callback/cleanup logic
- error handling

### 8. Reusable tracked request execution helper
A common tracked request execution helper is now reused in:
- `getBackendStatus()`
- `subscribeChannel()`
- `doLogin()`

This was one of the most valuable structural outcomes of the phase.

---

## What Remains Intentionally Unfinished

Phase 5 intentionally stopped before aggressive callback abstraction.

In particular, it did **not** force:
- broad shared callback frameworks
- aggressive shared error handlers for all callbacks
- risky callback bootstrap generalization

This is intentional because the callback bodies still carry behavior-sensitive differences.

---

## Public Behavior That Stayed Frozen

The following behavior remained stable during Phase 5:

- app startup flow
- socket init flow
- handshake semantics
- channel subscription flow
- backend status request flow
- login request shape
- callback-driven auth materialization
- `loggedUser` assignment behavior
- dashboard readiness behavior

---

## Success Criteria Achieved

Phase 5 is considered successful because:

- `ServiceProvider` is easier to read
- critical methods are smaller and more navigable
- tracked request execution is more coherent
- handshake and auth helper boundaries are clearer
- the runtime behavior remained stable in the validated paths

---

## Recommended Next Step

After this phase, the best next move is **not** another risky runtime-core abstraction.

The recommended direction is:

1. move toward presentation cleanup and feature-oriented structure
2. preserve the backend contract
3. only revisit deeper callback abstraction if a concrete and validated need appears
