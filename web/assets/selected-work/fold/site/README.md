# Fold Clothing store

Version 1 implemented 15 October 2026. Self-initiated studio concept. The static EN/AR demonstration uses a single HTML entry, native form controls and a small JavaScript module, with no remote scripts, commerce service, payment collection or order transmission.

Serve this directory over HTTP. Relative image/font paths resolve from the parent Fold artifact directory. The root preview server maps this source to `/assets/selected-work/fold/site/`.

## Routes and state

- Collection: `?`; optional `category`, `color`, `size`, `price` filters are visible, individually removable and shareable.
- Product: `?page=product&id=FL01&colour=chalk`; product links preserve collection query context.
- Cart: `?page=cart`.
- Shipping and simulated checkout: `?page=checkout`.
- Confirmation: `?page=confirmation`; the receipt exists only for the current successful demonstration.
- Information: `?page=about`, `?page=delivery`, `?page=sizes`.
- Add `lang=ar` to any route for the complete Arabic journey. The visible language link preserves the route, current query and in-memory shipping input.

`data.mjs` is the exact product/stock/measurement canon and the pure transaction boundary. All amounts are integer USD cents. `app.mjs` renders localized semantic pages and delegates interactions. `style.css` owns the Fold palette, licensed local type, editorial grid, pattern-alignment details, focus, mobile and reduced-motion behavior.

## Cart contract

Storage key `fold.demo.cart.v1` contains `{version:1,lines:[{id,color,size,quantity}]}`. Restoration rejects unknown versions, malformed records, duplicate variants, invalid sizes/colours and quantities exceeding fixture stock. Price is always reconstructed from the catalogue. Shipping input is never written to persistent storage.

A transaction computes and validates a new array, then writes it before replacing the previous valid in-memory cart. A controlled or real save failure retains the previous cart and offers Try again. Quantity edits and size edits recheck stock, including merged lines. Removal offers Undo. Clear demo cart uses an inline confirmation with keyboard focus. Successful checkout clears the browser cart and retains a local receipt; it never deducts fixture inventory.

The footer’s native Demo test controls disclosure can fail the next cart update or the next simulated checkout. Controlled failure flags reset after one attempt. Checkout failure retains all cart lines and all shipping fields. Try again uses the same inputs. The deterministic reference hashes sorted SKU/quantity pairs, with no clock, locale or personal input.

## Verification

Run `node --test web/assets/selected-work/fold/site/store.test.mjs` from the agency project. The 19 tests cover exact catalogue and stock records, all measurement tables, mandatory explicit size, canonical $252 arithmetic, aggregate stock, size changes, undo transaction, versioned restoration, URL filters, imagery/SKU identity and deterministic receipts.

The root Fold production record owns actual browser captures and recordings. Browser emulation checks layout; safe-area behavior, touch feel and physical mobile keyboard behavior require hardware and are not inferred from desktop rendering.

## Version 1.1 maintenance

The real EN/AR v1 browser probe recorded BODY focus after quantity committed with Tab and after a size edit (`docs/fold/verification/maintenance-before.json`). Version 1.1 keeps edited line positions stable and deliberately restores focus: size edits return to their select; a quantity committed with Tab continues to that line's Remove control (Shift+Tab returns to Size). Removal focuses the next surviving line (or previous final line), an emptied cart focuses Explore Collection, and Undo focuses the restored line's Size select. The same restoration runs after retry. Root owns the matching after probe and before/after evidence.

Quantity Tab commits are synchronous: only a changed input prevents native Tab, applies the validated transaction and focuses its intended successor. Unchanged inputs keep native Tab. No timer or test wait is needed to settle focus.

## Reviewed finish fixes

The independent finish review identified two material issues. Status/error feedback now occupies a dedicated in-flow region between the header and main content, so persistent restoration, add feedback, Undo and retry cannot obscure a product name or cart control. Empty regions have no layout footprint, the status retains its live semantics and explicit dismissal, and Undo remains until the shopper uses it, dismisses it or navigates. Catalog swatch, removable-filter and product-name targets now measure at least 44 × 44 CSS pixels; mobile metadata keeps its separate readable row.

The first full capture set is preserved in `docs/fold/verification/store/before-finish-fixes/`. The same 19 Node checks, browser scenarios, 66 responsive observations, 20 page captures and both actual journey recordings are rerun for the final result. Timed browser checkpoints and Playwright trace ZIPs accompany the raw WebMs.

The chapter-wide 44 px correction also covers mobile masthead and footer links. The same real-browser target assertions now include visible header/footer links at every tested width.

Recoverable failures deliberately reveal the in-flow error region and focus Try again after rendering. Failed cart transactions do not run normal success/control-restoration callbacks, and the cart-focus helper cannot override an active recovery control. Retained cart and shipping assertions accompany immediate viewport/focus observations in `docs/fold/verification/failure-focus-before.json` and `failure-focus-after.json`; targeted viewport screenshots show both locales. Success-page captures remain unchanged.
