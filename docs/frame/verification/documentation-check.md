# Frame documentation check

14 October 2026. Scan-mode documentation of the implemented, user-approved Frame system. The approved “The next frame” direction was reused; no new direction interview or application edit was part of this pass.

This pass writes only `docs/frame/DESIGN.md`, `docs/frame/.impeccable/design.json`, the three scoped surface briefs under `docs/frame/.impeccable/surfaces/` and this file. Frame owns those documents. The CR8.Media root PRODUCT/DESIGN/sidecar remain the agency context and were preserved. The existing native `docs/frame/app/DESIGN.md` was read and retained.

The extraction read the shared sections 1–7 and complete Frame chapter of `docs/selected-work-context.md`, Frame PRODUCT/direction/identity context, the Impeccable skill/document reference, current website CSS/interaction/content, native theme/interaction/content/session code, workbook CSS and the original SVG masters. Geometry and text were inspected with XML parsing without printing embedded font data. The current desktop English website, Arabic mobile website, native lesson capture and English workbook contact board were opened for a source/document spot-check.

Normative primitive values live in the DESIGN frontmatter. The schema-version-2 sidecar extends them with role metadata, preview-only tonal ramps, exact authored web shadows/motion, breakpoints, representative framework-free components and narrative. The native field snippet translates only explicit fill/border/radius/focus values; native floating-label, keyboard, text metrics and platform semantics remain in Flutter. No generated snippet is evidence of a running native screen.

| Documentation check | Result / scope |
| --- | --- |
| YAML / canonical format | Passed. YAML parsed with Ruby; exactly eight canonical sections, 18 source colors, 18 implemented type roles and ten component variants. |
| Component primitive references | Passed. All 32 references resolve; component properties remain within the portable eight-property schema. |
| Color/source parity | Passed. All documented solid primitives occur in current website/workbook CSS or explicit native Color declarations, including White. |
| Sidecar ownership | Passed. Frontmatter owns primitive scales; keyed color/type metadata align. Eight-step OKLCH ramps are synthesized panel previews, not new shipping palette choices. |
| Component previews | Passed. Ten scoped snippets have balanced CSS blocks, locally resolvable token fallbacks, inline SVG and no framework/package or embedded-image dependency. No browser rendering of the live documentation panel was claimed. |
| Narrative mapping | Passed. North Star, full philosophy, five characteristics, four source-derived rules and Do/Don't text map directly to DESIGN.md. |
| Exact mark geometry | Passed. SVG has a 100-unit viewBox, the two original paths, 12-unit stroke, butt endpoints and miter joins. The current native painter uses matching butt endpoints and the same shape/orientation. |
| Responsive/source values | Passed. Website 980/760/440px and workbook 700px breakpoints, native 660px measure, separate app crops and task-specific type sizes are recorded from code. |
| Focus / direction / motion | Passed as extraction. Web focus/restoration and immediate device-reduction rules are explicit in CSS/JS; native focus/semantics/route builders and left-to-right transport are named according to source. Recorded device verification is a separate scope. |
| Local fonts / notices | Passed. All eight CSS font URLs resolve. Native original TTFs and all three OFL notices exist in their declared project folders. The font-provenance register is linked. |
| Surface jobs | Passed. Website Persuade, app Operate and workbooks/transcripts Read are persisted in scoped briefs; agency case Experience stays inside the retained shell. |
| Curriculum/media truth | Passed. Produced media is 30 seconds; lesson 01 is eight planned study minutes and the six-lesson course is 62 planned minutes. Later lesson media is explicitly unavailable. |
| State truth | Passed as extraction. Confirmed draft, explicit completion, pending save, retained failure/retry and edits during a save are distinguished from playback. |
| Agency preservation | Passed. Root PRODUCT.md, DESIGN.md and `.impeccable/design.json` hashes match the pre-write snapshot below. |
| Whitespace | Passed. `git diff --check` for the scoped documentation. |

The supplied [website verification](web-checks.md) and [artifact verification](artwork/verification.md) were read, not rerun. They record ten browser groups, forty containment/decision-field combinations, separate visual captures, real HTTP checks, focused Node tests, all 40 PDF pages and exact 30-second media probes. The source/document spot-check is not a new forty-screen visual audit or an independent Arabic/WCAG certification.

Native final handoff, controlled failure/retry, cold launch, learner continuity, device text scaling, keyboard and reduced motion belong to their actual device/journey record. The original extraction did not claim those checks as completed. The final native continuation now records both English/Arabic cold handoffs, failure/retry, explicit1-of-6 completion and real app restart in [native-verification.md](native-verification.md); keyboard/focus,1.6× text scale and disableAnimations are separately scoped widget checks. `verification/native/qa-course-zero.png` was read only as an actual player/style capture. Final integrating evidence may extend the file inventory and completion record without changing this distinction.

The source cap mismatch found during extraction was resolved by retaining the verified SVG master's butt endpoints and aligning native painting/specification to it. Website/native Arabic UI titles were also aligned to the shared catalogue during the implementation finish. The later workbook practice headings retain authored equivalent Arabic phrasing; English titles/IDs/order/study times and lesson 01's Arabic title remain canonical. These were implementation-owner changes, not documentation edits. No unresolved token or identity drift was found in the checked sources.

Root agency preservation hashes at the original extraction:

- `PRODUCT.md`: `0d1f21359cdc523161f5250422deeef9fb5878fec58d469e39e71400d07ba7ce`
- `DESIGN.md`: `0fd5be8c156c991ac65ab06aa9a1e7d07b811360de0ff3ba54a0405ba462e3d5`
- `.impeccable/design.json`: `69a98e7d21af96e79115d77f6eed0e3fac1092d9d46b485198642af6b910b914`

The original extraction performed syntax/reference/source/file-existence/geometry/hash checks only. It did not rebuild the app or agency, run application tests, publish a site, certify physical print production, verify a commercial synchronization service or claim real learners, paid enrolment, instructor review or business results.

## Final native source recheck

The scoped DESIGN narrative and sidecar were rechecked against the final `app/lib/main.dart`, `app/lib/session.dart` and `app/ios/Runner/SceneDelegate.swift`, without rerunning detection or editing the root agency system. Arabic heading/title/body/label roles explicitly use `letterSpacing: 0`; natural shaping, mixed-script isolation and text scaling remain. CourseArt uses the text-free composition photograph with a localized title overlay at its two documented app ratios, so no course-cover text is cropped. Cold/warm UIScene links forward to app_links, and Dart validates the exact route with a one-second duplicate guard. Requested-learner/read-generation checks and write-time read invalidation preserve linked learner/progress authority; delayed-response tests cover the reviewed races.

The sidecar adds source-truth metadata under `extensions.nativeImplementation`; existing primitive tokens, component previews and agency ownership are unchanged. The app README records actual local setup, registered course URI/SceneDelegate behavior, eleven focused tests and the precise native/widget verification split. JSON syntax, source references and scoped `git diff --check` passed. The native report owns final build/kernel/recording provenance; this recheck does not turn local widget checks into certification.
