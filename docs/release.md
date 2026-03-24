# Release

## Current release state

Product:
- **Mi IP·RED**

Technical package:
- `geryon_web_app_ws_v2`

Current supported targets:
- Web
- Android

Deferred target:
- iOS

Current product state:
- functional
- production in use
- structurally safer after Phase 5 runtime-core decomposition

---

## Current engineering focus

This stage is not focused on store publishing changes.

The current focus is:
- preserve runtime stability
- keep documentation aligned with real code
- move from runtime-core refactor to safer next-phase cleanup
- avoid unnecessary changes to backend-sensitive flows

---

## Release-readiness note

Phase 5 was an internal maintainability phase.

Its objective was:
- not to change visible product behavior
- not to alter backend contracts
- not to redesign UX
- but to reduce internal risk inside `ServiceProvider`

That means release validation after this phase should focus on regression checks rather than feature-delta checks.
