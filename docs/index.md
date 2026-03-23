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
- `security.md`

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
- `phase3_cleanup_hygiene.md`
- `phase4_infra_normalization.md`
- `phase5_service_provider_decomposition.md`

---

## 🚦 Current Phase

**Phase 5 — ServiceProvider internal decomposition**

Goals:
- reduce the internal responsibility concentration of `ServiceProvider`
- split logic by responsibility without changing runtime behavior
- preserve backend contract and current flows
- prepare the codebase for later feature-first cleanup