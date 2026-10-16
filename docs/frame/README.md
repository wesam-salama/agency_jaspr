# Frame Academy — developer handoff

Start with the current source and the shared [Selected Work plan](../selected-work-plan.md). The final agency order is **Sift → Form → Frame → Fold**. Frame occupies slot 03. The Frame production and verification reports describe the completed 13–14 October 2026 delivery; their references to protecting Northline or navigating Frame → Northline predate Fold replacing slot 04. Use those reports for the recorded Frame evidence, not as the current agency ordering contract.

Frame is a self-initiated studio concept with an English/Arabic discovery website, Flutter learning demonstration and shared local service. Composition Essentials has six planned lessons and 62 planned study minutes; lesson 01 has produced 30-second media in each language. Opening or playing a lesson never completes it. Saved drafts and explicit completion must be acknowledged by the shared service. The demonstrated journey ends at 1 of 6, survives app restart and continues to lesson 02.

## Open the folder for your task

| Folder | Open it to work on |
| --- | --- |
| [design/](design/) | Identity specification, approved direction and lesson script |
| [app/](app/) | Flutter app, native platform projects and app tests |
| [service/](service/) | Shared demonstration API, persistence and service tests |
| [Website](../../web/assets/selected-work/frame/site/) | English/Arabic course discovery implementation |
| [Artwork](../../web/assets/selected-work/frame/source/) | Editable SVG/HTML course covers, workbooks and lesson source |
| [production/](production/) | Production/provenance records, capture map, film edit decisions and recording sources |
| [presentation-sources/](presentation-sources/) | Editable case boards and rendered proofs |
| [tools/](tools/) | Preview, packaging, checking and film-edit scripts; `artwork/` holds artwork export tools |
| [verification/](verification/) | Check reports and reviews; `website/`, `native/`, `agency/`, `artwork/` hold proof captures, `logs/` holds command logs |
| [history/](history/) | Completed integration helpers retained as historical text |

`README.md`, `PRODUCT.md` and `DESIGN.md` stay at the project entrance. Public case images, films and downloads retain their existing URLs under `web/assets/selected-work/frame/`.

## Read before editing

| Purpose | Authoritative files |
| --- | --- |
| Approved brief, identity, fixtures and future edit boundaries | [Shared context](../selected-work-context.md), shared sections 1–7 and Project 03; [current plan](../selected-work-plan.md) |
| Product and interaction contract | [PRODUCT.md](PRODUCT.md), [direction-contract.md](design/direction-contract.md) |
| Tokens, typography, layout, RTL, focus and states | [DESIGN.md](DESIGN.md), [native design](app/DESIGN.md), [scoped design data](.impeccable/design.json) and [surface briefs](.impeccable/surfaces) |
| Identity and authored lesson | [identity-spec.md](design/identity-spec.md), [lesson-script.md](design/lesson-script.md) |
| Delivered scope and limitations | [production-record.md](production/production-record.md), [verification.md](verification/verification.md), [finish-review.md](verification/finish-review.md), [agency-finish-review.md](verification/agency-finish-review.md) |
| Website, native and edited film evidence | [web-checks.md](verification/web-checks.md), [native-verification.md](verification/native-verification.md), [film-verification.md](verification/film-verification.md) and their linked JSON records |
| Editable artwork, rights and provenance | [asset production](verification/artwork/production-record.md), [asset verification](verification/artwork/verification.md), [source README](../../web/assets/selected-work/frame/source/README.md), [asset manifest](../../web/assets/selected-work/frame/source/asset-manifest.json), [generation prompts](production/generation-prompts.json), [font provenance](verification/artwork/font-provenance.json) |

## Source map

Paths below are relative to the agency repository root. Keep their layout stable: render helpers, manifests, source packages and evidence records use these paths.

