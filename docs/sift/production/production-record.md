# Sift Coffee — production record

Created 13 October 2026 for Creative Media's Selected Work. Audience: international, Arabic-ready. Sift is a self-initiated studio concept; the artwork is authored, while coffee data and the business brief are fictional.

## Completed inventory

- Strategy, positioning, name rationale and the Selected Line identity, documented in [identity-spec.md](../design/identity-spec.md) and the approved master context.
- Forty editable SVG masters and forty matching PNG proofs: logo variants, clear space, palette/type system, front/reverse/side labels, and application compositions.
- Eight application families: three 250 g coffee packs; 1 kg format; shipping carton and tape; brewing cards; three-coffee sample box and insert; wholesale sheet; social templates; counter display.
- English/Arabic packaging descriptions, local Fraunces, Manrope and IBM Plex Sans Arabic files, and their font licences.
- Twelve-page brand guide in editable HTML and PDF, with rendered page proofs and native-size digital samples.
- Two generated packaging presentations; four case boards made from the actual vector masters; fourteen responsive WebP exports.
- First Selected Work card and four-chapter Sift case integrated in English, Arabic and French. PDF and editable-artwork links use the site's existing base path and focus/navigation system.

The other three approved projects remain planned. Existing Loop, Marrow and Northline placeholders remain until those projects are produced.

## Image provenance and export

The built-in ImageGen tool generated the card and hero scenes from the authoritative `source/label-front-sheet.png`. These are concept presentations, not photographs of manufactured products. The source PNGs are retained under `web/assets/selected-work/sift/mockups/`; exact SVGs are the authoritative lettering, geometry and copy source.

Generation brief: warm paper bags on a pale tabletop, soft directional daylight, the three supplied product fronts with exact lowercase sift lockup and tagline, readable product names and weights, no invented claims or dates. Card: two upright bags and After Hours lying at the lower right, cup behind. Hero: a distinct still life with open sample carton, brewing-card graphic, cup and three packs. Each scene received one targeted correction so the longer middle rule on every light label is Cobalt `#3047D9`; Everyday's product underline and lower band remain orange.

| Output | Generated original | Native dimensions |
|---|---|---|
| Card | `exec-b370013e-7a0c-46d0-89a9-e10d3502a1fc.png` | 1586 × 992 |
| Hero | `exec-3aea215d-7cdc-4279-b61c-accf81770dad.png` | 1586 × 992 |

Both originals remain in the task's generated-images directory. Full WebPs preserve their native resolution rather than upscaling to the initial planned dimensions. Responsive exports use 480 × 301 and 960 × 601. Identity, range, bilingual and application boards use 2000 × 1500, with 960 × 720 variants. `runtime-images.json` records exact dimensions and byte sizes. Exports use cwebp quality 88; no raster lettering was painted or reconstructed with a script.

## Evidence

- [source/asset-manifest.json](../../../web/assets/selected-work/sift/source/asset-manifest.json): individual asset IDs, dimensions, source, provenance and checksums.
- [source/digital-audit.json](../../../web/assets/selected-work/sift/source/digital-audit.json), [source/render-audit.json](../../../web/assets/selected-work/sift/source/render-audit.json): actual font loading, text bounds, canonical copy and SVG checks.
- [guide/proof-report.json](../guide/proof-report.json), [guide/proofs/](../guide/proofs): all twelve PDF pages, linked artwork, fonts, contrast and digital size samples.
- [verification.md](../verification/verification.md): completed code/build/browser checks and their actual results after final integration.

All native artwork and guide pages received a batched visual review with one bounded confirmation after material fixes. Root review also inspected the four site boards and representative guide pages. Generated scenes were inspected for composition, canonical labels and motif colour before export.

Physical print dimensions, supplier dielines, coffee sourcing/tasting, recipe testing and independent translation review remain production tasks for any future commercial use. Digital proof sizes do not establish physical printing minima.

## Final delivery status

Local digital delivery is complete on `selected-work`. Analysis, formatting, 55 tests and the production build passed. English, Arabic and French were inspected at 320/390/768/1440 px; all twelve records have zero horizontal overflow. Focus wrapping/restoration, case navigation and downloads were checked. The corrected PDF has fourteen portable relative links and is packed into the validated ZIP; the final build contains matching copies. No public deployment has been performed.
