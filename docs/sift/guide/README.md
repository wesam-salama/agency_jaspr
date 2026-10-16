# Sift Coffee brand-guide handoff

Open [the project folder guide](../README.md) for artwork, production and website verification. This folder holds the guide documentation, reports and proof images; its executable tools live in [tools/guide/](../tools/guide).

Completed outputs:

- `web/assets/selected-work/sift/sift-brand-guide.html` - editable, responsive and printable guide; native self-hosted type; source-artwork links relative to the public asset directory.
- `web/assets/selected-work/sift/sift-brand-guide.pdf` - 12 A4 pages exported from the guide, with page numbering and no added browser headers/footers.
- `docs/sift/guide/proofs/guide-01.png` through `guide-12.png` - all final PDF page proofs.
- `docs/sift/guide/proofs/lockup-visible-320px.png`, `lockup-visible-176px.png`, `wordmark-small-visible-64px.png`, `selected-line-48px.png` and `selected-line-24px.png` - inspected digital scale explorations at device pixel ratio 1.
- `docs/sift/guide/proof-report.json` - measured layout, asset, font, colour and size evidence.
- `docs/sift/guide/source-register.md` - source/provenance record, scoped generation prompts and the factual verification record.
- `docs/sift/tools/guide/render-guide.cjs` - local rendering and verification script. It requires the bundled runtime and isolated Chromium/localhost access.
- `docs/sift/tools/guide/fix-pdf-links.py` and `portable-links-report.json` - reproducible post-export link correction and destination evidence. All 14 PDF annotations preserve the HTML's authored relative paths.

The guide covers positioning and voice; primary, stacked, reverse and small wordmark applications; exact i-stem clear space; digital size exploration; all six colours with actual contrast roles; Fraunces, Manrope and IBM Plex Sans Arabic; the exact five-rule Selected Line; canonical product hierarchy; bilingual artwork; 250 g and 1 kg handling; eight application families; and inspectable source handoff.

Size recommendations measure nominal visible wordmark artwork, separately from a padded SVG container. The complete monochrome master needs a 284 px container for approximately 176 px visible width. The small master needs 79 px for approximately 64 px visible width. The primary horizontal wordmark/symbol SVG has different padding and needs its own container calculation.

All 12 pages and five digital size proofs were visually inspected. The final guide has 18 successfully loaded images, 14 resolved handoff links, four loaded font faces, six calculated colour pairings and no detected content/footer overlap. Ten confirming page rasters were byte-identical to the first reviewed batch; changed pages 4 and 11 were reviewed again.

The PDF's 14 URI annotations were subsequently made portable by preserving relative `source/...` and `fonts/...` hrefs, with every sibling destination verified. No localhost URL or temporary port remains. A focused page-12 raster after this annotation-only correction was byte-identical to the previously reviewed page. Keep the guide beside its `source/` and `fonts/` directories when extracting the archive.

No physical print minimum, production dieline, translation approval, coffee sourcing/tasting, manufacturing, business-name clearance or commercial launch is claimed. These remain production gates stated in the guide.

To rebuild the guide from the repository root:

```sh
node docs/sift/tools/guide/render-guide.cjs
```

This refreshes the public PDF, applies portable link repair, then writes `proof-report.json`, `portable-links-report.json` and `proofs/` here. The authored HTML and its sibling assets remain under `web/assets/selected-work/sift/`.
