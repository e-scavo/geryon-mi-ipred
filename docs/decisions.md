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

For that reason, Phase 7.2 treats ownership as an explicit concern.

State must now be understood as one of:

- UI state
- feature functional state
- derived state
- global source state

---

## Decision 6 — Inventory Before Consolidation

Phase 7.2 begins with ownership inventory before implementation-heavy changes.

Reason:

- moving state without classification risks duplication and regression
- inventory makes later moves deliberate instead of intuitive

That is why `7.2.1` was required before `7.2.2`.

---

## Decision 7 — Billing Is the First Phase 7.2 Implementation Target

Billing was selected first because the real codebase showed it had the strongest concentration of:

- widget-owned feature lifecycle state
- manual coordination
- customer-change synchronization logic
- loading/error/data flags dispersed in presentation

This made billing the safest and highest-value first implementation target.

---

## Decision 8 — Billing Consolidation Must Remain Local and Incremental

Billing state-boundary work must not widen into a global state-management redesign.

Therefore, `7.2.2` deliberately does **not** introduce:

- a new global application layer
- a broad provider redesign
- a ServiceProvider replacement
- a billing-specific notifier architecture

Instead, it introduces a feature-local state object and keeps the current runtime trigger mechanism.

---

## Decision 9 — Preserve `listenManual` During Billing Consolidation

Although `listenManual` is part of the manual coordination story, removing it in `7.2.2` would widen risk unnecessarily.

Therefore, the decision for this subphase is:

- keep `listenManual`
- move the billing-specific decisions out of the widget callback
- preserve runtime ordering while improving ownership clarity

This is a deliberate transitional decision.

---

## Decision 10 — Billing Functional State Moves Behind a Single Boundary

Billing should no longer expose dispersed lifecycle variables directly in the widget.

The adopted solution is:

- aggregate billing functional state into `BillingFeatureState`
- let the controller own transition construction
- let the widget render from a single feature-state instance

This improves ownership without changing the backend/runtime contract.

---

## Decision 11 — Dashboard Derivation Must Be Normalized Without Replacing Reactivity

Dashboard did not show the same lifecycle-state problem as billing.

Its main debt was derivation ambiguity.

For that reason, the dashboard solution must:

- preserve `ref.watch(...)` in presentation
- avoid a new provider/notifier architecture
- clarify the source-to-derived boundary inside the feature

This keeps the change local and low-risk.

---

## Decision 12 — Dashboard Introduces an Explicit Source Snapshot

Dashboard derivation should no longer begin from `WidgetRef` directly.

The adopted solution is:

- create `DashboardSourceState`
- build it from the watched `ServiceProvider`
- derive `DashboardResolvedState` from that explicit source model

This makes the feature input explicit without changing the global source-of-truth.

---

## Decision 13 — `DashboardResolvedState` Must Contain Only Derived State

The resolved dashboard model should not mix global source state with feature-derived state.

Therefore, `DashboardResolvedState` now contains only render-ready derived values such as:

- active client
- active client index
- active client display name
- client options

This makes the resolved-state contract clearer and more truthful.

---

## Decision 14 — Auth Cleanup Must Still Include Startup Boundary Cleanup

The previous inventory remains valid:

- auth initial state and startup initial state form a shared boundary concern

Therefore, the later subphase remains:

- `7.2.4 — Auth & Startup Initial State Boundary Cleanup`

and not an auth-only cleanup.

---

## Decision 15 — No Global Application Service Layer During Phase 7.2

Even after billing consolidation and dashboard derivation cleanup, Phase 7.2 remains a boundary-clarification phase, not a platform redesign phase.

For that reason, no new global application service layer is introduced here.

---

## Decision 16 — Runtime Order Has Priority Over Refactor Elegance

In all Phase 7.2 work, preserving runtime order has higher priority than achieving the most abstract or elegant internal design.

This is especially important because:

- customer changes drive downstream reload behavior
- dashboard state affects visible UI immediately
- billing reacts to dashboard-driven customer selection

---

## Conclusion

The active architectural contract is now:

1. protect runtime
2. keep controllers feature-local
3. classify ownership explicitly
4. consolidate the strongest hotspot first
5. normalize dashboard source-to-derived boundaries next
6. preserve transitional mechanisms where needed
7. continue incrementally with auth/startup next

That is the decision chain currently governing Phase 7.2.