# Frame actual journey films

Final stable exports: 14 October 2026. Both silent films use actual browser and iPhone simulator video, with English evidence annotations around the recorded English or Arabic interface. Both are 1920 × 1080, 25 fps and contain twelve explicitly documented segments. No screenshot animation, generated interface, synthetic interaction or fabricated saved state appears.

| Film | Duration | Edit decision | Verification record |
| --- | --- | --- | --- |
| [English journey](../../../web/assets/selected-work/frame/demo-journey.mp4) | 25.20 seconds | [EN cuts and speeds](../production/journey-edit-en.json) | [EN record](../production/journey-record-en.json) |
| [Arabic journey](../../../web/assets/selected-work/frame/demo-journey-ar.mp4) | 28.60 seconds | [AR cuts and speeds](../production/journey-edit-ar.json) | [AR record](../production/journey-record-ar.json) |

Each film shows course choice, an authored captioned preview, confirmed demo enrolment, the final local app-open request, the matching native course at 0 of 6, captioned playback, a controlled save failure with the full note retained, confirmed retry, explicit completion, actual app termination/launch, restored 1 of 6 with lesson 02 next, and the actual lesson 02 screen. Viewing the lesson does not write completion. The final website request acknowledgement and native foreground acceptance have separate proof records; the edited film is a highlight sequence of those actual recordings for the same stored learner.

The original native presentation timestamps were decoded and checked against the actual screenshots. Selected source intervals and joined output frames were inspected directly; invocation UTC offsets were not used to guess cuts. Both complete outputs passed `ffmpeg -v error -i output -f null -`. [Film verification JSON](film-verification.json) records final hashes, frame paths and scopes. The final joined contacts are [EN](../production/recording-sources/qa/journey-en-contact.png) and [AR](../production/recording-sources/qa/journey-ar-contact.png). Full-resolution saved-note, restored-progress, request and next-lesson frames are linked from each record.

The English request segment ends before the source's temporary full-page screenshot resized the recorded browser viewport. Its closing lesson interval ends before XCTest teardown returns to the iOS home screen. The final closing frame remains the actual lesson 02. The Arabic request likewise ends before its full-page capture transition.

The original Arabic catalogue source has unloaded cover thumbnails; its canonical selection text, actual Arabic preview and confirmed enrolment remain captured. Corrected covers are verified separately in the final website screenshots. The original continuous Arabic core ends on lesson 02 for only about 22 milliseconds. Its film therefore ends with a documented five-second excerpt of a later [real read-only lesson 02 hold](native/native-next02-ar.json), using the same persisted `demo-ar` record, Arabic language and canonical guarded app source. Before/after service records were equal. The edit does not extend a screenshot to invent a longer hold.

Source recordings remain intact, and each decision stores their SHA256 values. The earlier English decision, record and derived film are preserved in `production/recording-sources/before-final-read-race-fix/`. The existing editor rebuilds a full film with `python3 docs/frame/tools/edit-journey.py en` or `ar`; an optional zero-based segment argument rebuilds only one changed segment after a complete edit exists, then concatenates and decodes the full output again.

Final output hashes:

- EN: `27f296891cf95ffcb89df7d2c908ae71a211944d22814912e1451c16ae998c87`
- AR: `1f725b8159a2bd7f84c8a6acf1708047c6e0c985bdd38b0f676755a471d9383c`
