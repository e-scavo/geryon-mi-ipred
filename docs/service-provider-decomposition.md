# 🧠 ServiceProvider Decomposition

## 🎯 Purpose

This document defines how `ServiceProvider` should be decomposed internally in Mi IP·RED.

The goal is not to replace it immediately, but to make it smaller, clearer, and safer to maintain.

---

## 🧭 Current Problem

`ServiceProvider` is currently the main runtime backbone of the application, but it also concentrates too many responsibilities in a single place.

Today it acts as:

- connection manager
- backend bootstrap coordinator
- session/login manager
- message sender
- async response tracker
- customer/company context holder
- partial UI trigger source
- state notifier

This works, but it creates high maintenance pressure.

---

## 🚫 What Phase 5 Is NOT

Phase 5 is **not**:

- a full rewrite
- a protocol redesign
- a login redesign
- a provider replacement
- a change to the backend contract

It is a **controlled internal decomposition**.

---

## ✅ What Phase 5 Is

Phase 5 is:

- extracting internal helper methods
- grouping logic by responsibility
- reducing method size
- reducing branching complexity
- making state transitions easier to understand
- preparing later file-level separation

---

## 🧱 Proposed Internal Responsibility Areas

The current `ServiceProvider` logic should gradually be split into these areas.

### 1. Connection lifecycle
Responsibilities:
- socket initialization
- reconnect attempts
- done/error handling
- connection stage transitions

Suggested future helper names:
- `_initializeSocket()`
- `_connectSocket()`
- `_handleSocketError(...)`
- `_handleSocketDone()`
- `_retryConnectionIfNeeded()`

---

### 2. Handshake/bootstrap lifecycle
Responsibilities:
- detect first backend message
- extract `TokenID`
- mark `isNew = false`
- trigger channel subscription
- continue provider initialization

Suggested future helper names:
- `_isHandshakeMessage(...)`
- `_handleHandshakeMessage(...)`
- `_applySessionToken(...)`
- `_continueInitializationAfterHandshake()`

---

### 3. Channel subscription lifecycle
Responsibilities:
- subscribe to required channels
- confirm subscription success
- control initialization progression

Suggested future helper names:
- `_subscribeRequiredChannels()`
- `_subscribeSingleChannel(...)`
- `_markChannelSubscribed(...)`

---

### 4. Backend status lifecycle
Responsibilities:
- request backend status
- interpret status result
- decide next init stage

Suggested future helper names:
- `_requestBackendStatus()`
- `_handleBackendStatusResult(...)`

---

### 5. Login/session lifecycle
Responsibilities:
- check login state
- send login request
- apply logged user data
- logout/reset session-related state

Suggested future helper names:
- `_checkLoginState()`
- `_sendLoginRequest(...)`
- `_handleLoginSuccess(...)`
- `_clearLoginState()`
- `_resetSessionState()`

---

### 6. RPC/tracked message lifecycle
Responsibilities:
- create tracked messages
- assign `messageID`
- send request
- wait for response
- route callback data

Suggested future helper names:
- `_createTrackedMessage(...)`
- `_sendTrackedMessage(...)`
- `_waitForTrackedMessage(...)`
- `_resolveTrackedMessage(...)`

---

### 7. Customer/company context lifecycle
Responsibilities:
- set current company
- set current customer
- switch current customer
- expose current context to UI

Suggested future helper names:
- `_applyCompanyContext(...)`
- `_applyCustomerContext(...)`
- `_selectCustomerByIndex(...)`
- `_resetCustomerContext()`

---

## 🛡️ Public Behavior That Must Stay Frozen

The following behavior must remain stable during Phase 5:

- app startup flow
- socket init flow
- handshake semantics
- channel subscription flow
- backend status request flow
- login request shape
- `loggedUser` assignment
- dashboard data availability
- billing/receipts loading
- logout visible behavior

---

## 🧪 Recommended Decomposition Strategy

### Step 1
Extract **private helper methods only** inside the same file.

### Step 2
Group related helpers together using comment sections or clearly marked regions.

### Step 3
Once internal responsibilities are stable, move helper groups into dedicated companion files if still needed.

This reduces risk because behavior stays close to the original code during the first decomposition pass.

---

## ⚠️ High-Risk Areas

Special care is required around:

- `_onData(...)`
- `init()`
- handshake detection
- message tracking maps
- async callback resolution
- login result assignment
- anything touching `notifyListeners()`

These are the most behavior-sensitive parts of the runtime core.

---

## ✅ Success Criteria

Phase 5 is successful when:

- `ServiceProvider` is easier to read
- large methods are split into smaller helpers
- the runtime behavior remains identical
- future extraction to separate files becomes feasible