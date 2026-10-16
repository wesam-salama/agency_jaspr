# Selected Work — developer handoff

Start here for future edits to **Sift Coffee → Form Architecture → Frame Academy → Fold Clothing**. All four are self-initiated studio concepts. The working source and the context below define the current delivery; dated reports describe the checks run at that time. A local verification record does not establish a public release, a real client, or commercial results.

## Read in this order

1. [Approved selection and current integration](../selected-work-plan.md): project IDs, order, layouts and completion boundaries.
2. [Master context](../selected-work-context.md): shared sections 1–7 plus the complete chapter for the project being edited. Keep the approved names, fixtures, identity, language and provenance rules.
3. The relevant project handoff below, then its PRODUCT/DESIGN or identity contract, production record and verification record.
4. For agency changes, read [PRODUCT](../../PRODUCT.md), [DESIGN](../../DESIGN.md), the [homepage brief](../../.impeccable/surfaces/home.md) and [shared curtain contract](../selected-work-curtain.md).

| Slot | Project handoff | Editable project and public assets | Agency layout |
| --- | --- | --- | --- |
| 01 | [Sift Coffee](../sift/README.md) | [sift/](../../web/assets/selected-work/sift) | `stickyChapters` |
| 02 | [Form Architecture](../form/README.md) | [form/](../../web/assets/selected-work/form) | `split` |
| 03 | [Frame Academy](../frame/README.md) | [frame/](../../web/assets/selected-work/frame), [Flutter app](../frame/app), [shared service](../frame/service) | `horizontalScroll` |
| 04 | [Fold Clothing](../fold/README.md) | [fold/](../../web/assets/selected-work/fold) | `statistics`, with empty metrics |

## Open a project

Open its README from the table above. The project folders now group files by responsibility:

| Folder | Contents |
| --- | --- |
| `design/` | Approved identity, direction, content and lesson contracts |
| `production/` | Production records, generation provenance, export inventories and film sources |
| `tools/` | Build, render, preview, package and checking scripts |
| `verification/` | Check reports and reviews; scoped capture subfolders and `logs/` |
| `presentation-sources/` | Editable case-board compositions and their rendered proofs, where present |
| `guide/` | Sift's brand-guide documentation and page proofs |
| `app/`, `service/` | Frame's Flutter application and shared demonstration service |
| `.impeccable/` | Each project's existing design-system metadata |

The entrance keeps `README.md`, `PRODUCT.md` and `DESIGN.md` where applicable. Editable artwork, fonts and standalone website code remain in each project's public asset folder, linked from its README. Root public images and PDF/ZIP/film files are the case's published interface; their URLs stay stable. Nested `source/`, `site/`, `fonts/`, `products/`, `studies/` and other media folders retain their existing scope.

[The move record](organization-map.json) maps every relocated file to its original path. No authored artwork, screenshots, raw recordings or historical logs are removed. Keep the named `before*` captures: maintenance comparisons and film edits use them. The current [organization validation](organization-validation.json) records preservation, links, package integrity and runtime checks separately from [earlier cleanup validation](validation.json).

The dated Form/Frame reports refer to Marrow or Northline because later replacements had not happened. The current selection and source establish the four completed projects. Historical test counts and screenshots retain their original scope.

## Common agency edit locations

| Change | Files |
| --- | --- |
| English cards and cases | [lib/data/site_data.dart](../../lib/data/site_data.dart) |
| Arabic and French copy | [lib/l10n/arabic_content.dart](../../lib/l10n/arabic_content.dart), [lib/l10n/french_content.dart](../../lib/l10n/french_content.dart), [localized content](../../lib/l10n/site_content.dart), [UI text](../../lib/l10n/ui_text.dart) |
| Case types and download/link semantics | [lib/models/site_models.dart](../../lib/models/site_models.dart) |
| Work section and shared case rendering | [work.dart](../../lib/components/sections/work.dart), [site_sections.dart](../../lib/components/site_sections.dart) |
| Case behavior and curtain | [lib/runtime/](../../lib/runtime), [curtain contract](../selected-work-curtain.md) |
| Responsive image registration and presentation | [image_assets.dart](../../lib/utils/image_assets.dart), [styles.css](../../web/assets/styles.css) |
| Case and localization regressions | [test/](../../test), especially the four `*_case_test.dart` files, `content_data_test.dart`, `reference_copy_test.dart` and `site_document_test.dart` |

Preserve the four identities, English/Arabic/French agency routes, naturally shaped Arabic and RTL, truthful concept status, shared curtain/focus behavior and draft-preserving enquiry. Use actual implementation captures for software claims. Generated imagery remains labelled in the provenance records.

## Run and verify

Commands in this guide run from the agency repository root, `website/agency_jaspr/`. See the [repository setup](../../README.md) for Dart/Jaspr requirements. Resolve dependencies before the first run.

```sh
dart test test/sift_case_test.dart test/form_case_test.dart test/frame_case_test.dart test/fold_case_test.dart test/content_data_test.dart test/reference_copy_test.dart test/site_document_test.dart
dart analyze lib test
dart pub global run jaspr_cli:jaspr build --dart-define=SITE_BASE_PATH=/agency_jaspr/
```

After reorganizing files, run `python3 docs/selected-work/tools/check-organization.py` to verify the move map, preserved evidence/runtime bytes, project links, script syntax, source archives, asset manifests and matching production assets. Start Frame and Fold with their `tools/start-preview.mjs` launchers, then run `node docs/selected-work/tools/check-website.cjs` for current browser checks. Results are kept in `organization-validation.json` and `browser-validation.json`; this check uses isolated browser state and preserves existing proof learners.

`dart analyze lib test` is a focused check; the repository's full `dart analyze` and release checks still apply when shipping code. Open the affected standalone experience and the agency case in the relevant languages and viewports when changing behavior or presentation. Project handoffs give their own JS/Flutter tests and preview commands. Browser/capture helpers often reference the original Mac's bundled Playwright, Chrome, Python libraries, simulator IDs or Xcode paths; they need local setup on a different machine.

## Cleanup and source packages

Generated Flutter build output, SDK/IDE caches, platform `ephemeral/` files, preview PID/log files, Python bytecode and Finder metadata can be recreated. Keep these out of version control and public source packages. Live Frame `service/data/` contains learner state; keep it local and out of packages. Existing proof learners should be preserved while reviewing their evidence.

The [cleanup record](cleanup-record.json) lists what was removed during this organization pass. Authored sources, context, final evidence, referenced before/after evidence, licences and public runtime URLs are retained. [Earlier validation](validation.json) records the preceding cleanup checks, separately from historical implementation checks.

After a future source or evidence edit, rebuild the affected public source package and verify its integrity/checksum. Form provides `tools/package_source.py`; Frame and Fold provide `tools/package-source.py` to refresh archives without regenerating artwork. Frame writes `frame-source.zip` and the companion `frame-recordings.zip`, each below 100 MiB; extract both into the same directory for the full handoff. Form's `tools/finalize-assets.py` additionally changes provenance and manifests; use it only for an intended asset-production pass. Sift's artwork ZIP follows the guide/source layout documented in its handoff; its artwork generator does not package that ZIP. Inspect the relevant production workflow before replacing downloads. Rebuilding a website or archive can create ignored caches again; remove disposable output after validation if a clean handoff is required.
