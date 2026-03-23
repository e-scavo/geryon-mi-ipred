# 📚 Documentation Index

This folder contains the living technical documentation for **Mi IP·RED**.

---

## 🧭 Core Documents

### Architecture
- `architecture.md`
  - high-level architecture overview
- `architecture-deep.md`
  - detailed architectural breakdown by runtime layer and technical responsibility

### Runtime and Product
- `flows.md`
  - key runtime and business flows
- `features.md`
  - current functional inventory
- `release.md`
  - current release/target status
- `security.md`
  - security observations and repository handling notes

### Engineering Governance
- `decisions.md`
  - architectural decisions and constraints
- `development.md`
  - development notes and working conventions
- `module-inventory.md`
  - inventory of the main modules and their current role
- `target-structure.md`
  - proposed target project structure for staged refactor
- `refactor-plan.md`
  - staged refactor roadmap
- `legacy.md`
  - legacy, superseded, disabled, and quarantine candidate inventory
- `cleanup-checklist.md`
  - operational checklist for low-risk cleanup and repository hygiene

### Audit Phases
- `phase1_audit.md`
  - initial technical audit of the current codebase
- `phase2_structural_plan.md`
  - structural planning, refactor boundaries, and cleanup candidates
- `phase3_cleanup_hygiene.md`
  - repository hygiene phase and low-risk cleanup plan

---

## 🧩 Documentation Policy

This documentation exists to make the project portable between conversations and development sessions.

Each major step should be reflected in a new phase document, for example:

- `phase4_infra_normalization.md`
- `phase5_service_provider_decomposition.md`
- `phase6_feature_reorganization.md`

---

## 🚦 Current Phase

**Phase 3 — Low-risk cleanup and repository hygiene**

Goals:
- identify safe cleanup actions
- classify legacy and disabled files
- define quarantine strategy
- prepare the repository for structural refactor without changing runtime behavior