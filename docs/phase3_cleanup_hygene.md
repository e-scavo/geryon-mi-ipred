# 🧼 Phase 3 — Low-Risk Cleanup and Repository Hygiene

## 🎯 Phase Goal

Prepare Mi IP·RED for deeper refactor by cleaning the repository in a **safe and reversible** way.

This phase is intentionally conservative.

It does **not** change:
- backend protocol behavior
- login behavior
- billing behavior
- app navigation flow
- runtime architecture

Instead, it establishes a safe process for removing confusion from the repository.

---

## ✅ What Phase 3 Adds

This phase contributes:

- a formal legacy inventory
- an operational cleanup checklist
- classification of dead, disabled, and experimental files
- a safe quarantine strategy
- explicit boundaries for what must not be touched yet

---

## 🧠 Core Conclusion

The repository can be improved immediately without touching critical runtime behavior.

The strongest current opportunities are:

1. obvious legacy file cleanup
2. disabled feature quarantine
3. removal of noisy historical leftovers
4. clearer repository hygiene rules

This creates a cleaner base for future infrastructure normalization and `ServiceProvider` decomposition.

---

## 🗂️ Legacy and Cleanup Findings

### Confirmed low-risk legacy candidates
These appear to be the safest initial cleanup targets:

- `lib/models/GeryonSocket/model2.dart`
- `lib/models/SessionStorage/session_storage_old.dart`
- `lib/models/ServiceProvider/login_data_user_message_model_old.dart`
- `lib/utils/utils_old.dart`
- `lib/services/websocket_service.dart`

These files showed no active import hits in the repository audit and appear superseded by current runtime implementations.

---

### Likely legacy commented transport file
- `lib/models/GeryonSocket/model.dart`

This file appears to contain commented legacy transport code and is strongly likely to be removable or quarantinable after one final working-tree validation.

---

### Disabled but still present files
- `lib/models/ServiceProviderConfig/widget.dart`
- `lib/models/ServiceProviderConfig/popup_widget.dart`

These files are important because they create structural noise even if they are not part of the real active user experience.

They should be treated as **disabled feature remnants**, not as active product functionality.

---

### Experimental/demo file
- `lib/models/_pruebas/them1.dart`

This file appears to be a local UI demo/prototype.  
It should not remain mixed into the production hierarchy long-term.

---

## 🛡️ What Must Remain Untouched in Phase 3

These areas are explicitly out of scope for this phase:

- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/GeryonSocket/geryonsocket_model.dart`
- `lib/models/GeryonSocket/geryonsocket_model_web.dart`
- `lib/models/GeryonSocket/geryonsocket_model_io.dart`
- `lib/pages/Billing/widget.dart`
- `lib/pages/dashboard_page.dart`
- backend message contracts
- login payloads
- handshake logic
- `messageID` tracking

This is critical because repository hygiene must not accidentally become backend refactor.

---

## 🧭 Recommended Execution Strategy

### Step 1 — Document before deleting
Before any cleanup:
- update docs
- classify files
- create a cleanup branch

### Step 2 — Quarantine uncertain files
If confidence is high but not absolute:
- move files to `lib/_legacy/`
- keep history readable
- avoid hard deletion first

### Step 3 — Validate after each small step
After each cleanup:
- analyze
- build
- run Web
- run Android
- test login
- test dashboard
- test billing

### Step 4 — Commit in small units
Do not combine:
- cleanup
- folder restructuring
- provider refactor
- UI changes

in the same commit.

---

## 📦 Suggested Quarantine Layout

A temporary quarantine layout may look like this:

```text
lib/_legacy/
  geryonsocket/
  session_storage/
  service_provider/
  experiments/
  disabled_config_ui/
```

This is not the final architecture.

It is a safety mechanism for cleanup.

---

## ⚠️ Risks Observed

### Low risk
- removing files with zero active imports and clearly superseded purpose

### Medium risk
- removing files that still have textual references but may only be referenced in comments or disabled code

### High risk
- touching active transport files
- touching `ServiceProvider`
- touching any file involved in handshake, login, or tracked backend responses

---

## ✅ Phase 3 Decision

The repository is ready for a **cleanup-first, behavior-safe** pass.

This should happen before:
- infrastructure folder normalization
- orchestration decomposition
- feature folder reorganization

That ordering reduces confusion and makes future diffs more understandable.

---

## 📌 Recommended Next Phase

> **Phase 4 — Infrastructure normalization**

Targets:
- config loader
- session storage
- file saver
- WebSocket transport structure

Phase 4 should still preserve behavior, but it can begin improving folder clarity and internal organization in low-risk infrastructure areas.

---

## ✅ Phase 3 Exit Criteria

Phase 3 is complete when:

- legacy candidates are documented
- cleanup strategy is explicit
- repository hygiene rules are defined
- cleanup can be performed in small safe commits
- the project is ready for infrastructure normalization