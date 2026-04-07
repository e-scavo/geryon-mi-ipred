# Phase 14 — Surface Normalization & Billing Workbench Modernization

## Objective

Open the next justified implementation layer after the formal closure of Phase 13 by normalizing the remaining legacy widget and overlay surface that still lives outside the already consolidated `features` and `shared` structure, while also preparing a safer foundation for the future billing workbench modernization.

## Initial Context

The current ZIP confirms the following closed baselines:

- Phase 7 — Application Layer Consolidation
- Phase 8 — Runtime Reliability
- Phase 9 — Product Surface Consistency & UX Hardening
- Phase 10 — Capability Completion
- Phase 11 — Release & Distribution
- Phase 12 — Store Publication Assets & Operational Rollout
- Phase 13 — Store Execution Integrity & Market Presence Hardening

That means the repository is no longer blocked by:

- feature extraction
- runtime coordination
- responsive alignment
- product capability completion
- release reproducibility
- publication scaffolding
- publication readiness validation

What remains open in the real ZIP is a structural surface inconsistency:

- some reusable widgets still live under `lib/models/`
- some fallback/error UI still lives under `lib/pages/`
- some billing-specific widgets still live under legacy generic locations
- some global overlays still expose active legacy import paths even though the app already has a stable `shared/` area

## Problem Statement

The project already reached a mature architecture baseline, but the widget surface still contains legacy placement decisions from earlier stages.

That creates several practical problems:

- active imports still cross from `features` into legacy `models/` UI files
- `shared` code still depends on a fallback surface stored under `pages/`
- billing keeps depending on a table and download surface that are not placed inside the billing feature boundary
- future modernization of the billing workbench would have to start from a partially normalized UI surface instead of a clean one

The problem is not behavioral instability.
The problem is final structural normalization of the remaining active UI surface.

## Scope

Phase 14 covers:

- normalization of remaining legacy widget and overlay placement
- controlled migration of active shared surfaces to `lib/shared/`
- controlled migration of active billing-specific surfaces to `lib/features/billing/`
- retention of compatibility wrappers where required to reduce migration risk
- documentary closure of the first normalization cut before any larger billing workbench redesign

Phase 14 does not cover:

- Riverpod architecture changes
- navigation redesign
- backend communication changes
- business-logic changes
- billing workbench visual redesign in the same step
- aggressive deletion of dormant legacy code without validation

## Root Cause Analysis

The project evolved through multiple baselines.
Earlier phases correctly focused on getting the app stable, structured, and publishable.
That work left behind a smaller class of debt: UI surfaces that still occupy legacy folders even though the repository now already has the target structural vocabulary.

This happened because:

- some widgets were normalized behaviorally before they were normalized structurally
- some overlays remained in their original folders to avoid destabilizing runtime during earlier closure phases
- billing-specific widgets were made operational before the final billing presentation boundary was fully cleaned up

By the end of Phase 13, those tradeoffs remained acceptable.
After Phase 13 closure, they became the next justified target.

## Implemented Subphases

### Phase 14.1 — Legacy Widget Surface Audit & Final Normalization

Implemented.

Focus:

- audit the active legacy widget surface present in the ZIP
- classify what is really shared versus billing-specific
- move active shared UI surfaces into `lib/shared/`
- move active billing presentation surfaces into `lib/features/billing/`
- keep compatibility wrappers on the old import paths to reduce migration risk during the transition
- avoid any logic rewrite while normalizing paths and ownership

## Final Baseline After Phase 14.1

After Phase 14.1, the repository now has a cleaner active surface contract:

- `LoadingGeneric` now has a canonical shared path under `lib/shared/widgets/`
- the fallback system error surface now has a canonical shared path under `lib/shared/widgets/`
- the active shared error/loading/progress overlays now have canonical paths under `lib/shared/overlays/`
- the billing documents table now has a canonical feature path under `lib/features/billing/presentation/widgets/`
- the billing document download popup route now has canonical feature paths under `lib/features/billing/presentation/overlays/`
- legacy paths are preserved as compatibility exports for a controlled migration boundary

