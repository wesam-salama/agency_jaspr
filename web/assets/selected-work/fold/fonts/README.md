# Fold's local type files

Downloaded/assembled 15 October 2026. Fonts retain their SIL Open Font Licence 1.1 files in this folder. No font licence is transferred into ownership of the Fold concept.

| File | Family / role | Source |
| --- | --- | --- |
| `Archivo.woff2` | Archivo, variable 400–700, Latin store/editorial subset | Google Fonts CSS2 service and `fonts.gstatic.com` |
| `Archivo.ttf` | Archivo full variable editable master | Official `google/fonts` repository, `ofl/archivo/Archivo[wdth,wght].ttf` |
| `DMSans.woff2` | DM Sans, variable 400–700, Latin interface subset | Google Fonts CSS2 service and `fonts.gstatic.com` |
| `DMSans.ttf` | DM Sans full variable editable master | Official `google/fonts` repository, `ofl/dmsans/DMSans[opsz,wght].ttf` |
| `IBMPlexSansArabic-Regular.woff2`, `.ttf` | IBM Plex Sans Arabic, 400 | Existing locally licensed agency/Frame files, byte-copied |
| `IBMPlexSansArabic-SemiBold.woff2`, `.ttf` | IBM Plex Sans Arabic, 600 | Existing locally licensed agency/Frame files, byte-copied |

The WOFF2 Latin files preserve the official service subsets. Their declared range is 400–700; the full TTF masters include wider design axes. Full Arabic files support shaping and the concept's Arabic strings. Typography roles remain Archivo/DM Sans/IBM Plex Sans Arabic throughout. Do not add tracking to Arabic.

Official source references:

- [Archivo source and licence](https://github.com/google/fonts/tree/main/ofl/archivo)
- [DM Sans source and licence](https://github.com/google/fonts/tree/main/ofl/dmsans)
- [IBM Plex Sans Arabic source and licence](https://github.com/google/fonts/tree/main/ofl/ibmplexsansarabic)

The exact font URLs, checksums and coverage check are recorded in `../source/font-manifest.json` and `docs/fold/verification/font-checks.json` in the repository. The coverage sample includes the case's Latin punctuation and French accent specimens plus the Arabic label specimens. It is a sample check, not a claim of universal Unicode coverage.
