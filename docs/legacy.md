# 🗃️ Legacy Inventory

## 🎯 Purpose

This document records files and areas that appear to be:

- legacy
- superseded
- disabled
- experimental
- or likely unused in the active runtime path

The goal is **not** to delete them blindly.  
The goal is to classify them so cleanup can happen safely and traceably.

---

## 🧭 Classification Levels

### L1 — Confirmed legacy candidate
File appears unused or superseded and is a strong candidate for quarantine/removal after one final validation pass.

### L2 — Disabled but structurally present
File is still in the repository, but large parts are commented out or the runtime behavior is effectively disabled.

### L3 — Experimental / local prototype
File appears to be a test, demo, or design experiment rather than part of production runtime.

### L4 — Active but historically named
File is active and important, but its naming or placement suggests historical drift rather than ideal structure.

---

## ✅ Current Legacy Candidate Inventory

## 1. GeryonSocket old implementations

### `lib/models/GeryonSocket/model.dart`
**Classification:** L1 — confirmed legacy candidate

### Evidence
- file content is fully commented legacy-style WebSocket code
- active runtime uses:
  - `geryonsocket_model.dart`
  - `geryonsocket_model_web.dart`
  - `geryonsocket_model_io.dart`

### Recommended action
- do not keep as an active runtime file
- move to quarantine or remove in a dedicated cleanup commit

---

### `lib/models/GeryonSocket/model2.dart`
**Classification:** L1 — confirmed legacy candidate

### Evidence
- no active import hits detected in the current repository audit
- naming suggests experimental or superseded implementation

### Recommended action
- quarantine first
- remove later if not needed for historical reference

---

## 2. Session storage old implementation

### `lib/models/SessionStorage/session_storage_old.dart`
**Classification:** L1 — confirmed legacy candidate

### Evidence
- no active import hits detected
- active runtime uses:
  - `session_storage.dart`
  - `session_storage_web.dart`
  - `session_storage_io.dart`

### Recommended action
- quarantine or remove after final import verification

---

## 3. Old login data model

### `lib/models/ServiceProvider/login_data_user_message_model_old.dart`
**Classification:** L1 — confirmed legacy candidate

### Evidence
- no active import hits detected
- current runtime uses:
  - `login_data_user_message_model.dart`

### Recommended action
- quarantine or remove in low-risk cleanup phase

---

## 4. Experimental theme/demo screen

### `lib/models/_pruebas/them1.dart`
**Classification:** L3 — experimental / local prototype

### Evidence
- file is clearly a styled components demo
- title and content show UI exploration intent
- one textual reference appears in `dashboard_page.dart`, so this file should not be removed blindly without checking whether the import is real, commented, or test-only

### Recommended action
- inspect the real import line
- if not active in runtime, move to a dedicated `legacy/` or `sandbox/` area
- do not leave under production models path long-term

---

## 5. Old utils implementation

### `lib/utils/utils_old.dart`
**Classification:** L1 — confirmed legacy candidate

### Evidence
- no active import hits detected
- active runtime appears to use:
  - `utils.dart`
  - `utils_web.dart`
  - `utils_io.dart`

### Recommended action
- quarantine or remove after one final grep validation in working copy

---

## 6. Unused websocket service

### `lib/services/websocket_service.dart`
**Classification:** L1 — confirmed legacy candidate

### Evidence
- no active import hits detected
- actual WebSocket path is handled by the GeryonSocket abstraction layer

### Recommended action
- quarantine or remove after final repo validation

---

## 7. Disabled configuration update UI

### `lib/models/ServiceProviderConfig/widget.dart`
**Classification:** L2 — disabled but structurally present

### Evidence
- file content is largely or fully commented
- it still receives textual references because other files mention the filename or related symbols
- current runtime does not appear to use an active configuration editor flow

### Recommended action
- keep documented as disabled feature
- do not treat as active product functionality
- candidate for later move to `legacy/disabled_config_ui/`

---

### `lib/models/ServiceProviderConfig/popup_widget.dart`
**Classification:** L2 — disabled but structurally present

### Evidence
- popup route still exists as a concrete file
- actual content is effectively empty
- child screen invocation is commented out

### Recommended action
- mark as disabled
- do not remove until confirming no runtime route can still instantiate it
- likely quarantine candidate

---

## 8. Historically named active files

These are not legacy in behavior, but they are part of historical structural drift.

### `lib/models/ServiceProvider/data_model.dart`
**Classification:** L4 — active but historically named

### Reason
- this is a critical active file
- the name `data_model.dart` is too generic for the role it now plays

### Long-term recommendation
Rename later toward something explicit such as:
- `service_provider.dart`

Only after internal decomposition is complete.

---

### `lib/models/ServiceProvider/model.dart`
**Classification:** L4 — active but historically named

### Reason
- active runtime model
- generic filename harms discoverability

### Long-term recommendation
Later rename toward something more explicit such as:
- `service_provider_message_model.dart`
- or equivalent, depending on exact semantic role

---

## 🛡️ Legacy Handling Policy

Legacy files must be processed using this sequence:

1. classify
2. document
3. verify imports in working copy
4. quarantine if uncertain
5. remove only when confidence is high

---

## 🚫 What Should Not Be Done

Do **not**:
- delete all old files in one step
- mix legacy cleanup with transport refactor
- rename critical active files during the same pass as deleting old files
- assume commented code is harmless without checking references

---

## ✅ Phase 3 Legacy Conclusion

The repository contains a manageable number of low-risk legacy candidates.

Most of them can be:
- quarantined
- marked as deprecated
- or removed

without affecting runtime, provided one final import/reference validation is performed in the working tree before deletion.