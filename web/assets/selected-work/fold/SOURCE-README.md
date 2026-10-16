# Fold Clothing — editable local studio concept

Collection 01: Everyday Structure. Version 1.1, 15 October 2026.

The complete English/Arabic shopping demonstration runs without a server API. Serve the `web` directory over HTTP, then open `assets/selected-work/fold/site/index.html`; add `?lang=ar` for Arabic. From this checkout, `node docs/fold/tools/start-preview.mjs` opens the loopback static preview on port 8804. Prices, stock and specifications are fictional fixtures. The canonical basket totals $252. No payment, order, email or inventory deduction occurs.

- `identity/`, `packaging/`: editable exact SVG mark, care-label, hangtag and mailer artwork.
- `source/`: native generated triptychs/editorial sources, editable vector construction sheets, identity/packaging HTML boards and printable `fold-brand-guide.html`.
- `fonts/`: exact local Archivo, DM Sans and IBM Plex Sans Arabic files and licences.
- `products/`, `editorial/`: native-height garment-view exports and generated concept editorials, with exact generation/origin records.
- `site/`: implemented store, immutable integer-cent fixtures and 19 focused state tests (`node --test web/assets/selected-work/fold/site/store.test.mjs` from the package root).
- `screens/`: actual implemented EN/AR browser captures. They are distinct from generated product imagery.
- `shopping-flow.html`, `shopping-flow-{en,ar}.mp4`: actual continuous local browser journeys, accompanied by a written transcript in the viewer.
- `docs/fold/` in the source archive: `design/` for briefs; `tools/` for preview/export/check scripts; `presentation-sources/` for editable case boards; `generated/` for original image registers; `production/` for provenance/export records and `production/recordings/` for raw films, checkpoints and traces; `verification/` for reports, captures and measured maintenance comparisons. Start at `docs/fold/README.md`.

The archive retains the repository layout under `Fold-Clothing/`, so the relative image/font paths and presentation masters remain editable. From that directory, run `python3 -m http.server 8000 --directory web` and open `http://localhost:8000/assets/selected-work/fold/site/`. Browser/rendering verification scripts use the installed Codex dependency bundle and local Chrome; adjust those environment paths on another machine. No dependency download is required to use the store.

The browser-local cart uses version 1 and can be cleared within the store. Shipping words remain in memory for the current visit. Recorded sample values are test data. The packaging is authored digital artwork, and garment images are generated concepts; no physical manufacture, commercial launch, client commission or business outcome is represented. Final project verification is recorded in the repository's `docs/fold/verification/verification.md`.
