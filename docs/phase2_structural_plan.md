# 🧭 Phase 2 — Structural Planning and Refactor Boundaries

## 🎯 Phase Goal

Build the structural plan for the repository after the initial audit.

This phase does **not** change behavior.  
It defines:
- what the system currently contains
- what should be protected
- what can be cleaned safely
- what the staged refactor order should be

---

## ✅ What Was Achieved in Phase 2

This phase adds:

- deep architectural documentation
- module inventory
- target repository structure
- staged refactor roadmap
- identification of legacy and cleanup candidates

---

## 🧠 Core Conclusion

Mi IP·RED does **not** need a rewrite.

It needs:

1. structural clarity
2. responsibility separation
3. legacy cleanup
4. a careful decomposition of the backend orchestration layer

The app is already functionally valid.  
The engineering task is to make that working base maintainable.

---

## 🛡️ Protected Zones

The following areas are now formally considered protected:

### Backend handshake and connectivity
- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/GeryonSocket/geryonsocket_model.dart`
- `lib/models/GeryonSocket/geryonsocket_model_web.dart`
- `lib/models/GeryonSocket/geryonsocket_model_io.dart`

### RPC tracking and async backend responses
- `lib/models/CommonRPCMessageResponse/common_rpc_message_response.dart`
- `lib/models/SynchronizedMapV2CRUD/model.dart`
- `lib/models/SynchronizedMapThreadsToDataModelCRUD/model.dart`

### User context and business data
- `lib/models/ServiceProvider/login_data_user_message_model.dart`
- `lib/models/tbl_ClientesV2/*`
- `lib/pages/Billing/widget.dart`
- `lib/pages/dashboard_page.dart`

These areas must not be casually reworked.

---

## 🧹 Cleanup Candidate Inventory

The following files are currently the strongest cleanup or quarantine candidates.

### Likely legacy / superseded
- `lib/models/GeryonSocket/model.dart`
- `lib/models/GeryonSocket/model2.dart`
- `lib/models/SessionStorage/session_storage_old.dart`
- `lib/models/ServiceProvider/login_data_user_message_model_old.dart`
- `lib/models/_pruebas/them1.dart`
- `lib/utils/utils_old.dart`
- `lib/services/websocket_service.dart`

### Likely disabled / commented configuration UI
- `lib/models/ServiceProviderConfig/widget.dart`
- `lib/models/ServiceProviderConfig/popup_widget.dart`

### Notes
These files should not necessarily be deleted immediately.

Recommended sequence:
1. mark them as legacy in docs
2. verify they are not imported in active runtime
3. move to quarantine or remove in a dedicated cleanup phase

---

## ⚠️ Structural Risks Confirmed

### 1. Oversized orchestration class
`lib/models/ServiceProvider/data_model.dart` is the main source of complexity.

### 2. Mixed physical boundaries
UI, logic, storage, and transport responsibilities are spread across folders that do not always match their real role.

### 3. Partial implementation leftovers
Several files clearly show previous iterations that remain inside the active repository.

### 4. Product/technical naming drift
- visible product: **Mi IP·RED**
- technical package: `geryon_web_app_ws_v2`

This is acceptable temporarily, but must remain documented.

### 5. Config loader behavior mismatch
The infrastructure for persisted config exists, but the real read-from-storage path is currently commented out.

---

## 🧱 Structural Direction Confirmed

The target structure for Mi IP·RED should move toward:

- `app/`
- `core/`
- `backend/`
- `features/`
- `shared/`

This will improve:
- discoverability
- onboarding
- future feature work
- maintainability

without requiring a rewrite-first strategy.

---

## 🚀 Recommended Next Execution Order

### Step 1
Perform a low-risk cleanup phase:
- document all legacy candidates
- confirm active imports
- quarantine or mark non-runtime files

### Step 2
Normalize infrastructure:
- session storage
- config loader
- file saver
- websocket transport

### Step 3
Decompose `ServiceProvider` internally

### Step 4
Move UI code toward feature-based folders

### Step 5
Reorganize domain models only after infrastructure and orchestration are stabilized

---

## 📌 Phase 2 Decision

The project is now ready for the next safe step:

> **Phase 3 — low-risk cleanup + repository hygiene**

This should be the first phase that touches the repository structure in a visible way, while still avoiding behavioral changes.

---

## ✅ Phase 2 Exit Criteria

Phase 2 is considered complete because:

- the architecture is documented more deeply
- the main modules are inventoried
- cleanup candidates are identified
- the target structure is defined
- the staged refactor order is now explicit