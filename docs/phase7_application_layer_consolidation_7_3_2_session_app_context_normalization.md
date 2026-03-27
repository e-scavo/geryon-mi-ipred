# 🧭 Phase 7.3.2 — Session & App Context Normalization

## Objective

Normalize the concepts, ownership, lifecycle boundaries, and read paths of the session-related and app-context-related state already present in Mi IP·RED so that startup, auth, dashboard, billing, and logout flows stop depending on implicit semantics while preserving the current runtime contract.

## Initial Context

Phase 7.3.1 already documented the real application flows currently active in the codebase.

That inventory confirmed that multiple runtime surfaces already share and consume context through:

- `main.dart`
- `SessionStorage`
- `LoginController`
- `ServiceProvider`
- `DashboardController`
- `BillingController`

The real ZIP also confirmed that those flows were operating over several distinct concepts that were not yet normalized explicitly:

- startup boundary state
- persisted login hint state
- authenticated runtime context
- active operational context

The app already worked with those concepts, but some of their semantics were still implicit.

This subphase addresses that gap conservatively.

## Problem Statement

The project already distinguished several context concepts in practice, but not yet with a normalized contract.

That ambiguity created real issues visible in the ZIP:

- `SessionStorage` only stored remembered DNI hint, but its usage could still be interpreted as broader “session” behavior
- remember-me persistence was not symmetric when the user disabled remember-me after a previously remembered login
- logout cleared all storage instead of only removing the remembered login hint it actually owned
- dashboard and billing still consumed shared runtime context through raw `ServiceProvider` fields in critical paths

If left unresolved, these ambiguities would become a weak foundation for later feature interaction contracts or coordinator work.

## Scope

This subphase includes:

- explicit remembered-login-hint removal support in storage
- symmetric remember-me lifecycle in auth submit flow
- explicit logout cleanup for remembered-login hint
- minimal read-only runtime-context accessors on `ServiceProvider`
- incremental migration of dashboard and billing critical paths to normalized context reads
- documentation alignment for the new semantic baseline

This subphase does not include:

- backend-authenticated persistent session redesign
- new coordinator logic
- feature interaction contract types
- navigation redesign
- UI redesign
- ServiceProvider ownership redesign

## Root Cause Analysis

The current issue existed because Mi IP·RED evolved in the correct pragmatic order:

1. make runtime work
2. protect backend flow
3. normalize structure
4. extract feature-local logic
5. clarify state ownership
6. inventory flows
7. only then normalize the meanings of the shared contexts used by those flows

That sequencing exposed three important realities:

### A. Persisted login hint is narrower than “session”

The storage implementation only persisted `user_dni`.

That means the storage layer was not persisting authenticated user state.

It was only persisting a remembered login hint.

### B. Runtime auth is in memory

The real authenticated runtime context still lives in `ServiceProvider` through the current user state and its lifecycle helpers.

That remained correct and unchanged.

### C. Active client/company context is operational context

Dashboard and billing do not merely need to know whether a user exists.

They need the currently active operational context.

That context already lived in `ServiceProvider`, but its read paths were not yet normalized.

## Files Affected

### Runtime files changed

- `lib/core/session/session_storage_io.dart`
- `lib/core/session/session_storage_web.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/models/ServiceProvider/data_model.dart`

### Documentation files changed

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_3_2_session_app_context_normalization.md`

## Implementation Characteristics

### 1. Persisted Login Hint Normalization in Storage

The platform-specific session storage implementations now expose:

- `saveDni(...)`
- `getSavedDni()`
- `removeSavedDni()`

The key remains the same:

- `user_dni`

This preserves compatibility while making the actual lifecycle operation explicit.

### 2. Symmetric Remember-Me Behavior in Auth

`LoginController.login(...)` now behaves symmetrically:

- if remember-me is enabled, the normalized DNI is saved
- if remember-me is disabled, any previously saved DNI hint is removed explicitly

This prevents stale remembered-login state from surviving successful logins where the user no longer wants to be remembered.

### 3. Explicit Logout Cleanup

`DashboardController.logout(...)` no longer clears all storage.

It now removes only the remembered login hint and then delegates runtime reset to `ServiceProvider.logout()`.

This keeps responsibilities separated:

- storage hint cleanup
- runtime auth reset

### 4. Read-Only Runtime Context Accessors on ServiceProvider

`ServiceProvider` now exposes explicit read-only accessors for shared runtime context:

- `hasAuthenticatedRuntimeContext`
- `authenticatedUser`
- `activeClientIndex`
- `availableClients`
- `hasActiveClientContext`
- `activeClient`
- `activeCompany`

These accessors do not move ownership.

They only normalize shared reads.

### 5. Dashboard Read Normalization

`DashboardController` now builds its source state from explicit read-only context accessors instead of reaching directly into raw provider internals for its critical inputs.

This keeps dashboard as a consumer of shared context, not its owner.

### 6. Billing Read Normalization in Critical Paths

`BillingController` now reads critical shared-context values through explicit accessors in the provider during:

- current client resolution
- active company resolution
- active client resolution
- authenticated-context presence checks

The billing feature still owns its feature-local state and reload decisions.

It does not own the shared runtime context.

## Validation

A valid 7.3.2 implementation must preserve all previous runtime behavior and additionally validate the normalized context lifecycle.

The current implementation should be validated through:

### Startup

- application still boots exactly as before
- startup boundary behavior remains unchanged

### Auth

- manual login still works
- auto-submit from remembered DNI still works
- login with remember-me disabled removes any stale remembered DNI from previous successful logins

### Dashboard

- authenticated dashboard render still works
- active client selection still works
- logout still works

### Billing

- billing still loads after login
- billing still reloads after client change
- billing still resolves active company and active client context correctly

### Logout

- logout still resets authenticated runtime context
- logout still re-enters unauthenticated runtime flow
- remembered login hint is removed explicitly without clearing unrelated storage

## Release Impact

This subphase is intended to have no user-facing feature redesign.

Its practical runtime impact is limited to:

- preventing stale remembered DNI state
- narrowing storage cleanup semantics
- reducing implicit coupling in shared-context reads

## Risks

The main risks of this subphase were:

- over-normalizing into a hidden coordinator
- moving ownership accidentally out of `ServiceProvider`
- breaking remember-me bootstrap behavior
- conflating remembered login hint with authenticated runtime context again

The implemented approach avoids those risks by remaining narrow and read-only wherever context normalization was introduced.

## What it does NOT solve

This subphase does not solve:

- backend-persisted authenticated session validation
- feature interaction contract definitions
- minimal application coordinator introduction
- broader auth/session redesign
- automated flow-level tests

Those belong to later subphases.

## Conclusion

Phase 7.3.2 is now implemented as a conservative normalization layer over context semantics that already existed in the project.

It does not redesign runtime ownership.

It clarifies it.

The resulting baseline is now safer for future work because Mi IP·RED explicitly distinguishes:

- startup boundary state
- persisted login hint state
- authenticated runtime context
- active operational context

and consumes shared runtime context through more explicit read paths without introducing premature new layers.