# 🛠️ Development

## 🎯 Current Development Principle

Mi IP·RED is functional in production.

Development must follow this rule:

> improve structure without breaking runtime behavior

---

## 🎯 Current Targets

- Web
- Android

Deferred:
- iOS

---

## ▶️ Basic Commands

### Install dependencies

```bash
flutter pub get
```

### Run on Chrome

```bash
flutter run -d chrome
```

### Run on Android

```bash
flutter run -d android
```

---

## 🧭 Working Conventions

### 1. Protect backend flow

Do not change request/response structures casually.

---

### 2. Refactor by phase

Every meaningful refactor should be documented in a phase document.

---

### 3. Prefer actual runtime paths

Before cleaning old code, confirm whether it is still part of runtime behavior.

---

### 4. Keep platform abstractions aligned

Whenever Web/IO code changes, both variants must be reviewed.

---

### 5. Decompose critical classes internally before moving them

For highly sensitive classes such as `ServiceProvider`, first reduce internal complexity while staying in the same file.

---

### 6. Use compatibility shims for structural UI migrations

When reorganizing the presentation layer, introduce canonical paths first and keep temporary compatibility exports until imports are fully migrated.

---

## 🧪 Validation Policy

After every meaningful runtime-core change:

- run `flutter analyze`
- run Web target
- run Android target
- validate login
- validate dashboard
- validate billing/receipts
- validate logout

This is mandatory for ServiceProvider-focused work.

For presentation-structure changes, validation must also include:

- startup loading flow
- login popup visibility
- customer selection
- payment information dialog
- invoice/receipt rendering
- file download entry points that open dialogs or visual containers

---

## 🗺️ Recommended Engineering Sequence

1. Phase 1 — audit and baseline docs
2. Phase 2 — structural planning
3. Phase 3 — cleanup and hygiene
4. Phase 4 — infrastructure normalization
5. Phase 5 — ServiceProvider decomposition
6. Phase 6 — presentation structure cleanup
7. Phase 7 — domain model organization
8. Phase 8 — session/config hardening
