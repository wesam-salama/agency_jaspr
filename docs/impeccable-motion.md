Method: dual-agent (A: /root/restored_design_review · B: /root/restored_technical_review).

# CR8.Media motion restoration

Restored locally on 8 October 2026 in `website/agency_jaspr`. Deployment remains outside this work. This report supersedes the motion and current bundle/test counts in [the initial enhancement report](impeccable-enhancement.md).

The moving constellation, six animated service motifs, portfolio particles and case entrances return within the Connected studio layout. The clearer copy, visible imagery, illustrative framing, native enquiry controls and email-draft handoff remain.

## Selected work update — 9 October 2026

All four cases and Next now use the original Loop's full-viewport curtain: 550 ms to cover from the left, details open at 580 ms under full cover, and 550 ms to retract toward the right, using `cubic-bezier(.7,0,.3,1)`. The curtain is attached to the document body above the header and dialog, independently of image readiness or geometry. The other transition enum values and implementations are retained.

`case_navigation.dart` guards the latest delayed opening. Dismissal cancels it and restores opener focus even before the dialog opens. Resize, document hiding, and preference changes settle the requested case immediately; paused/reduced motion and unavailable animation support bypass the curtain. Tab cannot enter the inert background while opening. Current verification is recorded in [the curtain update report](selected-work-curtain.md).

The restoration inventory and captures below document the earlier 8 October implementation; its four individual case entrances have been superseded by this update.

## Change inventory

| Area | Restored behavior |
|---|---|
| Hero | Organic node drift, fine-pointer ink, proximity response and progressive service connections continue while hovering, focusing or pressing the network. Six native links remain usable; keyboard focus activates its connection. Consultancy, Web Dev and App Dev sit 7px below their existing endpoints in aligned animated/static layouts, with 64px reserved below the diagram. The “You” label stays centered 16px below the moving red hub with a page-colored background clearing the lines. Coarse-pointer service labels stay stable while decorative points move, add 8px of clearance beneath the lower endpoints and use native first-activation navigation. |
| Services | Overlapping branding circles, rotating identity ring, consultancy pulses, moving web brackets, travelling app dot and maintenance orbit. |
| Work | Sparse particles disperse on hover or keyboard focus. Project text and imagery stay visible before interaction. |
| Fenwick & Ash | Shared image expansion, 650 ms. |
| Loop | Red curtain cover/reveal, 700 ms total. |
| Marrow | Iris originating at the activation point, 650 ms. Keyboard activation uses the trigger centre. |
| Northline | Tunnel zoom and crossfade, 700 ms, plus the visible metric count-up. Assistive technology receives the final metric values. |
| Supporting effects | Logo signature stroke, moving navigation indicator, project CTA wire, service marquees beneath the hero and above the footer, process progression and contact connection drawing. |

The case heading, toolbar and focus indicators remain outside animated image presentation layers. Next uses the previous hero image for image transitions and its own button centre for the iris. The removed rail, obsolete statistics section, scroll-driven hero fade and hidden-content reveal defaults stay removed.

`MotionRuntime` owns the shared policy and one demand-driven animation-frame scheduler. CSS and SVG handle bounded effects. Document visibility, individual effect visibility and an open dialog suspend background effects. The two “Pause animations” controls share a session preference; the device's reduced-motion preference remains authoritative. Selection and colour feedback stay immediate.

Canvas resolution is capped at DPR 2, pointer trails at 40 points/600 ms and portfolio particles at 500 per card. Geometry is cached; the runtime batches layout reads before writes. Close, Next, resize, visibility/preference changes and disposal cancel transient layers and stale callbacks. Dialog focus containment, Escape dismissal and opener restoration happen immediately.

The runtime is implemented in `lib/runtime/motion_runtime.dart`, with pure policy/generation logic in `motion_state.dart` and cancellable case presentation in `case_transition.dart`. The `CaseTransition` mapping and enquiry interfaces are unchanged. No animation dependency was added. Static SVG, native links and visible imagery remain the fallback.

The original HTML and image references remain intact. Original HTML SHA-256: `7a4d4736ada6b8e624f17ef95e082e6f67fac80e21903fc52192ac1f8c803295`.

## Impeccable review

The motion restoration applied the animate and craft guidance, followed by one shared design/technical review batch. Assessment A (`/root/restored_design_review`) inspected the rendered design independently, without detector results. Assessment B (`/root/restored_technical_review`) held its technical findings until A finished. The root checked policy/failure fixtures in the same batch. Findings were corrected together, followed by one confirmation round on the final production build.

