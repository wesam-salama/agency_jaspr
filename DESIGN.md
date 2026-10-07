---
name: CR8.Media — Connected studio
description: A precise connected visual system for brand, web and apps.
colors:
  background: "#0b0b0c"
  alternate: "#111113"
  panel: "#141416"
  foreground: "#f3f3f0"
  muted: "#8c8c90"
  line: "#232326"
  accent: "#ff4433"
  accent-dim: "#3a1712"
typography:
  display:
    fontFamily: "Space Grotesk, system-ui, sans-serif"
    fontWeight: 600
    letterSpacing: "-.02em"
  body:
    fontFamily: "Inter, system-ui, sans-serif"
    fontSize: "1rem"
    lineHeight: 1.6
  data:
    fontFamily: "IBM Plex Mono, monospace"
rounded:
  control: "2px"
spacing:
  unit: "4px"
components:
  button-primary:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.background}"
    rounded: "{rounded.control}"
---

# Design System: CR8.Media

## Overview
Connected studio is confident, direct, and precise. A nearly black ground, warm white type, signal red, sharp edges, and connected geometric linework carry the established identity. Composition earns attention through clear type and useful imagery, while interactions explain the relationship between services and a project brief.

This document records the incumbent identity and the user-approved evolution. The stylesheet owns implemented values; the final verification pass refreshes this record from the shipped code.

## Colors
Use signal red for the primary action, selected services, and meaningful connecting lines. Use warm white for reading and headings; muted text must retain readable contrast. Neutral layers separate passages without decorative gradients or glow.

## Typography
Space Grotesk carries headings. Inter carries prose and controls. IBM Plex Mono is reserved for real measurements, timescales, and project metadata. Keep display tracking above -.04em and prose at a comfortable measure.

## Layout
The incumbent content container is 1200px. Use a 4px spacing base, tight related groups, and generous separation between distinct passages. Mobile reflows to one column; desktop uses purposeful asymmetric composition and a two-column project gallery.

## Elevation & Depth
Flat surfaces and quiet tonal separation are the rule. Borders distinguish controls and content boundaries. A dialog may use an offset soft shadow to clarify its layer.

## Shapes
Keep sharp 2px corners on controls and crisp geometric linework. The constellation is a diagram, not an illustration.

## Components
Primary actions use signal red and dark text. Secondary actions use quiet outlines. Native checkbox selection, persistent form labels, and conspicuous focus states are shared patterns. Project imagery is visible in the default state. Case dialogs protect focus and restore the opening control on dismissal.

## Do's and Don'ts
- Do retain the dark palette, existing font families, sharp edges, and connection motif.
- Do label illustrative content and distinguish draft preparation from message delivery.
- Do let the constellation acknowledge a useful service selection.
- Do keep content visible before client enhancement.
- Don't turn every section into an identical card grid or animation.
- Don't use hover as the only way to reveal portfolio work or functionality.
