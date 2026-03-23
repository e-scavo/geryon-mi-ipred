# 🧱 Phase 4 — Infrastructure Normalization

## 🎯 Goal

Reorganize infrastructure code into a clean structure without changing behavior.

---

## 🧠 Strategy

We move from:

```text
models/
utils/
mixed structure
```

to:

```text
core/
  config/
  transport/
  session/
  files/
  utils/
```

---

## ✅ What We Move

### Low Risk (first)
- SessionStorage
- FileSaver
- Utils

### Medium Risk
- ServiceProviderConfig

### Higher Risk
- GeryonSocket

---

## 🚫 What We DO NOT TOUCH

- ServiceProvider
- backend messages
- login logic
- dashboard
- billing

---

## 🧪 Execution Pattern

For EACH move:

1. move files
2. fix imports
3. run analyzer
4. run app
5. test flows

---

## 📦 Example Move

FROM:
```text
lib/models/SessionStorage/session_storage.dart
```

TO:
```text
lib/core/session/session_storage.dart
```

---

## ⚠️ Risk Control

Never:

- move everything at once
- mix multiple domains
- refactor logic in same commit

---

## 📌 Outcome

After Phase 4:

- project becomes understandable
- infra is separated
- ready for ServiceProvider refactor

---

## 🚀 Next Phase

Phase 5 — ServiceProvider decomposition