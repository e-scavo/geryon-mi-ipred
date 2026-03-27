# 🧩 Phase 7 — Application Layer Consolidation

## Objective

Consolidate the application layer of Mi IP·RED by progressively separating presentation from business interaction logic, introducing explicit feature-local controller boundaries, and clarifying state ownership without altering the validated runtime contract of the application.

---

## Initial Context

After the structural normalization work completed in Phase 6, the project reached a state where the main runtime flows were stable but still carried important application-layer ambiguity.

The main issue was no longer directory structure.

The main issue was responsibility placement.

Widgets in the main runtime surfaces still owned too much business-adjacent logic and too much coordination behavior.

Phase 7 was opened to address that safely and incrementally.

Phase 7.1 completed the first extraction pass:

- auth extraction
- dashboard extraction
- billing extraction

That work introduced feature-local controllers and successfully removed inline request orchestration from the main presentation surfaces.

Once that extraction completed, a second architectural layer became visible:

- state ownership was still partially implicit
- some widgets still owned feature lifecycle state
- some derived state was still resolved ad hoc from `ServiceProvider`
- startup/auth initial flow boundaries were still not explicit enough

That led to the opening of Phase 7.2.

---

## Problem Statement

Phase 7.1 solved the first boundary problem:

- request orchestration should not remain inline in widgets

But it did not yet solve the second boundary problem:

- widgets should not continue to own feature functional state when that state is not truly UI state

The codebase still showed different forms of ownership ambiguity:

- local widget state acting as feature lifecycle state
- derived state resolved directly from `ServiceProvider` without explicit normalization
- manual coordination spread across widget listeners and `setState`
- initial startup/auth state split across runtime surfaces

Without clarifying those boundaries, future application-layer work would become riskier and less coherent.

---

## Scope

### Included

- feature-local controller introduction
- progressive logic extraction from widgets
- preservation of the current runtime contract
- state ownership inventory
- billing state-boundary consolidation
- dashboard state-derivation normalization
- auth/startup initial-boundary cleanup
- formal closure of Phase 7.2
- documentation alignment with real runtime structure

### Excluded

- backend protocol changes
- ServiceProvider redesign
- navigation redesign
- UI redesign
- global application service layer introduction
- full state-management migration
- broad Riverpod architecture replacement

---

## Root Cause Analysis

Mi IP·RED evolved under practical runtime priorities.

That sequence was correct:

1. stabilize backend/runtime behavior
2. protect ServiceProvider
3. normalize structure
4. extract request orchestration
5. only then normalize state ownership

This means Phase 7.2 is not a correction of a previous mistake.

It is the next natural step revealed after Phase 7.1 succeeded.

The current debt is not that billing/auth/dashboard still contain too much request logic.

The current debt is that some runtime surfaces still contain too much coordination state and too many implicit ownership assumptions.

---

## Files Affected

### Core Phase 7 runtime areas

- `lib/features/auth/controllers/*`
- `lib/features/dashboard/controllers/*`
- `lib/features/billing/controllers/*`
- `lib/features/auth/presentation/*`
- `lib/features/dashboard/presentation/*`
- `lib/features/billing/presentation/*`
- `lib/main.dart`

### Phase 7 documentation

- `docs/index.md`
- `docs/development.md`
- `docs/decisions.md`
- `docs/phase7_application_layer_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_1_1_auth_extraction.md`
- `docs/phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md`
- `docs/phase7_application_layer_consolidation_7_1_3_billing_extraction.md`
- `docs/phase7_application_layer_consolidation_7_2_1_feature_state_inventory.md`
- `docs/phase7_application_layer_consolidation_7_2_2_billing_state_boundary_consolidation.md`
- `docs/phase7_application_layer_consolidation_7_2_3_dashboard_state_derivation_normalization.md`
- `docs/phase7_application_layer_consolidation_7_2_4_auth_startup_initial_state_boundary_cleanup.md`
- `docs/phase7_application_layer_consolidation_7_2_5_formal_closure.md`

---

## Implementation Characteristics

### Phase 7.1 — UI / Logic Decoupling

Phase 7.1 extracted business-adjacent logic from the main widgets into feature-local controllers.

Validated subphases:

- `7.1.1 — Auth extraction`
- `7.1.2 — Dashboard extraction`
- `7.1.3 — Billing extraction`

Result:

- widgets stopped owning inline request orchestration
- controllers became the application-layer boundary for feature logic
- runtime behavior remained stable

Formal status:

- Phase 7.1 completed and closed

---

### Phase 7.2 — State Coordination Boundaries

Phase 7.2 starts only after Phase 7.1 has been validated.

Its goal is not to redesign state management globally.

Its goal is to clarify ownership boundaries:

- UI state
- feature functional state
- derived state
- global source state

Validated subphase structure:

- `7.2.1 — Feature State Inventory & Ownership Definition`
- `7.2.2 — Billing State Boundary Consolidation`
- `7.2.3 — Dashboard State Derivation Normalization`
- `7.2.4 — Auth & Startup Initial State Boundary Cleanup`
- `7.2.5 — Formal Closure of Phase 7.2`

Formal status:

