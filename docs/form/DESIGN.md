---
name: Form Architecture — Material-led architecture
description: Spatial images, useful project stories and retained open-frame recognition.
colors:
  chalk: "#f1f0ea"
  charcoal: "#2d3331"
  sage: "#69766a"
  functional-sage: "#4e5e51"
  clay: "#a56b50"
  rule: "#d2d5cb"
  muted: "#59605a"
  error: "#852f26"
  field-border: "#788075"
  placeholder: "#646b63"
  secondary-hover: "#e4e5db"
  diagram-surface: "#e8e9e0"
  frame-surface: "#e3e5dc"
  editor-paper: "#fafaf6"
  editor-error: "#7d432f"
  editor-field-border: "#879186"
  editor-placeholder: "#5c685d"
  editor-feedback: "#e5eadf"
  editor-warning: "#eee0d4"
  editor-hover: "#e2e6dd"
  editor-active: "#d2d9cf"
  editor-on-action: "#fff"
typography:
  display:
    fontFamily: "Cormorant Garamond, serif"
    fontSize: "clamp(48px,6.1vw,88px)"
    fontWeight: 500
    lineHeight: 1.04
    letterSpacing: "-.025em"
  hero:
    fontFamily: "Cormorant Garamond, serif"
    fontSize: "clamp(52px,5.3vw,80px)"
    fontWeight: 500
    lineHeight: 1.04
    letterSpacing: "-.025em"
  headline:
    fontFamily: "Cormorant Garamond, serif"
    fontSize: "clamp(38px,4.3vw,64px)"
    fontWeight: 500
    lineHeight: 1.04
    letterSpacing: "-.025em"
  title:
    fontFamily: "Cormorant Garamond, serif"
    fontSize: "clamp(30px,2.5vw,40px)"
    fontWeight: 500
    lineHeight: 1.04
    letterSpacing: "-.025em"
  body:
    fontFamily: "Instrument Sans, Form Symbols, sans-serif"
    fontSize: "16px"
    lineHeight: 1.65
  label:
    fontFamily: "Instrument Sans, Form Symbols, sans-serif"
    fontSize: "14px"
    fontWeight: 500
  caption:
    fontFamily: "Instrument Sans, Form Symbols, sans-serif"
    fontSize: "13px"
    lineHeight: 1.6
  control:
    fontFamily: "Instrument Sans, Form Symbols, sans-serif"
    fontSize: "16px"
    fontWeight: 500
    lineHeight: 1.5
  arabic-display:
    fontFamily: "Plex Arabic, sans-serif"
    fontSize: "clamp(42px,4.8vw,70px)"
    fontWeight: 500
    lineHeight: 1.35
    letterSpacing: "normal"
  arabic-body:
    fontFamily: "Plex Arabic, sans-serif"
    fontSize: "16px"
    lineHeight: 1.9
    letterSpacing: "normal"
  editor-body:
    fontFamily: "Instrument Sans, Form Symbols, sans-serif"
    fontSize: "16px"
    lineHeight: 1.5
  editor-label:
    fontFamily: "Instrument Sans, Form Symbols, sans-serif"
    fontSize: ".875rem"
    fontWeight: 600
rounded:
  square: "0"
spacing:
  unit: "8px"
  related: "16px"
  group: "24px"
  passage: "32px"
  medium: "40px"
  generous: "48px"
  grid-gap: "56px"
  wide: "64px"
  section: "96px"
components:
  button-primary:
    backgroundColor: "{colors.functional-sage}"
    textColor: "{colors.chalk}"
    typography: "{typography.control}"
    rounded: "{rounded.square}"
    padding: "13px 24px"
    height: "52px"
  button-primary-hover:
    backgroundColor: "{colors.charcoal}"
    textColor: "{colors.chalk}"
  button-secondary:
    backgroundColor: "transparent"
    textColor: "{colors.charcoal}"
    typography: "{typography.control}"
    rounded: "{rounded.square}"
    padding: "11px 20px"
    height: "48px"
  button-secondary-hover:
    backgroundColor: "{colors.secondary-hover}"
  text-link:
    textColor: "{colors.charcoal}"
    rounded: "{rounded.square}"
    padding: "4px 0"
    height: "48px"
  public-field:
    backgroundColor: "transparent"
    textColor: "{colors.charcoal}"
    rounded: "{rounded.square}"
    padding: "13px 14px"
    height: "52px"
  editor-button-primary:
    backgroundColor: "{colors.functional-sage}"
    textColor: "{colors.editor-on-action}"
    rounded: "{rounded.square}"
    padding: "10px 16px"
    height: "44px"
  editor-field:
    backgroundColor: "{colors.editor-paper}"
    textColor: "{colors.charcoal}"
    rounded: "{rounded.square}"
    padding: "10px 12px"
    height: "44px"
