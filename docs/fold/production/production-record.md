# Fold Clothing — local production record

15 October 2026 · version 1.1 · branch `selected-work`. Fold is a self-initiated studio project. The approved authority is shared sections 1–7, the complete Fold chapter and the colour audit in [selected-work-context.md](../../selected-work-context.md). This record establishes authored digital work and a local shopping demonstration. The garment, price, stock, composition and commercial circumstances remain fictional fixtures.

## Completed inventory

| Deliverable | Source and export | Actual scope |
| --- | --- | --- |
| Brief and canon | `brief.md`, `garment-canon.md`, scoped `PRODUCT.md` | Audience hypothesis, positioning, commercial gaps, exact four products/eight colour variants, prices, stock and once-rounded laid-flat measurements |
| Identity | `web/assets/selected-work/fold/identity/` | Nine editable SVG mark/clear-space masters; one controlled cut and offset in the F; the Latin signature is retained in Arabic |
| Packaging | `packaging/`, `source/identity-board.html`, `packaging-board.html` | Four editable hangtag/care-label/mailer applications, bilingual sample text and exact fixture information; flat digital artwork |
| Construction | `source/garment-*.svg`, `garment-canon.md` | Five editable explanatory sheets, with button/pocket/seam/silhouette locks established before generation; not manufacturing patterns |
| Typography | `fonts/`, `source/font-manifest.json`, `font-checks.json` | Exact local Archivo, DM Sans and IBM Plex Sans Arabic; original font masters and OFL licences; eight font files checked without missing specimen glyphs |
| Garment artwork | Eight `source/*-triptych.png` originals, 24 `products/*.webp` views | Front, back and construction detail for every colour variant; native-height exports with silhouette-preserving padding |
| Editorial | `source/{capsule,fabric}-source.png`, `editorial/` | Generated capsule group composition and tactile fabric still life; no manufactured-goods photography claim |
| Brand guide | `source/fold-brand-guide.html` | Editable responsive HTML with A4 print styles; a PDF is not supplied |
| Shopping experience | `site/{index.html,app.mjs,data.mjs,style.css}` | Responsive collection, shareable filters, four PDPs, Size & Fit, Delivery & Returns, About, cart, shipping, simulated checkout and confirmation in English/Arabic |
| Implementation evidence | `verification/store/`, runtime `screens/`, `production/recordings/` | Twenty page captures, measurement/shopping crops, actual continuous EN/AR browser films, timed event checkpoints and trace ZIPs |
| Case presentation | Seven editable HTML boards and sixteen responsive WebPs | Card 1600×1000; hero 2560×1600; five case figures 2000×1500, using exact artwork and actual software captures |
| Agency case | Slot 04 in EN/AR/FR | Fold replaces Northline through the statistics family with five figures, `metrics: []`, no empty results group and no quotation |
| Handoff | `fold-source.zip`, `SOURCE-README.md`, `source/asset-manifest.json` | Editable masters, native generated sources, implemented store, fonts/licences, scripts, evidence and source records in a portable repository layout |

## Garment and image continuity

The fixed collection is Box Shirt (`FL01`, $95, Chalk/Ink), Pleat Trouser (`FL02`, $145, Ink/Olive), Layer Vest (`FL03`, $110, Stone/Olive) and Field Overshirt (`FL04`, $165, Olive/Stone). Integer cents own all arithmetic. Sizes remain XS/S/M/L/XL; every stock row and measurement cell matches the approved chapter, including unavailable `FL03-STN-XS`.

The pattern lock fixes a five-button shirt with one chest pocket, a trouser with one forward pleat per leg and side pockets, a four-button V-neck vest with two lower patch pockets, and a six-button overshirt with two open chest pockets. Added plain-back/yoke/cuff decisions are identified as fictional continuity choices in the canon. The four primary generated triptychs were inspected before producing the second colour of each pattern from its actual primary image. All eight triptychs were independently reviewed. No garment logo or product lettering was delegated to a generator.

The built-in `image_gen` tool produced eight garment triptychs and two editorials. [generation-prompts.json](generation-prompts.json) preserves the exact prompts, reference roles and original tool paths. Native copies live inside the project. Equal-panel crops preserve silhouette, texture, seams and button/pocket counts. Source dimensions are recorded; larger case canvases are authored presentations, not claimed native photographic resolution.

