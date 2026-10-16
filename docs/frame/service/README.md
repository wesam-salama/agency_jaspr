# Frame local demonstration service

The responsive discovery website and the installed Frame Academy iPhone app use this single local service. The course catalogue is an authored studio fixture. Enrolments, exercise notes, sample-attachment choices and explicit lesson completion are persisted per demo learner in `data/demo-state.json`.

From the agency project root, run:

```sh
node docs/frame/service/server.mjs
```

Open `http://127.0.0.1:8803/assets/selected-work/frame/site/`. The default learner is `demo`; `?lang=ar&learner=demo-ar#courses` opens the Arabic proof learner. Language switching keeps the selected learner. A new learner has no enrolment and 0 of 6 lessons complete. The website's app link contains the same course ID, learner code and language. The installed iPhone simulator app recognizes `frameacademy://course/FA-PH-01?learner=demo&lang=en`.

The service binds to this computer's loopback address. It uses Node's standard library and serves only the project's `web/` files. It never serves `docs/`, the saved learner JSON or source code from the service directory. The `/agency_jaspr/` prefix serves the production `build/jaspr/` preview when present, allowing the agency case and Frame demonstration to share a working local origin. Static hosting alone does not supply this demonstration API. No remote account, paid enrolment, authentication, instructor review or commercial synchronization is claimed.

The local **Open Frame app** action calls `POST /api/handoff`. After validating the demo learner, exact course ID and `en`/`ar` language, the service calls `xcrun simctl openurl` with separate arguments and the configured iPhone simulator. It acknowledges the request only after that process succeeds. iOS may still ask the learner to choose Open; the website says that the app-open request was sent, without claiming that the confirmation was accepted. The default simulator UUID is `8BDFE212-1DE0-4F67-928E-65C3E9B24533`; a different installed simulator can be selected with `FRAME_SIMULATOR_ID`. This optional bridge works on this Mac's installed simulator; it is not a hosted app-launch service. Remote browser origins are rejected. If the simulator is unavailable, the website retains the enrolled course, shows retry feedback and keeps the direct app URI and learner code available.

| Operation | Request | Successful response |
| --- | --- | --- |
| Catalogue | `GET /api/catalogue` | `{courses: [...]}` with the three exact fixtures |
| Learner record | `GET /api/session?learner=demo` | Session including enrolments, completed lesson IDs, drafts and revision |
| Demo enrolment | `POST /api/enrol` | Session after enrolment is durably written |
| Exercise draft | `POST /api/draft` | Session after the note and sample-attachment choice are durably written |
| Explicit completion | `POST /api/complete` | Session after the exercise and lesson completion are durably written |
| Local simulator handoff | `POST /api/handoff` | Acknowledged `xcrun` request and the exact learner/course/language app URI |
| Controlled recovery check | `POST /api/test/fail-next` | Arms one `503` on the learner's next draft/completion request |
| Reset a demo learner | `POST /api/test/reset` | New session at 0 of 6; other learners remain unchanged |

Mutation bodies include `learner`. Enrolment includes `courseId: "FA-PH-01"`. Draft/completion bodies include `lessonId: "01"`, `note` and a Boolean `attachment`. Completion requires a non-empty note or the sample attachment. Opening the video never writes completion. IDs `01`–`06` are accepted; only Composition Essentials has demo enrolment.

Changes are serialized. A complete proposed session is written to a temporary file and renamed into place before the API confirms success. Failed writes preserve the previous session. A failed request does not replace a client-held draft: the app retains the note and retries the same exercise. The failure control affects one exercise mutation, not enrolment. Learner state survives restarting either the app or the service. Saved exercise records are ignored by Git and should be excluded from the editable-source handoff.

Run the focused catalogue/state tests:

```sh
node --test docs/frame/service/state.test.mjs docs/frame/service/handoff.test.mjs web/assets/selected-work/frame/site/data.test.mjs
```

`browser-checks.mjs` checks catalogue states, course decision content, keyboard preview/focus restoration, explicit enrolment, shared progress, Arabic learner continuity, 40 language/view/viewport combinations, text expansion and reduced motion. It uses the isolated `demo-web-test` learner. Set `FRAME_PLAYWRIGHT` to an installed Playwright package path if using a different runtime. `capture-web.mjs` captures actual screens and EN/AR web handoff recordings; it deliberately resets the reserved `demo` and `demo-ar` proof learners before enrolling them. Coordinate those recordings with native-app captures so each complete proof follows one consistent session.

After the native exercise and cold-restart checks pass, preserve those proof learners. `capture-shared.mjs` is the read-only follow-up: it compares the final native session JSON with the service record, checks the website's exact note, 1-of-6 progress and lesson 02, captures desktop/mobile screens and verifies that the record remained unchanged. It rejects any page API mutation. Run each language explicitly:

```sh
FRAME_CAPTURE_LANG=en node docs/frame/service/capture-shared.mjs
FRAME_CAPTURE_LANG=ar node docs/frame/service/capture-shared.mjs
```

The full-page `shared-progress-*.png` screenshots retain the enrolment context. `saved-record-desktop-*.png` and `saved-record-mobile-*.png` show the actual shared record at a readable scale, with the surrounding page margin retained for Arabic glyphs. The matching JSON records name their native source, capture time and GET-only page requests. These screenshots do not invoke app handoff, reset, save or complete an exercise.

For a strict cold-start handoff capture, arm `node docs/frame/service/capture-ready-request.mjs en` (or `ar`) before starting the native helper. It writes `/tmp/frame-web-request-waiting.json` and waits for a newly created `/tmp/frame-handoff-ready` flag. Only then does the real website Open action run from the already enrolled learner at 0 of 6. `/tmp/frame-web-request-completed.json` records the capture result. The watcher does not reset or enrol a learner; the native helper separately proves foreground course acceptance.
