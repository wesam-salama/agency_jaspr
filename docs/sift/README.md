# Sift Coffee — developer handoff

Sift is Selected Work slot 01: a self-initiated brand strategy and identity concept. This index points to the editable files and retained context. Run the commands below from the repository root, `website/agency_jaspr/`.

## Folder guide

| Open this folder | To work on |
| --- | --- |
| [design/](design) | Identity direction, logo rules, palette, typography and application specifications. |
| [guide/](guide) | Brand-guide handoff notes, source register, PDF reports and page/size proofs. |
| [production/](production) | Production provenance and the inventory of published image exports. |
| [tools/](tools) | Artwork generation, SVG rendering and audits; [tools/guide/](tools/guide) contains PDF rendering and link repair. |
| [verification/](verification) | Website checks and historical delivery reports; [website/](verification/website) contains site screenshots and [verification/review/](verification/review) contains artwork contact sheets. |
| [Published assets](../../web/assets/selected-work/sift) | Editable artwork, font files, mockups, runtime images and public downloads used by the website. |

The published asset directory stays together because the website, HTML guide and portable PDF use its existing paths. The folders here organize the project documentation and maintenance tools.

## Read before editing

| Document | Purpose |
| --- | --- |
| [Shared Selected Work context](../selected-work-context.md) | Shared rules, approved Sift chapter, exact project order, concept status and preservation requirements. This is the current cross-project authority. |
| [Identity specification](design/identity-spec.md) | Sift positioning, exact mark/Selected Line, palette, typography, applications and reproduction notes. |
| [Production record](production/production-record.md) | Completed Sift inventory, generation provenance and delivery boundaries. References to other cases still being planned describe the original Sift delivery; use the shared context for their current status. |
| [Verification](verification/verification.md) | Historical local checks and their limits; the recorded preview port is not a running-service guarantee. |
| [Guide handoff](guide/README.md) and [source register](guide/source-register.md) | Guide contents, editable sources, exact generation brief, digital size proofs and portable PDF-link handling. |

Coffee records are fictional fixtures. Do not convert artwork or digital size checks into claims of manufacture, supplier-approved dielines, commissioned work or commercial results.

## Files to edit

All asset links below point to [the Sift asset directory](../../web/assets/selected-work/sift).

| Location | Role |
| --- | --- |
| [source/](../../web/assets/selected-work/sift/source) | Forty editable SVG masters, their PNG proofs, exact `product-canon.json`, asset manifest and render/digital audits. The SVGs own exact lettering, geometry and copy. |
| [source/fonts/](../../web/assets/selected-work/sift/source/fonts) and [fonts/](../../web/assets/selected-work/sift/fonts) | Licensed source and guide fonts. Preserve licence files and embedded SVG font data. |
| [mockups/](../../web/assets/selected-work/sift/mockups) | Native generated card/hero scenes. These are concept presentations; retain them as the source of the runtime exports. |
| [sift-brand-guide.html](../../web/assets/selected-work/sift/sift-brand-guide.html) | Editable, printable brand guide. Its PDF and sibling `source/`/`fonts/` links form one portable handoff. |
| Asset-directory WebPs | Published card, hero and case boards, including 480/960 variants. Keep stable paths and update relevant manifests when replacing exports. |
| [sift-brand-guide.pdf](../../web/assets/selected-work/sift/sift-brand-guide.pdf), [sift-artwork.zip](../../web/assets/selected-work/sift/sift-artwork.zip) | Public downloads referenced by all three agency locales. They are deliverables, not disposable duplicate files. |

Agency integration lives in `lib/data/site_data.dart`, `lib/l10n/arabic_content.dart` and `lib/l10n/french_content.dart`. `test/sift_case_test.dart` protects Sift's public contract; shared content/reference tests protect the surrounding site. Preserve the existing dialog, curtain, locale routes and enquiry behavior.

## Preview and checks

```sh
python3 -m http.server 8796 --bind 127.0.0.1 --directory web
```

Open `http://127.0.0.1:8796/assets/selected-work/sift/sift-brand-guide.html`. This serves the editable guide/assets; previewing the compiled agency case requires the normal Jaspr build/preview described in the repository README.

```sh
dart test test/sift_case_test.dart test/content_data_test.dart test/reference_copy_test.dart
```

The following are production tools, not startup requirements. They write sources, proofs or reports; review their paths and generated changes before using them.

| Tool | Use |
| --- | --- |
| [build-assets.py](tools/build-assets.py) | Generate the deterministic SVG masters from the authored source definitions. Update these definitions when an edit must survive regeneration. |
| [render-assets.cjs](tools/render-assets.cjs) | Render SVGs to PNG proofs and refresh `source/render-audit.json`; accepts specific SVG filenames for a focused render. |
| [audit-assets.py](tools/audit-assets.py) | Check artwork/canonical content and refresh source audit records. |
| [guide/render-guide.cjs](tools/guide/render-guide.cjs) | Render/verify the HTML guide and PDF page proofs. |
| [guide/fix-pdf-links.py](tools/guide/fix-pdf-links.py) | Correct exported PDF links to portable authored paths and produce the link report. |

Run only the tool needed for the edit:

```sh
python3 docs/sift/tools/build-assets.py
node docs/sift/tools/render-assets.cjs
python3 docs/sift/tools/audit-assets.py
node docs/sift/tools/guide/render-guide.cjs
```

The guide renderer writes its PDF to the published asset directory and its reports/proofs to `docs/sift/guide/`. It calls the PDF-link repair tool automatically. For a focused SVG render, append a source filename, for example `node docs/sift/tools/render-assets.cjs sift-wordmark-small.svg`.

The rendering scripts contain machine-specific Codex dependency paths and the macOS Chrome executable path. Inspect these before running on another machine. Python audit/render dependencies, browser tooling and any export binaries must be available in that environment; opening the delivered guide requires no such tooling. Recheck the PDF destinations and source archive after any download change; old checksums describe the previously verified bytes.

## Evidence retained for future edits

- [verification/website/](verification/website), [responsive-checks.json](verification/responsive-checks.json) and [http-checks.json](verification/http-checks.json): final local EN/AR/FR case views, measurements and response checks.
- [verification/review/](verification/review): contact sheets of the authored artwork, referenced by the identity specification.
- [guide/proofs/](guide/proofs), [guide/proof-report.json](guide/proof-report.json) and [guide/portable-links-report.json](guide/portable-links-report.json): final twelve-page guide, small-size and link evidence.
- [runtime-images.json](production/runtime-images.json) and [final-artifact-checks.json](verification/final-artifact-checks.json): delivery dimensions and integrity records.

These files document the original checks. After changing an asset, behavior or public claim, rerun the relevant check and record the new result; an earlier pass does not verify the edit. Keep sources, font licences and provenance beside the regenerated output.
