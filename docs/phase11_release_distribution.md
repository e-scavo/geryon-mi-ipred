# Phase 11 — Release & Distribution

## Objective

Open the next justified engineering layer after the completion of Phase 10.2.

The repository is no longer primarily constrained by:

- architecture
- runtime ownership
- UX consistency
- responsive normalization
- capability exposure completeness

It is now constrained by the absence of a formal release/distribution baseline that turns the already working product into a consistently versioned and reproducible deliverable.

## Initial Context

The current ZIP confirms all of the following as already closed baselines:

- Phase 7 — Application Layer Consolidation
- Phase 8 — Runtime Reliability & Failure Semantics
- Phase 9 — Product Surface Consistency & UX Hardening
- Phase 10 — Product Capability Completion

Phase 10.2 completed the controlled exposure of the supported financial capability surface through the dashboard.

That means the application is now functionally complete for the current scope:

- dashboard exposes FacturasVT
- dashboard exposes RecibosVT
- dashboard exposes DebitosVT
- dashboard exposes CreditosVT
- runtime and architecture baselines remain intact
- no UX/layout/reflow reopening is justified

The next natural concern is therefore not product expansion but release readiness.

## Problem Statement

The application is operational and in use, but the repository still showed release fragility before this phase opened:

- version data was duplicated without strong synchronization rules
- release automation was too narrow and partially coupled to old assumptions
- Android distribution required App Bundle support as first-class output
- release metadata still contained retained generic branding values in the code version surface
- build flow was not yet documented as the active next baseline of the project

This is a release engineering problem, not a product behavior problem.

## Scope

Phase 11 covers:

- release/versioning normalization
- reproducible build commands
- Android/Web artifact generation baseline
- preparation for packaging/distribution work
- release documentation updates aligned with the real repository state

Phase 11 does not cover:

- new billing or dashboard features
- runtime redesign
- state ownership changes
- layout redesign
- responsive changes

## Root Cause Analysis

Earlier phases were correctly focused on:

- structure
- orchestration boundaries
- runtime hardening
- product-surface consistency
- capability exposure completion

Because those layers consumed the dominant engineering risk, release engineering remained secondary.

Once 10.2 closed capability exposure, that postponement became the next real bottleneck.

## Phase Structure

### Phase 11.1 — Build & Versioning Standardization

First release baseline.

Focus:
- synchronize version sources
- standardize Web/APK/AAB builds
- remove outdated fixed-branch assumptions from release automation
- align version metadata branding

### Phase 11.2 — Packaging & Artifact Structuring

Second release baseline.

Focus:
- copy generated artifacts into a stable dist root
- rename Android artifacts using product-aware versioned names
- preserve a versioned Web output folder
- generate release manifests for the produced artifact set

### Phase 11.3 — Distribution Readiness & Publication Surface Validation

Third release baseline.

Focus:
- align public Web metadata with Mi IP·RED branding
- validate structured release outputs against application and signing expectations
- document the local Android signing contract for reproducible operator setup
- prepare store-facing metadata handoff without publishing yet

### Expected Later Subphases

The repository may continue later with justified release/distribution steps such as:

- deployment pipeline formalization
- store submission execution
- release verification matrix
- smoke-test and approval workflow

Those later steps must remain incremental and evidence-based.

## Constraints

The following constraints remain mandatory under all Phase 11 work:

- do not reopen Phase 7 architecture
- do not reopen Phase 8 runtime semantics
- do not reopen Phase 9 layout/responsive baselines
- do not reinterpret Phase 10.2 as permission for new product behavior
- do not move ownership away from established feature/controller surfaces under the label of release work

## Impact

Positive impact of opening Phase 11:

- the project gets a formal release engineering baseline
- version drift is reduced
- Web and Android builds become easier to reproduce safely
- future distribution work gains a stable documentary and technical foundation

Risk if this phase did not open now:

- repeated manual release steps
- inconsistent versions across artifacts
- accidental history mutation from outdated automation assumptions
- slower path to Play-distribution readiness

## Validation

Phase 11 is correctly opened only if the current ZIP supports all of the following:

- Phase 10.2 is complete
- the product-facing capability surface is already coherent
- the next justified concern is release/distribution rather than product redesign
- the repository contains enough build/versioning surfaces to justify a normalization baseline

The current ZIP supports that reading.

## Conclusion

Phase 11 is now the correct next layer for Mi IP·RED.

It does not reopen product work.
It industrializes the already working product.

The correct initial subphase is therefore 11.1 — Build & Versioning Standardization.
