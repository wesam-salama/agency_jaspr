# Form documentation check

13 October 2026. Scan-mode documentation of the current approved Form world. No new visual direction was selected.

This pass writes only `docs/form/PRODUCT.md`, `docs/form/DESIGN.md`, `docs/form/.impeccable/design.json` and this file. The scoped path is deliberate: the CR8.Media shell owns the root design system, while Form owns its public site, editor and artwork. Existing Sift artifacts and the original agency reference were not edited by this task.

The extraction used the shared sections 1–7 and complete Form chapter of `docs/selected-work-context.md`, the approved code-led contract in `docs/form/design/direction.md`, current agency PRODUCT/DESIGN context, the Impeccable document reference/craft floor, and the finished Form source. The internal direction contract remains documentation; it was not inserted into public copy.

The normative tokens came from `web/assets/selected-work/form/site/style.css` and `cms.css`; behavior came from `app.js`, `cms.js` and `data.js`; recognition geometry came from the original `source/*.svg` assets. The documentation records the actual palette, type roles, local font files and notices, eight-unit foundation with observed exceptions, square corners, one-pixel rules, responsive/RTL behavior, image usage ratios, focus, validation and unavailable-storage recovery. It makes the separate browser-local CMS and not-sent enquiry receipt explicit.

| Documentation check | Result / evidence |
| --- | --- |
| DESIGN format | Passed. Valid YAML was parsed separately with Ruby; eight canonical sections, 22 colors, 12 type roles, eight component variants and 20 resolved primitive references. |
| Exact colors | Passed. All 22 colors exist in current public/editor CSS; no extra shipping color primitive was chosen. |
| Sidecar token ownership | Passed. Primitive ownership remains in frontmatter. Canonical metadata is aligned; synthesized eight-step OKLCH ramps are panel previews only, not shipping colors. |
| Component previews | Passed. Nine representative snippets use scoped classes, literal source CSS, variable fallbacks and inline SVG; no runtime package dependency. |
| Narrative alignment | Passed. Approved North Star, full overview, characteristics and guardrails copied directly; two source-derived named rules are retained. |
| Current hero override | Passed. Final whole-word positioning correction documented; superseded cap is not prescribed. |
| Public crop roles | Passed. Opening 16:9 desktop/4:3 mobile, story 4:3, material primary 16:7 desktop/4:3 mobile, additional material story use 4:3. |
| Corrected editor crop roles | Passed. Usage-specific previews, full 8:5 diagrams and disabled unused focal controls documented; homepage framing is separate. |
| Natural-finish Arabic | Passed. Current Courtyard wording agrees with the corrected natural-finish meaning. |
| Font URLs | Passed. All 8 CSS font references resolve locally after the explicit Form Symbols additions; Latin subset and Arabic regular/semibold assets match their documented roles. |
| OFL notices | Passed. SIL OFL notices exist for all three font families; physical printing and independent clearance remain unclaimed. |
| Frame source geometry | Passed. Original 3:4 geometry with the lower-right opening is retained in the signature snippet. |
| Supplied check records | Passed. Current supplied records: 56 responsive views, nine named public checks, eleven editor checks and nine vector entries, all with their recorded successful results; not rerun here. |
| Depth and dialog scope | Passed. No authored shadows or public/editor modal are prescribed; native editor confirmations are identified. |
| Agency design preservation | Passed. Agency DESIGN and sidecar match pre-documentation hashes. This task writes only its four named Form documentation files and no Sift/application source. |

`DESIGN.md` carries token-bearing YAML frontmatter and all eight canonical headings. Its schema-version-2 sidecar extends those primitives with color/type metadata, preview-only tonal ramps, motion, breakpoints, nine representative components and exact narrative mapping. Focus treatments, border rules and full component states remain in the sidecar because the frontmatter component schema cannot represent them. Snippets preserve their source font families and supplied fallbacks; local fonts are served by the Form pages.

The current home proof at `verification/website/en-home-1440.png`, Arabic project proof at `verification/website/ar-courtyard-390.png` and recaptured crop proof at `verification/website/cms-focal-desktop.png` were opened for a source-to-document spot-check. They support the documented image/story relationship, linear RTL mobile order and corrected 16:9/4:3 opening previews. This is not a fresh browser interaction or independent language review.

The initial `finish-review.md` describes the first eight-vector audit and three material corrections. Its counts are historical; the current identity audit now includes a ninth starting-brochure source. Current crop source, recaptured editor proof and Arabic description reflect the corrections. The bounded confirmation verdict and the integrating agent's whole-agency checks remain separate evidence. Documentation does not promote their status.

The supplied public/editor records were read, not rerun. This pass performed YAML/JSON/reference parsing, source/token/geometry comparisons and file-existence checks. It did not run application unit tests, rebuild the agency, certify production integration, publish a site, verify external delivery, or independently audit WCAG compliance. Source snippets and local test records establish their stated scope only.

Root agency preservation hashes at the end of this pass:

- `DESIGN.md`: `0fd5be8c156c991ac65ab06aa9a1e7d07b811360de0ff3ba54a0405ba462e3d5`
- `.impeccable/design.json`: `69a98e7d21af96e79115d77f6eed0e3fac1092d9d46b485198642af6b910b914`

These match the values captured before writing the scoped documentation. The task added no Sift or application mutation. Physical printing, real architectural commissioning/construction, an authenticated or hosted CMS, receiving-service delivery, independent commercial Arabic review and real business outcomes are unclaimed.

## Later edit — explicit superscript fallback

The final font-coverage pass found that upstream Instrument Sans lacks U+00B2. Both public and editor CSS now define `Form Symbols` from the approved local Cormorant Garamond WOFF2, restricted with `unicode-range: U+00B2`, and use `Instrument Sans, Form Symbols, sans-serif` in Latin functional stacks. The scoped frontmatter and sidecar snippets now match that chain. Arabic font rules retain their existing families and direction. `font-checks.json` explicitly records the upstream gap as `resolved_missing` and the approved fallback's verified coverage; it does not attribute the superscript glyph to Instrument Sans.

After this later edit, the actual CSS declarations, scoped token/reference chain, sidecar component font families, local font-file references and YAML/JSON syntax were rechecked. This was a source/documentation recheck; browser or production checks are owned by the integrating agent and were not rerun here.
