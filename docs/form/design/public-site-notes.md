# Form public website implementation

Created 2026-10-13. Local implementation, version 1.0. Authored for the Form Architecture self-initiated rebrand study; no commissioned architecture, constructed work, external publication, or receiving service is established.

## Editable source

- `web/assets/selected-work/form/site/index.html`: document, local font/asset links, visible navigation, and authored no-JavaScript home/contact guidance.
- `web/assets/selected-work/form/site/style.css`: Chalk/Charcoal editorial system, shared eight-unit rhythm, responsive grids, RTL font/layout rules, focus, browser surfaces, and reduced-motion behavior.
- `web/assets/selected-work/form/site/app.js`: five public page types, English/Arabic authored copy, project-context routing, and enquiry behavior.
- `web/assets/selected-work/form/site/data.js`: three bilingual study fixtures, publishing schema, local data loading, validation, and persistence.
- `web/assets/selected-work/form/site/baseline.html`: responsive fictional starting website, using the same three spatial-study images and canonical facts as the redesign. Its exact disclosure is “Fictional starting identity created for this rebrand study.”
- `web/assets/selected-work/form/site/public-site.test.mjs`: focused validation and data-contract tests.

The running public page types are `#home`, `#work`, `#project/courtyard-house` (also `line-studio`, `shore-library`), `#studio`, and `#contact`. Contextual enquiry starts from `#contact?project=courtyard-house`; that reference is copied into the editable draft, then the URL becomes `#contact` so a later language switch does not overwrite an explicitly changed reference.

The CMS draft preview is the actual public renderer at `index.html?project=<slug>&preview=1`, reading the unpublished array from session storage. `lang=ar` opens its Arabic edition. Normal visits read only the published collection. A missing optional area is omitted from facts; invalid/empty image drafts explain the missing gallery instead of crashing. The public renderer follows section order and image relations from the shared schema.

## Identity, content, and direction

The redesigned site uses the root-authored Form wordmark and 3:4 open frame; Cormorant Garamond carries English editorial headings, Instrument Sans carries functional text, and locally hosted IBM Plex Sans Arabic carries Arabic. The full header mark is at least 192 CSS pixels wide; navigation remains visible and wraps on narrow screens. Arabic uses document RTL direction with no letter spacing; Form's Latin wordmark and numeric facts remain readable in their own direction.

English is the master. Arabic is an authored translation trial checked during local RTL verification, not an independently reviewed commercial translation. “Mineral” is expressed as natural finishes rather than the Arabic term that could suggest metal cladding. Concept diagrams are described as relationship diagrams, not approved construction plans. All three study facts remain canonical: Courtyard House, residential, 2025, fictional Mediterranean setting, 240 m²; Line Studio, workplace, 2026, fictional international urban setting, 180 m²; Shore Library, cultural space, 2026, fictional coastal setting, 620 m².

Public disclosure identifies the self-initiated concept in the footer, Studio story, project status, and enquiry explanation. Captions remain with images, and full image links allow uncropped inspection. Desktop/mobile focal points are independent values per asset; responsive object positioning applies the corresponding crop without rewriting the original image.

The fictional baseline uses a compact two-line FORM / ARCHITECTURE identity, an open rectangle, slate-blue emphasis, readable serif typography, short project descriptions, separated project facts, and deliberately varied image proportions. It is a usable authored site. Its Contact links carry no study reference, illustrating the approved communication limitation without breaking mobile or hiding information.

## Enquiry implementation

Name, email, project type, location, and outline are required. An outline must contain 20–2,000 characters; its counter appears only at 1,700 characters or above. Email validation checks sensible formatting only. Area, indicative budget, and timing are optional; budget/timing include “Not decided,” and a blank area has the same meaning. No response-time promise, office address, submission delivery, or email-domain existence is implied.

The editable reference project stays visible in a contextual image/title preview and a native select. Input changes save the draft to `form-enquiry-draft-v1` in local storage. Route changes, language switches, reload, inline errors, simulated failure, and the receipt leave visitor text intact. Browser-storage failure keeps the in-memory draft and gives a clear copy-before-closing explanation.

Native fields have permanent labels and associated hints/errors. An invalid attempt focuses the first invalid field and announces the review status. The “Demonstration controls” disclosure can simulate one local failure; the draft is preserved and the same preview action retries. The primary action is “Preview demo receipt.” The receipt says “Demo complete. This enquiry has not been sent.” Its editable return preserves all fields. No network request or message delivery occurs.

Public route changes focus the page heading. Native navigation remains visible without a menu/dialog. Reduced motion removes the restrained image-hover scaling; content never relies on entrance animation. The skip link focuses the main region without disrupting hash routing.

## Schema and verification

`DEFAULT_PROJECTS`, `loadProjects()`, `validateProject(project, collection)`, `saveProjects(collection)`, `cloneProjects()`, and `PREVIEW_KEY` are the CMS/public interface. The publishing validator requires stable ID, unique valid slug, bilingual title/summary/category/location/material explanation, study year, exact Studio concept status, image description/caption/focal points, ordered bilingual story sections with valid image relations, and next-project relation. Area is optional. Corrupt or incomplete stored collections fall back to canonical fixtures; a storage write failure throws for the CMS to explain and recover.

Six focused public tests passed together with the six CMS tests on 2026-10-13:

```sh
node --test web/assets/selected-work/form/site/public-site.test.mjs web/assets/selected-work/form/site/cms.test.mjs
```

They cover canonical fixtures, misleading statuses, duplicate slugs, missing images/stories, Arabic/text/crop bounds, persistent data and corrupt-store fallback, enquiry validation preserving its input, uncertainty, email formatting, and outline bounds. CMS tests additionally cover reordered bilingual stories, image-relation preservation, optional facts, and blocked storage. Root verification owns the actual desktop/mobile/RTL checks, screenshots, and demonstration recordings; those appear in `verification.md` and the main production record.

Measured solid-color pairs (sRGB WCAG contrast calculation, 2026-10-13): Charcoal `#2D3331` on Chalk `#F1F0EA` 11.29:1; Functional Sage `#4E5E51` on Chalk 6.04:1; muted `#59605A` on Chalk 5.67:1; input boundary `#788075` on Chalk 3.58:1; error `#852F26` on Chalk 7.56:1. These are color-pair calculations, not a complete accessibility audit. Important text is not overlaid on photography. The palette's Sage and Clay remain decorative rather than small-text colors.
