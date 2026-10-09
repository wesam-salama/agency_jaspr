# Reference layout restoration — 9 October 2026

The Jaspr page now follows the organization of `../agency_website.html`, with the current CR8.Media identity, copy, illustrative framing and enquiry flow retained. The original HTML was not edited. Its SHA-256 remains `7a4d4736ada6b8e624f17ef95e082e6f67fac80e21903fc52192ac1f8c803295`.

## Concrete improvements

- The header exposes Services, Work, Process, Engagement, Studio and FAQ, followed by Start a project. At narrow widths the enhanced menu keeps keyboard dismissal and focus return; fallback links wrap into readable rows.
- Section labels, titles and introductions share one alignment system. Titles stop at 44px; introductions move below titles on mobile.
- Services form a connected two-column grid. All six labelled deliverable lists are immediately visible.
- Work retains four visible descriptions and illustrative labels beneath 16:10 landscape images. Image size hints follow the restored grid.
- Process is one ordered six-stage sequence with a continuous connector. Active stages colour the connector; paused motion leaves the complete sequence readable.
- Engagement choices share boundaries, padding and aligned actions. Studio groups its narrative opposite the existing brief guidance and CTA.
- FAQ questions and dividers share the heading's left edge and full content width. Native independent disclosures use trailing plus/minus controls, with answers limited to 68ch.
- Services and Work become one column at 860px. Mobile contact keeps the form before its diagram. Anchor arrivals leave approximately 16px between the header and section label.

## Verification

Formatting and `git diff --check` pass. Dart analysis reports no issues. All **34 tests pass**, including the updated six-link navigation contract and visible service lists, ordered process and independent native FAQ controls.

The production build succeeds. The existing preview's build daemon and proxy occupied Jaspr's default ports, so release compilation ran in a temporary copy of the same source with the same Jaspr CLI version, using a temporary CLI copy whose internal proxy port alone changed from 5567 to 5568. The installed CLI and running preview were preserved. Source/CSS equality was checked before copying the generated `build/jaspr` output back.

One combined source, visual and mechanical review was followed by one confirmation pass. No further design changes were needed after that review.

| Browser check | Result |
| --- | --- |
| Every section at 1440, 900, 768, 390 and 320px | Inspected; full-page screenshots saved |
| Menu/grid breakpoint at 860 and 861px | Correct change of layout; no horizontal overflow |
| Visible service lists and FAQ alignment at all seven widths | Pass |
| Desktop and mobile anchor visibility | Section label clears sticky header by approximately 16px |
| Mobile menu links, Escape and selection dismissal | Pass; Escape returns focus to the menu button |
| FAQ Enter/Space, multiple open answers and visible focus | Pass; 3px focus outline, minus controls when open |
| Service preselection and reset | Web development selects Web Dev and focuses Project goal; reset clears selections |
| Empty enquiry validation | Required fields identified; focus returns to Name |
| Four case dialogs, Next, Escape and focus trap | Pass; all four images loaded; focus returns to each opener |
| Case transition interruption | Temporary transition layers removed on close |
| Hero/footer pause controls and process connector | Synchronized; connector transition becomes 0s when paused |
| No application JavaScript | Script-free compiled fixture: all six links wrap at 320px and native FAQ works |
| Browser console | No captured errors or warnings on the production page |
| 200% reflow equivalent | 720×500 CSS-pixel viewport for a 1440×1000 display; no overflow and lists remain visible |

Native browser zoom shortcuts had no effect in the available in-app browser, so **actual 200% browser zoom is unverified**. The device reduced-motion preference was false during browser inspection; its policy combinations pass unit tests and its media-query/runtime paths were reviewed, but **changing the real device preference during this run is unverified**. A valid email draft was not opened in an external mail application; existing payload tests passed and browser validation/preselection were checked.

## Detector review

The final scan of compiled HTML and its linked CSS completed with exit 2 and **18 raw warnings**. This is a findings result, not a scan failure. No ignores or broad suppressions were added.

| Rule | Count | Contextual assessment |
| --- | ---: | --- |
| broken-image | 1 | The hidden dormant dialog image has no source until a case opens. All four populated dialog images loaded in the browser. |
| cramped-padding | 7 | Three background sections contain inset wrappers; the Work grid contains padded text below edge-to-edge images; Studio and FAQ borders contain padded rows. The marquee intentionally reaches its clipped boundary. Rendered text spacing was inspected. |
| all-caps-body | 8 | Repeated decorative marquee strings, excluded from the accessibility tree. Reading copy remains sentence case; section labels are short. |
| overused-font | 2 | Inter and Space Grotesk are explicitly preserved by the approved brief. |

## Evidence and comparisons

- [Before header](verification/reference-layout/before-header.png), [before FAQ](verification/reference-layout/before-faq.png)
- [After desktop FAQ](verification/reference-layout/desktop-faq.jpg), [expanded FAQ](verification/reference-layout/desktop-faq-expanded.jpg), [mobile FAQ](verification/reference-layout/mobile-faq-390.jpg)
- [Full page at 1440px](verification/reference-layout/page-1440.jpg), [900px](verification/reference-layout/page-900.jpg), [768px](verification/reference-layout/page-768.jpg), [390px](verification/reference-layout/page-390.jpg), [320px](verification/reference-layout/page-320.jpg)
- [Loaded landscape Work gallery](verification/reference-layout/desktop-work.jpg), [fallback header](verification/reference-layout/fallback-header-320.jpg)
- [Responsive measurements](verification/reference-layout/responsive-final.json), [screenshot viewport measurements](verification/reference-layout/screenshot-viewports.json), [interaction results](verification/reference-layout/interactions.json), [console](verification/reference-layout/console.json), [raw detector findings](verification/reference-layout/detector-final.json)

The eight section anchors and case-dialog contracts are retained. Enquiry payloads and external APIs were not changed. Deployment, the removed side rail and the standalone statistics section remain outside this change. Pre-existing local marquee/motion changes were preserved.
