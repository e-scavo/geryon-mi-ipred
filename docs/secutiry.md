# Security

## Current observations

### 1. Sensitive files in shared project package
The provided project package included keystore files.

Repository exchanges for review/refactor work should avoid including:
- keystores
- signing material
- secrets
- private credentials

### 2. Local remembered data
Current remembered login support stores the DNI locally.

This is lightweight convenience persistence, not a full secure authenticated session persistence system.

### 3. Backend session/authentication handling
The app negotiates connection state and token context through backend WebSocket flows.

This area is critical and must not be modified without controlled review.

### 4. Phase 5 security implication
Phase 5 did not redesign security behavior.

What it did do was make the most sensitive runtime paths easier to reason about:
- handshake flow
- tracked request flow
- auth/context application points
- callback finalization points

This improves maintainability and lowers accidental regression risk, but it is not a security redesign.

### 5. Future hardening opportunity
Future phases should review:
- config persistence behavior
- token/session lifecycle
- logout semantics
- remembered login behavior
- sensitive logging reduction for production
