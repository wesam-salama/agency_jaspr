# Form Architecture — project guide

Form is Selected Work slot 02: a self-initiated identity and responsive website/editor demonstration. Start here when editing the project. Run the commands below from the agency repository root (`website/agency_jaspr/`).

## Find the right folder

| Folder or file | Open it for |
| --- | --- |
| [PRODUCT.md](PRODUCT.md), [DESIGN.md](DESIGN.md), [.impeccable/](.impeccable) | Product contract, design system and token definitions. |
| [design/](design) | Visual direction, public website behavior and editor decisions. |
| [production/](production) | Delivery scope, image generation prompts and export records. |
| [presentation-sources/](presentation-sources) | Editable case-board HTML compositions and rendered PNGs. |
| [verification/](verification) | Behavioral reports, audits and review records; `website/` and `agency/` contain screenshots, and `logs/` contains command output. |
| [tools/](tools) | Identity/export generation, browser checks and source packaging scripts. |
| [site/](../../web/assets/selected-work/form/site) | Public website (`index.html`, `app.js`, `data.js`, `style.css`), editor (`editor.html`, `cms.js`, `cms.css`), baseline and Node tests. |
| [source/](../../web/assets/selected-work/form/source) | Editable identity SVGs, rendered identity proofs and provenance manifests. |
| [studies/](../../web/assets/selected-work/form/studies) | Native generated study images, runtime WebPs and editable concept diagrams. |
| [fonts/](../../web/assets/selected-work/form/fonts) | Font originals/subsets and licences. Shared Arabic fonts remain in `web/assets/fonts/`. |
| [Form public assets](../../web/assets/selected-work/form) | Runtime case boards and variants, `details/` exports, [source download](../../web/assets/selected-work/form/form-source.zip) and [download guide](../../web/assets/selected-work/form/SOURCE-README.md). |

[Shared Selected Work context](../selected-work-context.md) records approved content and integration requirements. Agency case copy is in `lib/data/site_data.dart` and `lib/l10n/`; integration tests are in `test/form_case_test.dart` and the shared content/reference tests.

English is the content master. The standalone website supports EN/AR and its agency case supports EN/AR/FR. Architecture studies, business facts and the starting identity are fictional fixtures. The editor publishes only in the current browser; the enquiry produces an explicitly not-sent demo receipt.

## Preview and check

```sh
python3 -m http.server 8797 --bind 127.0.0.1 --directory web
```

Open `http://127.0.0.1:8797/assets/selected-work/form/site/index.html`; add `?lang=ar` for Arabic. `editor.html` and `baseline.html` are beside it. Use an isolated browser context for editor fixtures because the editor and public page share local storage.

```sh
node --test web/assets/selected-work/form/site/public-site.test.mjs web/assets/selected-work/form/site/cms.test.mjs
dart test test/form_case_test.dart test/content_data_test.dart test/reference_copy_test.dart
node docs/form/tools/check-public.cjs
node docs/form/tools/cms-browser-checks.cjs
```

Browser tools require Playwright and Chrome. `check-public.cjs` and `cms-browser-checks.cjs` accept `FORM_PREVIEW_URL`. `check-agency.cjs` accepts `FORM_AGENCY_ORIGIN` and `FORM_AGENCY_BASE` and checks the compiled agency. `check-package.cjs` expects the extracted archive at `http://127.0.0.1:8798/package/`. `final-file-checks.py` expects the production build served under `/agency_jaspr/` on port 8798.

## Rebuild the source download

```sh
python3 docs/form/tools/package_source.py
```

This packages the current website, artwork, fonts and organized records without rewriting image bytes, provenance or reports. Extracted records keep this folder hierarchy under `records/`. The archive adjusts Arabic font URLs for independent use.

For artwork changes, `build-identity.py` creates SVG masters, `render-identity.cjs` renders their proofs, and `compose-exports.cjs` creates case-board HTML/PNG and runtime WebPs using real captures. `finalize-assets.py` embeds provenance, updates manifests/font records and then packages the source. Use these generation commands only when regenerating artwork is intended; direct SVG edits must also be reflected in generating definitions.

Some generation/browser tools retain workstation-specific Codex runtime, Impeccable CLI and Chrome paths. The standalone website needs only an HTTP server. Historical reports, captures and logs describe their recorded checks; rerun affected checks after implementation changes and retain evidence supporting the published case.
