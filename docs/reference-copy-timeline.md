# Reference copy and timeline — 9 October 2026

The eight existing sections and four case studies now use the supplied `../agency_website.html` wording. Original punctuation and spelling, including “Program”, CMS descriptions, process durations/deliverables, engagement terms, Studio values, FAQs, captions and quotes are restored. Added illustrative UI labels are removed by user approval; the typed case data and PRODUCT.md continue to identify the examples as unverified.

The enhanced contact flow retains required name, email and project goal; optional timing and service checkboxes; inline validation, preselection, reset and the existing encoded mailto payload. Shared controls use reference labels and placeholders. All cases and Next retain the previously selected Loop curtain, even though the original Work introduction describes individual transitions. The reference file, local assets, other motion, removed statistics strip/rail and inactive social links were preserved.

## Timeline behavior

A single background rail and red fill replace the one-time segmented connectors. Height is `clamp(viewportHeight * .7 - timelineTop, 0, timelineHeight)`; dots activate when their relative row offset is `<= height + 8`. Upward scrolling retracts the fill and deactivates passed dots. The original first dot is active at zero progress, as in the reference.

The fill uses 250ms ease and dots 300ms ease. Desktop uses a 2px rail at left 16px, 14px dots, 48px list inset and 34px row inset; at 860px the rail moves to 10px, dots become 12px, and insets become 32px/24px. Row spacing is 56px except after the final step. Below 480px the process wrapper uses the reference 16px gutter. Initial rendering, scroll, resize, body/timeline layout observation and policy changes update a coalesced one-shot frame callback; disposal cancels it and disconnects observers. Pause/reduction removes transitions while retaining immediate scroll feedback.

## Validation

- **47 tests passed**, including reference-copy comparisons for every existing section and all four case data sets, progress clamping, eight-pixel activation thresholds, reverse scroll and resize dimensions. Existing navigation, motion policy, assets, mailto encoding and curtain tests pass.
- Formatting check and Dart analysis pass; analysis reports no issues. `git diff --check` passes.
- Production Jaspr 0.23.4 compilation succeeds. It used an ignored isolated workspace and a temporary CLI copy changing only the internal proxy port to 5568, with static rendering on 8083. The installed CLI was unchanged. All app-owned source and assets were compared byte-for-byte before copying output back to `build/jaspr`.
- Browser inspection at **1440×1000 and 390×844** confirmed reference geometry and forward/backward fill/dot behavior. Live resizing at **320, 390, 860, 861 and 1440px** matched the formula and active-dot thresholds with no horizontal overflow.
- Hero/footer pause controls stayed synchronized; paused scrolling updated immediately with no fill or dot transition.
- FAQ Enter/Space opened independent answers. Web development preselected Web Dev and focused the project field; reset restored the reference empty-selection text. Empty submission showed all three required errors and focused Name; timing remained optional. No email was sent or external mail client opened.
- All four cases opened through the shared curtain/Next flow with loaded local images, reference metadata, no demo labels and title focus. Escape closed the dialog, cleared layers and returned focus to the original card. Mobile menu Escape returned focus to its button.
- Browser console captured no errors or warnings.

One combined desktop/mobile inspection was followed by one confirmation after correcting the mobile gutter. Device reduced-motion policy combinations are covered by tests and runtime/CSS paths were inspected; changing the actual device preference was not performed. Physical touch, external email-app handoff and deployment remain outside the performed checks.

## Detector review

The compiled-HTML/CSS detector returned 20 contextual warnings, with no errors or new ignores: one height transition (explicit reference behavior on an absolute 2px rail), one dormant dialog image without a source (all populated images loaded), seven compact/boundary-padding findings, eight decorative marquee/short-label capitalization findings, two pinned font findings, and one reference eyebrow finding. The user-approved reference controls these choices; no broad suppression was added.

## Evidence

- [Desktop process](verification/reference-copy-timeline/desktop-process.jpg), [mobile process](verification/reference-copy-timeline/mobile-process.jpg), [restored hero](verification/reference-copy-timeline/desktop-hero.jpg)
- [Desktop page](verification/reference-copy-timeline/desktop-page.jpg), [mobile page](verification/reference-copy-timeline/mobile-page.jpg)
- [Timeline samples](verification/reference-copy-timeline/timeline.json), [responsive checks](verification/reference-copy-timeline/responsive.json), [interactions](verification/reference-copy-timeline/interactions.json), [console](verification/reference-copy-timeline/console.json)
- [Checks](verification/reference-copy-timeline/checks.json), [tests](verification/reference-copy-timeline/tests.log), [analysis](verification/reference-copy-timeline/analysis.log), [build](verification/reference-copy-timeline/build.log), [detector](verification/reference-copy-timeline/detector.json)

Original reference SHA-256: `7a4d4736ada6b8e624f17ef95e082e6f67fac80e21903fc52192ac1f8c803295`.
