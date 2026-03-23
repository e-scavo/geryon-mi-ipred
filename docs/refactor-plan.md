# 🛠️ Refactor Plan

## 🎯 Purpose

This document defines the staged refactor roadmap for Mi IP·RED.

The application already works in production, so the goal is **controlled structural improvement**, not a rewrite.

---

## 🧭 Global Refactor Rules

### Rule 1
Do not break backend communication.

### Rule 2
Do not change working behavior only for aesthetic reasons.

### Rule 3
Prefer internal isolation before path or naming changes.

### Rule 4
Remove legacy only after confirming it is not in use.

### Rule 5
Each phase must be documentable and reversible.

---

## 🚦 Refactor Stages

## Phase 2
### Documentation alignment and structural planning
Scope:
- expand documentation
- map modules
- define target structure
- identify cleanup candidates

Deliverables:
- architecture deep dive
- module inventory
- target structure
- refactor roadmap
- structural planning document

Risk:
- none to runtime

---

## Phase 3
### Low-risk cleanup and repository hygiene
Scope:
- classify legacy and disabled files
- quarantine or remove obvious unused files
- improve repository clarity before deeper refactor
- document cleanup procedures and safety checks

Deliverables:
- `legacy.md`
- `cleanup-checklist.md`
- `phase3_cleanup_hygiene.md`

Primary candidates:
- old socket files
- old session storage file
- old login data model
- experimental theme/demo file
- old utility file
- unused websocket service file
- disabled config UI files

Risk:
- low, if performed with validation after each step

---

## Phase 4
### Infrastructure folder normalization
Scope:
- organize config, session storage, file saver, and transport
- move low-risk infra files toward clearer folders
- keep public APIs stable

Targets:
- config loader
- session storage
- file saver
- websocket client abstraction

Risk:
- medium-low

---

## Phase 5
### ServiceProvider internal decomposition
Scope:
- keep the same public behavior
- split responsibilities into internal collaborators
- reduce pressure on the main orchestration file
- improve readability and maintainability of the runtime core

Suggested extraction areas:
- connection lifecycle
- login/session lifecycle
- RPC tracking helpers
- message sending orchestration
- backend status flow
- customer context state transitions

Important:
The first goal is **internal responsibility separation**, not a behavioral rewrite.

Risk:
- high
- this is the most sensitive stage of the current roadmap

---

## Phase 6
### Presentation structure cleanup
Scope:
- move login into feature-based presentation folder
- move dashboard into dashboard feature folder
- move billing into billing feature folder
- move shared widgets to a dedicated shared widgets area

Risk:
- medium
- mostly path and import churn if done after phase 5

---

## Phase 7
### Domain model organization
Scope:
- group common/generic/table models more clearly
- improve discoverability
- preserve JSON contracts and constructors

Risk:
- medium
- mainly organizational, but must avoid serialization regressions

---

## Phase 8
### Session and config hardening
Scope:
- decide whether real persisted backend session validation is desired
- re-enable real persisted config loading if needed
- clarify logout semantics
- document remember-me policy

Risk:
- medium-high
- may affect real user behavior, so should not be mixed with structural cleanup

---

## 🔎 Specific Technical Recommendations

### A. Freeze public protocol points
Before deep refactor, treat these as frozen:
- request payload structure
- `messageID` generation/usage
- status transitions
- login payload
- handshake interpretation

### B. Extract helpers before moving ownership
Prefer extracting small helpers first, such as:
- `_sendTrackedMessage(...)`
- `_waitForTrackedResponse(...)`
- `_handleHandshake(...)`
- `_handleBackendStatusSuccess(...)`
- `_handleLoginSuccess(...)`
- `_resetSessionState(...)`

### C. Keep UI-triggered popups stable for now
If `ServiceProvider` currently triggers UI popups through `navigatorKey`, keep that behavior unchanged in Phase 5.
Separation of UI navigation concerns can happen later.

---

## ✅ Definition of Success

A successful refactor roadmap for Mi IP·RED is one that:

- keeps production behavior stable
- makes the code easier to navigate
- reduces the size and responsibility of `ServiceProvider`
- keeps the backend flow intact
- allows future feature work with less friction