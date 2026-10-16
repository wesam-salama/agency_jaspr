---
name: Fold Clothing — Everyday Structure
description: Garment-led editorial clothing with a practical, bilingual shopping system.
colors:
  ivory: "#F6F3EC"
  ink: "#161A18"
  citrine: "#D8F16A"
  olive: "#3C4A3E"
  slate: "#636F65"
  mist: "#D8DDD3"
  rule: "#B4B8AE"
  error: "#9A3026"
typography:
  display:
    fontFamily: "Archivo, sans-serif"
    fontWeight: 600
    fontSize: "clamp(44px,5.5vw,80px)"
    lineHeight: 1.03
    letterSpacing: "-.035em"
  headline:
    fontFamily: "Archivo, sans-serif"
    fontWeight: 600
    fontSize: "clamp(30px,3.5vw,48px)"
    lineHeight: 1.12
  body:
    fontFamily: "DM Sans, sans-serif"
    fontSize: "16px"
    lineHeight: 1.65
  arabic:
    fontFamily: "IBM Plex Sans Arabic, sans-serif"
    fontWeight: 400
    letterSpacing: "normal"
  price:
    fontFamily: "DM Sans, sans-serif"
    fontFeature: "'tnum'"
rounded:
  control: "0px"
spacing:
  unit: "8px"
  fine: "4px"
  related: "16px"
  group: "24px"
  passage: "32px"
  generous: "48px"
  section: "72px"
components:
  button-primary:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.ivory}"
    rounded: "{rounded.control}"
    padding: "16px 20px"
---

# Design System: Fold Clothing

## Overview

**Creative North Star: "Everyday Structure"**

Garment shape, fabric and useful information carry Fold's expression. The compact cut-letter signature, ivory canvas, ink information, olive textile imagery and restrained citrine selections connect editorial clothing to practical shopping decisions. Generous garment space, square edges and clear hierarchy keep the system tactile and direct.

This scoped system records the finished local source on 15 October 2026. [site/style.css](../../web/assets/selected-work/fold/site/style.css) owns store values; [source/identity.css](../../web/assets/selected-work/fold/source/identity.css) owns the editable boards/guide. CR8.Media's root design system remains separate. Product records and demo boundaries belong to [PRODUCT.md](PRODUCT.md); surface composition belongs to [.impeccable/surfaces/store.md](.impeccable/surfaces/store.md).

**Key Characteristics:**

- Manually drawn FOLD geometry with one controlled cut and a repeatable F monogram.
- Ivory and Ink, restrained Citrine, and tactile Olive garment imagery.
- Archivo editorial hierarchy, DM Sans information and shaped Arabic without tracking.
- Square controls, crisp rules, readable measurements and in-flow state feedback.
- Garment and colour continuity, equivalent English/Arabic decisions and honest demo evidence.

## Colors

Ivory is the primary canvas, Ink the reading and action colour, and Citrine a small selected/status highlight. Olive carries occasional dark information panels. Slate supporting text stays at full opacity. Mist is a surface or decorative separator, never an accessible text/control boundary on Ivory by itself.

Approved solid-pair contrast: Ink/Ivory 15.86:1; Ink/Citrine 13.98:1; Slate/Ivory 4.75:1; Ivory/Olive 8.46:1. The Rule token is decorative. Control borders and focus use Slate/Olive. Error uses words and an associated recovery action, rather than hue alone.

**The Readable Information Rule.** Slate text on Ivory stays at full opacity; Mist does not supply an accessible text or control boundary by itself.

## Typography

Archivo 600 makes Latin display and headings; DM Sans carries body, controls, captions, prices and tables. Both WOFF2 files are official Google Fonts variable 400–700 subsets, hosted locally. Full editable variable TTF masters and OFL licences are included. The signature is drawn geometry independent of both fonts.

The general title is `clamp(44px,5.5vw,80px)` / 1.03; the collection title is `clamp(48px,5.2vw,76px)`. The general headline is `clamp(30px,3.5vw,48px)` / 1.12. Latin heading tracking is -.035em; product-card information uses DM Sans with -.02em tracking. Prices, totals, SKU and table values use tabular numerals.

Arabic uses actual IBM Plex Sans Arabic 400 and 600 files, normal tracking, document RTL, logical spacing and natural expansion. Store CSS names this font `'Plex Arabic'`; guide CSS names the same file `PlexArabic`. General Arabic title leading is 1.35 and headline leading 1.5. Latin identity, SKUs, currency and cm/inch values retain readable direction. Directional arrows mirror; the custom signature does not.

