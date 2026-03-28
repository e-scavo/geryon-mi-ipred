# 🧠 Architectural & Implementation Decisions

## Objective

Record the active architectural and implementation decisions that govern Mi IP·RED after the closure of Phase 7 and after the introduction of normalized runtime failure-boundary semantics in Phase 8.2.

## Initial Context

The current ZIP confirms:

- Phase 7 is closed
- the architecture remains `presentation → controller → ServiceProvider`
- Phase 8 is active
- Phase 8.1 documented runtime failure surfaces
- Phase 8.2 introduced explicit failure-boundary normalization

## Problem Statement

The repository now needs a clear decision baseline so that future runtime hardening does not:

- reopen structural scope
- bypass the normalized semantic model
- treat runtime-global and feature-local failures as interchangeable
- introduce policy changes without semantic justification

## Scope

These decisions govern:

- current architecture interpretation
- ownership of runtime lifecycle
- interpretation of the new boundary model
- sequencing of later Phase 8 work
- what remains explicitly out of scope

## Root Cause Analysis

After Phase 7, the dominant unresolved concern was no longer structure.

After Phase 8.1, the dominant unresolved concern was no longer discovery of failure surfaces.

After Phase 8.2, the project now has an explicit semantic vocabulary for runtime and feature failure boundaries.

That changes the decision baseline:

future runtime hardening must now use the normalized model rather than work directly from raw flag combinations alone.

## Files Affected

These decisions directly govern interpretation of:

- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/ServiceProvider/failure_boundary_scope_model.dart`
- `lib/models/ServiceProvider/failure_recovery_expectation_model.dart`
- `lib/models/ServiceProvider/failure_boundary_state_model.dart`
- `lib/features/billing/controllers/billing_controller.dart`
- `lib/core/transport/geryonsocket_model.dart`
- `lib/core/transport/geryonsocket_model_io.dart`
- `lib/core/transport/geryonsocket_model_web.dart`
- `docs/phase8_runtime_reliability_failure_semantics_hardening.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_1_runtime_failure_surface_inventory.md`
- `docs/phase8_runtime_reliability_failure_semantics_hardening_8_2_failure_boundary_normalization.md`

## Implementation Characteristics

### Decision 1 — Phase 7 remains closed

No further `7.x` continuation is active.

Structural consolidation remains frozen.

### Decision 2 — Phase 8 remains a runtime-hardening phase

Phase 8 exists to harden runtime semantics and later runtime policy.

It does not exist to reopen architecture cleanup.

### Decision 3 — The active architecture remains unchanged

The active architecture remains:

- `presentation → controller → ServiceProvider`

This is a fixed baseline, not an open design question.

### Decision 4 — ServiceProvider remains the runtime owner

`ServiceProvider` remains the owner of:

- connection bootstrap
- authenticated runtime lifecycle
- startup/runtime continuation
- active operational client context

Phase 8 may clarify and harden this ownership.

It may not replace it.

### Decision 5 — The 8.2 boundary model is now the shared semantic baseline

The project now explicitly recognizes:

- `ServiceProviderFailureBoundaryScope`
- `ServiceProviderFailureRecoveryExpectation`
- `ServiceProviderFailureBoundaryState`

These models are now the shared language for interpreting runtime and feature failure boundaries.

### Decision 6 — Policy changes must follow semantics, not precede them

Retry / reboot / reconnect / reset behavior must not be changed first and explained later.

The semantic classification must come first.

That is why 8.2 precedes 8.3.

### Decision 7 — Billing is now an explicit example of boundary distinction

Billing now formally distinguishes between:

- authenticated-runtime invalidity
- active operational context invalidity
- feature-local load failure

This distinction is part of the current repository baseline.

### Decision 8 — Error-presentation heterogeneity is still evidence, not redesign permission

The current code still presents errors through different UI surfaces.

That remains evidence that semantics were historically distributed.

It is not, by itself, justification for a new global error framework.

### Decision 9 — Runtime-global and feature-local failures must not be merged implicitly

The following remain distinct categories:

- startup blocked state
- auth continuation required state
- transport disconnect state
- active client context invalidity
- feature-local request failure

Later work must preserve that distinction.

### Decision 10 — The active Phase 8 order remains explicit

The recommended order remains:

- `8.1 — Runtime Failure Surface Inventory`
- `8.2 — Failure Boundary Normalization`
- `8.3 — Retry / Reboot / Reconnect Policy Hardening`
- `8.4 — Runtime Diagnostic & Observability Signals`
- `8.5 — Formal Closure of Phase 8`

## Validation

These decisions are valid only if the current ZIP still confirms all of the following:

- Phase 7 is closed
- the architecture is stable
- the new failure-boundary model exists in code
- runtime policy has not yet been broadly redesigned
- Phase 8 remains focused on runtime hardening

The current ZIP confirms those conditions.

## Release Impact

These decisions have no direct user-facing impact.

They protect the interpretation of the repository and constrain later runtime-policy work so it remains narrow and justified.

## Risks

If these decisions are ignored, future work may:

- bypass the normalized semantic model
- overreact to local errors with global policy changes
- conflate active-client issues with transport issues
- reintroduce architecture drift under the label of reliability work

## What it does NOT solve

This decision record does not itself:

- change reconnect behavior
- change retry behavior
- change reboot behavior
- fix current hotspots such as `setCurrentCliente()`
- add observability signals

It only freezes the correct interpretation of the current baseline.

## Conclusion

The current project baseline is now:

- Phase 7 closed
- architecture frozen
- ServiceProvider retained as runtime owner
- Phase 8 active
- failure surfaces inventoried in 8.1
- failure boundaries normalized in 8.2

Future work must now continue under that explicit semantic baseline.