This means the app can continue to run without reopening old imports everywhere at once, while the normalized destination paths now become the source of truth for future work.

## Constraints

The following constraints remain mandatory across all Phase 14 work:

- do not reopen Phase 7 architecture
- do not reopen Phase 8 runtime semantics
- do not reopen Phase 9 responsive/layout baselines
- do not reopen Phase 10 product contracts
- do not reopen Phase 11 release/distribution baselines
- do not reopen Phase 12 publication rollout rules
- do not reopen Phase 13 publication-readiness gates
- do not mix surface normalization with uncontrolled behavior changes

## Impact

Positive impact of Phase 14.1:

- active imports now point more clearly to their real structural ownership
- billing is better positioned for the next workbench-oriented phase
- shared/runtime overlays no longer depend on `models/` as their canonical UI home
- the repository is easier to reason about because feature-specific and shared surfaces are more explicit
- compatibility wrappers reduce regression risk while the normalized paths become established

Risk if this phase had been skipped:

- future billing modernization would start from a mixed legacy surface
- active code would continue to normalize behavior without normalizing ownership
- more features would keep importing legacy UI paths by inertia

## Validation

Phase 14 is correctly represented only if the current ZIP now supports all of the following:

- active shared imports can target new canonical files under `lib/shared/`
- billing can target a new canonical table widget under `lib/features/billing/presentation/widgets/`
- the billing download popup route has a feature-local canonical path
- legacy paths remain available as compatibility wrappers rather than being deleted aggressively
- no business-logic or backend contract changes were required to complete the normalization

The current ZIP supports that reading.

## Conclusion

Phase 14 is now open and its first justified implementation cut is completed.

The repository did not need a new behavioral redesign first.
It needed the remaining active widget surface to catch up with the architecture that had already been stabilized by earlier phases.
Phase 14.1 completes that first normalization layer and leaves the project in a safer position for the later billing workbench modernization steps.


### Phase 14.1.1 — Canonical Source Consolidation & Legacy Wrapper Cleanup

Implemented.

Focus:

- consolidate the real implementation behind the canonical paths created in 14.1
- reduce active legacy files to wrapper or export compatibility layers where possible
- move the billing document download implementation to the billing feature boundary
- keep compatibility import paths alive for runtime/model callers that still point to the legacy locations
- avoid any behavior, runtime, navigation, or business-rule redesign while closing the residual duplication left by 14.1

## Final Baseline After Phase 14.1.1

After Phase 14.1.1, the repository now has a stricter canonical-source contract:

- the shared loading widget has a single real implementation under `lib/shared/widgets/loading_generic.dart`
- the shared system error surface has a single real implementation under `lib/shared/widgets/system_error_surface.dart`
- the shared error/loading/work-in-progress overlays remain canonically implemented under `lib/shared/overlays/`
- the billing documents table remains canonically implemented under `lib/features/billing/presentation/widgets/billing_documents_table.dart`
- the billing document download dialog and route are now canonically implemented under `lib/features/billing/presentation/overlays/`
- legacy UI files that remain active for compatibility are now reduced to wrappers or exports instead of carrying duplicate full implementations

This means the project keeps backward-compatible import stability while removing the duplicate-source condition detected during the 14.1 validation pass.

## Impact

Additional positive impact of Phase 14.1.1:

- the canonical shared and billing-local files now truly become the single source of implementation for the active surfaces normalized in Phase 14.1
- compatibility remains available for model/runtime layers that still reference legacy import paths
- the billing feature boundary is cleaner before starting the billing workbench modernization phase
- the repository becomes easier to maintain because active UI surfaces no longer exist as full duplicated implementations on both canonical and legacy paths

## Validation

Phase 14.1.1 is correctly represented only if the current ZIP now supports all of the following:

- the legacy shared UI files under `lib/models/` and `lib/pages/` now resolve through wrappers or exports instead of retaining full duplicate implementations
- the billing document download implementation now lives canonically under `lib/features/billing/presentation/overlays/`
- the legacy billing download file remains as a compatibility export only
- the legacy billing table file remains as a compatibility export only
- callers that were already repointed in 14.1 still resolve against the canonical destinations introduced in 14.1

The current ZIP supports that reading.

## Conclusion

Phase 14 remains open, and its first normalization layer is now structurally tightened.

Phase 14.1 created the canonical destinations and repointed the main callers.
Phase 14.1.1 closes the residual duplicate-source gap by making the canonical destinations the real implementation owners while legacy paths remain compatibility-only wrappers.

This leaves the project in a cleaner and safer state before any larger billing workbench redesign begins.

### Phase 14.2.1 — Billing Workbench Surface Contract & Pagination Baseline

Implemented.

Focus:

- introduce a canonical billing workbench shell inside the billing presentation boundary
- replace the previous simple embedded table usage with a workbench-oriented surface
- add presentation-only local pagination without touching backend or business logic
- add a toolbar, summary strip, modular table structure, and pagination footer
- preserve the existing per-row download behavior
- keep the older `BillingDocumentsTable` entry point as a compatibility wrapper while the billing feature moves to the new workbench shell

## Final Baseline After Phase 14.2.1

After Phase 14.2.1, the billing feature now has a stronger workbench foundation:

- `BillingWidget` now renders a canonical `BillingWorkbench` surface
- the workbench owns local rows-per-page state and current-page state
- billing now exposes a toolbar with refresh and rows-per-page controls
- billing now exposes a summary strip with visible range and page context
- the table is now structurally decomposed into column, header, row, table, and pagination widgets
- the billing document download action remains available from each visible row
- `BillingDocumentsTable` remains available as a compatibility wrapper rather than the main owner of the presentation contract

This means Phase 14 is no longer only about path normalization.
It now also includes the first safe modernization layer of the billing surface itself.

## Impact

Positive impact of Phase 14.2.1:

- billing navigation becomes lighter when the document count grows
- the surface feels closer to a desktop workbench instead of a temporary embedded table
- future additions such as filtering, sorting, selection, or grouped presentation now have a safer modular base
- the billing feature gains stronger ownership of its own operational surface without reopening any backend or runtime concerns

## Validation

Phase 14.2.1 is correctly represented only if the current ZIP now supports all of the following:

- `BillingWidget` uses a workbench-oriented surface under `lib/features/billing/presentation/widgets/`
- rows-per-page can be adjusted locally
- users can navigate between pages locally
- visible-range context is shown in the summary and footer areas
- row download remains available
- the workbench responds to layout constraints without platform-specific branching

The current ZIP supports that reading.

## Conclusion

Phase 14 remains open, and billing modernization is now formally underway.

Phase 14.1 and 14.1.1 prepared the structural surface.
Phase 14.2.1 is the first presentation modernization layer that turns billing into a real workbench baseline while preserving the current logic, contracts, and runtime architecture.


### Phase 14.2.1.1 — Billing Workbench Vertical Flow & Overflow Stabilization

Implemented.

Focus:

- remove the rigid fixed-height embedding that clipped billing sections inside dashboard
- let each billing type expand naturally according to its current visible page slice
- restore parent-owned vertical scrolling for the dashboard surface
- preserve the workbench shell, summary, pagination, and row actions introduced in Phase 14.2.1

Result:

- billing sections no longer depend on a hard-coded container height
- the main `BOTTOM OVERFLOWED` issue observed during runtime validation is structurally removed
- the dashboard vertical reading flow remains the single scroll owner for billing blocks


### Phase 14.2.1.2 — Billing Workbench Header Cleanup, Horizontal Table Access & Backend Pagination Alignment

Implemented.

Focus:

- remove the redundant type title from the workbench toolbar so the billing type is not repeated unnecessarily
- replace proportional-only billing columns with explicit-width columns so the horizontal table contract is stable
- add an interactive horizontal scrollbar and drag-capable horizontal access for desktop and touch usage
- move billing pagination from presentation-only local slicing to real backend-aligned `offset` / `pageSize` requests
- keep the billing widget as the owner of current page and rows-per-page state while the workbench remains a presentation surface