| Area | Location and responsibility |
| --- | --- |
| Standalone website | `web/assets/selected-work/frame/site/`: `index.html`, `app.mjs`, `data.mjs`, `style.css`; `data.test.mjs` covers course fixtures |
| Native app | `docs/frame/app/`: `lib/`, `test/`, `assets/`, platform projects and `pubspec.yaml`/`pubspec.lock`; [setup](app/README.md) |
| Shared local service | `docs/frame/service/`: server, immutable catalogue, atomic learner store and tests; [API and capture setup](service/README.md) |
| Editable identity and course materials | `web/assets/selected-work/frame/source/`: SVG masters, HTML workbooks/exercise sheets, print CSS, PDF exports and source manifest |
| Lesson, captions and fonts | `web/assets/selected-work/frame/media/` and `fonts/`; retain editable `source/lesson-film.html`, the original teaching image and font licences |
| Agency presentation | Top-level Frame WebP exports and responsive variants in `web/assets/selected-work/frame/`; editable board HTML in `docs/frame/presentation-sources/`; [capture map](production/capture-map.json), [export record](production/export-record.json), `tools/compose-exports.cjs` |
| Agency integration | `lib/data/site_data.dart`, `lib/l10n/arabic_content.dart`, `lib/l10n/french_content.dart`, shared case model/runtime/styles and `test/frame_case_test.dart` |
| Public source download | `web/assets/selected-work/frame/frame-source.zip`, built by `docs/frame/tools/package-source.py`; [public source README](../../web/assets/selected-work/frame/SOURCE-README.md), [package record](verification/source-package-check.json) |
| Companion recordings download | [frame-recordings.zip](../../web/assets/selected-work/frame/frame-recordings.zip) contains the original MP4/WebM verification recordings and film-edit segments. Extract both ZIPs into the same directory for the complete handoff; each archive stays below GitHub's 100 MiB file limit. |

The completed `integrate-agency.py`, `update-agency-tests.py`, `frame_case_test.dart.staged` and `finalize-status.py` helpers are preserved as non-executable text copies in [history/](history/README.md). Read them for implementation history; edit the current agency files directly. In particular, the staged test differs from the current `test/frame_case_test.dart`, and restoring/rerunning an old integration helper can overwrite later Fold-era changes.

## Run and check

From the agency repository root, start the service with Node's standard library:

```sh
node docs/frame/service/server.mjs
```

Open `http://127.0.0.1:8803/assets/selected-work/frame/site/`. The Arabic reserved learner is available at `?lang=ar&learner=demo-ar#courses`. The service also serves an existing agency production build at `http://127.0.0.1:8803/agency_jaspr/`. `FRAME_PORT` changes the service port, but existing app/capture defaults must then be adjusted too. `FRAME_SIMULATOR_ID` selects the installed iPhone simulator for the optional local app-open bridge.

Run the focused website/service tests from the repository root:

```sh
node --test docs/frame/service/state.test.mjs docs/frame/service/handoff.test.mjs web/assets/selected-work/frame/site/data.test.mjs
dart test test/frame_case_test.dart test/content_data_test.dart test/site_document_test.dart
```

From `docs/frame/app/`, resolve Flutter dependencies, run checks and launch the chosen simulator:

```sh
flutter pub get
flutter test
flutter analyze
flutter run -d <your-iPhone-simulator-id>
```

The app defaults to `http://127.0.0.1:8803`; `--dart-define=FRAME_API=http://YOUR_HOST:8803` selects another API address. See [app setup](app/README.md) for platform details. Actual native delivery was verified on the named iOS simulator; Android/macOS source availability does not establish successful runs on those targets.

`node docs/frame/service/browser-checks.mjs` exercises the local website with the isolated `demo-web-test` learner. Set `FRAME_PLAYWRIGHT` to an installed Playwright package path when using another runtime. Native/XCTest, asset exports, agency browser captures and full build checks require the environment setup described below and in the linked reports. The historical reports record earlier executed checks; this index does not rerun or extend those results.

## Evidence and recording edits

