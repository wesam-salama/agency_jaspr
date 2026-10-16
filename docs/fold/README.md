# Fold Clothing — developer handoff

Fold is Selected Work slot 04: a self-initiated ecommerce identity and English/Arabic shopping demonstration. Run commands below from the repository root, `website/agency_jaspr/`. The working source is organized by purpose; the dated production and verification records retain their original evidence scope.

## Start here

| Document | Purpose |
| --- | --- |
| [Shared Selected Work context](../selected-work-context.md) | Approved project order, Fold chapter, shared rules and colour audit. |
| [PRODUCT.md](PRODUCT.md), [design/brief.md](design/brief.md), [design/garment-canon.md](design/garment-canon.md) | Audience, product scope and locked garments, SKUs, stock, prices and measurements. |
| [DESIGN.md](DESIGN.md), [design/direction.md](design/direction.md) | Fold's design system; `.impeccable/` holds its companion metadata. |
| [production/production-record.md](production/production-record.md) | Delivered version 1.1, authored and generated artwork, actual shopping journey and maintenance. |
| [verification/verification.md](verification/verification.md) | Executed checks and delivery limits. |

Prices, stock, garment specifications and shipping are fictional fixtures. The canonical basket is `$240 + $12 + $0 = $252` with reference `FOLD-DEMO-76895E88`. The demo creates no real payment or order. Generated garment artwork and actual implementation captures have separate source records.

## Folder guide

| Location | What belongs here |
| --- | --- |
| [design/](design) | Brief, garment canon and art direction. |
| [tools/](tools) | Preview, export, rendering, browser-check and packaging scripts. Their paths resolve from the script location. |
| [generated/](generated) | Exact generation registers for original garment and editorial images. |
| [presentation-sources/](presentation-sources) | Seven editable HTML case boards, shared CSS, rendered PNGs and paired maintenance crops; see the [board guide](presentation-sources/README.md). |
| [production/](production) | Production record, generation prompts and product/screen/presentation export inventories, plus provenance embedding inventory. |
| [production/recordings/](production/recordings) | Canonical raw EN/AR WebMs, timed JSON/Markdown checkpoints and browser trace ZIPs. |
| [verification/](verification) | Dated reports and reviews. Reports describe the checks recorded at that time. |
| [verification/store/](verification/store), [identity/](verification/identity), [agency/](verification/agency), [recording/](verification/recording) | Actual full captures, identity checks, agency checks and decoded film-frame proofs. |
| [verification/logs/](verification/logs) | Retained build/check logs and disposable per-machine preview state. |
| [Runtime/source assets](../../web/assets/selected-work/fold) | The standalone store, editable artwork, fonts, exported images, public films and source ZIP. |

The runtime asset directory contains [site/](../../web/assets/selected-work/fold/site) (`index.html`, `app.mjs`, `data.mjs`, `style.css`, state tests); [identity/](../../web/assets/selected-work/fold/identity) and [packaging/](../../web/assets/selected-work/fold/packaging) (exact SVG artwork); [source/](../../web/assets/selected-work/fold/source) (native imagery, construction SVGs, HTML identity boards and guide, manifests); [fonts/](../../web/assets/selected-work/fold/fonts) (local fonts and licences); [products/](../../web/assets/selected-work/fold/products) and [editorial/](../../web/assets/selected-work/fold/editorial) (generated concept exports); and [screens/](../../web/assets/selected-work/fold/screens) (actual implemented UI captures). [SOURCE-README.md](../../web/assets/selected-work/fold/SOURCE-README.md) explains the public editable-source package.

Agency integration lives in `lib/data/site_data.dart`, `lib/l10n/arabic_content.dart` and `lib/l10n/french_content.dart`. `test/fold_case_test.dart` protects the case's status, links and empty metrics. Preserve the shared curtain, case controls, project order, unfinished enquiry brief and Fold's truthful concept status.

## Preview and focused checks

```sh
node docs/fold/tools/preview-server.mjs
```

The foreground preview defaults to port 8804 and accepts `FOLD_PORT`. Open `http://127.0.0.1:8804/assets/selected-work/fold/site/index.html`, adding `?lang=ar` for Arabic. The server also serves an existing `build/jaspr/` at `/agency_jaspr/` and supports video range requests. `node docs/fold/tools/start-preview.mjs` is the optional detached wrapper; its log and ownership JSON are written to `verification/logs/`.

