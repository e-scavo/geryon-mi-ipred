# 🧠 Phase 5 — ServiceProvider Internal Decomposition

## 🎯 Phase Goal

Reduce the internal complexity of `ServiceProvider` without changing runtime behavior.

This is the first phase that directly targets the most critical runtime class of Mi IP·RED.

---

## 🧠 Why This Phase Exists

At this point:

- the project is documented
- infrastructure has been normalized
- the backend flow is mapped
- the repository is cleaner

The next bottleneck is now clear:

> `ServiceProvider` is too large and too responsible.

The application works, but future maintenance will remain expensive unless this class is decomposed internally.

---

## ✅ What This Phase Tries to Achieve

This phase aims to:

- reduce mental load when reading `ServiceProvider`
- separate concerns inside the class
- isolate risky logic into smaller helpers
- keep the same public interface and runtime behavior
- prepare later extraction into more explicit runtime modules

---

## 🚫 What This Phase Must Not Do

This phase must **not**:

- change backend message contracts
- change login request structure
- change handshake semantics
- rewrite state management
- replace Riverpod/provider wiring
- redesign billing flow
- change dashboard usage of provider state

This is decomposition, not redesign.

---

## 🧱 Recommended Internal Breakdown

The current `ServiceProvider` should be decomposed around these responsibility groups:

### 1. Connection bootstrap
- socket creation
- init stages
- reconnect behavior

### 2. Handshake handling
- first message detection
- token assignment
- initialization continuation

### 3. Channel orchestration
- required channel subscription
- subscription bookkeeping

### 4. Backend status flow
- request status
- interpret response
- progress init state

### 5. Login/session flow
- check current login state
- login request
- apply logged user
- logout/reset

### 6. RPC tracking flow
- build tracked request
- wait for tracked response
- resolve callback states

### 7. Customer/company context
- assign current company
- assign current customer
- switch active customer

---

## 🧭 Execution Rule

The safest way to refactor `ServiceProvider` is:

1. stay in the same file first
2. extract private helpers
3. preserve method call order
4. preserve field names when possible
5. validate after every small change

This prevents large simultaneous failures.

---

## 🔒 Frozen Runtime Behaviors

These behaviors are formally frozen during Phase 5:

- current startup experience
- current login UX
- current WebSocket handshake
- current channel subscription sequence
- current backend status request flow
- current tracked message semantics
- current dashboard readiness behavior

---

## ⚠️ Sensitive Areas

The most fragile code paths are expected to be:

- `init()`
- `_onData(...)`
- `doCheckLogin()`
- `doLogin()`
- `sendMessageV2(...)`
- message tracking storage access
- state reset on logout/disconnect

Any decomposition touching these methods should be done incrementally.

---

## 🧪 Recommended Technical Pattern

For this phase, prefer:

- small private extraction
- no semantic rename of external methods
- no API redesign
- no new abstraction layer unless it reduces complexity immediately

Examples of acceptable extractions:
- `_handleHandshakeMessage(...)`
- `_requestBackendStatusInternal(...)`
- `_applyLoggedUser(...)`
- `_resetProviderState(...)`
- `_sendTrackedRequestInternal(...)`

---

## ✅ Expected Outcome

At the end of Phase 5:

- `ServiceProvider` should still behave the same
- its internal structure should be clearer
- future changes will become safer
- Phase 6 can then focus on presentation structure with less pressure on the runtime core

---

## 📌 Recommended Next Step After This Phase

> **Phase 5 execution — step-by-step guided decomposition of `ServiceProvider`**

This should be performed carefully and validated after each internal extraction.