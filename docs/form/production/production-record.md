# Form Architecture — production record

13 October 2026. Version 1.0.1. Local delivery on `selected-work`. Form is a self-initiated studio project with fictional architectural studies. This record establishes authored digital work and an implemented demonstration; it establishes no real architecture commission, construction, external practice, client relaunch or commercial outcome.

The approved source is the complete Form chapter and shared rules in [selected-work-context.md](../../selected-work-context.md). The name, positioning, palette, type roles, open-frame proportions and three canonical studies are retained. Sift's 115 existing asset files remain byte-identical; the original reference HTML checksum is unchanged.

## Completed deliverables

| Deliverable | Actual source / export | Status |
| --- | --- | --- |
| Fictional starting identity | `source/starting-identity.svg`, `starting-brochure.svg`, actual `site/baseline.html` | Designed, implemented and captured |
| Redesigned identity | Original outlined wordmark, dark/mono variants, 3:4 frame, palette/type board, clear-space board, bilingual cover | Designed; nine SVG proofs and a small-size proof checked |
| Study imagery | Nine generated native 1586 × 992 PNGs and nine WebPs; three original relationship diagrams | Designed and provenance recorded |
| Responsive public website | Home, Work, three Project records, Studio, Contact in `site/index.html`, `app.js`, `style.css`, `data.js` | Implemented and verified in English/Arabic |
| Enquiry | Project → editable reference → associated validation → retry → honest not-sent receipt | Implemented and browser verified; no receiving service |
| Local project editor | `site/editor.html`, `cms.js`, `cms.css`; separate draft/preview/published stores | Implemented edit → preview → browser-local publish |
| Case presentations | Twelve parent boards and fourteen responsive variants; `export-record.json` | Designed from actual captures and editable artwork |
| Agency integration | Slot 02, split renderer, EN/AR/FR case and demo/source links | Local production build and browser verification |
| Editable handoff | `form-source.zip`, `SOURCE-README.md`, source registers and reproducible scripts | ZIP integrity and matching source/build bytes checked |

The full presentation dimensions are 1600 × 1000 for `card.webp`, 2560 × 1600 for `hero.webp`, and 2000 × 1500 for the other ten boards. Card/hero have 480/960 variants; each other board has a 960 variant. No generated study image is upscaled to simulate higher native resolution. Architectural studies are Courtyard House (residential, 2025, fictional Mediterranean setting, 240 m²), Line Studio (workplace, 2026, fictional international urban setting, 180 m²) and Shore Library (cultural-space, 2026, fictional coastal setting, 620 m²).

## Imagery and typography provenance

The built-in ImageGen tool produced one primary spatial view per study, then one exterior/context and one material-detail view using the primary as a reference. Exact prompts and original tool output paths are retained in [generation-prompts.json](generation-prompts.json); project-local originals live in `studies/*-source.png`. These are synthetic architectural concept views, not sourced photographs relabelled as Form buildings. They maintain the study's material vocabulary; alternate views do not establish a surveyed, buildable or measured architectural model. The three SVG diagrams communicate relationships and are explicitly labelled as conceptual, not construction drawings.

Original deterministic SVG geometry supplies the custom FORM lettering and open frame. The 3:4 frame has one lower-right opening. Clear space is half the wordmark cap height; the exported construction uses a 1000-unit wordmark width, approximately 250-unit cap height and 125-unit clearance. Digital inspection supports a 192px full lockup and a 24px frame accompanied by the name. Physical print minima and supplier proofs are unverified. Baseline brochure and redesigned cover are editable digital artwork, not photographs of printed stock.

Cormorant Garamond and Instrument Sans were downloaded from the [Google Fonts Cormorant repository](https://github.com/google/fonts/tree/main/ofl/cormorantgaramond) and [Instrument repository](https://github.com/google/fonts/tree/main/ofl/instrumentsans), with their SIL OFL texts preserved. Original variable TTFs and Latin WOFF2 subsets are saved. Existing licensed local IBM Plex Sans Arabic files shape the Arabic layouts without tracking. Glyph checks disclosed that Instrument Sans omits U+00B2; an explicit `Form Symbols` fallback supplies only that approved Cormorant glyph for the canonical m² units. See [font-checks.json](../verification/font-checks.json).

Each of the 54 project raster files carries embedded generation prompt or authored-source provenance. `source/asset-manifest.json` records stable filename, source, dimensions, creator, rights/status boundary, captions, alt text, focal instructions, bytes and SHA-256. Public per-image English/Arabic captions, alt text and independent desktop/mobile focal coordinates are in `site/data.js`. Full-image inspection remains available.

## Implementation and demonstrated detail

English is the content master. The working Arabic edition uses authored professional Arabic, document RTL, correct shaping, logical layout and readable Latin/numeric fragments. French is integrated in the agency case; the standalone Form demo's editions are English and Arabic. Local translation/RTL checks do not substitute for independent commercial language review.

The CMS validates stable IDs, unique slugs, required bilingual fields, exact concept status, actual local imagery loading, captions/alt text, focal ranges, bounded text, ordered story relations and next-project links. It requires previewing the current draft before publication. Image removal keeps the story text and exposes a missing relation. Project-page crop previews match primary usage: opening 16:9/4:3, story 4:3, material 16:7/4:3, diagrams full 8:5. Material story reuse is explained. The actual public renderer previews the unpublished record and reads successful publication from the same browser. No server, authentication, upload or external publishing is represented.

The enquiry requires name, email format, type, location and a 20–2000-character outline. Optional uncertainty is supported. Inline errors are associated with inputs and focus the first invalid field. Draft words and the editable study reference survive errors, route/language changes, reload and an induced local preview failure. Storage failure keeps the in-memory draft and explains the limit. The primary action says “Preview demo receipt”; the result says “Demo complete. This enquiry has not been sent.” No message or network submission occurs. The CR8.Media agency enquiry remains its existing email-draft flow.

## Maintenance release

The first working editor revealed a malformed adjacent-attribute selector during keyboard story reordering. Release 1.0.1 corrects focus restoration and confirms preserved bilingual text/image relations. Independent finish review also identified mismatched editor/public crop ratios, a clipped CMS proof summary and one ambiguous Arabic material alt. Those three findings were corrected and scored resolved in [finish-verdict.md](../verification/finish-verdict.md). These are actual subsequent improvements to implemented work, not a hypothetical maintenance roadmap or a claim of ongoing client service.

## Evidence and handoff

[verification.md](../verification/verification.md) contains the final checks. `verification/website/` holds actual public/CMS states and equivalent 1440 × 1000 baseline/redesign captures. `verification/agency/` holds localized production case views. `presentation-sources/` holds editable HTML compositions and PNG exports. [DESIGN.md](../DESIGN.md), [PRODUCT.md](../PRODUCT.md) and `.impeccable/design.json` document Form's scoped system; CR8.Media's system remains separate.

The source ZIP adapts its Arabic font URLs to its own bundled fonts so it can be extracted and served independently. Its site source otherwise retains the repository implementation. No public deployment, trademark/domain clearance, physical printing, built architecture, commissioning client, conversion result or independent commercial translation approval is claimed.
