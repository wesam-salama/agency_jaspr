---
name: CR8.Media — Connected studio
description: A connected studio expressed through clear type, geometric linework and authored motion.
colors:
  background: "#0b0b0c"
  alternate: "#111113"
  panel: "#19191c"
  foreground: "#f3f3f0"
  muted: "#b0b0b6"
  muted-secondary: "#96969e"
  line: "#333338"
  control-border: "#72727a"
  accent: "#ff4433"
  accent-dim: "#331b18"
  accent-hover: "#ff685a"
  diagram-line: "#763c36"
  scrollbar: "#62626a"
typography:
  display:
    fontFamily: "Space Grotesk, system-ui, sans-serif"
    fontWeight: 600
    fontSize: "clamp(2.5rem,5.5vw,4.65rem)"
    letterSpacing: "-.025em"
    lineHeight: 1.12
  headline:
    fontFamily: "Space Grotesk, system-ui, sans-serif"
    fontSize: "clamp(2rem,3.6vw,3.25rem)"
    fontWeight: 600
    lineHeight: 1.12
  title:
    fontFamily: "Space Grotesk, system-ui, sans-serif"
    fontSize: "1.45rem"
    fontWeight: 600
    lineHeight: 1.12
  body:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "1rem"
    lineHeight: 1.65
  label:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: ".875rem"
  control:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "1rem"
    fontWeight: 600
  data:
    fontFamily: "IBM Plex Mono, monospace"
    fontSize: ".875rem"
rounded:
  control: "2px"
spacing:
  unit: "4px"
  small: "8px"
  control-gap: "12px"
  related: "16px"
  group: "24px"
  passage: "32px"
  generous: "48px"
  wide: "64px"
  section: "96px"
components:
  button-primary:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.background}"
    rounded: "{rounded.control}"
    padding: "14px 24px"
    typography: "{typography.control}"
---

# Design System: CR8.Media

## Overview
Connected studio is confident, direct, and expressive. A nearly black ground, warm white type, signal red, sharp edges, and connected geometric linework carry the established identity. Moving points, drawn lines and distinct project entrances express the studio's creative character. Clear type and visible imagery keep the offering understandable throughout the motion.

This document records the implemented user-approved evolution. Values were refreshed from the production stylesheet on 8 October 2026. The stylesheet owns implemented values; .impeccable/design.json documents motion, breakpoints and component previews. The synchronized pause controls show the current state, and device reduction remains authoritative. Selection feedback sits beside the enquiry service controls.

## Colors
Use signal red for the primary action, selected services, and meaningful connecting lines. Use warm white for reading and headings; muted text must retain readable contrast. Neutral layers separate passages without decorative gradients or glow.

## Typography
Space Grotesk carries headings. Inter carries prose and controls. IBM Plex Mono is reserved for real measurements, timescales, and project metadata. Keep display tracking above -.04em and prose at a comfortable measure.

## Layout
The incumbent content container is 1200px. Use a 4px spacing base, tight related groups, and generous separation between distinct passages. Mobile reflows to one column; desktop uses purposeful asymmetric composition and a two-column project gallery. The enquiry form precedes its selection diagram on mobile; the diagram sits beside the brief on desktop. Unenhanced mobile navigation exposes the section links directly.

## Elevation & Depth
Flat surfaces and quiet tonal separation are the rule. Borders distinguish controls and content boundaries. A dialog may use an offset soft shadow to clarify its layer.

## Shapes
Keep sharp 2px corners on controls and crisp geometric linework. The constellation diagrams explain service relationships and carry the studio's motion language.

## Components
Primary actions use signal red and dark text. Secondary actions use quiet outlines. Native checkbox selection, persistent form labels, and conspicuous focus states are shared patterns. Project imagery is visible in the default state. Case dialogs protect focus and restore the opening control on dismissal.

The hero's organic constellation is the focal motion: small node drift, a bounded fine-pointer ink trail, and accumulated service connections. Native service links freeze during interaction; coarse-pointer labels remain stable while decorative points move. Six service SVG motifs and two slow service marquees carry the same vocabulary. Portfolio particles disperse on hover and focus without obscuring the work.

Each case retains its own entrance: Fenwick & Ash expands an image over 650ms, Loop uses a 700ms red curtain, Marrow opens an iris over 650ms, and Northline uses a 700ms tunnel zoom. Title, toolbar and focus indicators remain outside the animated image presentation. Selection paths draw over 400ms; routine feedback uses the existing 150ms/250ms tokens.

Pause controls synchronize across the hero and footer. Device reduced-motion preferences remain authoritative. Ambient loops stop offscreen, when the document is hidden, and behind an open case. One demand-driven animation-frame scheduler owns canvas drawing and bounded metric counts; transition transactions own and cancel their temporary layers. Static SVG, content and imagery remain visible if enhancement fails.

## Do's and Don'ts
- Do retain the dark palette, existing font families, sharp edges, and connection motif.
- Do label illustrative content and distinguish draft preparation from message delivery.
- Do let the constellation acknowledge a useful service selection.
- Do preserve moving points, line drawing, service motifs and the four distinct case entrances as part of the creative identity.
- Do make motion interruptible and provide pause and intentional reduced-motion states.
- Do keep content visible before client enhancement.
- Don't turn every section into an identical card grid or animation.
- Don't use hover as the only way to reveal portfolio work or functionality.
