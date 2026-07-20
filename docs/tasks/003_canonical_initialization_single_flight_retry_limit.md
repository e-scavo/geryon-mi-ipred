# Phase X — Task 003 — Canonical Initialization Single-Flight and Retry Limit

## Objective

Correct the runtime behavior reproduced with the backend intentionally unavailable: the startup/loading surface must execute one canonical bootstrap cycle, perform only the configured automatic attempts, and then remain in manual-retry mode instead of starting overlapping connection/recovery loops indefinitely.

## Source ZIP

- `geryon-mi-ipred-x.task2.zip`

The screenshot supplied with this task confirms repeated WebSocket connection attempts after the backend was stopped.

## Root Cause Confirmed in the Repository

The login-route exclusion introduced in Task 002 was active, but the remaining repetition did not originate in a second `PopUpLoginWidget` construction.

The actual loop was produced below the login layer:

1. `ServiceProvider.init()` recursively retried `wssClient.init()`.
2. A failed WebSocket attempt could also invoke `_onDone()`.
3. `_onDone()` changed the global state to disconnected and requested transport recovery.
4. Transport recovery invoked `init()` again while the original initialization chain was still active.
5. Backend-status failures also recursively invoked `init()` without sharing one canonical Future and without a bounded backend-validation retry counter.

Consequently, more than one initialization/recovery continuation could coexist. Each continuation could initiate further transport attempts, making the loading/login bootstrap appear to execute indefinitely even though the login route itself was globally owned.

## Owner Decision

`ServiceProvider` remains the only owner of:

- initialization;
- connection retries;
- backend validation;
- transport recovery;
- startup/login continuation.

No widget flag, timer, secondary recovery coordinator, or parallel retry mechanism was added.

## Implementation

### Single-flight initialization

`ServiceProvider.init()` now owns and exposes one active initialization Future.

While that Future is active:

- every additional caller reuses it;
- no second initialization chain is created;
- startup, handshake continuation, loading, and recovery callers converge on the same execution.

### Iterative bounded retry loop

The recursive initialization implementation was replaced by one iterative canonical loop.

The same `connRetry` / `maxConnRetry` policy now covers:

- WebSocket establishment failures;
- backend-status validation failures.

After the configured limit:

- automatic execution stops;
- `isProgress` becomes false;
- `canRetry` becomes true;
- the current explicit error stage remains visible;
- only a user-triggered manual recovery starts a new clean bootstrap.

### `_onDone()` recovery exclusion during initialization

A transport-done callback received while canonical initialization is active is recorded in the log but is not accepted as a second recovery trigger.

The already-running initialization owns that failed attempt and applies the configured retry limit. A genuine disconnect occurring after initialization has completed continues to use the existing runtime recovery policy.

### Loading retry display

The loading surface no longer hardcodes `5` when deciding whether to display the current attempt. It now reads `ServiceProvider.maxConnRetry`, preserving one source of truth.

## Files Modified

- `lib/models/ServiceProvider/data_model.dart`
- `lib/shared/overlays/global_loading_dialog.dart`
- `docs/tasks/index.md`
- `docs/index.md`

## Files Added

- `docs/tasks/003_canonical_initialization_single_flight_retry_limit.md`

## Expected Runtime Result

With the backend unavailable:

1. one loading/bootstrap route remains active;
2. one initialization Future performs the configured automatic attempts;
3. `_onDone()` cannot create a parallel recovery cycle;
4. automatic attempts stop at the configured limit;
5. the UI remains in an explicit manual-retry state;
6. pressing retry starts one new full bootstrap cycle;
7. no login route is opened because backend validation was never reached successfully.

With the backend restored:

1. manual retry re-enters the complete bootstrap;
2. backend validation executes;
3. login is requested once only when authentication is actually required;
4. the Task 002 global route/future/generation protections remain in force.

## Validation

Repository-level checks performed:

- inspected every `ServiceProvider.init()` call site and handshake continuation;
- inspected `_onDone()` and all runtime recovery entry points;
- confirmed there is still one `PopUpLoginWidget` construction point;
- confirmed retry UI now consumes `maxConnRetry`;
- checked delimiter balance in the modified Dart source;
- built a partial ZIP containing only modified/new files.

The execution environment does not provide Dart or Flutter, so `dart format`, `dart analyze`, and browser runtime execution could not be run here.
