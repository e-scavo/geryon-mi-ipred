# Development

## Current development principle

The app is functional in production.

Development must follow this rule:

> improve structure without breaking runtime behavior

---

## Current targets

- Web
- Android

Deferred:
- iOS

---

## Basic commands

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

## Working conventions

### 1. Protect backend flow
Do not change request/response structures casually.

### 2. Refactor by phase
Every meaningful refactor should be documented in a phase document.

### 3. Prefer actual runtime paths
Before cleaning old code, confirm whether it is still part of runtime behavior.

### 4. Keep platform abstractions aligned
Whenever Web/IO code changes, both variants must be reviewed.

---

## Recommended future engineering structure

Planned future documentation and code phases:

1. Phase 1 — audit and baseline docs
2. Phase 2 — repository/documentation alignment
3. Phase 3 — ServiceProvider structural split
4. Phase 4 — connection/session hardening
5. Phase 5 — feature expansion and UI cleanup