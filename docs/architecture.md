# Architecture

## Overview

Mi IP·RED is a Flutter application with a backend-centric architecture based on a custom WebSocket protocol.

The system is currently designed for Web and Android, with iOS planned later.

The codebase is organized around a central orchestration object named `ServiceProvider`, which coordinates:

- WebSocket connection
- handshake and token negotiation
- channel subscription
- login
- session-related state
- backend RPC request/response tracking
- customer context selection

---

## High-level structure

```text
UI Layer
  -> DashboardPage
  -> BillingWidget
  -> LoginPageWidget
  -> reusable widgets

App Shell / Global State
  -> main.dart
  -> common_vars.dart
  -> Riverpod providers
  -> navigatorKey
  -> theme

Backend Orchestration
  -> ServiceProvider

Transport
  -> WebSocketClient
  -> platform-specific Web / IO implementations

Config / Local Persistence
  -> ServiceProviderConfig
  -> SessionStorage
  -> FileSaver

Domain / Backend Models
  -> Common* models
  -> tbl_* models
  -> GenericDataModel
```

---

## Main layers

### 1. Bootstrap layer
Primary files:
- `lib/main.dart`
- `lib/common_vars.dart`

Responsibilities:
- Flutter startup
- provider registration
- global navigator
- theme initialization
- initial page selection

### 2. Connection configuration layer
Primary files:
- `lib/models/ServiceProviderConfig/*`

Responsibilities:
- create and persist WebSocket connection parameters
- abstract Web vs IO configuration persistence

### 3. Transport layer
Primary files:
- `lib/models/GeryonSocket/*`

Responsibilities:
- initialize WebSocket
- listen for incoming messages
- send outbound JSON messages
- normalize transport errors

### 4. Orchestration layer
Primary files:
- `lib/models/ServiceProvider/*`

Responsibilities:
- application connectivity lifecycle
- handshake processing
- message tracking by `messageID`
- channel subscription
- login/logout
- readiness state
- logged user state
- current company/customer state

### 5. Domain model layer
Primary files:
- `lib/models/Common*/*`
- `lib/models/tbl_*/*`
- `lib/models/GenericDataModel/*`

Responsibilities:
- backend payload parsing
- validation
- domain representation
- table-oriented data access support

### 6. Presentation layer
Primary files:
- `lib/pages/*`
- `lib/models/Login/widget.dart`

Responsibilities:
- login screen
- dashboard
- customer switching
- payment info
- billing/receipt rendering
- error/loading UI

---

## Critical architectural fact

`ServiceProvider` is currently both:

- a connection/session controller
- a global state holder
- a message bus coordinator
- a partial business context container

This is functional, but it is also the main source of future refactor complexity.

---

## Current architecture quality assessment

### Strengths
- centralized backend lifecycle
- cross-platform abstractions already exist
- strong typed model presence
- real product behavior is already implemented

### Weaknesses
- oversized orchestration class
- inconsistent module naming
- legacy/commented code still present
- insufficient separation between transport, session, and domain workflows

---

## Architectural priority for future phases

The next refactor stages should preserve behavior while gradually separating:

1. transport
2. session/auth flow
3. RPC tracking
4. domain/table data loading
5. UI state concerns