# Sift Coffee guide - source and proof register

This register covers only the brand-guide artifact and its digital proof pack. It does not establish physical manufacturing, brewing validation or a commercial launch. Identity masters and application artwork are authored separately by the Sift identity owner; this guide consumes them without modifying their geometry.

## Governing sources

- `docs/selected-work-context.md`, global contract and complete Project 01 chapter: approved strategy, names, palette, five-rule motif, products, bilingual scope and eight application families.
- Public authored identity/application SVGs under `web/assets/selected-work/sift/` and `source/`: exact logo and label artwork, not generated lettering.
- `web/assets/selected-work/sift/fonts/`: self-hosted Fraunces and Manrope files and OFL notices. Exact source URLs and download provenance are recorded by the font/asset owner.
- Existing `web/assets/fonts/ibm-plex-sans-arabic-regular.woff2` and `-semibold.woff2`: Arabic display in the guide. Keep their source/licence record with the project handoff.

## Guide outputs

| Artifact | Path | Provenance / purpose |
|---|---|---|
| Editable guide | `web/assets/selected-work/sift/sift-brand-guide.html` | Authored HTML/CSS, native local fonts, actual linked vector artwork. |
| Portable guide | `web/assets/selected-work/sift/sift-brand-guide.pdf` | Chromium PDF export from the HTML source; 12 A4 pages intended. |
| Rendering / checks | `docs/sift/tools/guide/render-guide.cjs` | Reproducible local renderer and fixture/asset checks. |
| Portable PDF link correction | `docs/sift/tools/guide/fix-pdf-links.py` | Restores authored relative hrefs after Chromium export; annotation values only. |
| Portable link report | `docs/sift/guide/portable-links-report.json` | Verification of all 14 relative destinations and unchanged page-12 raster. |
| Page proof images | `docs/sift/guide/proofs/guide-01.png` through `guide-12.png` | PDF page rasterizations used for visual inspection. |
| Digital proof report | `docs/sift/guide/proof-report.json` | Actual final font, asset, page count, overflow and contrast checks. |

Rows become completed only after the paths exist and the proof report confirms the current source. Until then they are reserved outputs.

## Status language and boundaries

- Authored logo, label and application SVGs are **designed concept artwork**.
- The guide is a **designed and digitally checked artifact** once all pages pass inspection.
- Native-size digital samples are size explorations, not physically verified printing minima.
- Bilingual layouts and visible Arabic shaping do not establish independent translation approval.
- The sample coffee data and recipe remain fictional. No tasting, supplier, market, certification, research or sales result is invented.
- HEX contrast applies only to exact solid colours. Photographs, opacity, textured materials and print require separate checks.
- Format drawings have provisional geometry; supplier dielines are required for production.

## Generation prompts

**Guide refinement:** Load the approved Sift chapter, current guide HTML, linked vector masters and final proof report. Change only `{requested_sections}`. Preserve the actual logo geometry, exact product names, tagline punctuation, five-rule motif, six HEX colours, type families and evidence boundaries. Export 12 A4 pages. Return source changes and a new page proof record; never add claims of physical printing or business results.

**Packaging scene:** Load `{approved_artwork}` and `{approved_content_records}`. Generate a warm-paper, softly lit base scene with `{objects}` in `{composition}` and `{dimensions}`. Do not invent label typography, Arabic, dates, batch values, certificates or extra logos. Apply exact supplied artwork after scene generation. Preserve physical proportions and safe crop margins. Record which source is mapped to each object and label the output a concept presentation.

**Detail board:** Use actual linked SVGs and `{verified_proof_images}` only. Explain `{decision}` with a visible crop and one factual caption. Preserve source text and geometry. Distinguish an authored rule from a check actually carried out. Show clear reading hierarchy without shrinking Arabic into a secondary footnote. Return editable composition, export and source manifest.

## Verification record - 13 October 2026

The HTML and PDF are completed guide artifacts. The final PDF has **12 A4 pages**, all rasterized through bundled Poppler at 110 dpi. The first batch was visually inspected page by page. The confirming export changed only page 4 (the corrected monochrome size sample) and page 11 (the identity owner's completed carton panel); both changed pages were inspected. The remaining ten final page rasters matched the inspected first batch byte for byte. No clipped text, footer overlap, missing art or broken Arabic shaping was observed.

All **18 guide images** loaded, all **14 linked handoff assets** returned successfully, and Fraunces, Manrope plus regular/semibold Plex Arabic loaded as local fonts. The renderer found no content crossing page footers. Six solid-colour pair calculations agree with the printed table: Ink/Paper 13.28, Paper/Cobalt 5.87, Ink/Mist 11.04, Ink/White 15.69, Ink/Roast 3.90 and Roast/Paper 3.41.

Five 1× digital proof captures were inspected. The 500-unit monochrome lockup uses the canonical nominal 310-unit wordmark width; its 284 px image container gives approximately 176.08 px of visible artwork. The 380-unit small master uses a 79 px image container for approximately 64.45 px visible artwork. The separate horizontal lockup includes the symbol and has a 700-unit viewport, so the monochrome container recommendation must not be copied to that asset. Symbol captures at 48/24 px are explorations of the padded image container, not a claim of a 48/24 px visible symbol or a physically proven minimum.

The PDF skill's artifact-operation marker ran successfully exactly once before authoring. The guide used one complete render/inspection batch and one confirming export. The actual checks and images remain in this directory; the reproducible renderer is now grouped with [guide tools](../tools/guide). No physical production, independent copy review, sourcing, tasting or commercial outcome was verified.

### Portable PDF links

Final functional QA found that Chromium had resolved the 14 authored relative links against its temporary local rendering origin. The PDF annotations were corrected with `fix-pdf-links.py` to retain the exact HTML hrefs (`source/...` or `fonts/...`). The HTML, artwork and page content were unchanged. The renderer now invokes this correction after every PDF export.

The written PDF was reopened: all **14 URI annotations are relative**, none contains a local hostname or temporary port, and every destination exists beside the guide at its authored relative path. A focused page-12 Poppler raster after the correction is **byte-identical** to the previously inspected image (SHA-256 `4fdbd0c3be3c19d7ad2864530cb8859cfe6b851efe413fc97ec84ab35940e347`). This was an annotation-only functional correction, with no additional exploratory visual round.
