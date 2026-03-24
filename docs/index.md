# 📚 Documentation Index

This folder contains the living technical documentation for **Mi IP·RED**.

---

## 🧭 Core Documents

### Architecture
- `architecture.md`
- `architecture-deep.md`

### Runtime and Product
- `flows.md`
- `features.md`
- `release.md`
- `secutiry.md`

### Engineering Governance
- `decisions.md`
- `development.md`
- `module-inventory.md`
- `target-structure.md`
- `refactor-plan.md`
- `legacy.md`
- `cleanup-checklist.md`
- `infra-normalization.md`
- `service-provider-decomposition.md`

### Audit Phases
- `phase1_audit.md`
- `phase2_structural_plan.md`
- `phase3_cleanup_hygene.md`
- `phase4_infra_normalization.md`
- `phase5_service_provider_decomposition.md`
- `phase6_presentation_structure_cleanup.md`

---

## 🚦 Current Phase

**Phase 6 — Presentation structure cleanup**

Current active substep:

- **Phase 6.1 — Canonical shared UI paths with compatibility shims**

Goals:
- normalize the presentation-layer structure without changing runtime behavior
- separate feature screens from shared visual widgets
- introduce canonical UI paths while preserving compatibility during migration
- avoid touching backend protocol, handshake flow, and tracked request semantics
- prepare the codebase for later feature-first organization