| Review | Initial result | Scope |
|---|---:|---|
| Design | **27/32 — Good (84%)** | Heuristics 7 and 10 are not applicable to this persuade surface; remaining scores: 3, 3, 4, 3, 4, 3, 3, 4. |
| Technical | **16/20 — Good** | Accessibility 3, performance 3, responsive behavior 3, theming 3, implementation integrity 4. |

| # | Design heuristic | Score | Review finding |
|---|---|---:|---|
| 1 | Visibility of system status | 3 | Visible pause/resume feedback needed; fixed. |
| 2 | Match with the real world | 3 | Illustrative photographs give limited evidence of finished work. |
| 3 | User control and freedom | 4 | Pause, cancellation and opener restoration work. |
| 4 | Consistency and standards | 3 | Service and case motion use the established identity. |
| 5 | Error prevention | 4 | Native controls and validation preserve the enquiry flow. |
| 6 | Recognition rather than recall | 3 | Move selected-service acknowledgment beside the controls; fixed. |
| 7 | Flexibility and efficiency | n/a | Persuade surface without an expert workflow. |
| 8 | Aesthetic and minimalist design | 3 | Motion remains decorative while content stays visible. |
| 9 | Error recovery | 4 | Validation and tested failure fallbacks remain usable. |
| 10 | Help and documentation | n/a | No separate product-help workflow. |
| Total | | **27/32** | **Good** |

These are pre-polish scores, not a final rescore. The earlier 31/36 design result used a different applicable set, so raw totals are not directly comparable. Neither review observed a P0/P1 issue in the tested paths.

The design review confirmed visible node movement, service animation, particle behavior, distinct case entrances, focus visibility and working pause controls. Its actionable findings were unclear visible resume feedback and the mobile service acknowledgment's distance from its checkboxes. The technical review identified short email-link touch areas and repeated canvas palette literals. The collective fix also makes profiling capability explicit and removes smooth anchor movement when motion is paused or reduced.

**Final confirmation:** both pause controls now show visible on, paused/resume or device-reduced status. The single live service acknowledgment sits beside the checkboxes. Direct email links measure 44 px high. Canvas paint reads the shared CSS palette; reduced/paused anchor navigation is immediate. The final round confirmed these fixes, five overflow-free widths, keyboard selection/redraw, interrupted Next/Escape cleanup, resize settling, focus containment/restoration and simulated device precedence. [Confirmation evidence](verification/motion-confirmation.json) records the results. The scores above remain pre-polish scores; no second design rescore was run.

One content limitation remains: the portfolio uses sector/reference photographs rather than finished identity or product artifacts. The site explicitly labels the cases, quotes, metrics, timelines and imagery as illustrative. Future verified client work would provide stronger evidence of craft; replacing the approved assets is outside this restoration.

## Compiled-HTML detector

The shared batch scanned the production HTML with its adjacent stylesheet. It returned **13 raw warnings**, retained in [motion-detector.json](verification/motion-detector.json). No rule was broadly suppressed.

| Rule | Count | Browser/source assessment |
|---|---:|---|
| cramped-padding | 5 | The services grid has padded children; three alternate sections have inset wrappers. The decorative marquee band is intentionally edge-to-edge. Rendered inspection found readable spacing. |
| all-caps-body | 4 | Repeated short service labels belong to the decorative, assistive-technology-hidden marquees. They are not long reading passages. |
| overused-font | 2 | Inter and Space Grotesk are the confirmed incumbent fonts. |
| broken-image | 1 | The dormant hidden dialog template starts with an empty image source. A real source is assigned before opening; image failures are separately checked. |
| marquee | 1 | The user explicitly requested the original moving service bands. They are decorative, pauseable and gated by reduction, page/effect visibility and modal state. |

Generated findings point to `build/jaspr/index.html` at line 0; rule snippets and selectors provide the useful context. The browser's evaluated JavaScript is read-only, so mutable detector-overlay injection was unavailable. No overlay or live-overlay server is claimed.

The final confirmation scan returned the same **13 warnings**, with the same rule counts: [motion-detector-final.json](verification/motion-detector-final.json). Exit 2 indicates detected findings, not a scan failure. No ignores were added.

## Verification

Before the collective polish fixes, formatting passed with zero changes, full Dart analysis reported no issues, **all 33 tests passed**, and the production Jaspr build succeeded. The built local site was reloaded and hydrated. The independent production browser review reported no console warnings or errors.