- Phase 7.2 completed and closed

---

### Phase 7.2.1 — Feature State Inventory & Ownership Definition

This subphase documented the real ownership baseline of the project after Phase 7.1 closure.

It confirmed that:

- billing was the strongest feature-state hotspot
- dashboard mainly required derived-state normalization
- auth still mixed UI state with initial functional coordination
- startup participated in the same initial boundary as auth

Result:

- Phase 7.2.1 completed
- billing was validated as the first implementation target of Phase 7.2

---

### Phase 7.2.2 — Billing State Boundary Consolidation

This subphase consolidated billing feature state into an explicit feature-local boundary.

Implemented characteristics:

- billing functional state is now grouped into `BillingFeatureState`
- billing transitions are now owned by `BillingController`
- client-tracking and reload decisions are now controller-owned
- `listenManual` remains temporarily in place as a low-risk runtime trigger
- `BillingWidget` now consumes a single aggregated feature state instead of managing dispersed lifecycle variables

Formal status:

- completed

---

### Phase 7.2.3 — Dashboard State Derivation Normalization

This subphase normalized dashboard state derivation without changing the current reactive source.

Implemented characteristics:

- an explicit `DashboardSourceState` now represents dashboard source input
- `DashboardResolvedState` now contains only dashboard-derived render-ready state
- dashboard derivation now follows a source-to-derived flow
- `DashboardPage` keeps the `ref.watch(...)` reactivity boundary
- `DashboardController` no longer resolves dashboard state directly from `WidgetRef`

Formal status:

- completed

---

### Phase 7.2.4 — Auth & Startup Initial State Boundary Cleanup

This subphase clarified the shared initial boundary between startup and auth.

Implemented characteristics:

- an explicit `LoginViewState` now represents auth feature state during initial entry and submit transitions
- bootstrap loading and manual submit loading are now distinct
- `LoginController` now owns auth-state construction and transition helpers
- `LoginPageWidget` now renders from a single aggregated auth feature state
- an explicit `AppStartupViewState` now represents startup initial-boundary completion in `main.dart`
- the existing startup trigger sequence remains in place

Formal status:

- completed

---

### Phase 7.2.5 — Formal Closure of Phase 7.2

This subphase closes Phase 7.2 at the architectural and documentary level.

Implemented characteristics:

- the practical outcome of the phase is now frozen
- the resolved ownership boundaries are now explicitly recorded
- the preserved transitional mechanisms are now explicitly documented as intentional
- the limits of the phase are now clearly stated
- the project now has a clean architectural handoff position for whatever phase follows next

Formal status:

- completed and closed

---

## Validation

### Phase 7.1 validation baseline

Previously validated:

- login flow
- login success/failure
- dashboard rendering
- customer switching
- billing rendering
- logout

### Phase 7.2 consolidated validation baseline

Phase 7.2 as a whole is considered complete once the following remain valid together:

- startup still completes correctly
- remembered DNI still hydrates correctly
- autologin still behaves correctly
- manual login still behaves correctly
- dashboard still renders the correct active customer
- customer switching still updates dependent content
- billing still loads and reloads correctly
- logout still behaves correctly

### Phase 7.2.5 validation target

This closure subphase introduces no runtime behavior.

Its validation target is therefore:

- documentation aligns with the real code
- resolved boundaries are described accurately
- no additional 7.2 code-level refactor is required to satisfy the phase objective

---

## Release Impact

Phase 7.2.5 does not change the product release surface.

It affects only project clarity, architectural handoff, and documentation alignment.

Release-relevant impact is indirect:

- lower future ambiguity
- clearer phase boundary
- safer handoff to future work

---

## Risks

### Risk if Phase 7.2 remains informally open

- later work may continue to be appended to the phase even when unrelated
- the phase objective may appear incomplete even though it has already been achieved
- preserved transitional mechanisms may be misread as accidental leftovers

### Risk inside 7.2.5

- overstating Phase 7.2 as if it had redesigned the full application architecture
- understating the deliberate conservative nature of the work

### Mitigation

- close the phase explicitly
- document preserved transitional mechanisms as intentional
- document what the phase does not solve

---

## What it does NOT solve

Phase 7 overall still does not solve:

- global application state unification
- full navigation ownership normalization
- complete startup flow redesign
- complete ServiceProvider replacement
- broad lifecycle redesign across all features

Phase 7.2 specifically does not solve:

- a global state-management migration
- a new provider/notifier architecture for the whole app
- full elimination of transitional mechanisms
- broad application-lifecycle centralization
- future product-level feature expansion

---

## Conclusion

Phase 7 remains coherent and intentionally incremental.

The project first normalized structure, then extracted request orchestration, then clarified ownership and derivation boundaries where they were still ambiguous, and has now formally closed that work.

With Phase 7.2.5, Phase 7.2 is now complete.

The resulting architectural baseline is:

- presentation remains focused on rendering and interaction
- controllers own feature-local orchestration, state construction, and derivation logic where applicable
- ServiceProvider remains the protected runtime source
- ownership boundaries are clearer without forcing a premature global redesign

Any subsequent phase should now start from this closed and documented baseline rather than extending Phase 7.2 further.