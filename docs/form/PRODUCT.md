# Form Architecture

<!-- impeccable:product-schema 1 -->

## Platform

Web: a responsive public site and a browser-local project editor, delivered as static HTML, CSS and JavaScript beneath `web/assets/selected-work/form/site/`.

## Users

The public experience addresses people considering thoughtful homes, small workplaces or cultural spaces. Their questions are whether the approach fits their brief, how a project develops, and what to describe first. The editor addresses a person maintaining the three bilingual study records, their images and their ordered stories. These audiences are design assumptions for the concept; no user research is claimed.

## Product Purpose

Explain architectural decisions through light, material, movement and use, then carry the visitor's chosen study into an editable enquiry. The positioning is “Architecture shaped around how people live.” The implemented primary action is “Preview demo receipt”; its result says “Demo complete. This enquiry has not been sent.” No receiving service or message delivery is connected.

## Positioning

Form Architecture is a fictional practice created for a self-initiated CR8.Media rebrand and website study. Its material-led identity and project narrative demonstrate the studio's concept strategy, identity design, art direction, UX/UI and local website implementation. Generated architectural scenes depict fictional studies; they do not establish architectural commissioning, construction, professional qualifications or real client work.

## Operating Context

The public site has Home, Work, Project, Studio and Contact page types, reached through visible native navigation and hash routes. Project context flows from a study's “Discuss a similar project” action into Contact, where the visitor can change the reference. The local editor changes structured English/Arabic records, previews the actual public renderer and publishes to this browser's local storage.

| Study | Canonical fictional metadata | Spatial idea |
| --- | --- | --- |
| Courtyard House | Residential study; 2025; fictional Mediterranean setting; 240 m² | A planted opening relates light, privacy and everyday movement. |
| Line Studio | Workplace study; 2026; fictional international urban setting; 180 m² | Distinct connected zones support shared work and concentration. |
| Shore Library | Cultural-space study; 2026; fictional coastal setting; 620 m² | A shaded threshold links gathering with quiet reading. |

The years describe the study fixtures. They are not construction dates or agency delivery durations.

## Capabilities and Constraints

Public content and the editor share `data.js`. Stable IDs, unique slugs, bilingual content, study metadata, concept status, local image references, captions, image descriptions, independent desktop/mobile focal points, ordered stories and next-study relations form the publishing contract. Area is optional. The editor requires a preview of the current draft, valid records and loadable imagery before publishing. It does not upload assets or write the canonical source files.

Published records use `form-projects-v1` in local storage. Editor drafts use `form-editor-draft-v1`; unpublished public previews use `form-editor-preview-v1` in session storage. Normal public pages read published records. Invalid stored collections fall back to the canonical fixtures. Blocked storage keeps the current in-memory draft and explains the recovery required; persistence after closing or reloading is not promised in that degraded state.

Enquiry requires name, sensible email formatting, project type, location and a 20–2,000-character outline. Approximate area, indicative budget and timing are optional; uncertainty has explicit “Not decided” choices. The counter appears from 1,700 characters. Draft values are retained through invalid input, route/language changes, reload when storage works, a simulated unsuccessful preview, retry and receipt editing. A format-valid email is not evidence that an address exists.

English is the public/editor content master. Arabic is authored, shaped and checked in the local RTL trial; independent commercial-language review is not established. The surrounding agency case also has its own English/Arabic/French localization contract. The Form public/editor implementation currently provides English and Arabic.

## Brand Commitments

The approved identity retains the Form name, open-frame recognition cue and association with architectural space. The authored fictional baseline uses slate blue (`#546D85`), a compact two-line FORM / ARCHITECTURE signature and the same three studies. Its disclosure is “Fictional starting identity created for this rebrand study.” It is an authored comparison, not a recovered client website.

The finished Form world uses Chalk, Charcoal, restrained Sage, Functional Sage for readable actions, and Clay in the identity artwork. Cormorant Garamond supplies Latin editorial headings; Instrument Sans supplies facts and controls, with an explicit Form Symbols fallback from the approved Cormorant WOFF2 for its missing superscript-two glyph in m²; IBM Plex Sans Arabic supplies Arabic. The coverage record identifies this resolution rather than claiming Instrument Sans contains U+00B2. The custom vector wordmark and a vertical 3:4 open frame with one lower-right opening bind the system. This scoped world is recorded in [DESIGN.md](DESIGN.md); it does not replace the agency's dark/red identity or Sift's separate system.

## Evidence on Hand

Editable identity SVGs and generated-study source assets are under `web/assets/selected-work/form/`. Actual public/editor captures are under `docs/form/verification/website/`. The supplied `public-checks.json` records 56 English/Arabic route views at 320, 390, 768 and 1440 px plus enquiry, recovery and fallback scenarios. The supplied `cms-browser-checks.json` records eleven editor scenarios, including the corrected usage-specific crop previews. The current `identity-render-audit.json` records nine vector render checks, including the starting brochure, with no reported text overflow. These are local artifact records; this documentation pass did not rerun those flows.

The initial independent review in `finish-review.md` requested three narrow fixes: usage-specific crop previews, readable published-change composition on the CMS board, and natural-finish Arabic image wording. Current source and the updated editor evidence reflect those corrections. The bounded confirmation verdict and whole-agency production verification are separate records; neither is inferred from documentation.

## Product Principles

- Connect each spatial image to the project record, caption and decision it explains.
- Keep project context visible and editable throughout the enquiry.
- Preserve visitor words and editor story/image relations through validation and recovery.
- Say precisely what Preview and Publish change, where data lives and whether anything was sent.
- Preserve the canon and concept status across English/Arabic records without adding client or construction claims.
- Keep internal direction contracts in project documentation; public copy should explain the practice, studies and useful actions.

## Accessibility & Inclusion

The implemented surface uses permanent field labels, associated errors/hints, practical 44–52 px control targets, visible keyboard focus, a skip link, route-heading focus and announced status. Invalid enquiries focus their first invalid field. Editor error summaries link to affected fields, and keyboard story moves restore focus to the moved control. The public site uses full pages with visible navigation; it has no authored menu or case dialog. The editor uses native browser confirmations for destructive draft operations.

Arabic uses document-level RTL, normal tracking and local IBM Plex Sans Arabic; Latin identities, asset paths, email addresses and numeric facts retain readable direction. Mobile layouts establish a linear reading order. Reduced motion removes the small user-triggered image zoom; content is visible by default. English no-script content provides a usable home/study fallback and clear no-send enquiry guidance. Recorded color-pair checks are not a complete accessibility certification.

Physical print proofing, commissioned or constructed architecture, independent translation review, trademark/domain clearance, commercial launch, hosted CMS, receiving-service delivery and measured business outcomes remain unclaimed.
