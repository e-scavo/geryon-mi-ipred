# Documentation Index

This folder contains the living technical documentation for **Mi IP·RED**.

---

## Core Documents

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

### Audit and Refactor Phases
- `phase1_audit.md`
- `phase2_structural_plan.md`
- `phase3_cleanup_hygene.md`
- `phase4_infra_normalization.md`
- `phase5_service_provider_decomposition.md`

---

## Current Phase

**Phase 5 — ServiceProvider internal decomposition completed**

Completed goals:
- reduce the internal responsibility concentration of `ServiceProvider`
- split high-risk logic into smaller helpers without changing runtime behavior
- preserve backend contract and current flows
- stabilize tracked request execution across the most sensitive runtime methods

---

## Current documented state

The repository now has explicit documentation for:

- current runtime architecture
- backend-centric flow constraints
- ServiceProvider decomposition strategy
- completed Phase 5 refactor results
- next-step guidance for later phases

---

## Recommended next focus

After Phase 5, the recommended direction is:

1. avoid further risky callback abstraction unless it provides immediate and verified value
2. move toward presentation- and feature-oriented cleanup
3. keep the backend contract frozen while improving maintainability around the runtime core