The tests include existing prerender/metadata, enquiry/mailto and asset coverage, plus 12 meaningful motion policy/generation cases and semantic motion markup checks. Policy tests cover pause/system precedence, visibility/modal eligibility and invalidation of stale work. Browser checks supplement these tests with actual animated presentation and focus behavior.

**Final build checks:** formatting checked 22 files with zero changes; analysis reported no issues; **all 33 tests passed**; `git diff --check` passed; the production Jaspr build succeeded. The actual local preview was reloaded and hydration confirmed through enabled case/pause controls and updated status text. The final production browser error/warning log was empty. The prerender test harness emits its known missing-client-entrypoint warning; the built site loads its compiled client script successfully. Dart 3.13.2 and Jaspr CLI 0.23.4 were retained; the CLI update notice was not applied.

The shared browser batch verified:

- No horizontal overflow at **320, 390, 768, 1024 and 1440 px**. Both independent reviews used desktop and narrow layouts; all four case entrances were inspected on desktop and at 390 px.
- Hero hover, keyboard focus and pressing keep the network moving while activating the selected service connection. The “You” label follows the hub and remains horizontally centered below it.
- All four case presentations, repeated Next/open/close actions, dismissal during motion, contained focus, Escape, inert background and opener restoration. Natural completion was explicitly checked for Fenwick; the others were checked during entry and cancellation.
- Service preselection/clearing, selection feedback, required-field and invalid-email recovery, mobile menu/Escape and the Loop chapter region's horizontal keys.
- Offscreen loops pause. Background canvas tasks and the RAF stop while the case dialog is open.

Policy and failure fixtures use compiled production output. Their overrides are confined to the fixture routes and are not application code. [The root browser evidence](verification/motion-resilience-browser.json) records these outcomes:

| Fixture | Observed outcome |
|---|---|
| Dynamic reduced motion | CSS loops pause and canvas tasks/RAF reach zero. Resuming the user toggle does not override simulated device reduction. Removing reduction resumes eligible motion. |
| Dynamic document visibility | Simulated hiding pauses loops and reaches zero tasks/RAF; becoming visible resumes eligible effects. |
| Preference change during case entry | A real running image-transition clone is removed immediately when reduction changes. The dialog remains open and usable, then Escape closes normally. |
| Scripts unavailable, 320 px | All eight sections, portfolio imagery and native navigation remain visible; the document remains 320 px wide. Enhancement controls safely stay disabled. |
| 2D canvas unavailable, 390 px | Six hero links and case controls remain available, no canvas scheduler runs, and Loop opens with an inert background and closes with Escape. |
| Images unavailable, 390 px | Marrow's meaningful alt text, title, explanatory text and illustrative disclosure remain. No transition decoration lingers; Escape restores focus and removes the inert background. |

The `imagesOffCleanup.modal` value in the raw root evidence records the dialog's `hidden` property: `true` means it is closed.

Actual OS reduced-motion settings, real hidden-tab/browser scheduling, physical or synthesized touch, 200% browser zoom and screen-reader operation were not exercised by the available automation. Native first-activation behavior and static coarse-pointer support are implemented; physical-device verification remains manual. The real OS email composer handoff remains a manual check inherited from the initial enhancement.

## Performance and payload

Measurements use the Codex in-app browser on the local machine with CSS viewport emulation. `?motionProfile=1` instruments synchronous work in the shared motion callbacks and retains up to 600 samples. Its p95 is not full render/paint time, FPS or visitor performance. Long-task counters cover observed page tasks and do not establish animation attribution.

The shared technical review recorded typical callback p95 values of **0.4–1.8 ms**, below the 8 ms target. It also recorded an isolated **81.8 ms callback maximum**, plus **16 observed long tasks with a 313 ms maximum** during browser inspection and interaction. Attribution is unknown; that batch does not establish the requested absence of animation-induced tasks above 50 ms. The separate policy-fixture warm sample recorded p95 0.5 ms/max 1.1 ms and zero observed long tasks.

**Final measurement environment:** Apple M1, 8 GiB memory, macOS 26.6.2 (25G83), Codex in-app browser, 1440 × 1000 CSS px. The browser engine version is not exposed by the inspection API. Long-task observation explicitly reports supported.

