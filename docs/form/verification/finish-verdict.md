## Disposition

**ship** for the reviewed Form artifacts and local implementation. The three material findings in `finish-review.md` are resolved. Bounded confirmation date: 13 October 2026.

## Scope and verdict

This confirmation covers only the three previously reported findings, their exact updated source/proofs, and the reported provenance source-path correction. It does not reopen the design direction or certify CR8.Media production integration. The earlier contract and visual review remain the basis for this verdict; this file supersedes the earlier **fix** disposition within that review's Form scope.

## Material findings

| Previously reported finding | Score | Confirmation |
| --- | --- | --- |
| CMS preview ratios differed from the public project crops | **Resolved** | `site/cms.js:99` now determines the project-page opening, story, material and diagram ratios. Labels explicitly name the scope. Opening images use 16:9 desktop / 4:3 mobile; story images use 4:3; material details use 16:7 desktop / 4:3 mobile, with their possible 4:3 story reuse explained. Diagrams use the full 8:5 drawing with containment and disabled irrelevant crop controls. `cms.css` reads the declared ratio; the updated focal proof visibly shows landscape mobile framing and independent values. |
| CMS board clipped the corresponding published title and changed summary | **Resolved** | `compose-exports.cjs:30` uses the actual 760 px `cms-published-project-excerpt.png` with containment. The regenerated `presentation-sources/cms-edit.webp.png` shows the complete Courtyard House title, concept status and edited summary, matching the editor field. The published change is now readable. |
| Courtyard detail Arabic alt text described metal instead of mineral finishes | **Resolved** | The final `site/data.js:18` reads “تفصيل للجدران ذات التشطيبات الطبيعية الفاتحة والخشب الدافئ والعتبة الحجرية المظلّلة.” No remaining `المعدنية` wording appears in that source. The alt and visible caption now express the same material meaning. |

No material finding remains from this bounded list.

## Evidence validity and checks

Opened and inspected the updated `verification/website/cms-focal-desktop.png`, actual `verification/website/cms-published-project-excerpt.png`, and regenerated `presentation-sources/cms-edit.webp.png`. Inspected the corresponding CMS/CSS/composition source and final Arabic description. The updated `cms-browser-checks.json` still records eleven passing flows and no JavaScript errors; its reproducible script explicitly checks all eight crop declarations and diagram containment, as well as independent focal values. These recorded browser flows were examined, not independently rerun by this reviewer.

The source-mapping correction in `finalize-assets.py:32–37` retains `.webp`, flattens detail paths, maps 480/960 responsive variants to the parent composition, and asserts source existence. This resolves the prospective broken-path concern. It does not certify a manifest or package before the finalization step actually runs.

The current `detector.json` contains 48 records. The reported palette/type comparisons with the agency design system do not override Form's pinned fonts or Chalk surface; the polygon is the exact geometric open-frame device. The reported fallback padding signal does not establish a defect against the supplied computed 64 px padding. No new detector run, browser overlay or capture was made for this confirmation.

## Risks/limits

Agency production build/browser checks, preservation of the surrounding Sift/agency experience, final per-raster register/package integrity and deployment remain outside this confirmation and belong to the integrating agent's final gate. The result remains a self-initiated studio project with generated architectural concepts, a local browser CMS and an honest not-sent enquiry demonstration. The earlier limits on independent commercial Arabic review, physical printing, construction, clearance and business outcomes remain unchanged.