- Final website, native and agency evidence live in `verification/website/`, `verification/native/` and `verification/agency/`. Their named JSON records, screenshots and raw recordings establish what actually ran. Keep canonical raw films used by `journey-edit-{en,ar}.json` and referenced from `journey-record-{en,ar}.json`.
- `journey-edit-en.json` and `journey-edit-ar.json` are editable cut/speed decisions. `python3 docs/frame/tools/edit-journey.py en` or `ar` rebuilds a complete film with FFmpeg; `production/recording-sources/en/` and `ar/` contain reproducible intermediate segments and text. `production/recording-sources/qa/` holds final semantic-frame/contact-sheet checks referenced by the film records.
- `before*` and `failed*` folders are historical captures, not current acceptance evidence. Preserve any folder explicitly referenced by a verification/provenance record or used as an edit source, including `verification/website/before-read-race-fix/`, `production/recording-sources/before-final-read-race-fix/` and `verification/agency/before-scroll-margin-fix/`. Keep the surrounding record if pruning an unreferenced diagnostic artifact.
- Capture helpers can overwrite proof files. `service/capture-web.mjs` deliberately resets the reserved `demo`/`demo-ar` learners; coordinate complete web/native recaptures. `service/capture-shared.mjs` is the documented read-only follow-up. Native helpers arm controlled failures and drive real UI; do not run them merely to preview the project.
- Live `service/data/demo-state.json` is local learner state, ignored by Git and excluded from the handoff ZIP. Preserve existing proof learners while inspecting their recorded journeys; use another learner for experiments.

## Local helper limits and cleanup

The runtime website, app and service are project sources. Several production/capture helpers retain the original Mac's paths and are not drop-in commands on a new machine:

- `tools/compose-exports.cjs`, agency/browser capture scripts and most `tools/artwork/*.mjs` helpers reference the bundled Playwright/Sharp runtime under `/Users/wesamsalama/.cache/codex-runtimes/`; several also select `/Applications/Google Chrome.app/...` directly. Only `service/browser-checks.mjs` currently exposes the `FRAME_PLAYWRIGHT` override.
- Asset helpers including `render-artwork.mjs`, `render-lesson.mjs`, `export-workbooks.mjs`, `render-pdf-proofs.py`, `compose-pdf-proofs.mjs`, `embed-provenance.py` and `generate-manifest.py` resolve the repository from their script location where supported; some retain original machine-specific runtime paths. PDF proof rendering also names the original bundled `pdftoppm`; provenance helpers name the original Impeccable launcher.
- `app/tool/native-proof.mjs` hardcodes a simulator UUID. `run-native-ui-proof.mjs`, `run-native-handoff.mjs` and the retained `.xctestrun` configurations name local build paths. Regenerate a runner with Xcode/`xcodebuild build-for-testing`, install the intended app and confirm kernel parity before recording; update those local paths/UUIDs for another Mac. The service's `FRAME_SIMULATOR_ID` does not override the separate proof helper constant.
- Coordinated request capture uses `/tmp/frame-*` flag files; native screenshot copies also expect `/tmp/frame-*.png`. `tools/start-preview.mjs` creates a detached local service and temporary preview PID/log records. These are execution details, not application requirements.

Disposable files include Flutter `app/build/`, `app/.dart_tool/`, generated plugin/dependency metadata, ignored IDE files, generated platform `ephemeral/` files, generated `Generated.xcconfig`/`flutter_export_environment.sh`, Android `local.properties`, Python `__pycache__/` and preview PID/log records. Flutter and local tooling recreate them. Keep authored platform projects, `pubspec.lock`, the native test source, editable assets, font licences and all evidence records needed to explain the final result.

After changing packaged source or retained evidence, run `python3 docs/frame/tools/package-source.py` to refresh both public ZIPs and their checksum record. The source archive retains runnable code, public lesson/journey media, editable artwork, screenshots and textual proof records; the companion retains the original recordings without recompression. The script intentionally excludes caches and live learner state. `check-final-files.py` additionally expects a current `build/jaspr` containing every Frame public file and checks an older protected-file baseline; interpret that baseline against the current selected-work plan before treating later authorized project changes as regressions. Preserve the local-delivery boundary: a local build or source package does not establish deployment, app-store publication or commercial results.
