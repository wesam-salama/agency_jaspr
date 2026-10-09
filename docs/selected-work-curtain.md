# Selected work curtain — 9 October 2026

All four project cards and Next now use the original Loop full-screen red curtain. Cover takes 550 ms from the left, details open at the 580 ms timer, and reveal takes 550 ms toward the right, with `cubic-bezier(.7,0,.3,1)`. Existing case content and layouts are preserved.

The temporary curtain belongs to the document body at z-index 650, above the header and dialog. Its transaction cancels animations and the pending timer together. `CaseNavigation` permits only the latest deferred content update and commits it once. Dismissal abandons pending navigation and restores focus; resize and visibility/preference changes settle it immediately. Thumbnail geometry and image readiness do not gate this entrance.

## Verification

- **40 Dart tests passed**, including six focused tests for deferred commit, replacement, dismissal, policy settlement, reentrant navigation and disposal.
- **Dart analysis:** no issues. Formatting and `git diff --check` passed. The running Jaspr app accepted a hot reload.
- **Production build:** passed in an isolated temporary copy because the active development daemon uses incompatible build options. Jaspr CLI 0.23.4 also reserves proxy port 5567 for static builds, so a temporary CLI copy used proxy 5569 and rendering port 8083. Only that temporary CLI port constant changed; the installed CLI, running preview and project dependencies were preserved. Production output was copied back to `build/jaspr/`, excluding all test fixtures.
- **Browser checks:** 27 recorded checks across 1280×720 and 390×844 viewports. Every card and the complete Next cycle opened the correct case; content remained stable during cover and scroll reset at commit. Keyboard entry, focus wrap/restoration, Tab during pending opening, Escape during both phases, repeated Next, resize, pause, simulated system reduction/document hiding, unavailable animation support and missing thumbnail/hero images passed.
- **Timing trace:** details became visible at **588.7 ms** after activation, while the curtain covered all **1280×720 px**. The preceding full-cover sample still had the dialog hidden. Both animation durations were 550 ms with the requested easing. The small difference from the 580 ms timer reflects browser scheduling and content population.
- **Impeccable detector:** 18 warnings, matching the preceding layout-restoration snapshot exactly; no new warning signatures.
- **Reference preserved:** original HTML SHA-256 remains `7a4d4736ada6b8e624f17ef95e082e6f67fac80e21903fc52192ac1f8c803295`.

Preference, visibility and unsupported-API checks used temporary copies of the built HTML with explicit fixtures. Missing-image checks served the same client without image assets. These fixtures are outside the repository and were excluded from copied production output. Mobile verification used a narrow browser viewport; physical touch-device profiling was not performed. Deployment was outside this task.

## Evidence

- [Recorded desktop animation](verification/selected-work-curtain/loop-curtain.gif)
- [Mobile Loop details](verification/selected-work-curtain/mobile-loop.jpg)
- [Browser check states](verification/selected-work-curtain/browser-checks.json)
- [Cover/reveal frame samples](verification/selected-work-curtain/desktop-sequence.json)
- [Instrumented timing trace](verification/selected-work-curtain/timing-trace.json)
- [Detector output](verification/selected-work-curtain/detector.json)
