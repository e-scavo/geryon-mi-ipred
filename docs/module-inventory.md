# 🧩 Module Inventory

## 🎯 Purpose

This document inventories the main modules of the current Mi IP·RED codebase and explains their current role.

It is intentionally practical and oriented toward maintainers who need to understand **where things are** before any refactor is attempted.

---

## 📍 Root-Level Runtime Files

### `lib/main.dart`
**Role:** application bootstrap

Responsible for:
- Flutter initialization
- `ProviderScope`
- `MaterialApp`
- startup screen orchestration

### `lib/common_vars.dart`
**Role:** global app wiring

Responsible for:
- `navigatorKey`
- debug flag
- main `ChangeNotifierProvider<ServiceProvider>`
- connection config provider
- global theme

### `lib/config/version.dart`
**Role:** app version metadata

---

## 🔌 Connection and Transport

### `lib/models/ServiceProviderConfig/*`
**Role:** backend connection configuration

Important files:
- `model.dart`
- `config_loader.dart`
- `config_loader_web.dart`
- `config_loader_io.dart`

Current status:
- active
- important
- partially unfinished in behavior because persisted config reading is commented out

### `lib/models/GeryonSocket/*`
**Role:** WebSocket abstraction layer

Important files:
- `geryonsocket_model.dart`
- `geryonsocket_model_web.dart`
- `geryonsocket_model_io.dart`

Current status:
- active
- critical
- should remain stable during early refactor phases

---

## 🧠 Core Runtime Orchestration

### `lib/models/ServiceProvider/*`
**Role:** central runtime backbone

Important files:
- `data_model.dart`
- `channel_model.dart`
- `init_stages_enum_model.dart`
- `login_data_user_message_model.dart`
- `whole_message_model.dart`

Current status:
- active
- critical
- highest-risk refactor area

### `lib/models/CommonRPCMessageResponse/*`
**Role:** tracked backend message state

### `lib/models/SynchronizedMapV2CRUD/*`
**Role:** synchronized RPC tracking store

### `lib/models/SynchronizedMapThreadsToDataModelCRUD/*`
**Role:** synchronized thread/data map support

Current status of these supporting modules:
- active
- infrastructure-level
- tightly coupled to backend flow

---

## 🔐 Login and Session

### `lib/models/Login/*`
**Role:** login UI + login model

Files:
- `model.dart`
- `widget.dart`

Current status:
- active
- important
- UI and behavior currently live under `models/`, which is structurally awkward but functionally valid

### `lib/models/SessionStorage/*`
**Role:** local remembered DNI persistence

Files:
- `session_storage.dart`
- `session_storage_web.dart`
- `session_storage_io.dart`

Current status:
- active
- useful
- convenience persistence only

---

## 📦 Domain / Common Data Models

### `lib/models/CommonDataModel/*`
**Role:** common backend data envelope and whole-message structures

### `lib/models/CommonMessages/*`
**Role:** general message model definitions

### `lib/models/CommonFileDescriptorModel/*`
**Role:** download/file metadata

### `lib/models/CommonParamRequest/*`
**Role:** request/header parameter structures

### `lib/models/CommonParamKeyValue/*`
**Role:** generic key-value parameter objects

### `lib/models/CommonBooleanModel/*`
**Role:** typed boolean wrapper

### `lib/models/CommonDateModel/*`
**Role:** date wrappers

### `lib/models/CommonDateTimeModel/*`
**Role:** datetime wrappers

### `lib/models/CommonNumbersModel/*`
**Role:** numeric wrappers

### `lib/models/CommonModel/*`
**Role:** common base-like value modeling

### `lib/models/CommonUtils/*`
**Role:** generic shared helpers

Current status:
- active
- broad foundational layer
- naming consistency could be improved later

---

## 🗃️ Generic Data and Table-Oriented Models

### `lib/models/GenericDataModel/*`
**Role:** generic model abstraction used by data-loading flows

### `lib/models/tbl_*/*`
**Role:** business/domain entities mapped to backend tables or typed records

Examples:
- `tbl_ClientesV2`
- `tbl_ComprobantesVT`
- `tbl_Empresas`
- `tbl_DetServiciosDATOSClientesV2`
- `tbl_NAS`
- geographic and tax-related tables

Current status:
- active
- part of the real business model layer
- should be cleaned by organization, not by behavioral rewrite

---

## 🖥️ UI and Screens

### `lib/pages/dashboard_page.dart`
**Role:** main customer dashboard screen

Current status:
- active
- important
- directly dependent on provider state

### `lib/pages/Billing/widget.dart`
**Role:** billing/receipts/invoices UI and backend load flow

Current status:
- active
- important
- likely one of the main feature modules

### `lib/pages/FrameWithScroll/*`
**Role:** scroll/container layout helper

### `lib/pages/WindowWidget/*`
**Role:** reusable framed/presentational screen helpers

### `lib/pages/copyable_list_tile_page.dart`
**Role:** reusable copyable info widget

### `lib/pages/infocard_page.dart`
**Role:** reusable information card widget

---

## 🧰 Utility and Support Modules

### `lib/models/FileSaver/*`
**Role:** local file saving abstraction by platform

### `lib/models/GeneralLoadingProgress/*`
**Role:** loading workflow and progress popup route

### `lib/models/LoadingGeneric/*`
**Role:** generic loading widget

### `lib/models/ScreenGeneralWorkInProgress/*`
**Role:** work-in-progress / error / progress display helpers

### `lib/models/ShakeTextField/*`
**Role:** animated textfield validation feedback

### `lib/widgets/barcode_widget.dart`
**Role:** barcode rendering helper

### `lib/utils/*`
**Role:** generic runtime/platform helpers

Important files:
- `utils.dart`
- `utils_web.dart`
- `utils_io.dart`

---

## ⚠️ Legacy / Transitional / Cleanup Candidates

These are the clearest current cleanup candidates:

### Likely legacy or unused files
- `lib/models/GeryonSocket/model.dart`
- `lib/models/GeryonSocket/model2.dart`
- `lib/models/SessionStorage/session_storage_old.dart`
- `lib/models/ServiceProvider/login_data_user_message_model_old.dart`
- `lib/models/_pruebas/them1.dart`
- `lib/utils/utils_old.dart`
- `lib/services/websocket_service.dart`

### Likely disabled configuration UI
- `lib/models/ServiceProviderConfig/widget.dart`
- `lib/models/ServiceProviderConfig/popup_widget.dart`

These files appear to be:
- fully commented
- not part of the active main flow
- or superseded by newer implementations

They should **not** be deleted immediately, but they are prime candidates for:
- quarantine
- archival
- or later removal after one more dependency check

---

## 🛡️ Protected Modules

These modules must be treated as protected in early refactor phases:

- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/GeryonSocket/geryonsocket_model.dart`
- `lib/models/GeryonSocket/geryonsocket_model_web.dart`
- `lib/models/GeryonSocket/geryonsocket_model_io.dart`
- `lib/pages/Billing/widget.dart`
- `lib/models/CommonDataModel/*`
- `lib/models/GenericDataModel/*`
- `lib/models/tbl_ClientesV2/*`
- `lib/models/ServiceProvider/login_data_user_message_model.dart`

---

## ✅ Inventory Summary

The project already contains:
- a working runtime backbone
- a meaningful typed model layer
- a working multi-platform base
- a usable customer dashboard flow

The main issue is not missing architecture, but **mixed physical organization and accumulated legacy layers**.