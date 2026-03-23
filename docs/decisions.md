# Decisions

## Decision 1 — Preserve backend flow first
The backend communication flow is the highest priority constraint of the project.

We will not perform refactors that alter:
- handshake semantics
- token negotiation
- channel subscription order
- request envelope format
- response tracking by `messageID`
- login request shape

---

## Decision 2 — Refactor in stages
The application is already functional in production.

Therefore, refactoring will be:
- staged
- conservative
- traceable
- documented phase by phase

No large rewrite-first strategy will be used.

---

## Decision 3 — Document the real code, not an idealized version
The documentation must reflect the actual current state of the repository, including:
- technical debt
- legacy structures
- current constraints
- naming inconsistencies
- temporary implementations

---

## Decision 4 — Keep current package identity until explicitly changed
The visible product is **Mi IP·RED**, but the technical package remains `geryon_web_app_ws_v2`.

This mismatch should be documented now and changed only in a controlled later phase.

---

## Decision 5 — Treat `ServiceProvider` as critical infrastructure
`ServiceProvider` is the current backbone of the app.

It must be treated as a protected refactor area:
- isolate responsibilities gradually
- do not split blindly
- preserve public behavior first

---

## Decision 6 — Keep multi-platform abstractions
The project already contains meaningful Web/IO abstractions for:
- WebSocket
- session storage
- config storage
- file saving

These abstractions should be preserved and improved, not removed.

---

## Decision 7 — Do not assume persistent authenticated session exists
Current implementation persists only lightweight login assistance data (DNI), not a full authenticated reusable session.

Any future "remembered session" improvement must be designed explicitly and safely.

---

## Decision 8 — Remove legacy noise only after mapping dependencies
There is commented and legacy code in multiple areas.

It should not be removed until:
- actual runtime paths are confirmed
- references are mapped
- replacement/documentation exists