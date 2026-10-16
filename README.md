# CR8.Media agency website — Jaspr

A static Jaspr/Dart agency website built around the Connected studio direction: dark surfaces, signal red, the existing fonts, sharp edges, and a connecting-line motif. The original `../agency_website.html` remains unchanged as a reference.

The site has three complete language editions: English at `/`, Arabic at `/ar/`, and French at `/fr/`. Arabic uses a right-to-left document layout; all three pages keep the same section anchors and four case studies.

## Selected Work developer handoff

Start with the [Selected Work handoff](docs/selected-work/README.md) for the current Sift → Form → Frame → Fold selection, shared context, per-project source maps, setup/check commands and evidence retention rules. Each project groups its design contracts, production records, tools and verification evidence into folders, with a developer README under `docs/sift/`, `docs/form/`, `docs/frame/` and `docs/fold/`. Dated delivery sections below preserve the scope at the time of each replacement; the handoff and current plan describe the final four-project state.

## Architecture

The Jaspr components, typed localized content, and stylesheet are the source of truth. They replace the former reference generator and `lib/generated/agency_markup.dart`; there is no markup-regeneration step.

- `lib/app.dart` composes the page and hydrated browser runtime.
- `lib/components/site_sections.dart` owns the shared page shell, navigation, case dialog, and component helpers; `lib/components/sections/` holds one Jaspr part file per page section.
- `lib/site_document.dart` supplies each page's language, direction, title, description, and stylesheet; the header renders the language links.
- `lib/l10n/site_content.dart` selects a typed `SiteContent` for each route; its Arabic, French, and UI-text parts provide complete translated strings. `lib/data/` and `lib/models/` retain shared services and illustrative project identities.
- `lib/runtime/` enhances navigation, the service constellation, case exploration, animation, and enquiry preparation.
- `web/assets/styles.css` owns the implemented visual system and responsive layouts.

Jaspr is configured with `mode: static`. Build output contains prerendered HTML for all three routes and client JavaScript; hosting needs static-file serving, not a running Dart backend. Section anchors, four case slots and the supported case-layout renderers remain part of the page contract. Sift uses sticky chapters, Form uses split, Frame uses four horizontal chapters, and Fold uses the statistics family with narrative/figures, empty metrics and no results strip.

## Languages and enquiry

The header language selector uses native links and works before hydration or with JavaScript disabled. On an enhanced switch, the current section is retained. An unfinished enquiry is passed through same-tab temporary storage, restored once on the destination page, and removed from storage. If storage fails, the site keeps the brief on the current page and explains how to continue. A direct visit to the main URL always opens English.

English keeps the approved reference wording outside the user-authorised Sift, Form, Frame and Fold replacements. Existing Arabic agency copy retains its professional Gulf voice; Sift's international case uses clear professional Arabic. French uses professional “vous.” Project identities, numbers, timescales, and illustrative claims retain their source meaning. Page metadata, image descriptions, labels, validation, live messages, case details, and the `mailto:` draft use the selected language. User-written brief text is copied verbatim into the email draft. The site does not send the email.

## Motion

`lib/runtime/motion_runtime.dart` owns dynamic device motion preferences, viewport suspension and a single demand-driven frame scheduler. The hero restores organic service points, drawn connections and a bounded fine-pointer trail. Six animated service SVGs, visible-image portfolio particles, two service bands and supporting linework retain the original creative vocabulary.

All four project cards and Next use the reference Loop's full-screen red curtain: 550 ms to cover from the left, details open at 580 ms, then 550 ms to retract to the right. `lib/runtime/case_transition.dart` owns the temporary viewport layer and animations; `case_navigation.dart` guards the delayed opening. Close cancels pending navigation and restores opener focus; resize and visibility/preference changes immediately reveal the latest requested case. Device reduced motion bypasses the curtain. The existing transition enum and image expansion, iris and tunnel implementations remain available.

Motion follows the device's reduced-motion preference without manual pause controls or stored overrides. Ambient effects suspend when offscreen, while the document is hidden, and behind an open case dialog. Content, SVG and imagery are prerendered and visible without motion or client enhancement.

The footer uses one wrapping row beneath its marquee, with the logo, grouped email/Back to top links, and copyright. It follows the reference's 28px vertical padding and 18px logo height while retaining 44px link targets and responsive wrapping.

For local profiling, append `?motionProfile=1` to the preview URL. Hidden `#agencyRuntime` data attributes report sampled callback costs, frame/task counts and observed long tasks. These measure the local browser run and do not establish device or field performance.

## Content and enquiry semantics

