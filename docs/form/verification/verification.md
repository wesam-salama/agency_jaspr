# Form Architecture — final local verification

13 October 2026. Scope: authored identity and baseline, generated conceptual study imagery, implemented responsive EN/AR website/editor/enquiry demonstration and EN/AR/FR agency Selected Work integration. Branch `selected-work`; no public deployment.

## Code and production

- Full Dart suite: **59 tests passed**, including all asset presence/srcset checks, localized Form, preserved Sift and reference-copy/shared-flow contracts. Existing server-render test warnings about a client entry are confined to the test context; the production client bundle is present.
- Dart analysis: no issues. Formatting: 41 files, zero changes. `git diff --check` passed.
- Public/CMS JavaScript: **12 focused tests passed**; source scripts parse and actual browser checks report no page JavaScript errors.
- Owned Jaspr debug server received a successful Dart MCP hot reload, then was stopped before the final static build.
- Production build succeeded with the existing Jaspr 0.23.4 and `SITE_BASE_PATH=/agency_jaspr/`; English, Arabic and French routes generated.
- Sift preservation: 115 existing files are byte-identical. Original reference SHA-256 remains `7a4d4736ada6b8e624f17ef95e082e6f67fac80e21903fc52192ac1f8c803295`. Marrow and Northline retain their approved copy, layouts, quotes and metrics; reference tests protect them.

## Browser evidence

[public-checks.json](public-checks.json) records **56 responsive views**: seven page/study views × two languages × 320/390/768/1440px. All measured document overflow is zero; study images load. Nine named checks comprise that responsive aggregate and eight separate functional/fallback checks. They cover Home → Work → study → contextual enquiry, first-invalid focus and associated errors, verbatim draft/reference continuity through language/reload, induced failure/retry and exact not-sent receipt, over-limit draft preservation/counter timing, reduced-motion content, usable 320px no-script fallback and unavailable-storage recovery. The final run used the production Form URL.

[cms-browser-checks.json](cms-browser-checks.json) records **11 passing checks**, zero page JavaScript errors, real edited preview and a corresponding published public page. The browser checked required-field blocking, mandatory preview, draft reload, independent focal controls, keyboard story reorder and focus restoration, retained story after image removal, Arabic mobile/long-title/absent-area behavior and storage failure recovery. All eight canonical crop previews have asserted ratios/fitting matching their declared public usage. Six actual state captures include the complete changed summary. The final run used the production editor URL.

[agency-checks.json](agency-checks.json) records **12 locale/viewport combinations**: English, Arabic, French at 320/390/768/1440px. Checks cover slot 02, all eleven case images and ten figures, project facts, body/dialog overflow, loaded fonts, initial title focus, Tab wrapping, Escape opener restoration, shared red curtain, Form → Marrow and Sift → Form, and local demo/download destinations. Final records have zero overflow and no console/page errors. The first run's sole error was the local host-root automatic favicon request; the existing built favicon was mapped at the preview host root and the full confirmation passed. No agency source change was needed for that preview condition.

The stable production preview is `http://127.0.0.1:8798/agency_jaspr/`; Form is under `assets/selected-work/form/site/index.html`, with `editor.html` and `baseline.html` alongside it. Desktop/mobile screenshot and HTTP/file records are stored here. Browser checks are local Chrome evidence, not physical-device performance or field measurements.

## Artifact review and integrity

- Nine generated native study images, three authored relationship diagrams and nine identity SVG proofs plus small-size proof are retained; text bounds audit reports no overflow.
- Twelve parent presentation boards, fourteen responsive variants and nine study WebPs use recorded dimensions. Final website comparisons/screens use actual implementation captures; screenshots are straight and preserve source proportions.
- The once-run detector reported comparisons with the agency's type/palette, pinned Form fonts/Chalk and an exact geometric frame; those do not override the approved Form system. Its fallback-padding signal was checked against the implemented 64px padding. Findings and independent disposition are retained.
- Independent review: **ship** within the reviewed Form scope; all three listed material fixes scored resolved. Agency production/file checks above are the integrator's separate verification.
- Form's token-bearing DESIGN and scoped sidecar were documented from finished source and rechecked after the explicit superscript fallback. Agency design files were preserved.
- Exact generation prompts/source paths, per-raster embedded provenance, font coverage/licences, file checksums and final source/build/ZIP integrity are recorded. The extracted source package includes working Arabic fonts and local assets; a separate package smoke check passed for English home, Arabic project and editor views (package-browser-checks.json).

This remains a studio concept. Construction, client commissioning, live enquiry delivery, hosted CMS accounts, external publication, independent commercial translation, physical printing and business performance are unclaimed.
