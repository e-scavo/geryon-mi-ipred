# Phase X — Task 011 — Mandatory DBVersion 10 Request Contract

## Objective

Make `DBVersion: 10` a mandatory backend-request contract for the Mi IP·RED Customers frontend after the backend migration to DBVersion 10.

The attached Task 010 ZIP is the implementation source of truth for this intervention.

## Repository-wide audit

The complete `lib/` tree was reviewed, including the model, feature, shared-widget, legacy transport, and active transport surfaces. The current repository contains 188 Dart source files.

The audit confirmed that active application requests reach the backend through two canonical boundaries:

1. CRUD/data requests flow through `CommonDataModel` -> `CommonParamRequest.fromData()` -> `ServiceProvider.sendMessageV2()`.
2. Startup/auth requests built directly by `ServiceProvider` are `Get:Status`, `Subscribe_Channel`, and `Auth:Login`.

The only direct feature/widget `abmCalls()` sites are the billing-document flow and the common local-download flow. Both use `GenericDataModel`, and therefore both pass through the canonical `CommonDataModel` / `CommonParamRequest` boundary.

No active widget or feature sends an application RPC directly to the WebSocket transport.

## Root cause

Before this task, DBVersion was supplied only by selected callers such as Clientes, DetServiciosDATOSClientes, NAS, and billing. Every other request that omitted the key reached the Go backend with the deserialized default value `0`.

Adding `DBVersion: 10` independently to every widget/model would preserve the same distributed-contract problem and would remain vulnerable to future omissions.

## Implementation

### Canonical backend contract

A new `BackendContract` defines the single DB version used by the frontend:

- key: `DBVersion`
- value: `10`

The value is no longer duplicated as a magic literal across request-building models.

### Canonical CRUD/data boundary

`CommonParamRequest.fromData()` now forcibly writes the canonical DBVersion into `LocalParams` after `HeaderParamsRequest.localParams` precedence has been resolved.

This ordering is intentional. A caller or header cannot accidentally remove or downgrade the mandatory DB version. Every active `CommonDataModel` request is therefore guaranteed to reach the backend with DBVersion 10.

`CommonDataModel.abmCalls()` also initializes its local request envelope with DBVersion 10 so the contract is visible as early as possible in the request lifecycle. `CommonParamRequest` remains the final enforcement boundary.

### Startup/auth direct requests

The two direct ServiceProvider application requests that carry backend parameters now include the same contract:

- `Get:Status`
- `Auth:Login`

`Subscribe_Channel` remains deliberately versionless because it is a transport subscription operation and does not represent a database-backed application request.

### Existing explicit callers

Existing DBVersion literals in:

- billing controller
- Clientes
- DetServiciosDATOSClientes
- NAS

were normalized to `BackendContract`. Their behavior remains DBVersion 10 while eliminating duplicated magic numbers.

The stale commented DBVersion 2 example in DetServiciosDATOSClientes was also normalized so it cannot be copied back into active code later.

## Resulting invariant

For every active database-backed application request in the current repository:

`LocalParams.DBVersion == 10`

The invariant is enforced by the request owner rather than by individual screens.

## Files changed

- `lib/core/backend/backend_contract.dart` (new)
- `lib/models/CommonParamRequest/common_param_prequest.dart`
- `lib/models/CommonDataModel/data_model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/models/tbl_ClientesV2/model.dart`
- `lib/models/tbl_DetServiciosDATOSClientesV2/model.dart`
- `lib/models/tbl_NAS/model.dart`
- `docs/tasks/011_mandatory_dbversion_10_request_contract.md` (new)
- `docs/tasks/index.md`
- `docs/index.md`

## Validation

Repository-level static audit performed:

- all Dart files under `lib/` enumerated and inspected for backend request construction
- all `sendMessageV2()` call sites enumerated
- all `abmCalls()` and `callRPC()` call sites enumerated
- all `CommonParamRequest.fromData()` call sites enumerated
- all literal `DBVersion` occurrences audited
- no active literal DBVersion value remains outside `BackendContract`
- active feature/widget request sites resolve through the canonical enforcement boundary

The execution environment does not contain the Flutter/Dart SDK, so `dart format`, `dart analyze`, and Flutter tests could not be executed here.

## Manual verification requested

When validating against the DBVersion 10 backend, inspect representative backend payloads for:

- startup `Get:Status`
- customer login
- billing browse/filter
- billing document download
- Clientes lookup
- DetServiciosDATOSClientes lookup
- NAS-related lookup if reachable in the customer application

Each database-backed request must expose `DBVersion: 10` in its effective `LocalParams` contract.
