# Frame — applied delivery history

These files are verbatim text copies of completed 14 October 2026 delivery helpers and a superseded test draft. They are retained for context and are not runnable maintenance tools. The extra `.txt` extension makes that boundary explicit.

| Historical file | Original role | Current editing location |
| --- | --- | --- |
| [integrate-agency.py.txt](integrate-agency.py.txt) | Insert the original Frame case/copy into slot 03 | `lib/data/site_data.dart`, `lib/l10n/arabic_content.dart`, `lib/l10n/french_content.dart` and the current case renderer |
| [update-agency-tests.py.txt](update-agency-tests.py.txt) | Apply the original Frame-era expectations | Current files under `test/` |
| [frame_case_test.dart.staged.txt](frame_case_test.dart.staged.txt) | Staged Frame test used by that migration | `test/frame_case_test.dart`; it contains later changes |
| [finalize-status.py.txt](finalize-status.py.txt) | Append the original completion status to context/agency documents | Current shared context/plan, project production/verification records and repository README |

Their paths, assumptions and Northline-era preservation boundaries describe the original integration. Running them against the current checkout could overwrite later Fold delivery. Use the [Frame handoff](../README.md) and [current Selected Work plan](../../selected-work-plan.md) for future work. File checksums and original paths are retained in the [organization record](../../selected-work/cleanup-record.json).
