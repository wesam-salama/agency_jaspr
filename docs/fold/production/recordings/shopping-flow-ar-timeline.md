# Fold shopping journey — AR

Observed checkpoints from the actual continuous browser recording. Times are elapsed from page creation; a small initial screencast offset is possible. The matching trace retains screenshots and DOM snapshots.

| Time | Visible state |
| --- | --- |
| 00:00.3 | ملابس تمنح يومك مساحة.; Cart: 0 |
| 00:01.1 | ملابس تمنح يومك مساحة.; Category: shirts; Colour: chalk; Cart: 0 |
| 00:02.0 | قميص بقصّة صندوقية; SKU: FL01-CHK-M; Cart: 0 |
| 00:02.8 | قميص بقصّة صندوقية; SKU: FL01-CHK-M; Cart: 0; Recovery feedback: تعذّر تحديث السلة التجريبية. سلتك السابقة محفوظة.; Focused action: retry; Error visible in viewport: True |
| 00:03.5 | قميص بقصّة صندوقية; SKU: FL01-CHK-M; Cart: 1 |
| 00:04.4 | ملابس تمنح يومك مساحة.; Cart: 1 |
| 00:05.2 | بنطال بثنية; SKU: FL02-INK-M; Cart: 2 |
| 00:06.0 | السلة; Cart: 2; Demo total cents: 25200 |
| 00:06.8 | إلى أين ستصل؟; Cart: 2; Demo total cents: 25200 |
| 00:08.4 | إلى أين ستصل؟; Cart: 2; Demo total cents: 25200; Recovery feedback: تعذّر إتمام الدفع التجريبي. سلتك محفوظة.; Focused action: retry; Error visible in viewport: True |
| 00:10.0 | اكتملت تجربتك.; Cart: 0; Demo total cents: 25200; Reference: FOLD-DEMO-76895E88 |
| 00:10.7 | اكتملت تجربتك.; Cart: 0; Demo total cents: 25200; Reference: FOLD-DEMO-76895E88 |

Executed assertions verify the exact basket, visible and focused recovery, retained shipping fields after failure, successful retry and cleared browser cart. No payment, order or email occurs.