| Final sample | Rolling callback p95 | Rolling max | Observed state |
|---|---:|---:|---|
| Hero, at 08:01:27 UTC | 0.3 ms | 1.2 ms | 3,300 cumulative callbacks; one canvas task; zero observed page long tasks. |
| Work, at 08:09:37 UTC | 0.5 ms | 0.8 ms | 13,440 cumulative callbacks; two visible particle canvases. One page long task of 140 ms was recorded earlier during navigation/inspection. |

Each rolling result covers up to the latest 600 callbacks, approximately ten seconds at 60 Hz. The work measurement window ran from 08:07:46 to 08:09:37 UTC; the start was captured during anchor movement, so only the settled end sample represents the two visible canvases. A case-entry sample recorded a rolling maximum of 6.3 ms.

The sampled p95 values meet the **below 8 ms** callback-work target. The earlier 81.8 ms callback outlier remains material, and page long-task attribution is unresolved. These checks do **not** establish the absence of animation-induced tasks above 50 ms across all interactions, browsers or physical devices. A browser performance trace on a physical device remains the appropriate next check for that tail target.

| Payload | Initial enhanced site | First restoration build | Final restoration build |
|---|---:|---:|---:|
| JavaScript entry | 146,210 B | 150,452 B | 150,780 B |
| Deferred JavaScript | 40,945 B | 69,766 B | 70,743 B |
| JavaScript total | 187,155 B | 220,218 B (+33,063 B; 17.7%) | 221,523 B (+34,368 B; 18.4%) |
| CSS | 23,434 B | 30,721 B (+7,287 B) | 31,070 B (+7,636 B) |

Final HTML is 35,941 B. Its SHA-256 is `5c707807b82f29767689fdb41038d7cdacab0868fe9dcfc157dfd065cc19492c`. [Bundle sizes](verification/motion-bundle-sizes.json) retain the exact counts.
These are uncompressed file sizes, not transferred-byte or field-performance measurements. Responsive WebP assets are unchanged by this restoration; their existing size reductions remain documented in [the initial report](impeccable-enhancement.md).

## Captures and evidence

- [Desktop](verification/motion-desktop.jpg) and [mobile](verification/motion-mobile.jpg).
- [Hero frame 1](verification/motion-hero-frame-1.jpg) and [frame 2](verification/motion-hero-frame-2.jpg); these initial captures show changed positions, not calibrated FPS.
- [Work](verification/motion-work-desktop.jpg), [Fenwick](verification/motion-case-fenwick.jpg), [Loop](verification/motion-case-loop.jpg), [Marrow](verification/motion-case-marrow.jpg), [Northline](verification/motion-case-northline.jpg) and [mobile case](verification/motion-case-mobile.jpg).
- [Script failure](verification/motion-scripts-failure.jpg), [canvas failure](verification/motion-canvas-failure.jpg) and [image failure](verification/motion-images-failure.jpg).
- [Independent browser evidence](verification/motion-browser-review.json), [policy/failure browser evidence](verification/motion-resilience-browser.json), [raw detector findings](verification/motion-detector.json) and [bundle sizes](verification/motion-bundle-sizes.json).

- [Timed hero sequence](verification/motion-hero-sequence.gif): 20 captures spanning 1,266 ms.
- [Timed Loop curtain sequence](verification/motion-loop-sequence.gif): 16 captures spanning 1,850 ms, showing cover/reveal and the settled presentation.
- [Sequence timing metadata](verification/motion-sequences.json) and [final confirmation](verification/motion-confirmation.json). Capture timestamps are wall-clock observations, not a calibrated FPS recording; GIF intervals are rounded to 10 ms. GIFs are resized to 960 × 667 from the 1440 × 1000 originals.

Temporary fixture tabs were closed, viewport emulation reset, and the fixture server stopped. The production preview remains running.

PRODUCT.md, DESIGN.md, the home surface brief, editable design tokens/component documentation and README describe the restored motion and its policy. The local preview remains available at [127.0.0.1:8768](http://127.0.0.1:8768/).

Questions skipped: 2 remaining Priority Issues (illustrative portfolio evidence and unresolved performance-tail attribution); the restoration scope is already confirmed.

## Archive provenance

The snapshot was written to `.impeccable/critique/2026-10-08T08-16-22Z__build-jaspr-index-html.md` for the helper-derived target `build-jaspr-index-html`. Trend read succeeded: **20/36 → 31/36 → 27/32**. The last run uses a different applicable heuristic set and is not a like-for-like score comparison. Its score records the independent pre-polish assessment, accompanied by final confirmation evidence. The temporary snapshot body and fixture directory were removed after the write and completed checks.
