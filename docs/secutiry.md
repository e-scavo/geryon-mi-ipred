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

### 4. Future hardening opportunity
Future phases should review:
- config persistence behavior
- token/session lifecycle
- logout semantics
- remembered login behavior
- sensitive logging reduction for production