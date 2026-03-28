# ⚙️ Phase 8 — Runtime Reliability & Failure Semantics Hardening

## Objective

Open a new explicit post-Phase-7 effort focused on runtime reliability, operational recovery semantics, and failure-boundary hardening for Mi IP·RED without redesigning the application architecture, without replacing ServiceProvider, and without altering the working backend flow unless the real code later proves a narrowly justified need.

## Initial Context

The current ZIP confirms that:

- Phase 6 is completed
- Phase 7.1 is completed
- Phase 7.2 is completed and formally closed
- Phase 7.3 is completed and formally closed
- Phase 7.4 is completed and formally closed
- Phase 7.5 formally closed the whole Application Layer Consolidation effort

The resulting architecture remains:

- `presentation → controller → ServiceProvider`

The current codebase already preserves the intended Phase 7 baseline:

- feature-local controllers for `auth`, `dashboard`, and `billing`
- explicit source-state / derived-state handling
- explicit startup/auth continuation semantics
- minimal coordination only where justified
- no broad new global application layer
- no ServiceProvider replacement
- no UI redesign
- no navigation redesign

That means the next phase must not continue structural consolidation implicitly.

If a new phase is opened, it must be justified by a different real problem shown by the ZIP.

## Problem Statement

The real code confirms that Mi IP·RED now has a stable structural baseline, but the runtime still expresses failure handling and recovery behavior through distributed operational decisions rather than through a normalized failure model.

The problem is not that the app lacks recovery mechanisms.

The problem is that runtime failure semantics are still heterogeneous across:

- startup
- backend status bootstrap
- login continuation
- websocket disconnect / reconnect
- feature-level loading and failure presentation
- manual retry surfaces
- active-client-dependent reload behavior

In other words, the project is structurally consolidated, but not yet semantically hardened around runtime failure behavior.

That creates a new category of risk:

- transient failures may be handled inconsistently depending on where they occur
- the distinction between recoverable, retryable, blocking, and feature-local failures is not yet frozen as an explicit baseline
- runtime recovery depends on implementation detail and `initStage` transitions more than on a documented operational contract
- future hardening work could otherwise be done ad hoc and reopen architecture concerns indirectly

## Scope

Phase 8 includes:

- inventory of real runtime failure surfaces
- explicit identification of operational failure boundaries
- normalization of failure semantics
- hardening of retry / reboot / reconnect behavior
- clarification of startup/runtime recovery expectations
- documentation of runtime observability and diagnostic signals
- conservative runtime hardening without redesign

Phase 8 does not include:

- application architecture redesign
- ServiceProvider replacement
- navigation redesign
- UI redesign
- backend protocol redesign
- broad coordinator expansion
- state-management rearchitecture
- speculative new layers not justified by the real code

## Root Cause Analysis

By the end of Phase 7, the main structural ambiguity of the application had already been resolved.

That means the dominant remaining risk is no longer architectural structure.

The dominant remaining risk is runtime behavior under failure.

The current ZIP shows that the runtime already contains recovery-related mechanisms, for example:

- startup bootstrap through loading popup + coordinator state evaluation
- websocket close callback triggering reboot
- connection retry attempts during initialization
- explicit retry button during connection failure
- login continuation reopening when required
- feature-local error rendering in billing
- logout reset flowing back into backend status evaluation

Those mechanisms prove that reliability concerns are already present in the implementation.

However, they are not yet fully normalized into a formal operational baseline.

That is why Phase 8 is justified as a runtime reliability and failure semantics phase rather than as a structural phase.

## Files Affected

### Documentation

- `docs/phase8_runtime_reliability_failure_semantics_hardening.md` ← new
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md` ← new
- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`

### Runtime files analyzed for phase justification

- `lib/main.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/ServiceProvider/init_stages_enum_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/models/ServiceProvider/login_continuation_result_model.dart`
- `lib/models/ServiceProvider/auth_requirement_model.dart`
- `lib/core/transport/geryonsocket_model.dart`
- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/core/transport/geryonsocket_model_web.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/features/billing/presentation/billing_widget.dart`
- `lib/features/dashboard/controllers/dashboard_controller.dart`
- `lib/features/contracts/application_coordinator.dart`

### Code

- no code changes in this opening step

## Implementation Characteristics

### 1. Phase 8 is a new phase, not a continuation of Phase 7

Phase 7 solved application-layer consolidation.

Phase 8 is opened only because the ZIP shows a different category of remaining work:

- runtime reliability
- failure semantics
- operational recovery behavior

This keeps the phase model honest and prevents reopening structural scope under a misleading label.

### 2. The architecture remains frozen

The active architecture remains:

- `presentation → controller → ServiceProvider`

Phase 8 must operate inside that baseline.

It may harden runtime semantics, but it must not become an excuse to introduce:

- a broad new runtime layer
- a global event bus
- a new application engine
- controller inflation
- widget-owned recovery logic

### 3. The phase focus is operational semantics, not cosmetic error handling

The intent is not to merely show more messages.

The real concern is to normalize:

- what kind of failure happened
- whether recovery is automatic or manual
- whether a failure is feature-local or runtime-global
- whether the current runtime can continue safely
- whether reconnect, reboot, retry, or reset should occur

### 4. The phase will proceed conservatively

The recommended internal order is:

- `8.1 — Runtime Failure Surface Inventory`
- `8.2 — Failure Boundary Normalization`
- `8.3 — Retry / Reboot / Reconnect Policy Hardening`
- `8.4 — Runtime Diagnostic & Observability Signals`
- `8.5 — Formal Closure of Phase 8`

This order is intentionally conservative because it prevents premature implementation before the real failure surfaces are frozen.

## Validation

Phase 8 is justified only if all of the following are true in the current ZIP:

- Phase 7 is already fully closed
- the structural baseline is already stable
- failure/recovery logic already exists in the implementation
- runtime behavior under failure is still distributed across several layers
- there is still no fully frozen explicit runtime failure baseline
- the next safe work item is operational hardening rather than structural redesign

The current ZIP confirms those conditions.

## Release Impact

Opening Phase 8 has no direct runtime impact by itself.

Its impact is architectural and documentary:

- it defines the next justified phase after Phase 7
- it prevents stealth continuation of closed structural work
- it frames future changes as runtime hardening rather than redesign
- it prepares the repository for conservative reliability improvements

## Risks

If Phase 8 is not explicitly opened with this scope, future work may:

- mix runtime hardening with structural changes
- normalize error behavior inconsistently
- keep recovery behavior implicit
- patch runtime failures locally without a shared model
- accidentally destabilize the current baseline through ad hoc fixes

## What it does NOT solve

This opening document does not by itself:

- change reconnect behavior
- normalize retry policy
- classify failures formally
- fix runtime hotspots
- change feature error presentation
- add observability primitives
- repair any specific bug

It only establishes the correct justified scope for the next major phase.

## Conclusion

The current ZIP confirms that Mi IP·RED should not continue under Phase 7.

The correct next step is a new phase focused on runtime reliability and failure semantics.

That new phase is:

- `Phase 8 — Runtime Reliability & Failure Semantics Hardening`

Its first safe subphase is:

- `8.1 — Runtime Failure Surface Inventory`

No code should change before that inventory is explicitly frozen.