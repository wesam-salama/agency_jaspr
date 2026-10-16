# Frame Academy — native learning demonstration

Authored studio concept. This Flutter app connects the Composition Essentials discovery course to continued learning through the same local demonstration service. No app-store publication, commercial academy or instructor review is implied.

## Start the local experience

From the agency repository, run `node docs/frame/service/server.mjs`. The service and responsive website run at `http://127.0.0.1:8803/`; open `/assets/selected-work/frame/site/` and select Composition Essentials. Preview lesson 01, continue as the demo learner, then choose Open Frame. The local bridge sends the registered `frameacademy://course/FA-PH-01?learner=demo&lang=en` URL to the configured iPhone simulator. If iOS asks to open Frame Academy, choose Open. The Arabic handoff uses `learner=demo-ar&lang=ar`.

From this directory, run:

```sh
flutter pub get
flutter run -d <your-iPhone-simulator-id>
```

The default shared API is `http://127.0.0.1:8803`. Override it with `--dart-define=FRAME_API=http://YOUR_HOST:8803` if using another device. An Android emulator normally reaches the host at `10.0.2.2`. Physical hardware needs a reachable local host address; physical-device verification was not performed.

## What persists

Course enrolment, completed lesson IDs and exercise drafts belong to the service's demo learner record. Both website and app read that record. A video play does not complete a lesson. Save draft and Mark exercise complete wait for the actual service response before showing saved status. A failed save retains the entered note and offers retry.

Native preferences retain only the chosen demo learner and UI language across app termination. They do not substitute for shared progress or draft persistence. Local example imagery is bundled under `assets/sample-practice.png`; its attachment flag identifies that fixed demonstration sample.

## Produced and planned content

Composition Essentials is `FA-PH-01`, Photography, Beginner, six planned lessons totalling 62 minutes. Lesson 01, See the edges, has separate authored English and Arabic 30-second silent visual lessons, WebVTT captions and selectable transcripts. Its planned study time is eight minutes. Lesson 02, Find the subject, is the next resumable destination with ten minutes of planned study and an explicit video-not-produced state. Lessons 02–06 are planned curriculum; the app does not pretend that their films exist.

The app uses the approved Frame palette, Space Grotesk, Inter and IBM Plex Sans Arabic. Arabic has no added tracking, Latin values stay readable in isolated runs, and the two offset-corner symbol keeps its orientation. Back/next navigation follows the language. Licensed fonts, editable design tokens and generated platform icon assets are in this source package.

## Local verification and native evidence

`flutter test` runs eleven focused checks: persistence/recovery/restart, delayed reads around learner switching and completion, pending draft edits, keyboard Tab/Enter/Back-focus, and EN/AR 1.6× text scale with disabled animations. `flutter analyze` checks the full app source. The locally built/running target is an iPhone 17 Pro simulator on iOS 26.5; sources for Android and macOS are included, but no successful native run on those targets is claimed. [The native verification record](../verification/native-verification.md) separates widget checks from actual simulator evidence and physical-device limits.

The separate `RunnerTests` target is a native XCTest UI runner, outside production app code. It accepts only the normal Frame Academy app-open confirmation and drives actual learner controls. The two learning tests verify playable produced media, retained note after a controlled503, confirmed retry, explicit1-of-6 completion, app terminate/launch, retained progress and the next lesson. Screens are actual XCUIScreen/simctl captures; `../verification/native/` stores raw continuous simulator recordings, PNGs, native test logs and before/after shared records. The production/verification records specify final evidence scope.

To prepare the UI runner, use Xcode's Runner scheme with the iPhone simulator, or `xcodebuild build-for-testing -workspace ios/Runner.xcworkspace -scheme Runner -destination id=<id> -parallel-testing-enabled NO`. Run only the selected native UI test using the generated `.xctestrun` file. Disable parallel testing so proof stays on the chosen device. Before a capture, install the exact `UITargetAppPath` app and compare its kernel hash with the installed app; `test-without-building` alone can retain an older AUT. `tool/run-native-ui-proof.mjs` records the continuous screen, seven PNGs, capture timestamps and API snapshots; update its simulator/configuration paths for another machine. Test helpers use reserved demonstration learners and should be coordinated with the website's initial 0-of-6 proof.

A debug-only Marionette binding exposes app controls and a read-only `frameState` extension. Rediscover the VM service after native app termination rather than reusing an old connection. The cached app_links 6.4 plugin receives cold/warm UIScene links through the small native forwarding adapter in `ios/Runner/SceneDelegate.swift`; Dart validates the exact course route and coalesces duplicate deliveries within one second. If iOS already remembers its app-open approval, it can open the app directly; the proof still requires the actual foregrounded course and selected learner.
