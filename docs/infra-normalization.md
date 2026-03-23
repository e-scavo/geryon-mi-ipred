# 🧱 Infrastructure Normalization

## 🎯 Purpose

This document defines how infrastructure components should be reorganized in Mi IP·RED without altering runtime behavior.

This is the first phase where **code can start being moved**, but only in low-risk areas.

---

## 🧭 Scope of Phase 4

Allowed:

- moving files (without changing logic)
- renaming files (if imports are updated safely)
- grouping infrastructure modules
- cleaning folder structure

Not allowed:

- modifying backend communication
- altering ServiceProvider logic
- changing message formats
- changing login flow

---

## 🧱 Infrastructure Domains

The infrastructure layer is divided into:

### 1. Config
- connection configuration
- environment handling

### 2. Transport
- WebSocket client
- platform abstraction

### 3. Session
- local persistence (DNI)

### 4. Files
- file saving / downloads

### 5. Utils
- platform utilities

---

## 🏁 Target Mapping

### Config
FROM:
```
lib/models/ServiceProviderConfig/*
```

TO:
```
lib/core/config/*
```

---

### Transport
FROM:
```
lib/models/GeryonSocket/*
```

TO:
```
lib/core/transport/*
```

---

### Session Storage
FROM:
```
lib/models/SessionStorage/*
```

TO:
```
lib/core/session/*
```

---

### File Saver
FROM:
```
lib/models/FileSaver/*
```

TO:
```
lib/core/files/*
```

---

### Utils
FROM:
```
lib/utils/*
```

TO:
```
lib/core/utils/*
```

---

## ⚠️ Important Rules

### Rule 1 — Move only, do not rewrite
No logic changes.

### Rule 2 — Fix imports immediately
After each move:
- fix imports
- run analyzer

### Rule 3 — One group at a time
Do not move everything in one commit.

### Rule 4 — Validate after each step
- build
- run
- test login
- test dashboard

---

## 🧪 Suggested Execution Order

1. SessionStorage
2. FileSaver
3. Utils
4. Config
5. Transport (last, more sensitive)

---

## 🛡️ Why this order?

- Session/FileSaver/Utils → low risk
- Config → medium
- Transport → higher (used by ServiceProvider)

---

## ✅ Success Criteria

- infrastructure folders are clean
- imports updated
- no behavior change
- app still works exactly the same