**The Arabic Shaping Rule.** Arabic uses the local Arabic family and normal tracking; Latin identities and numeric fragments retain their readable direction.

## Layout

An 8 px spacing base with 4 px adjustments, square corners and thin rules. Store gutters are `clamp(24px,4.4vw,72px)` within an 1800 px maximum. The collection starts with editorial copy beside one garment-led composition, then accurate filters and four garment records. Product details pair a generous image gallery and a purchase column. Mobile reflows into reading order and keeps controls reachable.

Garment cards use a .76 desktop image aspect ratio, .72 on mobile; the main product view uses .82 desktop and .9 mobile. Front, back and detail each retain the same variant relation and an accessible caption. Measurements remain in semantic tables with horizontal overflow contained within the table area on narrow screens.

The store shifts to two catalogue columns at 1100 px, a linear reading order at 760 px, and 20 px gutters at 370 px. Status and errors now occupy their own normal-flow space between the header and main content, with 24 px top margin and a width aligned to the content gutters. They wrap naturally in either script and cannot cover garment information or shopping controls.

Identity/packaging presentation boards are authored 2000 × 1500 compositions, with card/hero exports at 1600 × 1000 and 2560 × 1600. They are design presentations. Actual UI imagery uses rendered store captures. The separate guide has responsive and A4 print styles.

## Elevation & Depth

The finished store is flat. Tonal separation and rules define surfaces; status and errors have no overlay positioning or shadow. Citrine identifies a state region in the reading flow and the error border identifies recovery. The removed fixed feedback layer and its shadows are historical, not part of this system.

## Shapes

Use the manually drawn FOLD SVG, never typeset approximations. Its F upper terminal has one 10-unit cut and a 4-unit displacement. The other letters remain whole. The F monogram is the same path. A 28-unit stem defines clear space around the 550 × 164 unit signature. Screen minimums are 72 px wordmark and 20 px monogram; physical printing requires proofing. Ink, ivory, black and white masters are supplied.

Controls and information surfaces have square corners and crisp rules. Construction diagrams show fixed feature counts with plain explanatory geometry. The line vocabulary uses solid edges, limited dashes and short alignment ticks; it does not supply manufacturing dimensions. The four garment patterns and eight colour variants follow [garment-canon.md](design/garment-canon.md).

## Components

The primary button is Ink/Ivory, 56 px minimum height with 16 × 20 px padding. Fine-pointer hover uses Olive; press feedback scales to .98. Fields use a minimum 48 px height and 16 px text; shipping fields use 52 px. Size targets are 50 px desktop / 54 px mobile. Selected sizes use a 2 px Ink boundary and Citrine fill; unavailable sizes use dashed boundaries, words and disabled semantics.

Catalogue colour links are at least 44 × 44 px; removable filter chips and product-name links have a 44 px minimum height. Small swatch colour squares remain visually compact inside the full target. Header navigation and footer links retain a 44 px minimum height on mobile. Reflow preserves the product/price/colour relationship at narrow widths.

General keyboard focus uses a visible 2 px Olive outline with 5 px offset. Size-radio focus wraps the visible target with a 3 px offset. Text selection uses Ink on Citrine, carets Olive, and thin Olive/Ivory scrollbars. Status/recovery actions retain at least 44 px dimensions and remain in the reading flow. Dismissal, Undo and retry retain their distinct actions. Totals remain readable while updating.

Useful user feedback only. Store easing is `cubic-bezier(.16,1,.3,1)`: action press 120 ms, arrow 160 ms and garment preview 350 ms. Reduced motion removes animations/transitions and press/image transforms and uses automatic scrolling. Content is visible by default; no garment or price depends on an entrance animation.

**The Feedback Space Rule.** Feedback stays in normal flow, preserves readable purchase information and never covers a shopping control.

## Do's and Don'ts

- Do use the exact authored signature and garment canon across every view.
- Do keep garment measurements, stock words and numeric values readable in both scripts.
- Do retain square targets, visible focus and in-flow feedback with explicit recovery actions.
- Do distinguish generated garment imagery, authored artwork and actual software captures.
- Do preserve the independent CR8.Media identity and the other Selected Work projects.
- Don't track Arabic or mirror the Latin FOLD signature.
- Don't use Mist or decorative rules as the only accessible control boundary.
- Don't allow feedback to cover product information or shopping controls.
- Don't present packaging geometry as manufacturing instructions or a demo as a commercial order.
- Don't invent sourcing claims, testimonials, commercial outcomes or performance metrics.