All four authored Selected Work projects are self-initiated studio concepts. Fictional product/course/study fixtures are separate from the actual artwork and local implementation evidence. No customer quotation, business-performance metric or real commissioning client is represented. Service durations, process timings and engagement terms remain examples rather than commitments. The original HTML and dated reference-restoration records remain preserved historical inputs; the subsequent authorised replacements supersede all four old example cases.

The enquiry action prepares an encoded `mailto:` draft addressed to `hello@cr8.media`. Visitors review and send it in their email app; this website does not deliver messages or confirm receipt. Name, email, and a project goal are required; services and rough timing are optional. The visible email address supplies an alternative when browser enhancement or an email-app handoff is unavailable.

## Sift Selected Work study

Sift Coffee replaces Fenwick & Ash in slot 01 only. Four sticky chapters reveal the Selected Line identity, the three-product range, English/Arabic label hierarchy and applications. The card says Studio concept; case metadata identifies a self-initiated studio project and Design study format, with 2026 as the study year. No client quotation or performance metrics are attached. Public copy leads with the finished craft, while coffee-fixture and production boundaries remain in the brand guide/source records.

`CaseStudy.downloads` supplies localized PDF/ZIP links with descriptive accessible labels. The Sift guide and editable artwork live under `web/assets/selected-work/sift/` as `sift-brand-guide.pdf` and `sift-artwork.zip`. The six case images share that directory. Keep exact names Everyday, Daybreak and After Hours across English, Arabic and French. The original HTML and legacy reference assets remain unchanged. `test/sift_case_test.dart` covers status, metadata, translations and card semantics; the reference-copy tests still protect every remaining original case.

## Local assets

