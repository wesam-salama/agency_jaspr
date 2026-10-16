# Fold Clothing — final local verification

15 October 2026. Scope: Fold's authored identity/packaging, generated garment artwork, implemented responsive English/Arabic store, actual shopping evidence, observed maintenance release and English/Arabic/French Selected Work slot 04. Branch `selected-work`; local delivery.

## Code and production

- **66 Dart tests passed** across the full agency suite, including Fold's status/translations/empty-statistics contracts, existing cases, all image dimensions/presence and shared enquiry/motion behavior.
- Full **`dart analyze` found no issues**. Formatting checked 43 files with zero changes. `git diff --check` passed.
- **19 focused Node tests passed**, covering the exact catalogue, eight stock rows, all measurement cells, integer-cent arithmetic, explicit valid selection, aggregate stock, cart edits, Undo, restoration, filters, stable references and keyboard-target helpers.
- Jaspr 0.23.4 production build succeeded with `SITE_BASE_PATH=/agency_jaspr/`; all three routes and the client bundle were generated. The existing server-render test client-entry warnings are confined to test rendering; the production client bundle is present and exercised.
- Later static handoff/metadata updates are synchronized byte-for-byte into that successful build; they do not change the compiled agency code. [final-artifact-checks.json](final-artifact-checks.json) owns the final matching-file count, manifest checks, archive checksum and full video decode results.

## Actual store behavior

[store-browser-checks.json](store-browser-checks.json) records **19 passing real Chrome browser groups**, **66 responsive observations**, **20 actual page captures**, **two continuous shopping recordings**, zero page JavaScript errors and zero external requests. Sixty-four observations cover collection, product, cart, checkout, confirmation, About, Delivery & Returns and Size & Fit in EN/AR at 320/390/768/1440 px. Two extra observations are limited root-font-enlargement checks; they are not a claim of a complete browser-zoom audit.

The final canonical recordings cover filtering Shirts/Chalk, explicit Box Shirt Chalk/M, controlled failed cart save/retry, returning with filter context, clearing filters, Pleat Trouser Ink/M, the $240 merchandise basket, $12 demo shipping, $0 tax, $252 total, entered sample shipping, controlled failed checkout/retry and reference `FOLD-DEMO-76895E88`. The cart and each entered shipping field survive the recoverable checkout failure. Both final confirmations retain the same basket and clear only the successfully completed demo cart.

Separate browser groups verify unavailable Stone Vest XS, keyboard size choice, all 24 image/colour/SKU combinations, missing-size blocking, quantity/size stock limits, stable cart order, reload restoration, corrupt/unknown cart-version rejection, Undo, cancel/confirm Clear demo cart, shareable filter reload/clear/empty states, form validity, language transfer, cancelled pending checkout, real `Storage.setItem` quota failure and retry, and reduced-motion transitions. [finish-fix-checks.json](finish-fix-checks.json) records ten observed target groups at a minimum 44 CSS px and non-overlapping in-flow feedback.

The final decoded-film check exposed an offscreen error-recovery boundary after feedback moved in-flow. [failure-focus-before.json](failure-focus-before.json) records the error above the viewport and lost focus. [failure-focus-after.json](failure-focus-after.json) verifies all six controlled-save/checkout/real-quota EN/AR cases immediately reveal the entire error and focus Try again, with cart/shipping preserved. The focused 11 browser groups and both actual films were rerun after this change; the 20 success captures and their case-board inputs remain unchanged. Decoded `failure-video-after-*-checkout.png` frames visibly show the recovery control in both languages.

The actual v1 maintenance comparison is in [maintenance-before.json](maintenance-before.json), [maintenance-after.json](maintenance-after.json) and the corresponding full/cropped screenshots. Before, quantity/size changes left `BODY` active. After, quantity Tab reaches Remove and a size edit retains its Select in both languages. This is a checked implementation improvement, not a proposed roadmap.

## Recording and visual evidence

`production/recordings/` preserves raw WebM, timestamped JSON/Markdown checkpoints and Playwright trace ZIPs. Runtime MP4s are continuous actual browser captures, not generated interfaces or a screenshot slideshow. The English film is 1440×1000 and the Arabic film 390×844; both are H.264 at 24 fps. The current exact durations and hashes are in `final-artifact-checks.json`. Both fully decode. `verification/recording/` retains unmodified decoded frames; the viewer includes controls, no autoplay and a written EN/AR journey transcript.

Twenty final captures cover the five main shopping surfaces in both languages at desktop 1440 px and mobile 390 px. A fresh independent full review inspected all 20, both measurement crops, all seven case boards, two identity/packaging boards and all eight garment triptychs. It requested two fixes; [finish-verdict.md](finish-verdict.md) scored those two fixes resolved. The final scope and limits are stated there. Root inspection also checked the actual store, localized agency contact sheets and decoded confirmation/recovery evidence. The earlier captures remain available separately.

The once-run design detector reported agency-system mismatches for Fold's DM Sans, Citrine, Mist and Ivory. These are the exact approved Fold system, documented in its scoped DESIGN; they are intentional project differences, not a reason to recolour the agency. [documentation-check.md](documentation-check.md) records final source-derived Fold tokens/sidecar and preservation of the agency system. No external UI comp was invented for this user-pinned, code-led brief.

## Agency and delivery

[agency-checks.json](agency-checks.json) records **12/12 passing production cases**: EN/AR/FR at 320/390/768/1440 px, with no page errors or document/dialog/body overflow. Checks cover exact project order, six loaded Fold images/five figures, no Results group or empty statistics strip, title focus, focus wrapping/restoration, curtain, Frame → Fold → Sift, localized store/viewer destinations and ZIP response. Eighteen final top/middle/end screenshots and three inspected contact sheets are retained; [agency-capture-checks.json](agency-capture-checks.json) records their validity.

[agency-enquiry-checks.json](agency-enquiry-checks.json) records **three passing language states**: empty required fields are invalid, and the exact unfinished name/email/bilingual message/services/timing survive EN → AR → FR switching at 390 px with `#contact` retained. Native action remains `mailto:hello@cr8.media`; no submit, mailto request, non-read request or popup occurred.

[delivery-checks.json](delivery-checks.json) records two localized recording-viewer checks, ten successful HTTP spot checks and HTTP 206 media seeking. [source-package-check.json](source-package-check.json) records ZIP integrity and matching packaged source bytes. The source bundle preserves portable relative paths, local fonts/licences, exact sources, evidence and reproducible scripts. [final-artifact-checks.json](final-artifact-checks.json) also checks all 371 protected incumbent files unchanged, the current runtime/build/manifest bytes and original reference checksum.

[package-browser-checks.json](package-browser-checks.json) then verifies the final exact archive after extraction: **4/4 cases passed**, covering the English four-card collection, explicit Arabic Chalk/M selection and saved cart, and the editable guide at 390/1440 px. Local fonts/images load, with zero missing assets, script/console errors or external page requests. The 448-file archive is 59,763,178 bytes; its SHA-256 is `5e6612ef8e5c8d7fe167f390f91b1d5b3b2d2148f79917f039dff1d72ddc86a4`. The report lives beside the delivery records outside the already-tested archive; no later repack changed those tested bytes.

These are local Chrome checks and digital artifact proofs. Physical-device touch/keyboard/browser chrome, physical manufacture, commercial product claims, production shipping/tax/returns, independent commercial language review and public deployment are unverified and unclaimed.