## Final Baseline After Phase 14.2.1.2

After Phase 14.2.1.2, the billing workbench is no longer only visually paginated.

The current baseline now supports:

- one clear billing-type identity per section without toolbar title duplication
- explicit horizontal access to all billing columns, including the download action column
- page changes that trigger real backend-aligned data loads
- rows-per-page changes that reset to page one and trigger real backend-aligned data loads
- summary and footer values that remain consistent with total-record information reported by the backend model

## Impact

Positive impact of Phase 14.2.1.2:

- billing sections become visually lighter because the repeated title layer is removed from the toolbar
- the action column remains reachable instead of being compressed by flexible-width layout
- horizontal table navigation becomes clearer and more usable on desktop/web
- billing requests now scale better because the feature stops loading the entire voucher collection when only one page is needed

## Validation

Phase 14.2.1.2 is correctly represented only if the current ZIP now supports all of the following:

- the toolbar no longer repeats the billing type title
- the table exposes a stable horizontal scrollbar and allows reaching the action column
- changing page produces a new backend request using an updated offset
- changing rows per page produces a new backend request using an updated page size
- the visible-range summary remains aligned with backend totals rather than with a local full-list slice

The current delivery reflects that implementation.


## Phase 14.2.1.3 — Billing Workbench Table Width Harmonization & Horizontal Viewport Alignment

### Objective

Align the rendered billing table width with the available workbench viewport width so the grid fills the section container on wide screens and keeps horizontal scroll only for narrow viewports below the intrinsic minimum table width.

### Implementation Characteristics

This stabilization keeps the existing backend pagination and billing interactions untouched. The change is strictly presentational and responsive:

- the billing workbench now distinguishes intrinsic minimum table width from effective rendered width
- the table grows to the available width when the billing section is wider than the column minimum
- the scrollbar remains active only when the viewport becomes narrower than that minimum

### Result

The billing table, summary, and footer now feel visually aligned inside the wider billing section, while small windows still retain horizontal access to the complete column set.

## Phase 14.2.2.1 — Sortable Columns & Query-State Wiring

### Objective

Add true sortable-column interaction to the stabilized billing workbench so the table headers can drive backend ordering without breaking the already validated pagination, width alignment, and download behavior.

### Implementation Characteristics

This phase introduces a narrow query-state extension rather than a structural redesign:

- `BillingWidget` now owns `sortField` and `sortAsc` together with `currentPage` and `rowsPerPage`
- `BillingController` now forwards sort state into the backend request payload
- the billing workbench column model now marks sortable columns explicitly
- the billing header renders sortable cells with neutral and active direction indicators
- changing the sort resets the visible page back to `1` before reloading

### Result

The billing surface now behaves more like an actual workbench:

- voucher number, date, and amount can be sorted from the UI
- the active sort direction is visible in the header
- the backend receives the requested ordering together with pagination
- the workbench remains stable in layout, scroll behavior, and row download actions


## Phase 14.2.2.2 — Search & Filter Entry Layer

### Objective

Add the first useful discovery layer on top of the stabilized billing workbench so users can reduce the voucher universe without losing backend pagination, backend sorting, horizontal access, or row download behavior.

### Implementation Characteristics

The current ZIP confirms full backend support for `Search` in the shared request header, but it does not provide equally explicit evidence for a billing-specific date-range contract in this exact flow. Because of that, this phase implements the search layer completely and handles the date-range portion honestly rather than faking unsupported filtering.

The applied changes are intentionally narrow:

- `BillingWidget` now owns `searchText` together with page, page size, and sort state
- `BillingController` now forwards the real search string into `HeaderParamsRequest.search`
- the billing toolbar now exposes a visible search input, submit action, and clear action
- the workbench summary now reflects active search context
- empty states now distinguish between “no vouchers available” and “no results for the current search”

