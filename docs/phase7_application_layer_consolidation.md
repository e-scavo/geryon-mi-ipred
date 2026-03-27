# 🧩 Phase 7 — Application Layer Consolidation

## Objective

Consolidate the application layer of Mi IP·RED by progressively separating presentation from business-adjacent logic, introducing explicit feature-local controller boundaries, clarifying state ownership, and now documenting the real coordination flows that connect already-separated features without changing the validated runtime contract of the application.

## Initial Context

After the structural cleanup completed in Phase 6, Mi IP·RED reached a point where the runtime was already functional but still had important application-layer ambiguity.

The problem was no longer directory structure.

The problem was responsibility placement.

Widgets still owned too much orchestration, and some runtime behavior still depended on implicit boundaries.

Phase 7 was opened to solve that incrementally and safely.

Phase 7.1 introduced feature-local controllers and completed:

- auth extraction
- dashboard extraction
- billing extraction

After that, Phase 7.2 clarified state ownership and completed:

- feature state inventory
- billing state-boundary consolidation
- dashboard state-derivation normalization
- auth/startup initial-boundary cleanup
- formal closure

With that baseline complete, the next visible concern in the current ZIP is no longer internal feature-local ambiguity as the main problem.

The next visible concern is the coordination that exists between already-separated features.

## Problem Statement

Phase 7.1 solved the problem of business-adjacent logic living inline in widgets.

Phase 7.2 solved the problem of unclear ownership between UI state, feature state, derived state, and runtime source state.

But Phase 7.2 intentionally stopped before introducing a coordination layer.

That leaves the current codebase in a state where:

- feature-local boundaries are better defined
- state boundaries are better defined
- but application flows still span multiple runtime owners
- and cross-feature interaction is still only partially explicit

Without documenting those flows first, any future contract or coordinator would risk being artificial.

## Scope

Phase 7 includes:

- feature-local controller extraction
- progressive removal of business-adjacent logic from widgets
- state ownership clarification
- runtime-preserving normalization work
- explicit inventory of real application flows
- preparation for future coordination contracts

Phase 7 does not include:

- backend protocol changes
- ServiceProvider redesign
- navigation redesign
- UI redesign
- full state-management replacement
- broad new application service infrastructure during 7.3.1

## Root Cause Analysis

Mi IP·RED matured in the correct practical order:

1. stabilize runtime behavior
2. protect ServiceProvider and backend interaction
3. normalize project structure
4. extract feature-local logic
5. clarify state ownership
6. only then expose cross-feature coordination debt

This means Phase 7.3 is not a continuation of state cleanup.

It is the next natural layer that became visible only after the previous layers were completed successfully.

## Files Affected

Core runtime surfaces involved in Phase 7 include:

- `lib/main.dart`
- `lib/features/auth/**`
- `lib/features/dashboard/**`
- `lib/features/billing/**`
- `lib/models/ServiceProvider/**`
- `lib/core/session/**`

Phase 7 documentation includes:

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
- `docs/phase7_application_layer_consolidation_7_3_1_application_flow_inventory.md`

## Implementation Characteristics

### Phase 7.1 — Feature-Local Controller Extraction

Phase 7.1 introduced the first major application-layer cleanup by moving feature-local orchestration out of widgets.

Completed subphases:

- `7.1.1 — Auth extraction`
- `7.1.2 — Dashboard extraction`
- `7.1.3 — Billing extraction`

Result:

- widgets stopped owning inline request orchestration
- controllers became the feature-local boundary
- runtime behavior was preserved

Formal status:

- completed
- validated
- closed

### Phase 7.2 — State Ownership and Boundary Clarification

Phase 7.2 did not redesign state management globally.

Its role was to clarify responsibility boundaries.

Completed subphases:

- `7.2.1 — Feature State Inventory & Ownership Definition`
- `7.2.2 — Billing State Boundary Consolidation`
- `7.2.3 — Dashboard State Derivation Normalization`
- `7.2.4 — Auth & Startup Initial State Boundary Cleanup`
- `7.2.5 — Formal Closure of Phase 7.2`

Result:

- billing owns explicit feature-local lifecycle state
- dashboard uses explicit source-to-derived resolution
- auth and startup initial boundaries are no longer modeled with ambiguous loading semantics
- Phase 7.2 was formally closed

### Phase 7.3 — Application Flow & Feature Coordination

Phase 7.3 begins only after the closure of Phase 7.2.

Its focus is not another feature-local state cleanup pass.

Its focus is:

- coordination between already-separated features
- runtime transition ownership
- application-flow sequencing
- explicit documentation of dependencies that today remain distributed

Validated structure for Phase 7.3:

- `7.3.1 — Application Flow Inventory`
- `7.3.2 — Session & App Context Normalization`
- `7.3.3 — Feature Interaction Contracts`
- `7.3.4 — Application Coordinator (mínimo)`
- `7.3.5 — Formal Closure of Phase 7.3`

At the current project state, only `7.3.1` is active.

### Phase 7.3.1 — Application Flow Inventory

This subphase is intentionally documentary first.

Its goal is to inventory the real flows already present in code before any new coordination abstraction is introduced.

The inventory covers flows such as:

- startup bootstrap
- backend status to auth decision
- login popup and auto-submit path
- login success to authenticated runtime context
- dashboard consumption of authenticated runtime context
- client selection propagation
- billing reload after client change
- logout reset path

Its output is a validated explicit map of current ownership and downstream effects.

It does not introduce runtime changes.

## Validation

Phase 7 as a whole remains valid because the current ZIP still preserves:

- startup bootstrap behavior
- backend status initialization behavior
- login popup behavior
- dashboard rendering from runtime source
- billing reload behavior driven by active client changes
- logout reset behavior

Phase 7.3.1 specifically is valid because those flows are present in the current code and can be documented without inventing new architecture.

## Release Impact

Phase 7.3.1 has no release-facing runtime changes.

Its impact is architectural and documentary:

- it reduces ambiguity
- it prepares future coordination work safely
- it prevents premature abstraction

## Risks

The main current risks are:

- assuming that distributed coordination means no coordination exists
- introducing a coordinator too early
- overloading ServiceProvider with future app-flow responsibilities
- collapsing distinct runtime concepts into one vague state notion

## What it does NOT solve

At the current stage, Phase 7 does not yet solve:

- explicit interaction contract types
- session/app-context normalization
- minimal coordinator implementation
- flow-level automated tests

Those belong to later validated Phase 7.3 subphases.

## Conclusion

Phase 7 is now best understood in three layers:

1. extract feature-local logic
2. clarify state ownership boundaries
3. inventory and later normalize cross-feature coordination flows

The current ZIP confirms that Mi IP·RED is now entering the third layer through `7.3.1 — Application Flow Inventory`.