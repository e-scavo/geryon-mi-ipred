# 📚 Documentation Index

## Objective

Provide a structured and accurate entry point to all technical documentation of Mi IP·RED, ensuring that every document reflects the real implementation state of the system, including historical evolution, structural decisions, and current architectural boundaries after Phase 7.2.1 inventory kickoff.

---

## Initial Context

The documentation set evolved alongside the system through multiple phases.

At the end of Phase 5:

- backend communication flow was fully stabilized
- ServiceProvider behavior was documented and protected
- core application flows were working in production
- documentation covered infrastructure and internal decomposition

Phase 6 then introduced full presentation normalization.

Phase 7.1 subsequently introduced the first application-layer consolidation work, extracting business-adjacent logic from the main presentation surfaces into feature-local controllers.

Phase 7.2 has now started with an ownership-definition step that documents real state boundaries before any runtime-facing consolidation is performed.

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
- ownership-definition rules for Phase 7.2

---

development.md

Defines development rules and constraints:

- how to perform refactors
- what is allowed vs restricted
- validation requirements
- migration workflow
- post-Phase 6 architectural rules
- Phase 7 controller extraction rules
- Phase 7.2 state-boundary rules

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

- Phase 6.1 shared UI normalization
- Phase 6.2 feature UI normalization
- Phase 6.3 formal closure and cleanup

---

### Phase 7

phase7_application_layer_consolidation.md

Covers:

- introduction of feature-local controllers
- application-layer consolidation strategy
- formal closure of Phase 7.1
- Phase 7.2 scope and validated subphase structure
- state coordination boundaries
- startup/auth initial boundary scope clarification

---

phase7_application_layer_consolidation_7_1_ui_logic_decoupling.md

Historical umbrella document for the original Phase 7.1 intent.

Kept for historical continuity after the formal split and closure into implementation subphases.

---

phase7_application_layer_consolidation_7_1_1_auth_extraction.md

Documents:

- auth controller introduction
- login flow extraction
- initial auth widget cleanup baseline
- preserved runtime contract for login flow

---

phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md

Documents:

- dashboard controller introduction
- customer selection extraction
- logout delegation extraction
- dashboard rendering-state preparation baseline

---

phase7_application_layer_consolidation_7_1_3_billing_extraction.md

Documents:

- billing controller introduction
- billing request preparation extraction
- billing response normalization extraction
- preserved widget rendering compatibility

---

phase7_application_layer_consolidation_7_2_1_feature_state_inventory.md

Documents:

- real state ownership inventory after Phase 7.1 closure
- separation of UI state vs feature functional state
- derived state mapping
- global source state mapping
- manual coordination hotspots
- validated priority order for the remaining Phase 7.2 subphases

---

## Structural and Historical Documents

module-inventory.md

High-level inventory of modules and ownership zones across the project.

---

target-structure.md

Describes the intended structural organization of the project.

---

legacy.md

Tracks historical paths, compatibility artifacts, and legacy structure references.

---

cleanup-checklist.md

Tracks cleanup-oriented tasks and normalization checkpoints.

---

infra-normalization.md

Documents infrastructure-related normalization work and its architectural implications.

---

refactor-plan.md

Historical refactor planning document preserved for continuity.

---

features.md

Feature-oriented documentation index and context.

---

## Recommended Reading Order

### For onboarding

1. README.md
2. docs/index.md
3. docs/architecture.md
4. docs/flows.md
5. docs/development.md
6. docs/decisions.md

---

### For understanding ServiceProvider and runtime constraints

1. docs/architecture-deep.md
2. docs/service-provider-decomposition.md
3. docs/phase5_service_provider_decomposition.md

---

### For understanding current UI/application architecture

1. docs/phase6_presentation_structure_cleanup.md
2. docs/phase7_application_layer_consolidation.md
3. docs/phase7_application_layer_consolidation_7_1_1_auth_extraction.md
4. docs/phase7_application_layer_consolidation_7_1_2_dashboard_extraction.md
5. docs/phase7_application_layer_consolidation_7_1_3_billing_extraction.md
6. docs/phase7_application_layer_consolidation_7_2_1_feature_state_inventory.md

---

## Current Documentation Status

Current status of the codebase reflected by documentation:

- Phase 1 completed
- Phase 2 completed
- Phase 3 completed
- Phase 4 completed
- Phase 5 completed
- Phase 6 completed
- Phase 7.1 completed and formally closed
- Phase 7.2 started
- Phase 7.2.1 documented as the ownership-definition baseline
- next safe implementation target identified as Phase 7.2.2

---

## Conclusion

The documentation set is aligned with the real project state reflected in the current ZIP.

At this point:

- presentation normalization is complete
- controller extraction baseline is complete
- state-boundary work has formally started
- the project now has an explicit ownership inventory to guide safe continuation of Phase 7.2