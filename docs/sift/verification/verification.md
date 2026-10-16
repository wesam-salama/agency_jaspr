# Sift Coffee — final verification

13 October 2026. Scope: finished digital Sift identity, application artwork, guide and the first agency Selected Work case. Integration is local on branch `selected-work`; no GitHub Pages deployment is claimed.

## Code and build

- Dart analysis: no issues.
- Full test suite: **55 tests passed**, including localized Sift status/copy/download contracts and all responsive image dimensions. The server-render tests emit an existing client-entry warning in the test context; the production build includes the client bundle.
- Format: 40 files checked, zero changes. `git diff --check` passed.
- Production build succeeded with Jaspr 0.23.4 and `--dart-define=SITE_BASE_PATH=/agency_jaspr/`; English, Arabic and French routes were rendered. Final PDF/ZIP updates were copied into that build without changing its compiled code.
- Each built locale has the correct `/agency_jaspr/` base, Sift in slot 01 and one localized concept label. Final build downloads match source bytes.
- The owned Jaspr server received a successful Dart MCP hot reload before production export. The dev server was then stopped; the stable static preview is served locally at port 8796.
- Original reference SHA-256 remains `7a4d4736ada6b8e624f17ef95e082e6f67fac80e21903fc52192ac1f8c803295`.

## Browser checks

The Codex in-app browser opened the final static build at `/agency_jaspr/`, `/agency_jaspr/ar/` and `/agency_jaspr/fr/`. English, Arabic and French Sift cases were inspected at **320, 390, 768 and 1440 px**. Twelve measurement records and screenshots are saved in [responsive-checks.json](responsive-checks.json) and [website/](website). Document and case-body horizontal overflow were zero in every case. The Arabic layout has RTL direction, shaped local text and readable Latin names. French labels and narrative wrap comfortably. The complete hero composition remains visible.

The shared curtain opened Sift, Next opened Loop, and Escape restored the Sift card opener. Initial dialog focus landed on `cmTitle`. On mobile, Shift+Tab from Close wrapped to Next; Tab wrapped back to Close. Scrolling exposed all four chapters; the five case images loaded. English downloads, localized AR/FR labels and repository-path hrefs were inspected. The final production tab reported no browser console errors.

PDF and ZIP downloads succeeded through the case links. Their first downloaded bytes matched the files at that time. A later functional PDF fix replaced fourteen temporary-server annotations with authored relative paths. The corrected PDF was packed into the ZIP and copied into the production build; local final integrity/path/byte checks passed. Page 12's raster remained byte-identical after the annotation-only change.

The browser controls timed out during some dev-preview actions; fresh UI observations confirmed their results. Final responsive checks used the stable static build. Dynamic reduced-motion emulation was not exposed by the browser controls used here; existing motion-policy tests passed, and this change does not modify that policy. No physical device performance measurement is claimed.

## Artifacts

- Forty SVG masters and forty matching PNGs; eight application families.
- All twelve guide pages rendered and inspected; local fonts, linked artwork and six contrast pairs checked.
- Four case boards inspected; two generated scenes checked against the label reference, each with one targeted motif correction.
- Fourteen responsive WebPs at recorded native/export dimensions.
- PDF: twelve pages and fourteen relative handoff links; every destination exists.
- ZIP integrity passed; it contains forty SVGs and the exact corrected PDF.
- `final-artifact-checks.json` records final file/build checks.

The final HTTP spot-check passed after continuation: all three locale pages, the client bundle, stylesheet, hero and both downloads returned HTTP 200. PDF/ZIP response bytes match the source files; `http-checks.json` records the results. The initial attempt was blocked when account usage prevented automatic approval review; the approved retry completed successfully.

Physical printing, supplier dielines, independent commercial translation review, sourcing/tasting and recipe testing remain outside this digital concept delivery.
