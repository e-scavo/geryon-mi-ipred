# 🧠 Decisions — Phase 7 Alignment

## Decision 1 — Preserve Backend Flow as Immutable Constraint

The backend communication model remains the highest-priority invariant of the system.

This includes:

- handshake lifecycle
- token negotiation
- message structure
- tracked request flow
- request/response timing assumptions

All Phase 7 work must preserve these behaviors.

---

## Decision 2 — Structural and Application-Layer Work Must Not Imply Behavioral Change

Mi IP·RED is already functional.

Therefore, refactors in Phase 7 must not silently alter runtime semantics.

This rule applies to:

- controller extraction
- state-boundary work
- derived-state normalization
- startup/auth boundary cleanup
- formal closure work

---

## Decision 3 — Shared UI and Feature UI Remain Separate

The Phase 6 boundary remains valid.

Shared UI belongs under shared areas.

Feature UI belongs under feature presentation areas.

Phase 7 builds on top of that structure and must not collapse it.

---

## Decision 4 — Controllers Are Feature-Local Boundaries

Phase 7.1 introduced controllers to stop widgets from owning business-adjacent orchestration.

That decision remains active.

Controllers are the correct location for:

- feature-local orchestration
- feature-local state transitions
- feature-local derived-state rules

---

## Decision 5 — State Ownership Must Be Explicit After Phase 7.1

Once request orchestration is extracted, ownership ambiguity becomes the next architectural problem.

For that reason, Phase 7.2 treated ownership as an explicit concern.

State must now be understood as one of:

- UI state
- feature functional state
- derived state
- global source state

This remains an active rule after closure.

---

## Decision 6 — Inventory Before Consolidation

Phase 7.2 began with ownership inventory before implementation-heavy changes.

Reason:

- moving state without classification risks duplication and regression
- inventory makes later moves deliberate instead of intuitive

That is why `7.2.1` was required before the implementation-focused subphases.

---

## Decision 7 — Billing Was the First Phase 7.2 Implementation Target

Billing was selected first because the real codebase showed it had the strongest concentration of:

- widget-owned feature lifecycle state
- manual coordination
- customer-change synchronization logic
- loading/error/data flags dispersed in presentation

This made billing the safest and highest-value first implementation target.

---

## Decision 8 — Billing Consolidation Remains Local and Incremental

Billing state-boundary work was intentionally kept local.

Phase 7.2 did **not** introduce:

- a new global application layer
- a broad provider redesign
- a ServiceProvider replacement
- a billing-specific notifier architecture

Instead, it introduced a feature-local state object and kept the current runtime trigger mechanism.

That remains the correct interpretation of the billing result.

---

## Decision 9 — Preserved Transitional Mechanisms Are Intentional

Some mechanisms remained in place after Phase 7.2 on purpose, not by accident.

Examples include:

- `listenManual` in billing
- `ref.watch(...)` as the dashboard reactive boundary
- the existing startup trigger sequence in `main.dart`
- `ServiceProvider` as the protected global runtime source

These should not be documented or interpreted as unresolved mistakes by default.

They are conservative compatibility decisions aligned with the runtime-protection rule.

---

## Decision 10 — Dashboard Derivation Was Normalized Without Replacing Reactivity

Dashboard did not show the same lifecycle-state problem as billing.

Its main debt was derivation ambiguity.

For that reason, the adopted solution was to:

- preserve `ref.watch(...)` in presentation
- avoid a new provider/notifier architecture
- clarify the source-to-derived boundary inside the feature

This remains the correct dashboard boundary contract after closure.

---

## Decision 11 — Dashboard Uses an Explicit Source Snapshot and a Truly Derived Resolved State

Dashboard derivation no longer begins from `WidgetRef` directly.

The adopted solution is:

- create `DashboardSourceState`
- build it from the watched `ServiceProvider`
- derive `DashboardResolvedState` from that explicit source model

`DashboardResolvedState` should remain derived and render-ready rather than mixing source state back in casually.

---

## Decision 12 — Auth Cleanup Includes Startup Boundary Cleanup

The inventory proved that auth initial state and startup initial state formed a shared boundary concern.

Therefore, the adopted subphase remained:

- `7.2.4 — Auth & Startup Initial State Boundary Cleanup`

and not an auth-only cleanup.

That remains the correct interpretation of the phase result.

---

## Decision 13 — Auth Initial Boundary Distinguishes Bootstrap From Submit

The login feature should no longer rely on a single ambiguous loading flag for both:

- bootstrap autologin loading
- manual submit loading

The adopted solution is:

- introduce `LoginViewState`
- separate `isBootstrapLoading` from `isSubmitLoading`
- let the controller own those transitions

This remains the active auth boundary contract after closure.

---

## Decision 14 — Startup Boundary Is Explicit Without Redesigning Startup Flow

The startup surface should no longer rely only on a generic local boolean as its state representation.

The adopted solution is:

- introduce `AppStartupViewState`
- make initial-boundary completion explicit
- preserve the existing trigger sequence and popup flow

This remains the correct conservative interpretation of the startup result.

---

## Decision 15 — No Global Application Service Layer Was Introduced During Phase 7.2

Even after billing consolidation, dashboard derivation cleanup, and auth/startup boundary cleanup, Phase 7.2 remained a boundary-clarification phase, not a platform redesign phase.

For that reason, no new global application service layer was introduced.

This is not an omission.

It is a scope decision.

---

## Decision 16 — Runtime Order Has Priority Over Refactor Elegance

In all Phase 7.2 work, preserving runtime order had higher priority than achieving the most abstract or elegant internal design.

This was especially important because:

- customer changes drive downstream reload behavior
- dashboard state affects visible UI immediately
- billing reacts to dashboard-driven customer selection
- startup/auth sequence affects the entire app entry behavior

This remains the governing principle for interpreting Phase 7.2 outcomes.

---

## Decision 17 — Phase 7.2 Is Now Formally Closed

The current ZIP state shows that the practical objective of Phase 7.2 has already been achieved.

Therefore, the project now adopts this explicit closure decision:

- Phase 7.2 is complete
- its outcomes are frozen as the current architectural baseline
- future work should start from this baseline rather than continuing to extend the phase artificially

---

## Conclusion

The active architectural contract is now:

1. protect runtime
2. keep controllers feature-local
3. classify ownership explicitly
4. keep preserved transitional mechanisms only when deliberately justified
5. use the completed Phase 7.2 boundaries as the new baseline
6. do not reopen closed cleanup work without real code-backed justification

That is the decision chain governing the post-Phase-7.2 state of Mi IP·RED.