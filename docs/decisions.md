# 🧠 Architectural & Implementation Decisions

## Objective

Record the active architectural and implementation decisions that govern Mi IP·RED after the formal closure of Phase 7 and the opening of Phase 8 as a runtime reliability and failure semantics hardening effort.

## Initial Context

The current ZIP confirms the following baseline:

- Phase 7 is formally closed
- the active architecture remains `presentation → controller → ServiceProvider`
- startup/auth continuation was already normalized during Phase 7.4
- the project is no longer in an application-layer consolidation phase
- Phase 8 is now opened for runtime reliability and failure semantics hardening
- Phase 8.1 documents the real runtime failure surfaces

## Problem Statement

The repository now needs a clear decision record so that future runtime hardening does not accidentally:

- reopen closed structural scope
- create new hidden architecture
- normalize error behavior inconsistently
- treat local feature failures and runtime-global failures as the same thing

The decisions below freeze the correct interpretation of the current baseline.

## Scope

These decisions govern:

- active architecture interpretation
- ownership of runtime lifecycle
- interpretation of Phase 8
- how runtime hardening may proceed
- what remains explicitly out of scope

These decisions do not themselves implement runtime changes.

## Root Cause Analysis

After Phase 7, the main structural problem was already solved.

The current ZIP shows that the remaining risk now lives in operational behavior:

- startup recovery
- websocket disconnect handling
- reconnect / reboot semantics
- login continuation failure handling
- feature fetch failure behavior
- heterogeneous error presentation

That means the decision model must shift from structural consolidation decisions toward runtime-hardening decisions.

## Files Affected

These decisions directly govern interpretation of:

- `lib/main.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/ServiceProvider/init_stages_enum_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/core/transport/geryonsocket_model.dart`
- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/core/transport/geryonsocket_model_web.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/application_coordinator.dart`
- `docs/phase8_runtime_reliability_failure_semantics_hardening.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md`

## Implementation Characteristics

### Decision 1 — Phase 7 remains closed

Phase 7 is frozen.

No future work may continue under new `7.x` subphases unless the project explicitly reopens that phase with a separate justified decision.

That is not the current state.

### Decision 2 — Phase 8 is a runtime-hardening phase, not a structural phase

Phase 8 exists because the ZIP shows real runtime failure and recovery surfaces that are not yet fully normalized.

Phase 8 does not exist to continue structural cleanup.

### Decision 3 — The active architecture remains unchanged

The active architecture remains:

- `presentation → controller → ServiceProvider`

This is a stable baseline, not an open question.

### Decision 4 — ServiceProvider remains the runtime owner

ServiceProvider remains the owner of:

- authenticated runtime lifecycle
- backend connectivity baseline
- startup/runtime continuation state
- active operational context

Phase 8 may clarify or harden that ownership.

It may not replace it.

### Decision 5 — Runtime failures must be classified before policy is changed

Before retry, reconnect, reboot, or reset behavior is changed, the project must first identify:

- where failures occur
- whether they are runtime-global or feature-local
- whether they are recoverable, retryable, blocking, or invalidating

This is why 8.1 comes before any implementation subphase.

### Decision 6 — Runtime policy must stay explicit and narrow

Any later hardening of:

- retry
- reboot
- reconnect
- reload
- reset

must remain narrowly tied to a real identified failure boundary.

No broad “reliability framework” may be introduced without explicit evidence from the ZIP.

### Decision 7 — Error presentation heterogeneity is evidence, not yet a bug by itself

The current codebase presents errors through multiple surfaces, including:

- loading popup retry path
- `SnackBar`
- `CatchMainScreen`
- popup dialogs

This heterogeneity is not, by itself, justification for redesign.

It is evidence that failure semantics are distributed and must be normalized before any unification work is proposed.

### Decision 8 — Feature-local failures and runtime-global failures must not be merged implicitly

Billing failure, login failure, startup failure, and websocket disconnect are not automatically the same class of problem.

Future work must keep that distinction explicit.

### Decision 9 — Phase 8 implementation must proceed in order

The active recommended order is:

- `8.1 — Runtime Failure Surface Inventory`
- `8.2 — Failure Boundary Normalization`
- `8.3 — Retry / Reboot / Reconnect Policy Hardening`
- `8.4 — Runtime Diagnostic & Observability Signals`
- `8.5 — Formal Closure of Phase 8`

This order is now part of the documentary baseline.

## Validation

These decisions are valid only if the current ZIP still confirms all of the following:

- Phase 7 is fully closed
- the active architecture is stable
- runtime recovery behavior already exists in code
- operational semantics remain partially distributed
- runtime hardening is the next justified step

The current ZIP confirms those conditions.

## Release Impact

These decisions have no direct user-facing release impact.

They protect the correct interpretation of the codebase and prevent the next phase from drifting into hidden redesign.

## Risks

If these decisions are ignored, future work may:

- reopen structural scope unnecessarily
- normalize the wrong failure boundaries
- patch runtime issues inconsistently
- move recovery policy into widgets
- destabilize the current baseline

## What it does NOT solve

This decisions document does not itself:

- fix runtime hotspots
- classify all failures formally
- change reconnect behavior
- define the final retry policy
- add observability signals

It only freezes the correct decision baseline for Phase 8.

## Conclusion

The current project baseline is:

- Phase 7 closed
- architecture frozen
- ServiceProvider retained as runtime owner
- Phase 8 opened as runtime reliability and failure semantics hardening
- Phase 8.1 established as the correct first step

Future work must now proceed under that interpretation.