Fonts are served from `web/assets/fonts/` with `font-display: swap`. Arabic uses Regular and SemiBold from [IBM's Plex Sans Arabic source](https://github.com/IBM/plex/tree/master/packages/plex-sans-arabic/fonts/complete/woff2), licensed under the SIL Open Font License in `web/assets/fonts/IBM-Plex-Sans-Arabic-OFL.txt`. The preserved CR8 mark is `web/assets/cr8-logo.svg`.

`lib/utils/image_assets.dart` maps legacy JPEG paths and Sift WebP paths to local sources, responsive `srcset` candidates, and intrinsic dimensions. Sift card/hero variants use 480px, 960px and full-size widths; its detail boards use 960px and full size. Original JPEG assets remain available as references. The legacy `loop-phone.jpg` contains a captured 404 response; its metadata deliberately aliases the valid Loop onboarding photo rather than displaying that broken asset.

These asset changes reduce file payloads locally. They are not field measurements, Core Web Vitals results, or deployment evidence.

## Develop and build

Run these commands from `website/agency_jaspr` with Dart 3.11 or newer and Jaspr CLI 0.23.4:

```sh
dart pub global activate jaspr_cli 0.23.4
dart pub get
jaspr serve
```

The development server uses `http://localhost:8080` by default.

```sh
dart format --output=none --set-exit-if-changed lib test
dart analyze
dart test
jaspr build
```

`jaspr build` writes static output to `build/jaspr/`. Verify `index.html`, `ar/index.html`, and `fr/index.html`, plus their locale metadata and asset links. A successful local build does not publish the site.

## GitHub Pages

The site publishes to https://wesam-salama.github.io/agency_jaspr/ through `.github/workflows/deploy-pages.yml`. The workflow analyzes and tests the project, builds it with Dart 3.13.2 and Jaspr CLI 0.23.4, and uploads only `build/jaspr/`. Pushes to `main` deploy automatically; the workflow also supports manual runs.

The build sets `SITE_BASE_PATH` from GitHub Pages metadata. This emits a document base URL so Jaspr's client script, styles, fonts and images load beneath the repository path. Locale links then resolve to `/agency_jaspr/`, `/agency_jaspr/ar/`, and `/agency_jaspr/fr/`. Builds without this define retain root-hosting behavior with `/`, `/ar/`, and `/fr/`.

To build for this repository locally:

```sh
dart pub global run jaspr_cli:jaspr build --dart-define=SITE_BASE_PATH=/agency_jaspr/
```

With GitHub CLI authenticated, enable Pages once using the GitHub Actions source:

```sh
gh api --method POST repos/wesam-salama/agency_jaspr/pages -f build_type=workflow
```

For later deployments and status checks:

```sh
git push origin main
gh run list --workflow deploy-pages.yml --limit 5
# Alternatively, rebuild the current main branch manually:
gh workflow run deploy-pages.yml --ref main
```

Confirm a successful deployment run and open the live URL before treating a release as published.

## Firebase Hosting

Hosting is configured in `firebase.json` to serve only `build/jaspr/`. The default project in `.firebaserc` is `cr8-media-agency`. Each deployment runs `dart pub global run jaspr_cli:jaspr build` first; a failed build cancels deployment. Hidden build files and Firebase's local deployment cache are excluded from upload or version control. Navigation uses section anchors, so Hosting has no catch-all rewrite.

**Provisioning status (2026-10-08):** Google Cloud rejected creation of the dedicated project because the signed-in account has reached its project quota. The local configuration records the intended project ID; the Firebase project and live website have not been created. Keep this as a dedicated project and resolve the account's project quota before publishing.

On another machine, install the Firebase CLI with `npm install -g firebase-tools`, run `firebase login`, and complete the Dart/Jaspr setup above. Run all commands below from `website/agency_jaspr`.

After the project quota is resolved, create the project once:

```sh
firebase projects:create cr8-media-agency --display-name "CR8 Media" --non-interactive
```

Google Cloud does not accept the dot in `CR8.Media` as a project display name. The website retains its CR8.Media branding. If the project ID is unavailable, append a timestamp and update `.firebaserc` to the actual ID returned by the CLI.

Publish the site, or redeploy later changes, with:

```sh
firebase deploy --only hosting
```

After a successful deployment, the expected default URL is `https://cr8-media-agency.web.app` (or the actual project ID if it changed). Confirm the Hosting URL printed by the CLI and verify it in a browser before reporting it as live. Hosting does not require a Firebase SDK or a running Dart server, and the enquiry flow still prepares a `mailto:` draft.

## Design workflow and detector

Read `PRODUCT.md` for product truth and constraints, `DESIGN.md` for the design system, and `.impeccable/surfaces/home.md` for the homepage brief before changing the interface. Preserve the original HTML reference and keep the final implementation consistent with these documents.

The project-local `.agents/skills/impeccable` is a symlink to the existing installation at `/Users/wesamsalama/.agents/skills/impeccable`; it does not duplicate the skill. The official Impeccable installer generated `.codex/hooks.json` with a `PostToolUse` detector for `Edit|Write|apply_patch` and a `Stop` deep pass. Shared Impeccable hook configuration is enabled. Installation consent is distinct from Codex hook trust.

Automatic hooks are **configured, but their activation in the current desktop chat has not been verified**. This chat is rooted in `/Users/wesamsalama/Desktop/Agency`; the manifest and its relative command belong to the nested app. Open a Codex chat or CLI session rooted in `/Users/wesamsalama/Desktop/Agency/website/agency_jaspr` so that the app's project configuration and launcher path are available.

In an app-rooted CLI session, use `/hooks` to review the two Impeccable hook definitions and trust them if approved. Project-local hooks also require a trusted project configuration layer. New or changed hook definitions need review again. No hook trust, project trust, or global security setting is granted by these project files. See the [official OpenAI Hooks documentation](https://learn.chatgpt.com/docs/hooks).

The generated manifest retains the installer's commands. On this machine the launcher can use engine 0.1.11 in its standard user cache, `/Users/wesamsalama/.impeccable/bin/0.1.11/impeccable`. Other developers need an existing Impeccable installation and must repair the local symlink for their machine.

The per-edit detector does not analyze Dart component markup. Build the page and scan its HTML together with the adjacent stylesheet for a complete manual pass:

```sh
/Users/wesamsalama/.agents/skills/impeccable/scripts/impeccable \
  detect --json build/jaspr/index.html
```

Exit code `0` means no findings; `2` means findings were reported. This manual compiled-HTML scan remains necessary for Dart UI changes and covers verification in the current parent-rooted chat. Browser inspection is still required for keyboard, dialog, form, responsive, zoom, and reduced-motion behavior.

## Enhancement verification

See [the motion restoration report](docs/impeccable-motion.md) for the restored effects, measured runtime costs, captures and current verification limits. [The initial enhancement report](docs/impeccable-enhancement.md) records the preceding content, accessibility and asset work.

## Reference copy and process parity

The eight page sections retain the original HTML wording, including process deliverables, engagement terms and Studio values. Sift's authorised replacement has its own study copy and tests. The enhanced contact controls and shared case curtain remain. The process uses the original 70%-viewport scroll formula, a continuous 2px rail, reversible dots, 250ms/300ms ease transitions and the 860px geometry breakpoint. Tests compare preserved typed/rendered copy to `test/fixtures/reference_copy.json`, captured from the unchanged reference, and cover process progress boundaries and reverse scrolling. See [verification](docs/reference-copy-timeline.md).

## Form Selected Work study

Form Architecture replaces Loop in slot 02 with a split case in English, Arabic and French. The authored rebrand retains the name/open-frame cue, and the fictional baseline uses the same Courtyard House, Line Studio and Shore Library studies. Its standalone responsive website and local project editor are implemented in English and Arabic. The contextual enquiry preserves drafts and previews a not-sent demo receipt; the project editor publishes in browser-local storage. This is a self-initiated project, with no commissioned/built architecture or external launch claim.

The complete source is `web/assets/selected-work/form/`; open `site/index.html`, `site/editor.html` or `site/baseline.html` through an HTTP server. The production agency case links to those destinations and `form-source.zip`. `CaseDownload.isDownload` keeps Sift’s downloads while opening Form’s HTML pages. Actual screenshots, source/provenance records, scoped Form PRODUCT/DESIGN/sidecar and reproducible public/CMS/agency checks are in `docs/form/`. See [production](docs/form/production/production-record.md) and [verification](docs/form/verification/verification.md).

Local production preview: `http://127.0.0.1:8798/agency_jaspr/`. Sift assets and the original reference are byte-preserved; Marrow/Northline, CR8 identity, curtain and agency email-draft flow remain unchanged. This historical Form record is superseded for slot 03 by the Frame delivery below; Fold is completed by the later local delivery record below.

## Frame Academy — local delivery

Frame replaces Marrow in Selected Work slot 03 with four horizontal chapters in EN/AR/FR. It is a Studio concept with editable identity artwork and bilingual course workbooks, a responsive discovery site, one captioned/transcribed lesson and a running Flutter iOS learning demo. The recorded EN/AR journeys use shared enrolment, drafts and explicit progress; failure/retry and cold restart restore 1 of 6 and continue at lesson 02. Media duration is 30 seconds; planned study remains 8 minutes for lesson 01 and 62 for the course.

Run `node docs/frame/tools/start-preview.mjs` from the repository to keep the loopback preview running independently of a terminal session, or use `node docs/frame/service/server.mjs` in a terminal. Then open both local previews:

- Agency build: `http://127.0.0.1:8803/agency_jaspr/` (requires the production build below).
- Frame discovery: `http://127.0.0.1:8803/assets/selected-work/frame/site/`.
- Native app: `docs/frame/app/README.md` supplies simulator setup; the shared API defaults to port 8803.

The source package `web/assets/selected-work/frame/frame-source.zip` excludes build caches and learner state; a fresh learner starts at 0 of 6. Current local proof learners demo/demo-ar intentionally retain their recorded 1-of-6 exercises. [Production](docs/frame/production/production-record.md) and [verification](docs/frame/verification/verification.md) link actual captures, two short journey films, test/build records, provenance and scoped limits. Sift/Form assets, Northline, the original HTML, CR8.Media identity, curtain and enquiry are preserved. This is local production, with no push, deployment or app-store release.

## Fold Clothing — local delivery

Fold replaces Northline in Selected Work slot 04 in English, Arabic and French. Its statistics case combines narrative and five figures without metrics, an empty results strip or a testimonial. Fold's editorial identity, editable packaging and generated garment artwork remain inside its own visual system; CR8.Media, Sift, Form, Frame, the shared curtain, locale/focus behavior and agency enquiry are preserved. Earlier dated Form/Frame paragraphs retain their historical preservation boundaries.

Run `node docs/fold/tools/start-preview.mjs`, then open:

- Agency production: `http://127.0.0.1:8804/agency_jaspr/#work`
- Fold English: `http://127.0.0.1:8804/agency_jaspr/assets/selected-work/fold/site/`
- Fold Arabic: `http://127.0.0.1:8804/agency_jaspr/assets/selected-work/fold/site/?lang=ar`
- Recorded journeys: `http://127.0.0.1:8804/agency_jaspr/assets/selected-work/fold/shopping-flow.html`

The complete EN/AR store covers URL filters, exact garment/colour/size/SKU decisions, half-width measurements, stock limits, versioned browser-local cart, Undo, clear cart, retained cart/shipping through controlled failure and retry, simulated checkout and deterministic confirmation. The canonical basket is $240 + $12 demonstration shipping + $0 test tax = $252. No payment, real order or email occurs. Version 1.1 includes an actual observed and checked keyboard-maintenance improvement.

Editable sources, native generated imagery, licensed fonts, actual captures/recordings and reproducible checks are in `web/assets/selected-work/fold/` and `docs/fold/`; `fold-source.zip` retains portable repository-relative paths. See [production](docs/fold/production/production-record.md), [verification](docs/fold/verification/verification.md), [source guide](web/assets/selected-work/fold/SOURCE-README.md) and the printable editable brand guide at `source/fold-brand-guide.html`. This is verified local digital production, with no public deployment or physical-device/manufacturing claim.
