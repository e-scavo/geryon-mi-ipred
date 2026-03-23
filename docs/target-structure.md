# 🗂️ Target Structure

## 🎯 Purpose

This document defines the **target repository structure** for Mi IP·RED.

It is not intended as a “move everything now” plan.  
It is the structural destination that future refactor phases should move toward gradually.

---

## 🧭 Refactor Principle

The target structure must:

- preserve runtime behavior
- preserve backend flow
- improve discoverability
- separate responsibilities more clearly
- reduce the current mix between UI, models, and infrastructure

---

## 🏁 Proposed Target Structure

```text
lib/
  main.dart

  app/
    app.dart
    bootstrap.dart
    providers.dart
    theme/
      app_theme.dart
      app_colors.dart
    navigation/
      app_navigator.dart

  core/
    config/
      service_provider_config.dart
      config_loader.dart
      config_loader_web.dart
      config_loader_io.dart
    errors/
      error_handler.dart
      standardized_errors.dart
    transport/
      websocket_client.dart
      websocket_client_web.dart
      websocket_client_io.dart
    session/
      session_storage.dart
      session_storage_web.dart
      session_storage_io.dart
    files/
      file_saver.dart
      file_saver_web.dart
      file_saver_io.dart
    utils/
      utils.dart
      utils_web.dart
      utils_io.dart

  backend/
    service_provider/
      service_provider.dart
      service_provider_init_stage.dart
      service_provider_channel.dart
      service_provider_message.dart
    rpc/
      rpc_message_response.dart
      synchronized_message_store.dart
      synchronized_thread_store.dart
    models/
      common/
      generic/
      tables/

  features/
    auth/
      data/
      domain/
      presentation/
    dashboard/
      presentation/
      widgets/
    billing/
      data/
      presentation/
      widgets/
    customer_context/
      presentation/

  shared/
    widgets/
      copyable_list_tile.dart
      info_card.dart
      barcode_widget.dart
      shake_text_field.dart
      loading/
      progress/

  config/
    version.dart
```

---

## 🧱 Mapping from Current Structure to Target Structure

### Current → Target

#### App bootstrap
- `lib/main.dart`
- `lib/common_vars.dart`

➡ target:
- `lib/main.dart`
- `lib/app/*`

#### Connection config
- `lib/models/ServiceProviderConfig/*`

➡ target:
- `lib/core/config/*`

#### WebSocket transport
- `lib/models/GeryonSocket/*`

➡ target:
- `lib/core/transport/*`

#### Session storage
- `lib/models/SessionStorage/*`

➡ target:
- `lib/core/session/*`

#### File saving
- `lib/models/FileSaver/*`

➡ target:
- `lib/core/files/*`

#### Service provider orchestration
- `lib/models/ServiceProvider/*`

➡ target:
- `lib/backend/service_provider/*`

#### RPC tracking
- `lib/models/CommonRPCMessageResponse/*`
- `lib/models/SynchronizedMapV2CRUD/*`
- `lib/models/SynchronizedMapThreadsToDataModelCRUD/*`

➡ target:
- `lib/backend/rpc/*`

#### Domain models
- `lib/models/Common*/*`
- `lib/models/GenericDataModel/*`
- `lib/models/tbl_*/*`

➡ target:
- `lib/backend/models/common/*`
- `lib/backend/models/generic/*`
- `lib/backend/models/tables/*`

#### Login
- `lib/models/Login/*`

➡ target:
- `lib/features/auth/*`

#### Dashboard
- `lib/pages/dashboard_page.dart`

➡ target:
- `lib/features/dashboard/presentation/*`

#### Billing
- `lib/pages/Billing/*`

➡ target:
- `lib/features/billing/*`

#### Shared visual widgets
- `lib/pages/copyable_list_tile_page.dart`
- `lib/pages/infocard_page.dart`
- `lib/widgets/barcode_widget.dart`
- `lib/models/ShakeTextField/*`

➡ target:
- `lib/shared/widgets/*`

---

## 🚫 What Should NOT Be Done Immediately

The following should not happen in one giant move:

- moving all files in one commit
- renaming every class now
- splitting `ServiceProvider` before documenting its call paths
- changing request payload shapes while restructuring folders

That would create too much simultaneous risk.

---

## ✅ Recommended Migration Order

### Phase A
Create the target documentation first.

### Phase B
Move only low-risk shared files:
- standalone widgets
- old utilities
- obvious inactive files to quarantine

### Phase C
Normalize infrastructure folders:
- session storage
- file saver
- config loader
- transport

### Phase D
Isolate orchestration support:
- RPC tracking types
- service provider enums/models

### Phase E
Split `ServiceProvider` internally before large path renames

### Phase F
Adopt feature-first presentation folders:
- auth
- dashboard
- billing

---

## 🧠 Naming Policy

Future naming should aim for:

- product-neutral technical clarity
- less historical baggage
- fewer “data_model.dart” names for unrelated responsibilities
- more explicit file names such as:
  - `service_provider.dart`
  - `websocket_client_web.dart`
  - `billing_screen.dart`
  - `login_screen.dart`

---

## 🛡️ Constraint Reminder

The target structure exists to improve maintainability.

It must never be pursued at the cost of:
- backend compatibility
- runtime stability
- currently working customer flows