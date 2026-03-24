# 🎨 Phase 6 — Presentation Structure Cleanup

## 🎯 Phase Goal

Normalize the presentation-layer structure of Mi IP·RED without changing runtime behavior.

This phase starts after the internal decomposition work of `ServiceProvider` and intentionally avoids touching the backend contract, handshake lifecycle, tracked RPC semantics, and login protocol behavior.

---

## 🧠 Why This Phase Exists

The current repository is now in a better position than before:

- backend flow is documented
- infrastructure paths are more explicit
- `ServiceProvider` has already gone through an internal decomposition phase
- runtime-critical behavior is better mapped and better protected

That makes the next bottleneck clear:

> the presentation layer is still structurally mixed.

The project currently contains real UI code under both `models/` and `pages/`, and some files classified as pages are actually reusable shared widgets.

This does not block runtime behavior today, but it does create friction for future maintenance.

---

## 🔎 Current Structural Symptoms

The real project shows the following presentation-layer inconsistencies:

### 1. UI living under `models/`
Examples:
- `lib/models/Login/widget.dart`
- `lib/models/ShakeTextField/widget.dart`
- `lib/models/GeneralLoadingProgress/*`

These are active runtime UI pieces, but their location suggests data/domain semantics rather than presentation semantics.

### 2. Reusable visual widgets living under `pages/`
Examples:
- `lib/pages/copyable_list_tile_page.dart`
- `lib/pages/infocard_page.dart`
- `lib/pages/FrameWithScroll/widget.dart`
- `lib/pages/WindowWidget/*`

These are not top-level product pages. They are shared visual building blocks.

### 3. Mixed import story inside active screens
`dashboard_page.dart` currently imports:
- billing feature UI
- layout wrappers
- shared visual widgets
- session helpers

from a mixture of page, model, and shared-like paths.

### 4. Login presentation is still coupled through a historical location
`ServiceProvider` still imports the login popup/widget from the current `models/Login` path.

This should not be broken impulsively. It should be migrated only through a safe structural sequence.

---

## ✅ What This Phase Tries to Achieve

This phase aims to:

- separate shared visual widgets from feature screens
- create clearer canonical presentation paths
- reduce the semantic confusion of UI code living under `models/`
- improve discoverability of visual components
- prepare the repository for later feature-first organization
- keep behavior stable during migration

---

## 🚫 What This Phase Must Not Do

This phase must **not**:

- change backend message contracts
- change tracked request handling
- change `ServiceProvider` public behavior
- redesign login flow
- redesign dashboard flow
- redesign billing flow
- change app startup orchestration semantics
- change platform abstractions
- introduce a large visual overhaul

This is structure cleanup, not a product redesign.

---

## 🧱 Recommended Structural Direction

The correct structural direction is to distinguish between:

### 1. Shared presentation building blocks
Examples:
- copyable tiles
- info cards
- shake text field
- framed layout wrappers
- generic loading/progress UI
- simple reusable visual containers

### 2. Feature presentation modules
Examples:
- auth presentation
- dashboard presentation
- billing presentation
- customer context presentation

The first step should focus on the lowest-risk shared building blocks, not on full feature relocation.

---

## 🪜 Recommended Execution Strategy

The safest strategy for Phase 6 is:

1. introduce canonical new paths first
2. keep compatibility with old paths temporarily
3. migrate imports gradually
4. validate UI behavior after each small move
5. remove old paths only after migration is complete

This avoids breaking multiple active screens at the same time.

---

## ✅ Phase 6.1 — Canonical shared UI paths with compatibility shims

This is the first safe execution step of Phase 6.

### Why this is the safest entry point
Because it focuses on low-risk visual pieces that:
- are easier to reason about
- are not backend-protocol critical
- are already reusable in nature
- can be relocated with minimal semantic risk

### Canonical target paths introduced
New canonical paths:

- `lib/shared/widgets/copyable_list_tile.dart`
- `lib/shared/widgets/info_card.dart`
- `lib/shared/widgets/shake_text_field.dart`
- `lib/shared/layouts/frame_with_scroll.dart`
- `lib/shared/window/window_model.dart`
- `lib/shared/window/window_widget.dart`

### Legacy compatibility paths preserved temporarily
These files remain as compatibility shims or exports during migration:

- `lib/pages/copyable_list_tile_page.dart`
- `lib/pages/infocard_page.dart`
- `lib/models/ShakeTextField/widget.dart`
- `lib/pages/FrameWithScroll/widget.dart`
- `lib/pages/WindowWidget/mode.dart`
- `lib/pages/WindowWidget/widget.dart`

### Imports migrated in this substep
Low-risk imports are migrated to canonical paths in:

- `lib/pages/dashboard_page.dart`
- `lib/models/Login/widget.dart`
- `lib/pages/Billing/widget.dart`
- `lib/models/CommonDownloadLocally/widget.dart`

---

## 🛡️ Frozen Runtime Behaviors During Phase 6

The following runtime behaviors remain frozen:

- startup loading experience
- login popup flow
- current remembered DNI behavior
- current dashboard rendering logic
- current customer selector behavior
- payment dialog behavior
- billing and receipts loading behavior
- current logout behavior
- current download entry points

---

## ⚠️ Sensitive Areas Inside This Phase

Even though this is a presentation-focused phase, the following areas are still sensitive:

- `lib/main.dart`
- `lib/models/Login/widget.dart`
- any `ServiceProvider` imports that point to UI files
- `dashboard_page.dart`
- `Billing/widget.dart`
- progress popup and login popup routes

These areas are presentation-adjacent but still connected to critical runtime entry points.

---

## 🧪 Validation Requirements

After Phase 6.1, validate at minimum:

- `flutter analyze`
- Web startup
- Android startup
- loading popup appears correctly
- login popup appears correctly
- successful login still reaches dashboard
- customer switching still works
- payment information dialog still works
- invoices and receipts still render
- logout still resets visible state correctly

If file download UI is touched, validate that too.

---

## ✅ Expected Outcome of Phase 6.1

After this substep:

- canonical shared presentation paths exist
- legacy imports still remain compatible
- active low-risk consumers use the new paths
- runtime behavior remains unchanged
- the repository is ready for further feature-oriented presentation normalization

---

## 📌 Recommended Next Step After Phase 6.1

Once the shared visual foundation is normalized, the next logical step is:

> **Phase 6.2 — migrate auth/dashboard/billing presentation paths more explicitly while preserving current runtime flow**

That step should still remain incremental and behavior-preserving.