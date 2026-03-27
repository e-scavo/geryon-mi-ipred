# 📚 Documentation Index

## Objective

Provide a structured and accurate entry point to all technical documentation of Mi IP·RED, ensuring that every document reflects the real implementation state of the system, including historical evolution, structural decisions, and current architectural boundaries after Phase 6 completion.

---

## Initial Context

The documentation set evolved alongside the system through multiple phases.

At the end of Phase 5:

- backend communication flow was fully stabilized
- ServiceProvider behavior was documented and protected
- core application flows were working in production
- documentation covered infrastructure and internal decomposition

However:

- presentation layer structure was not aligned with documentation
- UI ownership boundaries were not clearly represented
- legacy paths were still treated as primary references
- structural duplication existed across models and pages

Phase 6 introduced a complete normalization of the presentation layer, requiring full documentation alignment and historical traceability.

---

## Documentation Philosophy

Documentation in Mi IP·RED follows these principles:

- reflects real code, not idealized architecture
- includes historical context and evolution
- explains decisions, not only results
- prioritizes clarity over brevity
- evolves together with the codebase
- preserves transitional states when relevant
- explicitly documents migration strategies and outcomes

---

## Core Documents

### Architecture

architecture.md

Describes the high-level system architecture, including:

- client-server interaction model
- WebSocket communication structure
- runtime responsibilities
- application boundaries

---

architecture-deep.md

Provides a detailed breakdown of:

- ServiceProvider internals
- request lifecycle
- message tracking system
- internal execution flow
- backend interaction guarantees

---

### Runtime and Product

flows.md

Documents the main runtime flows:

- login lifecycle
- dashboard loading
- customer selection
- billing access
- logout behavior

---

release.md

Describes release strategy:

- build targets
- packaging
- versioning
- deployment considerations

---

secutiry.md

Documents:

- authentication handling
- token usage
- storage considerations
- security constraints

Note: filename preserved as-is to match repository state.

---

### Engineering Governance

decisions.md

Defines all architectural and structural decisions, including:

- backend invariants
- presentation normalization strategy
- migration approach
- compatibility rules
- shim strategy and removal policy
- controller-introduction rules for Phase 7

---

development.md

Defines development rules and constraints:

- how to perform refactors
- what is allowed vs restricted
- validation requirements
- migration workflow
- post-Phase 6 architectural rules
- Phase 7 controller extraction rules

---

service-provider-decomposition.md

Describes the internal decomposition of ServiceProvider:

- responsibilities
- flow segmentation
- design constraints
- rationale behind current structure

---

## Phase Documents

### Phase 5

phase5_service_provider_decomposition.md

Covers:

- internal restructuring of ServiceProvider
- stabilization of backend interaction
- preparation for safe UI refactor
- definition of protected runtime boundaries

---

### Phase 6

phase6_presentation_structure_cleanup.md

Covers:

- normalization of presentation layer
- separation between shared and feature UI
- compatibility shim strategy
- canonical import introduction
- controlled migration order
- complete removal of legacy presentation paths

Includes:

- Phase 6.1 — Shared UI normalization
- Phase 6.2 — Feature presentation normalization
- Phase 6.2.1 — Controlled migration sequence
- Phase 6.2.2 — Import normalization
- Phase 6.2.3 — Documentation alignment
- Phase 6.3 — Legacy shim audit and removal

---

### Phase 7

phase7_application_layer_consolidation.md

Covers:

- application-layer consolidation strategy
- introduction of controller boundaries
- progressive UI / logic decoupling
- preparation for state and flow normalization
- risk-aware migration rules for behavioral extraction

phase7_application_layer_consolidation_7_1_1_auth_extraction.md

Covers:

- auth controller introduction
- autologin extraction
- login orchestration extraction
- remembered DNI persistence extraction
- first safe controller pattern for Phase 7

phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md

Covers:

- dashboard controller introduction
- active customer resolution extraction
- customer-switch orchestration extraction
- logout orchestration extraction
- AppBar-supporting application logic extraction

phase7_application_layer_consolidation_7_1_3_billing_extraction.md

Covers:

- billing controller introduction
- data-model preparation extraction
- billing request orchestration extraction
- typed response validation extraction
- table-row normalization extraction
- refresh orchestration support for customer changes

---

## Current System State

After Phase 7.1.3:

- presentation layer remains normalized
- shared UI remains isolated under lib/shared
- feature UI remains isolated under lib/features
- canonical paths remain the only active paths
- auth logic no longer performs application coordination directly inside the widget
- dashboard logic no longer performs customer/session coordination directly inside the widget
- billing logic no longer performs request orchestration directly inside the widget
- controller boundaries now exist for auth, dashboard, and billing
- Phase 7.1 is functionally complete pending final validation and closure decision

The repository structure now reflects both ownership boundaries and the first behavioral extraction layer.

---

## Removed Transitional Elements

The following elements no longer exist after Phase 6.3:

- export-based compatibility shims
- legacy presentation paths under lib/models and lib/pages
- duplicated UI access paths
- fallback import surfaces

All transitional structures introduced during Phase 6 migration have been fully removed.

---

## What Documentation Does NOT Cover Yet

At this stage, documentation does not yet include:

- domain layer separation
- application service layer
- session persistence redesign
- advanced state management architecture
- flow ownership redesign beyond the current widget/controller split

These will be addressed in upcoming phases.

---

## Next Documentation Evolution

The next expected updates will correspond to one of these two paths:

Phase 7.1 closure

- final cross-feature consistency review
- removal or consolidation of any residual duplicated Phase 7.1 documentation surface if required
- formal closure of UI / Logic Decoupling

---

Phase 7.2

- state coordination boundaries
- clarification of widget-local state vs application state
- preparation for more explicit feature-owned state

---

## Conclusion

The documentation set is aligned with the real structure of the system after Phase 7.1.3.

It provides:

- complete historical traceability
- explicit architectural decisions
- clear ownership boundaries
- explicit subphase progression
- a stable base for controlled continuation of Phase 7