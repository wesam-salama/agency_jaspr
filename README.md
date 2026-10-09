# CR8.Media agency website — Jaspr

A static Jaspr/Dart agency website built around the Connected studio direction: dark surfaces, signal red, the existing fonts, sharp edges, and a connecting-line motif. The original `../agency_website.html` remains unchanged as a reference.

## Architecture

`lib/components/site_sections.dart` owns the page's Jaspr components. It replaces the former reference generator and `lib/generated/agency_markup.dart`; edit the components, typed content, and stylesheet directly. There is no markup-regeneration step.

- `lib/app.dart` composes the page and hydrated browser runtime.
- `lib/site_document.dart` supplies the document language, title, description, and stylesheet.
- `lib/data/site_data.dart` and `lib/models/site_models.dart` hold services and illustrative project content.
- `lib/runtime/` enhances navigation, the service constellation, case exploration, animation, and enquiry preparation.
- `web/assets/styles.css` owns the implemented visual system and responsive layouts.

Jaspr is configured with `mode: static`. Build output contains prerendered HTML and client JavaScript; hosting needs static-file serving, not a running Dart backend. Section anchors and the four case layouts remain part of the page contract.

## Motion

`lib/runtime/motion_runtime.dart` owns dynamic motion preferences, synchronized pause controls, viewport suspension and a single demand-driven frame scheduler. The hero restores organic service points, drawn connections and a bounded fine-pointer trail. Six animated service SVGs, visible-image portfolio particles, two service bands and supporting linework retain the original creative vocabulary.

All four project cards and Next use the reference Loop's full-screen red curtain: 550 ms to cover from the left, details open at 580 ms, then 550 ms to retract to the right. `lib/runtime/case_transition.dart` owns the temporary viewport layer and animations; `case_navigation.dart` guards the delayed opening. Close cancels pending navigation and restores opener focus; resize and visibility/preference changes immediately reveal the latest requested case. Pause and reduced motion bypass the curtain. The existing transition enum and image expansion, iris and tunnel implementations remain available.

The hero and footer share a **Pause animations** toggle. Device reduced motion takes precedence; storage failures retain a working page-level preference. Content, SVG and imagery are prerendered and visible without motion or client enhancement.

For local profiling, append `?motionProfile=1` to the preview URL. Hidden `#agencyRuntime` data attributes report sampled callback costs, frame/task counts and observed long tasks. These measure the local browser run and do not establish device or field performance.

## Content and enquiry semantics

Projects, client names, quotes, outcomes, service durations, process timings, and engagement terms are illustrative examples. They are not verified client evidence or business commitments. The user approved exact reference wording and removal of visible example labels on 9 October 2026. Preserve this copy choice while retaining internal illustrative classification; approval of supplied copy does not verify its claims.

The enquiry action prepares an encoded `mailto:` draft addressed to `hello@cr8.media`. Visitors review and send it in their email app; this website does not deliver messages or confirm receipt. Name, email, and a project goal are required; services and rough timing are optional. The visible email address supplies an alternative when browser enhancement or an email-app handoff is unavailable.

## Local assets

Fonts are served from `web/assets/fonts/` with `font-display: swap`. The preserved CR8 mark is `web/assets/cr8-logo.svg`.

`lib/utils/image_assets.dart` maps the existing JPEG content paths to local WebP sources, responsive `srcset` candidates, and intrinsic dimensions. Variants use 480px, 960px where applicable, and full-size widths. Original JPEG assets remain available as references. The legacy `loop-phone.jpg` contains a captured 404 response; its metadata deliberately aliases the valid Loop onboarding photo rather than displaying that broken asset.

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

`jaspr build` writes static output to `build/jaspr/`. A successful local build does not publish the site.

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

The eight page sections and four case studies now use the original HTML wording, including process deliverables, engagement terms and Studio values. The enhanced contact controls and shared case curtain remain. The process uses the original 70%-viewport scroll formula, a continuous 2px rail, reversible dots, 250ms/300ms ease transitions and the 860px geometry breakpoint. Tests compare typed and rendered copy to `test/fixtures/reference_copy.json`, captured from the unchanged reference, and cover process progress boundaries and reverse scrolling. See [verification](docs/reference-copy-timeline.md).
