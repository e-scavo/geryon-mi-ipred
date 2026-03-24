# Decisions

## Decision 1 — Backend behavior is frozen during structural refactor
The application is functional in production.

For that reason, structural work must preserve:
- request shapes
- callback semantics
- message tracking behavior
- handshake behavior
- login behavior
- readiness progression

---

## Decision 2 — ServiceProvider is refactored internally before any file split
The safest way to improve the runtime core is:

1. keep logic in the same file
2. extract private helpers
3. validate behavior
4. only later consider deeper separation if necessary

This decision was actively applied in Phase 5.

---

## Decision 3 — Callback-driven auth semantics remain valid
In Mi IP·RED, login/session materialization happens in callback paths.

That means:
- outward request methods orchestrate
- callbacks apply final state

This is not an idealized pattern, but it is the real runtime behavior and was preserved intentionally.

---

## Decision 4 — Tracked request execution is reused where it already exists safely
The repeated tracked-request runtime pattern was consolidated into a reusable internal helper and applied only where verified safe.

Applied safely in:
- `getBackendStatus()`
- `subscribeChannel()`
- `doLogin()`

Not force-applied elsewhere without validation.

---

## Decision 5 — Do not over-abstract callback bodies prematurely
Although several callbacks look similar, they still contain behavior-sensitive differences.

Therefore, Phase 5 stops before introducing aggressive shared callback frameworks or broad callback error abstractions.

This is intentional and reduces regression risk.

---

## Decision 6 — Preserve multi-platform abstractions
The project already contains meaningful Web/IO abstractions for:
- WebSocket
- session storage
- config storage
- file saving

These abstractions must be preserved.

---

## Decision 7 — Document real behavior, not ideal behavior
Phase documents and architecture files must describe the actual runtime behavior, even when that behavior is not yet fully ideal from a design perspective.

This applies especially to:
- login handling
- popup usage
- provider readiness transitions
- callback-driven state application

---

## Decision 8 — Phase 5 closure happens when structure is improved and runtime stays stable
Phase 5 is considered complete when:
- the most fragile methods are decomposed
- tracked request flow is reused safely
- `_onData(...)` is clearer
- auth/context helper extraction is in place
- the runtime behavior remains unchanged in tested paths
