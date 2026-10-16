# Fold shopping journey — EN

Observed checkpoints from the actual continuous browser recording. Times are elapsed from page creation; a small initial screencast offset is possible. The matching trace retains screenshots and DOM snapshots.

| Time | Visible state |
| --- | --- |
| 00:00.3 | Clothes that give your day room.; Cart: 0 |
| 00:01.1 | Clothes that give your day room.; Category: shirts; Colour: chalk; Cart: 0 |
| 00:02.1 | Box Shirt; SKU: FL01-CHK-M; Cart: 0 |
| 00:02.9 | Box Shirt; SKU: FL01-CHK-M; Cart: 0; Recovery feedback: We couldn’t update the demo cart. Your previous cart is saved.; Focused action: retry; Error visible in viewport: True |
| 00:03.7 | Box Shirt; SKU: FL01-CHK-M; Cart: 1 |
| 00:04.5 | Clothes that give your day room.; Cart: 1 |
| 00:05.4 | Pleat Trouser; SKU: FL02-INK-M; Cart: 2 |
| 00:06.5 | Cart; Cart: 2; Demo total cents: 25200 |
| 00:07.4 | Where would it go?; Cart: 2; Demo total cents: 25200 |
| 00:09.9 | Where would it go?; Cart: 2; Demo total cents: 25200; Recovery feedback: We couldn’t complete the demo checkout. Your cart is saved.; Focused action: retry; Error visible in viewport: True |
| 00:11.5 | Your demo is complete.; Cart: 0; Demo total cents: 25200; Reference: FOLD-DEMO-76895E88 |
| 00:12.2 | Your demo is complete.; Cart: 0; Demo total cents: 25200; Reference: FOLD-DEMO-76895E88 |

Executed assertions verify the exact basket, visible and focused recovery, retained shipping fields after failure, successful retry and cleared browser cart. No payment, order or email occurs.
