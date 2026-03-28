# 🛠️ Development Guidelines

## Objective

Define the active implementation rules for Mi IP·RED so that future work preserves runtime stability, respects the current architecture validated in code, and evolves the startup/auth continuation boundary incrementally without reopening already-closed earlier phases.

## Initial Context

Mi IP·RED is an already working production application.

Its current codebase has already completed:

- structural cleanup
- ServiceProvider decomposition and protection
- presentation-layer normalization
- feature-local controller extraction
- state ownership clarification
- application-flow inventory
- session and app-context normalization
- feature interaction contract freezing
- minimal coordination anchoring
- formal closure of Phase 7.3

The current ZIP now opens a narrower next concern:

- startup/auth continuation boundary hardening

The first step of that phase is documentary and inventory-based.

## Problem Statement

Without updated development rules, future work could accidentally:

- reopen Phase 7.3
- treat startup/auth as a reason for broad coordinator expansion
- push more runtime orchestration into ServiceProvider
- redesign a working flow instead of hardening its boundary
- confuse persisted login hint with authenticated session semantics
- replace explicit controller boundaries with ad hoc widget logic

These guidelines freeze the correct reading of the current ZIP.

## Scope

These guidelines apply to:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/features/contracts/**`
- `lib/models/ServiceProvider/**`
- `lib/models/GeneralLoadingProgress/**`
- `lib/core/session/**`
- Phase 7 documentation

These guidelines do not authorize by themselves:

- backend protocol changes
- ServiceProvider redesign
- navigation redesign
- UI redesign
- broad coordinator introduction
- state-management replacement

## Root Cause Analysis

The current codebase no longer has a generic coordination problem.

That was already handled and closed in 7.3.

The remaining issue is narrower:

- the startup/auth continuation bridge still depends on distributed implicit semantics

That means the correct next implementation style is not broad redesign.

It is conservative semantic hardening.

## Files Affected

The rules in this document govern work touching:

- `lib/main.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/models/GeneralLoadingProgress/model.dart`
- `lib/models/ServiceProvider/data_model.dart`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_4_1_startup_auth_continuation_inventory.md`

## Implementation Characteristics

### Rule 1 — Preserve `presentation → controller → ServiceProvider`

The active architecture remains:

- presentation
- controller
- ServiceProvider

Do not move feature logic back into widgets.

Do not use Phase 7.4 as an excuse to collapse layers.

### Rule 2 — ServiceProvider remains the runtime source of authenticated context

`ServiceProvider` remains the owner of:

- backend/runtime state
- authenticated runtime context
- active client/company context

Future work may clarify how auth requirement is expressed.

Future work must not transfer runtime-source ownership away from ServiceProvider unless a later explicit phase authorizes that.

### Rule 3 — Startup boundary remains explicit and local

`main.dart` remains the owner of startup boundary completion state.

Future work may normalize how startup learns that auth continuation resolved.

Future work must not hide startup completion behind broader implicit state.

### Rule 4 — Auth requirement must become explicit before any coordinator expansion is considered

The current ZIP shows that auth requirement meaning is still represented implicitly through special provider return codes.

Therefore, the next safe step is semantic normalization of auth requirement itself.

Do not jump directly to a startup/auth coordinator unless the normalized boundary still proves that one is truly necessary.

### Rule 5 — Login UI remains feature-local

The auth feature continues owning:

- login bootstrap view state
- remember-me UI state
- login submit interaction
- local failure presentation

Do not push feature-local login UI logic back into `main.dart` or into loading popup code.

### Rule 6 — Persisted DNI/CUIT remains a login hint, not a session

Stored DNI/CUIT is still only:

- a remembered input hint
- a possible auto-submit bootstrap input

It is not a backend-authenticated persistent session.

Do not model it as one.

### Rule 7 — Runtime continuation must be clarified without changing behavior first

The current runtime already works.

So Phase 7.4 work must follow this order:

1. inventory current flow
2. normalize auth requirement meaning
3. define continuation contract
4. only then evaluate whether any minimal startup/auth coordinator is still justified

### Rule 8 — Logout reentry must be treated as part of the same boundary family

Logout currently reenters backend/auth requirement flow through ServiceProvider.

Future work must account for both:

- initial startup entry
- runtime reentry after logout

Do not harden only one path while ignoring the other.

### Rule 9 — Avoid magic semantics in new work

The current ZIP already shows magic-code meaning around auth requirement.

Do not add more hidden semantics of the same kind.

Any new boundary normalization must prefer explicit models or explicit local meaning over additional special-case codes.

### Rule 10 — No broad redesign under the label of cleanup

Phase 7.4 is a hardening phase.

It is not a redesign phase.

Do not introduce:

- event bus
- global application services
- full startup/auth runtime engine
- broad reactive coordinator
- navigation overhaul

unless a later explicit phase and validated code evidence justify it.

## Validation

Any proposed change during Phase 7.4 must validate all of the following:

- startup still reaches dashboard correctly
- loading popup still behaves correctly
- remembered DNI bootstrap still works
- auto-submit still works when expected
- manual login still works
- logout still returns to unauthenticated flow safely
- ServiceProvider still owns runtime context
- no regression is introduced in backend communication flow

## Release Impact

This document has no direct user-facing impact.

Its purpose is to preserve a safe implementation style for the newly opened Phase 7.4 work.

## Risks

Without these rules, future work may:

- overcorrect a working flow
- redesign ServiceProvider too early
- spread auth logic across even more surfaces
- introduce unstable new coordination infrastructure

## What it does NOT solve

This document does not by itself:

- normalize auth requirement semantics
- introduce continuation contracts
- change popup ownership
- change runtime behavior

It only defines the correct implementation discipline for the next steps.

## Conclusion

The active development baseline is now:

- Phases 6, 7.1, 7.2, and 7.3 completed and closed
- Phase 7.4 opened narrowly around startup/auth continuation boundary hardening

The next safe implementation target remains:

- `7.4.2 — Auth Requirement Boundary Normalization`