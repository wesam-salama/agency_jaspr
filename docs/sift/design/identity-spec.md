# Sift Coffee — authored identity and application record

Created **13 October 2026** from the approved Sift chapter and shared rules in [selected-work-context.md](../../selected-work-context.md). This record covers original digital identity and flat application artwork. Sift Coffee remains a self-initiated studio project with fictional business and product data.

## Direction and reasoning

The collection makes coffee choice legible through one repeatable hierarchy: brand, product name, flavour direction, tasting notes, product type and format. Everyday, Daybreak and After Hours share the same structure, while written descriptions and a restrained colour identifier make their differences explicit. Colour supports the reading; it does not carry the entire meaning.

The warm Paper surface and Coffee Ink lettering give the identity a contemporary pantry character. Cobalt identifies the act of selection. Roast Orange belongs to Everyday; Ink identifies After Hours. Each product uses the same original lowercase wordmark and Selected Line motif. The authored flat masters precede any photographic mockup and remain the source of truth for exact wording.

The packaging places a large, compact wordmark above a more informative lower portion. The source artwork uses generous internal separation, a consistent product baseline, an independent weight field and a distinct product-colour panel. The 1 kg front has additional information space and a different hierarchy scale; it is not merely the 250 g image enlarged.

## Wordmark and motif construction

The lowercase `sift` wordmark is constructed from original filled SVG paths. It is not a font word converted unchanged to outlines. The `s` has a compact, open counter and flared terminals; the `i` has a round dot and serifed stem; the `f` has an open shoulder; and the `t` has a short shared-height crossbar and curved exit. The descriptor **COFFEE** uses actual Manrope and controlled Latin spacing.

Natural wordmark path width is approximately **310 units**. Principal contours extend from **y = 9** to approximately **y = 166**. The lowercase `i` stem construction extends from **y = 70** to **y = 163**, so the standalone mark's clear-space unit is **U = 93 units**. The descriptor baseline is **y = 198**. The clear-space diagram records this geometry; prescribed application artwork is deployed as a complete composition rather than rearranged by a mockup generator.

The small optical cut keeps the wordmark only, strengthens the `i` stem and increases the short `t` crossbar thickness. It omits the descriptor so “COFFEE” does not become tiny pseudo-text. The digital board shows visible wordmark widths of approximately 65, 99 and 161 px.

Digital starting recommendations are **64 px visible wordmark width** for the small cut and **176 px visible wordmark width** for the complete lockup. A padded SVG's CSS width is not the visible mark width: the mono/reverse master has a 500-unit viewport and a 310-unit visible wordmark, so 284 CSS px produces approximately 176 px of visible lettering. The horizontal master has a 700-unit viewport; it requires approximately 398 CSS px for the same visible mark width. These are digital recommendations, not measured physical print minima.

The Selected Line has **five horizontal rules**, with **12-unit baseline intervals** and **3-unit stroke width**. Four rules occupy **60 units**; the centre rule occupies **80 units**, preserving the six-part/eight-part relationship. Its colour is Cobalt in the primary version. Monochrome deployments use a single contrast colour, including the Ink shipping panel and small label footer. The device carries no taste score or quantity.

## Colour and typography

| Token | Exact colour | Use |
| --- | --- | --- |
| Paper | `#F4EBDD` | Primary labels, information sheets and editorial surfaces |
| Coffee Ink | `#28221F` | Primary text, outlined wordmark, reverse surfaces |
| Cobalt | `#3047D9` | Selected rule, Daybreak identifier and product social template |
| Roast Orange | `#C56339` | Everyday identifier; decorative colour panel |
| Mist | `#D9D9D0` | Presentation-board surface |

The solid-colour calculation recorded in `source/digital-audit.json` gives Ink/Paper **13.276:1**, Paper/Cobalt **5.868:1**, and Ink/Mist **11.044:1**. Ink/Roast is **3.897:1**, so the artwork does **not** set ordinary text over Roast Orange. The colour panels have no essential text. These calculations do not establish physical print contrast or contrast for future photographs.

Fraunces is the editorial face, Manrope handles information, and IBM Plex Sans Arabic handles Arabic. The actual files are embedded into each SVG, with variable weights declared for the Latin families. All three families loaded successfully in the isolated Chromium render. Arabic uses right-to-left direction, natural joining, logical start anchoring and independent line height. Arabic has no artificial tracking.

Source font files and SIL Open Font License 1.1 copies live in `web/assets/selected-work/sift/source/fonts/`. Fraunces and Manrope were downloaded from the official Google Fonts repository:

