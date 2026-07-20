# Phase X — Cross-Phase Corrections Baseline

## Objective

Establish a permanent, independent workstream for corrections that are justified by the real repository but do not belong to the numbered phase currently in progress.

Phase X is not the next numbered phase, does not replace the active roadmap, and does not reopen already closed phases by default. It is a controlled cross-phase lane for incidents, regressions, runtime failures, compatibility corrections, and narrowly justified structural repairs whose urgency or subject is external to the active phase.

## Repository Baseline Confirmed by the Initial ZIP

The initial Phase X ZIP confirms a Flutter + Riverpod customer frontend with an established feature/shared structure and a centralized ServiceProvider runtime model.

The relevant existing implementation includes, among other components:

- `lib/models/ServiceProvider/data_model.dart`
- `lib/models/ServiceProvider/startup_auth_continuation_coordinator_model.dart`
- `lib/models/ServiceProvider/init_stages_enum_model.dart`
- `lib/features/auth/controllers/login_controller.dart`
- `lib/features/auth/presentation/login_widget.dart`
- `lib/shared/overlays/global_loading_dialog.dart`
- `lib/shared/overlays/global_loading_dialog_route.dart`
- `lib/models/ServiceProviderConfig/popup_widget.dart`
- `lib/core/config/config_loader.dart`

The repository also confirms that numbered product work has progressed beyond the closed Phase 14 baseline and into Phase 15 operational enablement. Phase X must therefore remain independent of that numbered progression.

## Phase Identity

The canonical identifier is:

- **Phase X**

Its documentary location is:

- `docs/tasks/`

Its own index is:

- `docs/tasks/index.md`

Phase X tasks use a sequential three-digit task number:

- `001_...`
- `002_...`
- `003_...`

The sequence identifies the order of Phase X interventions only. It does not imply a new product phase or alter the numbering of ordinary phases.

## Admission Criteria

A task belongs to Phase X when all of the following are true:

1. The issue is real and confirmed by the current ZIP, logs, reproduction evidence, or directly related code.
2. The issue is outside the explicit scope of the numbered phase currently in progress, or must be corrected without delaying/redefining that phase.
3. The correction can preserve the repository's existing architectural contracts.
4. The work has a precise owner, validation boundary, and documentary closure.

Typical Phase X work includes:

- startup regressions
- login duplication or stale navigation
- runtime recovery failures
- ServiceProvider connection/retry defects
- configuration/rebootstrap defects
- provider invalidation regressions
- release-blocking compatibility errors
- narrowly scoped production defects unrelated to the active product phase
- corrections required after an earlier implementation when reopening the original phase would distort the roadmap

Phase X must not become a catch-all for arbitrary enhancements.

## Source-of-Truth Contract

For every Phase X intervention:

- the newly attached ZIP is the only implementation source of truth
- prior conversations provide design philosophy only
- prior solutions must never override the actual code in the ZIP
- the complete relevant flow must be reconstructed before code is changed
- existing owners and coordinators must be identified before adding logic
- no parallel coordinator may be introduced when a responsible owner already exists

If the ZIP answers a question, no clarification is required.

## Required Analysis Contract

Before implementing a Phase X correction, the analysis must include the complete related path, not only the reported file.

For startup/auth/runtime work this includes, as applicable:

- configuration loading
- ServiceProvider construction and initialization
- transport/WebSocket lifecycle
- backend validation
- retry counters and manual retry state
- authentication requirement evaluation
- login presentation and completion
- loading overlay behavior
- startup boundary completion
- runtime recovery entry point
- provider invalidation/reboot behavior
- navigation safety
- error and diagnostic logging

All callers and continuations affected by a modified contract must be reviewed.

## Startup and Runtime Ownership Contract

The repository already contains centralized ServiceProvider and startup/auth continuation concepts. Phase X corrections must preserve that direction.

The expected conceptual flow is:

`Config Loader -> ServiceProvider.init() -> backend connection -> backend validation -> login when required -> startup boundary completion`

Runtime recovery must re-enter the same canonical startup path rather than build a second recovery flow.

The loading overlay may present and drive the startup state, but it must not become a second source of ServiceProvider truth.

## Login Exclusivity Contract

A Phase X correction involving login must preserve a global single-login invariant:

- at most one interactive login route may be alive
- route ownership must be centralized in the runtime/startup owner
- widgets must not implement competing local or static exclusion flags
- stale login continuations must not mutate a newer recovery/startup cycle
- runtime recovery must invalidate and safely dismiss an obsolete login before starting a new loading/recovery surface
- login completion must be navigation-safe and must not abandon cleanup merely because another route temporarily covers it

When the concrete ZIP does not yet implement a generation/token mechanism, its introduction must be justified against the real continuation paths and integrated at the central owner rather than patched into widgets.

## Navigation Safety Contract

Navigation changes must not execute directly during:

- widget build
- synchronous provider notification
- a locked Navigator transition
- a stale asynchronous continuation

The implementation must use the repository's existing deferred-navigation mechanism or an equivalent safe post-frame/microtask boundary.

## Configuration and Retry Contract

When automatic connection retries reach the configured limit:

- automatic retry must stop
- the UI may expose manual retry and configuration actions
- manual retry must restart the complete canonical bootstrap, not only the socket
- the configuration popup may persist settings and close itself
- the configuration popup must not independently own or trigger a competing bootstrap
- the central startup/loading owner resumes initialization after configuration completion

The exact implementation must always be derived from the attached ZIP.

## Logging Contract

New or modified failure paths must retain useful diagnostic evidence.

Where applicable, logs must include:

- class/function or `WhereAmI`
- origin/trigger
- error message
- captured stack trace
- current stack trace when useful
- startup stage
- recovery state
- generation/token when present

Empty catches are not permitted.

## Implementation Contract

Each Phase X task must:

- correct the problem at the responsible owner
- preserve existing public contracts unless a coordinated change is required
- review every related call site
- avoid duplicated state and hardcoded styling
- reuse Theme, constants, shared widgets, and existing abstractions
- detect and correct directly related secondary defects when safely justified
- avoid unrelated refactors
- keep the numbered phase in progress logically untouched

## Documentation Contract

Every Phase X intervention must add one task document under `docs/tasks/` and update `docs/tasks/index.md`.

Each task document must contain, at minimum:

- objective
- initial ZIP baseline
- problem statement
- scope and exclusions
- complete flow/owner analysis
- root cause
- files affected
- implementation details
- related secondary corrections
- validation performed
- risks and compatibility impact
- final state

When a task changes a canonical project-level contract, the relevant root documentation must also be updated. Ordinary Phase X corrections should not rewrite historical phase documents.

## Delivery Contract

Each implementation delivery must contain:

- a partial ZIP only
- only modified or new files
- original repository paths preserved
- the new Phase X task document
- the updated `docs/tasks/index.md`

The full project must never be returned.

## Initial Phase X State

This task creates the Phase X governance and documentary baseline only.

No runtime or application source code is modified in this initialization task because the user has not yet reported a concrete defect to correct in this repository iteration.

The next Phase X task must start at `002` and must be grounded in the next supplied ZIP and issue evidence.