### Result

The billing workbench is now meaningfully faster to explore in day-to-day use:

- users can search vouchers directly from the toolbar
- clearing the search resets the listing cleanly back to page `1`
- backend paging and backend sorting stay intact
- the UI no longer pretends to support date-range filtering without a verified contract for that exact backend path


## Phase 14.2.2.3 — Table Interaction Rhythm & State Feedback

### Objective

Refine the billing workbench interaction layer so the table communicates interactivity more clearly, feels lighter during paging, sort, and search refreshes, and reads more like a professional operator-facing surface without changing the already-stabilized backend contracts.

### Implementation Characteristics

This phase keeps the workbench structure intact and focuses on interaction feedback and visual rhythm:

- billing interaction reloads now preserve the current table surface and show a localized refresh state instead of always replacing the whole section with a large loading state
- sortable headers now expose clearer hover affordance, active-sort emphasis, and a more legible direction indicator
- table rows now react with a soft hover treatment and tighter, more deliberate row density
- the toolbar, summary strip, and pagination footer now share a more coherent card rhythm and spacing
- summary tiles gained lightweight iconography to better segment context without redesigning the module

### Result

The billing workbench now feels calmer and more explicit in day-to-day use:

- users can immediately identify sortable headers
- row scanning is easier because hover rhythm and spacing are clearer
- search, sorting, and paging refreshes feel less disruptive
- the module reads as one coherent workbench instead of a stack of correct but flatter blocks

---

## Phase 14.2.2.4 — Formal Closure

La línea de modernización del billing workbench se considera finalizada.

Se consolidaron:

- paginación backend
- sorting real
- búsqueda funcional
- tabla responsive
- scroll horizontal correcto
- eliminación de overflow
- feedback de interacción consistente
- loading localizado
- empty states contextuales

El módulo billing deja de ser una tabla simple y pasa a comportarse como una surface de trabajo estable.

Se deja explícitamente fuera del alcance:

- filtros avanzados
- selección múltiple
- acciones masivas
- exportación

El estado actual es apto para uso real y preparado para futuras extensiones.

### Phase 14.3 — Payment Methods Surface Modernization

Opened.

Focus:

- audit the current payment methods surface that still lives inside dashboard
- keep the feature explicitly informational and backend-driven
- normalize structural ownership under `lib/features/payment_methods/`
- avoid introducing checkout, transaction state, or payment-gateway semantics
- align the surface with the already consolidated feature/shared organization

## Baseline Opened by Phase 14.3

The repository now has a justified next surface-normalization target after the formal closure of Billing Workbench UX and interaction work.

That target is the current payment methods dialog surface, which:

- is active in product behavior
- is currently triggered from dashboard
- is still implemented inline inside dashboard presentation
- is fed by backend-provided payment information
- is informational only and not an in-app payment flow

### Phase 14.3.2.1 — Payment Methods Feature Boundary & Overlay Extraction

Implemented.

Focus:

- create the first canonical `payment_methods` feature boundary
- extract the payment methods dialog into a dedicated overlay owner
- add a dedicated popup route for the surface
- keep the dashboard as trigger-only for `Ver medios de pago`
- preserve the current backend-driven informational behavior without introducing transaction semantics

## Final Baseline After Phase 14.3.2.1

After Phase 14.3.2.1, the repository now has the first normalized ownership cut for Payment Methods:

- the payment methods dialog now has a canonical home under `lib/features/payment_methods/presentation/overlays/`
- the payment methods popup route now has a canonical feature-local import path
- dashboard no longer owns the inline dialog implementation details
- the visible feature contract remains informational and backend-driven
- the project is now ready for further payment-method surface normalization without confusing the feature with an in-app checkout flow


### Phase 14.3.2.2 — Payment Methods Dashboard Integration Boundary Cleanup

Implemented.

Focus:

- remove the remaining Payment Methods popup-opening ownership from dashboard
- provide a feature-owned launcher API under the payment methods boundary
- keep the visible dialog content unchanged
- preserve the informational and backend-driven meaning of the surface