- [Fraunces font and licence](https://github.com/google/fonts/tree/main/ofl/fraunces)
- [Manrope font and licence](https://github.com/google/fonts/tree/main/ofl/manrope)
- IBM Plex Sans Arabic WOFF2 files and their existing OFL copy were copied from the workspace's `web/assets/fonts/` directory.

The local OFL files identify the Fraunces Project Authors, Manrope Project Authors and IBM copyright owners. Retain them when distributing font files. Embedded SVG fonts render in the tested browser; editing software may require installing the provided font files to preserve live text.

## Canonical product data

`source/product-canon.json` is the implemented content record. It preserves **Sift Coffee**, **Good coffee. Clearly chosen.**, **Three coffees. Three clear starting points.**, and the following fixtures:

| Coffee | Notes | Origin / process fixture | Roast fixture | Starting method |
| --- | --- | --- | --- | --- |
| Everyday | Cocoa · almond · brown sugar | Brazil / Colombia blend; natural / washed blend | Medium | Espresso or moka pot |
| Daybreak | Apricot · citrus · floral | Ethiopia single origin; washed | Light | Pour-over |
| After Hours | Dark chocolate · plum · caramel | Colombia single origin; washed | Medium-dark | Espresso or French press |

Every 250 g reverse carries an English fixture disclosure and Arabic disclosure. Variable data remains **`{ROAST_DATE}`** and **`{BATCH_ID}`**. The wholesale sheet carries **`{WHOLESALE_CONTACT}`**, with no invented address or contact domain. No certifications, decaffeination, health, sourcing, sales or sustainability claims are represented.

The Daybreak brewing card uses the approved sample starting recipe: **15 g coffee / 250 g water / medium grind / 3-minute starting target**. It includes “Too sharp? Try a slightly finer grind.” Physical brewing and taste testing remain pending. Arabic descriptions and guidance are authored concept translations with correct tested font shaping; final production editorial review remains pending.

## Delivered editable source families

All paths below are under `web/assets/selected-work/sift/source/`. Each SVG has a corresponding PNG render. These are flat geometric/type artwork masters, not shaded SVG simulations of photography.

| Family | Source masters |
| --- | --- |
| Identity | `sift-wordmark-horizontal.svg`, `sift-wordmark-stacked.svg`, `sift-wordmark-mono.svg`, `sift-wordmark-reverse.svg`, `sift-wordmark-small.svg`, `sift-selected-line.svg`, `sift-clearspace.svg`, `sift-wordmark-system.svg` |
| 250 g collection | `pack-{everyday,daybreak,after-hours}-250g-{front,reverse,side}.svg` — nine separate masters |
| 1 kg format | `pack-everyday-1kg-front.svg`, `pack-everyday-1kg-reverse.svg`, `pack-everyday-1kg-side.svg` |
| Shipping | `shipping-carton-panel.svg`, `shipping-tape-repeat.svg`, `sift-shipping-carton.svg` |
| Brewing cards | `brew-card-daybreak-front.svg`, `brew-card-daybreak-reverse.svg`, `sift-brewing-cards.svg` |
| Sample box | `sample-box-lid.svg`, `sample-box-insert.svg`, `sift-sample-box.svg` |
| Wholesale | `sift-wholesale-sheet.svg` |
| Social | `social-launch-template.svg`, `social-product-template.svg`, `sift-social-templates.svg` |
| Counter display | `sift-counter-display.svg` |

Packaging canvases are **design artboards in pixels**, not supplier-confirmed cutting or print dielines. The work demonstrates the design system; physical dimensions, substrate, bleed, food-labelling requirements and supplier files need an actual production brief before manufacturing.

## Case presentation and generation handoff

The inspectable front reference is `label-front-sheet.png`, **1800 × 1000**. It contains the three exact front labels and is the reference for generated product scenes. Per-product front, reverse and side PNGs can be supplied when the scene shows those surfaces.

Four case boards are **2000 × 1500**:

- `sift-identity-board.png`: outlined wordmark, type voices and palette.
- `sift-range-board.png`: three fronts, three reverse panels and three side panels.
- `sift-detail-bilingual.png`: enlarged bilingual reverse and side artwork.
- `sift-applications-board.png`: all eight application families in one authored overview.

`sift-detail-information.png` isolates the hierarchy. `sift-shipping-carton.png`, `sift-brewing-cards.png`, `sift-sample-box.png` and `sift-social-templates.png` provide fuller application views. Photographic mockups must apply this actual artwork; they may not invent, redraw or substitute text. Exact Arabic and product names should be composed from supplied vector/rendered artwork when generation cannot preserve them.

The source manifest records IDs, filenames, dimensions, status, provenance, rights, captions, alt text, crop guidance and SHA-256 checksums. Root case integration owns presentation WebP conversion and the public case narrative. This source task changes no site Dart or CSS.

## Verification and limits

The digital audit records **40 well-formed SVG masters**, matching declared dimensions and manifest checksums, with **40 PNG renders**. All requested font families loaded; no SVG text extended beyond its artboard. Canonical collection strings, Arabic content, variable placeholders and fixture disclosures passed direct source checks. No bitmap image is embedded in a geometric SVG master.

All outputs were visually inspected together in four contact sheets now filed under [verification/review/](../verification/review). One missing Ink background on the shipping presentation board was corrected and visually confirmed. The audit preserves the full render record after that correction. This establishes digital design and rendering, not physical production, a coffee supplier relationship, a client commission or business results.

Rebuild from the Jaspr repository root:

```sh
/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 docs/sift/tools/build-assets.py
/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node docs/sift/tools/render-assets.cjs
/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 docs/sift/tools/audit-assets.py
```

`render-assets.cjs` launches a separate headless browser and does not control the user's visible website tab. Passing a filename renders only that master while preserving earlier audit records. The build uses bundled source fonts and does not need a network request after initial font acquisition.