```sh
node --test web/assets/selected-work/fold/site/store.test.mjs
dart test test/fold_case_test.dart test/content_data_test.dart test/reference_copy_test.dart
```

| Check | Command and output |
| --- | --- |
| Store state and flows | `node docs/fold/tools/check-store.cjs --functional`; writes `verification/store-functional-checks.json`. `FOLD_STORE_ORIGIN` selects the preview origin. A full run also replaces captures, runtime screenshots and films. |
| Agency case | `node docs/fold/tools/check-agency.cjs`; uses `FOLD_AGENCY_ORIGIN` and writes `verification/agency-checks.json` plus `verification/agency/` captures. |
| Agency enquiry | `node docs/fold/tools/check-agency-enquiry.cjs`; verifies unfinished EN→AR→FR brief retention without submitting. |
| Viewer and compiled HTTP routes | `node docs/fold/tools/check-delivery.cjs`; requires the compiled agency and writes `verification/delivery-checks.json`. |
| Extracted source archive | `node docs/fold/tools/check-package.cjs`; checks ZIP integrity, forbidden state/cache paths and actual extracted store/guide behavior. |
| Fonts and identity | `python3 docs/fold/tools/check-fonts.py`; `node docs/fold/tools/check-identity.mjs`. |

Browser tools write reports and may replace retained captures. Inspect their configured scope before rerunning a historical comparison. The delivery, enquiry and maintenance tools use the original port-8804 URL. Browser/image tooling references the original Mac's bundled Playwright/Sharp, Chrome, FFmpeg and Impeccable paths; adapt those on another workstation. The delivered store needs only a static HTTP server.

## Regeneration and packaging

| Tool | Purpose |
| --- | --- |
| [export-products.cjs](tools/export-products.cjs) | Export registered native triptychs into runtime garment views and `production/product-exports.json`. |
| [render-presentations.mjs](tools/render-presentations.mjs) | Render editable case boards into PNG/WebP exports and `production/presentation-exports.json`. Supply board names to limit scope; `--ready` skips missing inputs. |
| [document-design.py](tools/document-design.py) | Refresh Fold's `.impeccable/design.json` from `DESIGN.md`. |
| [finalize-provenance.py](tools/finalize-provenance.py) | Embed raster origin prompts and write `production/generation-prompts.json` and `production/provenance-embedding.json`. |
| [package-source.py](tools/package-source.py) | Refresh editable asset metadata/manifest and replace the public ZIP. Docs evidence bytes are preserved. |
| [check-final-files.py](tools/check-final-files.py) | Compare source/build/manifest bytes, protected assets and archive integrity, and fully decode both films. Requires the matching production build and FFmpeg/FFprobe. |

Refresh the download with `python3 docs/fold/tools/package-source.py`, then run the package check. The archive keeps the portable repository layout under `Fold-Clothing/web/` and `Fold-Clothing/docs/`, including the reorganized tools and evidence directories. It excludes itself, preview state/logs, caches, browser-local state, anonymous `page@` recorder duplicates and the original `before-finish-fixes` captures. The source package report is `verification/source-package-check.json`. New source or archive bytes require fresh integrity/extraction checks. The preservation baseline is historical; reconcile it deliberately after authorized changes to earlier cases.

## Retained comparisons

The [before](verification/maintenance-before.json)/[after](verification/maintenance-after.json) maintenance records, `verification/store/maintenance-*` screenshots and paired presentation crops support the public maintenance figure. The [failure-focus-before](verification/failure-focus-before.json)/[failure-focus-after](verification/failure-focus-after.json) reports and `verification/store/failure-*` captures preserve the later recovery-focus diagnosis.

Keep the named historical folders: [verification/store/before-finish-fixes/](verification/store/before-finish-fixes), [verification/recording/before-recovery-focus-fix/](verification/recording/before-recovery-focus-fix) and [verification/agency/before-preview-route-fix/](verification/agency/before-preview-route-fix). Production records, finish reviews and provenance refer to those observations. [finish-review.md](verification/finish-review.md), [finish-verdict.md](verification/finish-verdict.md), [finish-fix-checks.json](verification/finish-fix-checks.json) and [detector-review.md](verification/detector-review.md) explain accepted corrections and project-specific design decisions. They are completed review history.