## Final Baseline After Phase 14.3.2.2

After Phase 14.3.2.2, the repository now has a correctly closed integration boundary for Payment Methods:

- dashboard now triggers the feature through `showPaymentMethodsDialog(...)`
- dashboard no longer owns `Navigator.of(context).push(...)` for this surface
- the Payment Methods feature now owns both the overlay content and the canonical opening entry point
- the feature remains informational, backend-driven, and explicitly oriented to external payment rather than in-app checkout

### Phase 14.3.2.3 — Surface Fine-Tuning & Residual Structural Decisions

Implemented.

Focus:

- remove the residual payment-specific semantic bias from the shared `InfoCard` action button contract
- keep the current Payment Methods surface stable while allowing a more neutral shared action icon API
- make an explicit and conservative decision about `barcode_widget.dart` based on real active usage in the ZIP
- avoid introducing visual or transactional scope creep

## Final Baseline After Phase 14.3.2.3

After Phase 14.3.2.3, the Payment Methods normalization line is structurally cleaner without expanding the feature beyond its current meaning:

- `InfoCard` now supports an optional `actionIcon`, so the shared widget no longer hardcodes a payment-specific action symbol as part of its generic contract
- dashboard now uses an informational bank/account-style action icon for `Ver medios de pago`, which better matches an external-payment data surface
- `barcode_widget.dart` was intentionally not integrated because the current product surface still displays the barcode value as backend-driven text and there is no active visual-barcode requirement in this exact flow
- the Payment Methods feature remains informational, backend-driven, and external-payment oriented
- the repository is now ready for formal closure of the 14.3.2 line without forcing premature checkout or barcode-visualization work

## Phase 14.3.2.4 — Payment Methods Structural Normalization Formal Closure

### Objective

Formally close the Payment Methods structural-normalization line opened in Phase 14.3 after validating that the feature boundary, overlay ownership, dashboard integration boundary, and shared-widget semantics are now aligned with the project’s modern structure.

### Implementation Characteristics

This closure does not introduce new runtime behavior.
It consolidates the now-validated architectural decisions produced across 14.3.2.1, 14.3.2.2, and 14.3.2.3:

- the Payment Methods surface is now feature-owned under `lib/features/payment_methods/`
- dashboard no longer owns the dialog implementation or popup-opening mechanics
- the feature launcher now lives on the Payment Methods side of the boundary
- the shared `InfoCard` contract is no longer implicitly payment-specific
- the existing payment-information dialog remains informational, backend-driven, and external-payment oriented
- `barcode_widget.dart` remains intentionally outside the active flow because the current feature contract does not require barcode rendering as a first-class surface element

### Final Baseline After Phase 14.3.2.4

After Phase 14.3.2.4, the repository now has a complete and formally closed Payment Methods normalization baseline:

- Payment Methods is no longer an inline dashboard-owned dialog surface
- the feature has a clear presentation/overlay ownership boundary
- dashboard consumes the feature through a feature-owned launcher instead of through local popup logic
- the current behavior remains unchanged from a product perspective: users still see backend-provided payment information for external payment channels
- the feature is structurally ready for future evolution without prematurely introducing checkout, transaction-state, provider, or gateway semantics

### Explicit Non-Goals Kept Closed

This formal closure also records what was intentionally not introduced:

- no in-app payment flow
- no checkout semantics
- no provider/state layer dedicated to payment processing
- no backend contract redesign
- no artificial presentation adapter where the current backend-fed data path is already sufficient
- no forced integration of dormant or currently unnecessary payment-visualization components

### Result

Phase 14.3.2 is now formally closed.

The Payment Methods surface has been:

- audited
- structurally extracted
- boundary-cleaned
- semantically fine-tuned
- documented as an informational feature rather than as a transactional subsystem

This leaves the repository in a cleaner state and prevents future work from having to reopen dashboard ownership questions before evolving the payment experience further.

