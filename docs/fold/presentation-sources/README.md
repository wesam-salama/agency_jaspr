# Fold editable presentation boards

The seven HTML masters use `boards.css`, exact local Fold fonts, original vector marks and linked source imagery. Each can be edited directly. The compositions have fixed export dimensions: card 1600 × 1000, hero 2560 × 1600, case figures 2000 × 1500.

Run `node docs/fold/tools/render-presentations.mjs` from the repository root to render all boards. Pass board names to render a subset, or `--ready` to render only boards whose actual source captures exist. The script uses the bundled Playwright/Sharp runtime and local Chrome. It preserves screenshots as pixels; it does not generate interface imagery.

Outputs are PNG proofs alongside these masters and WebPs under `web/assets/selected-work/fold/`: card/hero at full, 480 and 960 widths; case figures at full and 960 widths. Every exported raster has an origin JSON with source paths, dimensions, checksums and the original generation prompts for any referenced garment images. `../presentation-exports.json` inventories the exported files.

`identity.html` presents original identity/packaging; `continuity.html` compares generated views of one locked garment. `measurements.html`, `shopping.html` and `maintenance.html` use actual implemented browser captures from `../store-proofs/`. Their image crops retain their aspect ratio. The paired maintenance crops use the identical source rectangle around the actual cart controls, documenting focus loss and restoration; full original captures and active-element observations remain in the parent evidence folder.

No manufacturing, real order, commercial launch or business result is established by these presentations.
