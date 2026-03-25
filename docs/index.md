# 📚 Documentation Index

## Objective

Provide a structured and accurate entry point to all technical documentation of Mi IP·RED, ensuring that every document reflects the real implementation state of the system, including historical evolution, structural decisions, and current architectural boundaries after Phase 6.

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

Phase 6 introduced structural normalization that required documentation alignment.

---

## Documentation Philosophy

Documentation in Mi IP·RED follows these principles:

- reflects real code, not idealized architecture
- includes historical context and evolution
- explains decisions, not only results
- prioritizes clarity over brevity
- evolves together with the codebase

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

---

development.md

Defines development rules and constraints:

- how to perform refactors
- what is allowed vs restricted
- validation requirements
- migration workflow

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

---

### Phase 6

phase6_presentation_structure_cleanup.md

Covers:

- normalization of presentation layer
- separation between shared and feature UI
- compatibility shim strategy
- canonical import introduction
- migration order and rationale

Includes:

- Phase 6.1 — Shared UI normalization
- Phase 6.2 — Feature presentation normalization
- Phase 6.2.1 — Controlled migration sequence
- Phase 6.2.2 — Import normalization
- Phase 6.2.3 — Documentation alignment

---

## Current System State

After Phase 6:

- presentation layer is structurally normalized
- shared UI is isolated under lib/shared
- feature UI is isolated under lib/features
- canonical paths are established
- imports reflect ownership
- legacy paths exist only as compatibility shims

---

## Known Transitional Elements

The system still contains transitional elements:

- export-based shims in legacy paths
- residual legacy imports (expected to decrease)
- duplicated access paths (temporary)

These are intentional and controlled.

---

## What Documentation Does NOT Cover Yet

At this stage, documentation does not yet include:

- domain layer separation
- application service layer
- session persistence redesign
- advanced state management architecture

These will be addressed in future phases.

---

## Next Documentation Evolution

The next expected updates will correspond to:

Phase 6.3

- legacy shim audit
- identification of unused compatibility layers
- safe removal strategy

---

Phase 7

- domain model organization
- separation of business logic from presentation
- introduction of domain boundaries

---

Phase 8

- session and configuration hardening
- persistence improvements
- user experience stability enhancements

---

## Conclusion

The documentation set is now aligned with the real structure of the system.

It provides:

- historical traceability
- structural clarity
- explicit ownership boundaries
- safe foundation for future evolution

Documentation must continue evolving together with the system, preserving both technical accuracy and architectural intent.