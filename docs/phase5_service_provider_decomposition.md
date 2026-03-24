# Phase 5 — ServiceProvider Internal Decomposition

## Phase Goal

Reduce the internal complexity of `ServiceProvider` without changing runtime behavior.

This phase directly targeted the most critical runtime class of Mi IP·RED.

---

## Phase Status

**Completed**

Phase 5 was completed as a controlled internal decomposition phase.

The class was not replaced, but the most fragile runtime paths were split into smaller helpers and the repeated tracked-request flow was safely reused where validated.

---

## Why This Phase Existed

At this point in the project:

- the project was already documented
- infrastructure had been normalized
- the backend flow had been mapped
- the repository had become cleaner

The next bottleneck was clear:

> `ServiceProvider` was too large and too responsible.

The application already worked, but future maintenance would remain expensive unless this class was decomposed internally.

---

## What This Phase Did Not Do

This phase did **not**:

- change backend message contracts
- change login request structure
- change handshake semantics
- rewrite state management
- replace Riverpod/provider wiring
- redesign billing flow
- change dashboard usage of provider state

This was decomposition, not redesign.

---

## What Was Actually Completed

### 1. Auth/context helper extraction
The authenticated runtime state handling was isolated into helpers, reducing duplication around login and check-login flows.

Examples of extracted responsibility:
- reset authenticated runtime state
- apply authenticated user context

---

### 2. Handshake helper extraction
The handshake path was decomposed into smaller responsibilities:

- detect handshake message
- validate token
- apply session token
- continue initialization after handshake

This made the first-message flow easier to read without changing semantics.

---

### 3. Tracked wait and callback support extraction
Common internal support logic was extracted around:

- tracked response lookup
- callback payload parsing
- queued-message handling
- tracked callback finalization
- tracked completion waiting
- post-processing wait

This reduced repeated low-level plumbing.

---

### 4. Request builder extraction
Request construction was made more explicit for the main runtime request paths:

- backend status request
- subscribe channel request
- login request

This reduced noise in the outward runtime methods.

---

### 5. Post-send tracked request preparation extraction
The logic that converts a send result into a tracked response object was isolated, making tracked request orchestration easier to follow.

---

### 6. `_onData(...)` decomposition
The incoming-data handler was significantly cleaned up.

It now operates more clearly as a dispatcher between:

- handshake path
- tracked incoming path
- tracked callback-or-cleanup handling
- error handling

This was one of the most important structural improvements in the phase.

---

### 7. Reusable tracked request execution
A reusable internal tracked request execution helper was introduced and successfully applied in:

- `getBackendStatus()`
- `subscribeChannel()`
- `doLogin()`

This reduced repeated logic for:
- sending a tracked request
- preparing tracked state
- waiting for completion
- reading final response
- waiting for post-work completion
- cleaning up tracking

---

### 8. Callback-side state alignment
The phase also stabilized important callback-side behavior, including:

- callback-driven auth context application
- cleaner success finalization in login/check-login paths
- subscription completion based on real tracked counters

These were done while preserving the existing backend-driven semantics.

---

## Frozen Runtime Behaviors Preserved

The following behaviors remained stable during the phase:

- current startup experience
- current login UX
- current WebSocket handshake
- current channel subscription sequence
- current backend status request flow
- current tracked message semantics
- current dashboard readiness behavior

---

## What Was Intentionally Not Pursued

The phase intentionally stopped before aggressive shared callback abstraction.

In practice, this means it did **not** force:

- a generic callback framework
- a shared callback bootstrap layer across all callbacks
- a broad shared callback error framework

This decision was deliberate.

Even though several callbacks look similar, they still contain behavior-sensitive differences. The cost/risk ratio of forcing deeper abstraction at this stage was not favorable.

---

## Validation Approach Used During the Phase

The decomposition was done incrementally and validated in small steps.

Validated paths included, at minimum:

- handshake
- backend status request
- login flow
- check-login flow
- channel subscription flow
- tracked message completion and cleanup

The guiding rule was:

> small extraction, immediate validation, no speculative redesign

---

## Outcome

At the end of Phase 5:

- `ServiceProvider` still behaves the same from the product perspective
- its internal structure is clearer
- repeated tracked request flow is consolidated where safe
- auth/context and handshake boundaries are clearer
- the runtime core is in a safer condition for future work

---

## Recommended Next Step After Phase 5

The recommended next step is **not** to keep forcing runtime-core abstractions.

The best direction after this phase is:

1. move toward presentation and feature-oriented cleanup
2. preserve backend-sensitive flows
3. document real behavior continuously
4. revisit deeper callback/runtime abstractions only when directly justified by a concrete need
