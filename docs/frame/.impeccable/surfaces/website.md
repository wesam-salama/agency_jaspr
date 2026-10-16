# Frame discovery website

## Job and mode

Persuade: help a person choose a suitable practical course, inspect the first lesson and explicitly enter the demonstration learner journey.

## Scope and authority

Target: `web/assets/selected-work/frame/site/`, including `style.css`, `app.mjs`, `data.mjs` and `index.html`. The Frame chapter and shared sections 1–7 of `docs/selected-work-context.md`, `docs/frame/design/direction-contract.md` and the implemented Frame `DESIGN.md` govern this surface. This brief records the current approved implementation on 14 October 2026; it does not choose a new direction.

## Composition and path

Home pairs the practical proposition with the authored Composition Essentials cover. It continues through the three course entries, a complete 16:9 lesson example, the Choose/Make/Continue sequence and a final course-discovery action. Courses supports discipline and level filters. Course detail presents outcome, prerequisite and equipment before commitment, then the planned curriculum and first exercise. How learning works explains the sequence. Demo enrolment creates the named shared record and provides a deliberate app handoff.

The desktop content measure is 1160px. Paired sections and the three-course grid collapse through 980/760/440px breakpoints. The mobile header wraps in document flow; below 440px covers sit above their captions and filter fields use separate full-width rows. Preserve full cover/poster content and the complete decision facts. Website/app layout and type sizes differ deliberately.

## Interaction and state

Course loading, retained filters, empty results, catalogue error/retry, missing preview, enrolment pending/error/confirmed and handoff pending/error/confirmed are separate states. A native dialog provides user-operated video, timed captions, transcript and exercise. It closes on Escape or route change, pauses media and returns focus to the origin. Catalogue filters restore their active control after updates; navigation moves focus to the new page heading.

The service response owns enrolment and saved progress. The delayed initial session read is guarded so it cannot replace an already-confirmed enrolment. The shared record shows count, next lesson and saved draft. The app URI and learner code preserve a useful fallback when local simulator invocation fails. The visible local handoff explanation is scoped to this demonstration, not hosted app-launch infrastructure.

## Language and motion

English and Arabic have the same decision path, course IDs/order and record. Arabic uses document RTL, local IBM Plex Sans Arabic, normal tracking and isolated Latin records; directional arrows change independently from the fixed symbol/artwork corners. Learner notes use automatic writing direction. Navigation and actions can expand naturally.

Actions use 180ms feedback, cover inspection 350ms and confirmed progress 200ms. Device reduction removes transitions, animations, smooth scroll and cover lift. Media starts paused. Do not add a moving selection frame merely because the original brief allowed one; the current website uses the authored hover lift.

## Evidence boundary

`docs/frame/verification/web-checks.md` and `web-checks.json` record ten browser groups and forty containment/decision-field combinations, in English/Arabic at 320/390/768/1440px. `verification/website/` contains separately captured real website views and handoff recordings. The responsive-count checks do not imply forty visual screenshot reviews. Actual simulator invocation and native continuation belong to the native/handoff record.

The produced preview is 30 seconds, with English/Arabic media, captions and transcripts. Lesson 01's eight minutes and the six-lesson course's 62 minutes are planned study values. Light for Motion and Designing with Grids are preview-only outline/workbook fixtures without produced lesson videos or demo enrolment.
