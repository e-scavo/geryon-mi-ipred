# 🧹 Cleanup Checklist

## 🎯 Purpose

This document is the operational checklist for performing **low-risk cleanup** in Mi IP·RED.

It is intended for use during real repository work so cleanup can be executed in a controlled and reversible way.

---

## 🧭 Cleanup Principles

- no runtime behavior changes
- no backend protocol changes
- no hidden large refactors mixed into cleanup
- one cleanup concern per commit when possible
- prefer quarantine before deletion when confidence is not absolute

---

## ✅ Pre-Cleanup Validation

Before touching any file:

- [ ] run the application on Web
- [ ] run the application on Android
- [ ] confirm login still works
- [ ] confirm dashboard still loads
- [ ] confirm invoices/receipts still load
- [ ] confirm current branch is clean or committed
- [ ] create a dedicated cleanup branch

Recommended branch name:

```text
chore/phase3-repository-hygiene
```

---

## 🔍 Import and Reference Validation

For each cleanup candidate:

- [ ] search for direct imports
- [ ] search for symbol usage
- [ ] search for route instantiation
- [ ] search for reflective/manual string references if any
- [ ] verify whether hit results are real code or only comments/text

Recommended categories:

- **safe remove**
- **quarantine first**
- **keep for now**

---

## 📦 Quarantine Strategy

If a file is probably unused but not yet 100% certain:

- [ ] move it to a clearly documented quarantine location
- [ ] add a comment header marking it as legacy
- [ ] update `docs/legacy.md`
- [ ] do not rename active imports during the same step

Recommended quarantine folder pattern:

```text
lib/_legacy/
  geryonsocket/
  session_storage/
  service_provider/
  experiments/
```

This is a temporary operational pattern, not necessarily the final architecture.

---

## 🗂️ Recommended Cleanup Order

## Step 1 — Remove or quarantine obvious legacy candidates
Candidates:
- `lib/models/GeryonSocket/model2.dart`
- `lib/models/SessionStorage/session_storage_old.dart`
- `lib/models/ServiceProvider/login_data_user_message_model_old.dart`
- `lib/utils/utils_old.dart`
- `lib/services/websocket_service.dart`

Checklist:
- [ ] no active imports
- [ ] no symbol usage
- [ ] build still passes after quarantine/removal

---

## Step 2 — Handle commented legacy transport file
Candidate:
- `lib/models/GeryonSocket/model.dart`

Checklist:
- [ ] confirm only legacy/commented implementation remains
- [ ] confirm active runtime uses `geryonsocket_model*.dart`
- [ ] quarantine or remove

---

## Step 3 — Handle disabled config UI
Candidates:
- `lib/models/ServiceProviderConfig/widget.dart`
- `lib/models/ServiceProviderConfig/popup_widget.dart`

Checklist:
- [ ] verify whether route is ever pushed in active runtime
- [ ] verify whether references are active code or only historical leftovers
- [ ] if unused, quarantine as disabled feature
- [ ] if potentially useful later, keep but mark clearly as disabled

---

## Step 4 — Handle experimental UI prototype
Candidate:
- `lib/models/_pruebas/them1.dart`

Checklist:
- [ ] inspect real import in `dashboard_page.dart`
- [ ] verify whether the reference is active, commented, or dev-only
- [ ] move to sandbox/legacy if not active
- [ ] do not keep under production model hierarchy long-term

---

## 🧪 Post-Cleanup Validation

After each cleanup step:

- [ ] `flutter pub get`
- [ ] `flutter analyze`
- [ ] run Web target
- [ ] run Android target
- [ ] test login flow
- [ ] test dashboard flow
- [ ] test billing/receipts flow

---

## 📝 Commit Strategy

Recommended commit style:

### Commit 1
```text
docs: add phase 3 cleanup and legacy inventory
```

### Commit 2
```text
chore: quarantine unused legacy transport and storage files
```

### Commit 3
```text
chore: quarantine disabled config ui and experimental files
```

This keeps repository history understandable.

---

## 🚫 Anti-Patterns

Do **not** do this in Phase 3:

- rename `ServiceProvider` core files
- move billing feature files
- restructure folders broadly
- change provider wiring
- touch backend payload generation
- alter login/session behavior

Those belong to later phases.

---

## ✅ Phase 3 Success Criteria

Phase 3 is successful when:

- legacy candidates are documented
- obvious dead files are classified
- cleanup actions are reversible
- no runtime behavior changes occur
- the repository becomes easier to understand before deeper refactor begins