---

# Design System: Form Architecture

## Overview

**Creative North Star: "Material-led architecture"**

Material-led architecture connects a spatial image to the decision it explains. Chalk surfaces, Charcoal reading, restrained Sage actions and the retained open-frame cue carry a quiet, useful architectural identity. Editorial headings give the idea room; facts, captions and controls keep it inspectable.

This is the finished Form public/editor system, extracted from its source on 13 October 2026. It is intentionally scoped to Form. The agency's root `DESIGN.md` and `.impeccable/design.json` continue to own the CR8.Media shell; Sift keeps its own identity. The approved code-led contract in `direction.md` supplies the descriptive language. Its internal direction text belongs in documentation, not public site copy.

**Key Characteristics:**

- Spatial imagery beside a readable explanation, with captions and full-image inspection.
- Custom serif wordmark, a vertical open frame, square corners and thin rules.
- Editorial desktop asymmetry that becomes a purposeful linear mobile sequence.
- Functional controls and visible focus within a restrained material palette.
- English and shaped Arabic records with equivalent actions and clear concept status.

## Colors

Chalk and Charcoal do the reading work. The frontmatter records actual source values; the named roles below explain their use.

### Primary

- **Functional Sage:** public action surfaces, focus outlines, caret and selected text. The editor uses the same action hue with white action text.

### Secondary

- **Sage:** restrained identity emphasis and the public scrollbar, rather than ordinary small text.
- **Clay:** a small identity-artwork accent. It is not a public error or action color.

### Neutral

- **Chalk / Charcoal:** principal canvas and reading/heading pair; Charcoal also carries preview banners and selected editor records.
- **Rule / Muted:** one-pixel separation and captions, facts or guidance. Rules are structure, not input boundaries.
- **Field border / Placeholder:** darker public input boundaries and readable placeholder text. Error is a distinct public validation hue.
- **Diagram surface / Frame surface / Secondary hover:** quiet surfaces used by the authored diagram, Studio mark and secondary-control state.
- **Editor paper / Editor field border / Editor placeholder:** the editor's denser fields retain their observed separate values. Editor error and warning accompany written recovery; editor feedback, hover and active surfaces are tonal state treatments.

**The Readable Actions Rule.** Use Functional Sage for small text and actions on Chalk. Sage and Clay carry restrained identity emphasis; they must not replace readable functional text or become the only status cue.

`public-site-notes.md` records measured solid-pair contrast: Charcoal/Chalk 11.29:1, Functional Sage/Chalk 6.04:1, Muted/Chalk 5.67:1, public field boundary/Chalk 3.58:1 and public Error/Chalk 7.56:1. These are supplied calculations, not a complete accessibility audit or new measurements by this documentation pass.

The slate blue in `starting-identity.svg` and `baseline.html` belongs to the explicitly fictional baseline. The rebrand retains its name/open-frame recognition, not that baseline color as a redesign action token.

## Typography

**Display Font:** Cormorant Garamond, with serif fallback. **Body Font:** Instrument Sans, followed by the narrowly scoped Form Symbols fallback and then sans-serif. **Arabic Font:** IBM Plex Sans Arabic; the public stylesheet names it `Plex Arabic`, while the editor uses its full family name.

The Latin editorial face contrasts with quiet functional information. The public stylesheet declares the local Latin WOFF2 files for Cormorant Garamond at weights 300–700 and Instrument Sans at 400–700, with `font-display: swap`. The upstream Instrument Sans subset lacks superscript two (U+00B2). Both public and editor stylesheets explicitly declare `Form Symbols` from the approved Cormorant Garamond WOFF2 with `unicode-range: U+00B2`, then place it immediately after Instrument Sans in Latin functional stacks. This preserves canonical m² with the verified approved glyph rather than attributing that glyph to Instrument Sans. `font-checks.json` records the upstream gap and its resolution. Arabic uses the shared local regular and semibold WOFF2 files. OFL notices for all three families are retained beside their font assets. The wordmark's FORM letters are custom vector paths, not live Cormorant text; the supporting ARCHITECTURE descriptor is authored type in the master.

### Hierarchy