The original vector logo, packaging, technical geometry and HTML compositions remain editable. Generated garment imagery is distinct from real browser screenshots and recordings. Every raster has its exact generation prompt or origin: PNG uses native metadata and WebP uses the installed tool's supported sidecar fallback. The final scan and source manifest retain those distinctions. Font URLs, licences, byte counts and checksums are separately recorded.

## Working purchase decisions

The English master and authored Arabic edition cover the complete shopping journey. Document RTL, local shaping without Arabic tracking, logical spacing, mirrored directional arrows and isolated SKU/currency/measurement values preserve reading order. The Arabic edition includes product information, size/stock decisions, measurements, cart, shipping, errors, retry and confirmation.

URL filters cover category, colour, size and price, with removable selections and empty-results recovery. A product requires an explicit size. Colour, image and SKU update together; changing colour clears the previous size. Cart quantities and size edits recheck aggregate stock. Removal offers persistent Undo; a versioned browser-local cart restores valid contents, rejects corrupt/stale data and offers Clear demo cart. Shipping words remain in memory during the visit and survive recoverable failure/retry and language switching.

The actual recorded basket is `FL01-CHK-M` plus `FL02-INK-M`: **$95 + $145 = $240**, plus **$12** demo shipping and **$0** test tax, total **$252**. Checkout states **“Demo checkout — no payment or order will be placed.”** The simulated action ends with deterministic reference **`FOLD-DEMO-76895E88`**, the same basket summary and an empty saved demo cart. No card collection, external request, payment, email, real inventory deduction or order occurs.

## Observed maintenance and finish work

The first working store exposed a keyboard issue: committing a quantity or changing size replaced the cart DOM and sent focus to the page body. [maintenance-before.json](../verification/maintenance-before.json) records that actual state in both languages. Version 1.1 preserves line order, chooses the edited/merged/restored line deliberately, and synchronously keeps Tab on the intended next control. The identical [after probe](../verification/maintenance-after.json) shows quantity → Remove and size → the edited Select in both languages. Removal, Undo, stock rejection and retry also retain a useful focus target. Full captures and same-region before/after crops support the maintenance case figure.

The independent full review identified two material corrections: fixed feedback obscured content, and some catalogue targets missed the promised 44 px size. Feedback now occupies an in-flow region, and the measured catalogue/header/footer groups meet 44 px. Its [verdict pass](../verification/finish-verdict.md) scored both listed findings resolved. The written verdict is limited to those fixes; browser execution and production checks are separate evidence. The initial capture set is retained under `verification/store/before-finish-fixes/`.

The final recording review also exercises the sighted error-recovery boundary; its targeted focus/viewport observations and captures are recorded separately from the static layout review. Source guards cancel an interrupted checkout simulation, normalize untrusted filter values, preserve the previous cart on quota failure and keep deliberate focus through retries.

## Preservation and completion

Sift, Form and Frame's asset trees, the original reference HTML and the recorded agency-shell baseline are byte-preserved: 371 protected files checked. Original reference SHA-256 remains `7a4d4736ada6b8e624f17ef95e082e6f67fac80e21903fc52192ac1f8c803295`. The agency retains CR8.Media's identity, original section copy, locale routes, shared curtain, dialog focus and email-draft enquiry. Only the authorised fourth case and the generic omission of an empty results group change that experience.

The production build generated `/`, `/ar/` and `/fr/` with `/agency_jaspr/` as its base. Twelve agency viewport/locale cases and three enquiry language states passed. The local preview router's initial root mapping was corrected and its failed observations retained; the successful rerun checks the actual compiled agency, not the standalone store.

See [verification.md](../verification/verification.md) for exact executed checks and [source-package-check.json](../verification/source-package-check.json) / [final-artifact-checks.json](../verification/final-artifact-checks.json) for current inventory and bytes. Delivery is local. Physical production, name/trademark clearance, independently reviewed commercial translations, real shipping/tax/returns rules, live payments and external publication remain outside this concept's evidence. Mobile browser layouts were verified; physical handset behavior is untested.
