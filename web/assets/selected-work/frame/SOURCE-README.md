# Frame Academy — editable local project

Self-initiated studio concept, produced 13–14 October 2026. English master and complete Arabic demonstration. No client commissioning, commercial launch, paid enrolment, accreditation or instructor review is represented.

The package preserves repository layout. From this directory run:

    node docs/frame/service/server.mjs

Open http://127.0.0.1:8803/assets/selected-work/frame/site/index.html.
The Node service owns one atomically persisted local record for each demo learner. A fresh package starts at 0 of 6; demo is the English proof learner, demo-ar the Arabic proof learner. Enrolment, notes, sample attachment choice and explicit completion are shared by website and app. Test controls are local demonstration tools, not production accounts.

Flutter app source is docs/frame/app. Run flutter pub get, then flutter run -d <simulator-id> from that directory. API defaults to http://127.0.0.1:8803. The production record names the actually validated native target. The supplied iOS scheme supports frameacademy://course/FA-PH-01?learner=demo. Service and app must be running for the local handoff.

## Source and recording downloads

The complete handoff is split into two standard ZIP files so each remains below GitHub's 100 MiB file limit:

- [frame-source.zip](frame-source.zip): the runnable website, Flutter app, service, editable artwork, public lesson/journey media, screenshots, verification records and production tools.
- [frame-recordings.zip](frame-recordings.zip): the original MP4/WebM verification recordings and film-edit segments from docs/frame/.

Download both and extract them into the same destination directory to restore the complete project and its evidence. The source ZIP alone contains everything needed to run the demonstration. The download links above work when reading the public SOURCE-README.md alongside the archives. From the agency's Editable sources download URL, the recordings ZIP is available at the same address with the filename changed to frame-recordings.zip. Original repository recordings are retained unchanged; no video is recompressed.

Editable identity, covers and bilingual workbooks: web/assets/selected-work/frame/source. Produced lesson video, bilingual captions and transcript: media. Font files and licences: fonts. Actual screenshots and recorded journeys: docs/frame/verification/website and docs/frame/verification/native, with verification records. Case presentation HTML is retained under docs/frame/presentation-sources. Generated photographic teaching imagery is separately labelled and documented; software evidence is captured from actual implementations.

Composition Essentials has six planned lessons and 62 planned study minutes. Lesson 01 has an eight-minute study target; its short produced media duration is measured separately. Light for Motion (5/74) and Designing with Grids (5/56) are preview-only curriculum fixtures. The demonstrated first course has one produced playable lesson. Subsequent lesson targets remain an authored curriculum rather than a claim that all videos have been produced.

Capture/render helper scripts record the original machine paths and bundled runtime locations; update those local tool paths when reproducing evidence elsewhere. App, website and service sources are portable. No learner state, SDK/build cache or signing credential is included. A local production build does not publish this project. The agency website lives in its own source repository; the two archives together contain the complete Frame project and its evidence.

Start developer edits with docs/frame/README.md, the shared Selected Work plan/context and the scoped product/design files. Completed integration helpers are preserved as non-executable text under docs/frame/history/; edit the current agency source directly when working in the full agency repository.