- **Display / Hero:** the general page title and narrower home positioning have separate observed clamp roles in the frontmatter. Editorial headings use medium weight, balanced wrapping and the same tracking. The final home-positioning override keeps whole words and removes its earlier width cap.
- **Headline / Title:** section and study headings share the serif character. Story headings use `clamp(36px,3.7vw,56px)`; brief/material headings are 44px on desktop and 38px on mobile.
- **Body:** the default reading measure is 68ch. Supporting passages deliberately use narrower measures, commonly 31–58ch, according to their image/story column. Facts and captions remain below the paragraph scale.
- **Label / Caption:** permanent field labels, readable project facts, study status and adjacent image captions remain distinct from editorial headings. Year/area values use tabular numerals and readable LTR direction.
- **Editor:** Instrument Sans provides a denser functional hierarchy: 2rem introductory heading, 1.2rem group headings, 1rem image/story headings, `.875rem` labels and `.8125rem` help. The editor is not an editorial display page.

**The Arabic Shaping Rule.** Arabic uses IBM Plex Sans Arabic, normal letter spacing and document RTL. Latin identities, file paths, email addresses and numeric fragments retain readable direction; do not track Arabic to imitate the Latin display voice.

Desktop Arabic page titles use the documented Arabic role; its hero uses `clamp(42px,4.35vw,64px)` at 1.4 line height, section headings `clamp(32px,3.3vw,48px)` at 1.4 and study headings `clamp(25px,2.2vw,34px)` at 1.45. At 760px and below, Arabic page/project titles use `clamp(38px,8.8vw,58px)`, the hero uses `clamp(38px,8.8vw,60px)` and story headings become 32px. Paragraph/fact line height is 1.9.

## Layout

An eight-pixel foundation governs the principal gaps and passage spacing. Eight, sixteen and twenty-four pixels group related content; thirty-two through sixty-four pixels separate paired editorial parts; the main desktop sections use ninety-six pixels. Fine label gaps, rule offsets and native control dimensions retain observed exceptions instead of being forced onto an artificial scale.

Public gutters use `clamp(24px,4.45vw,80px)`. Paired stories commonly use `.85fr / 1.45fr` or its inverse with a 56px gap. The opening uses `minmax(280px,.85fr) / minmax(0,1.45fr)`; project previews use `1.3fr / 1fr`. The second home preview is offset by 112px. At 1000px gaps tighten to 32px and that offset becomes 72px. Above 1600px, header/main content is capped at 1760px.

At 760px and below, public gutters become 24px; paired editorial sections, process, work and form fields become single-column; alternating story image order resets to linear reading order; section spacing generally becomes 56px. The wordmark and language links occupy the first header row, while all three native navigation links occupy a visible second row. At 380px and below, gutters become 20px and the primary enquiry action fills its row. This is normal page flow without a hidden mobile menu, scroll takeover or automatic slideshow.

| Image use | Desktop | At 760px and below |
| --- | --- | --- |
| Home opening | Fixed responsive height: `clamp(420px,45vw,680px)`; 540px under 1000px | 4:3 |
| Ordinary project preview | 4:3 | 4:3 |
| Third compact home preview | 16:9 | 4:3 |
| Project opening | 16:9 | 4:3 |
| Story photograph | 4:3 | 4:3 |
| Material detail's primary section | 16:7 | 4:3 |
| Same material image in a story | 4:3 | 4:3 |
| Story diagram | Complete drawing contained inside a 4:3 surface | Complete drawing contained inside a 4:3 surface |

Photographs use independent desktop/mobile focal coordinates from their image record. Full-image links preserve uncropped inspection. The editor's “Project-page crops” panels mirror opening, story and material primary use. Its diagrams instead show the complete 8:5 drawing with disabled irrelevant focal controls. The editor explains the material image's additional 4:3 story use and directs the editor to the full public preview for every placement; it does not imply a home-opening crop.

The CMS has a 1800px content cap, a sticky project list, and a single editing column that splits into editing/preview columns when a preview is open. At 1150px it stacks that preview and makes it non-sticky; at 760px the three study controls become an in-flow row; at 430px bilingual field and focal groups become single-column. Its 390px preview option is explicit, while Fit panel uses available preview width. All spacing and directional alignment use the source's logical properties where supplied.

## Elevation & Depth

The implemented system uses no authored box shadows. Thin rules, tonal surfaces, imagery and readable grouping establish depth. Preview remains an adjacent or stacked region, not a modal layer. Native browser confirmations protect editor discard/removal actions; the public site and editor introduce no custom dialog.

Motion is restrained and user-triggered. Linked project imagery scales to 1.018 over 650ms with `cubic-bezier(.16,1,.3,1)`; text-link arrows move 2px on hover, with RTL direction respected. Public content is visible before enhancement. Device reduced motion removes scaling and collapses transition duration; the editor disables transitions. The 420ms enquiry preparation delay is local feedback, not evidence of network delivery.

## Shapes

The system uses square corners and one-pixel rules. The secondary mark's master is vertical 3:4, with one lower-right opening; its original SVG canvas is 96 × 128. The wordmark has optically authored letter geometry and spacing. Do not redraw it with a font or borrow Frame Academy's square offset corners.

Clear space is half the wordmark cap height on every side. Supplied proofs inspect the full lockup at 192 CSS pixels wide and a standalone frame at 24 CSS pixels high with nearby Form identification. These are digital examples, not universal print-production minima. The public header uses the 192px wordmark. Light, dark and monochrome editable masters preserve the recognition geometry.

The thin inset open-frame trace on linked preview images echoes the identity without masking the scene. Concept diagrams remain crisp explanatory geometry, with full content preserved by containment.

## Components

### Buttons and links

Actions are useful and quiet. The public primary button uses Functional Sage/Chalk, square corners and a 52px minimum height; hover uses Charcoal. The secondary uses a Charcoal outline and quiet tonal hover. Text links have a one-pixel bottom rule, a 48px minimum height and an authored SVG arrow. Full-image and navigation links keep practical 44px targets. The editor's primary button has a 44px minimum height and white text, with Charcoal hover; secondary editor actions are outlined.

Public keyboard focus uses a three-pixel Functional Sage outline offset by four pixels. Editor focus uses a two-pixel outline with the same offset. Pending enquiry feedback disables its action and names the preparation state; editor publication names the image-checking state. Disabled controls retain their observed opacity/cursor feedback. No unsupported button variant is implied.

### Project previews and stories

Image, title, facts, summary and study action form an open editorial group, not a rounded card surface. Titles and images provide separate, non-nested links. Captions remain adjacent to their image. The project template places a native fact list beside the brief, then ordered image/explanation chapters, material context and an enquiry invitation. A project-context preview in Contact shows which study travels with the editable reference.

### Inputs and recovery

Public fields use a transparent canvas, visible border, square corners and 52px minimum height; textareas have a 160px minimum. Editor fields use Editor paper, their separate border and a 44px minimum; textareas have a 100px minimum. Permanent labels precede the controls. Hint and error text identify the field's requirement and recovery; `aria-invalid` changes the boundary, with explicit error text rather than color alone.

An invalid enquiry preserves its values, focuses its first invalid control and announces review status. The receipt preserves the visitor's text and editable reference and explicitly states it was not sent. The simulated local failure preserves the draft and offers the same named preview action for retry. Empty or missing study/image states explain the gap instead of presenting fabricated content. Storage failure has persistent visible guidance: public input remains in this tab; editor publishing/preview explains which storage must become available before retry.

### Navigation and editor structure

Visible Work, Studio and Contact links use current-page underlining and native route actions. English/Arabic links remain visible and preserve the active route/draft where supported. Route changes focus their heading; the skip link reaches the main content. The editor exposes current study selection, bilingual field groups, live crop controls, ordered story moves, a real-renderer preview and separate preview/publish actions. Native confirmations protect removal/discard. Keyboard moves retain the section's text/image relation and restore the appropriate move-control focus.

### Browser surfaces

Selection, caret, underline thickness/offset, public scrollbar and tabular fact/focal numerals are deliberately themed. They carry the same restrained functional palette as visible controls. The editor keeps native ranges with Functional Sage accents and LTR numerical direction. The no-script public surface retains readable English study imagery and contact guidance.

## Do's and Don'ts

### Do:

- Do keep each spatial image beside its caption and the decision it explains.
- Do retain the approved custom wordmark, lower-right open frame, square corners and one-pixel rules.
- Do use the implemented crop for each placement and preserve full-image inspection.
- Do preserve readable focus, permanent labels, drafts and story/image relations through recovery.
- Do shape Arabic with the local family and normal tracking while keeping Latin/numeric fragments readable.
- Do keep Form's documented world scoped separately from the CR8.Media shell and Sift.

### Don't:

- Don't turn generated study scenes or conceptual diagrams into commissioned, built or construction-approved claims.
- Don't use decorative Sage or Clay as the ordinary functional text or sole status signal.
- Don't replace the usage-specific crops with one generic desktop/mobile ratio.
- Don't hide content behind an entrance animation, automatic slideshow or scroll takeover.
- Don't present browser-local Publish or Preview as server publication, or the demo receipt as a sent enquiry.
- Don't paste the internal direction contract into the public site.
