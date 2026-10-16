# Frame learning app

## Job and mode

Operate: return the learner to one useful next lesson, play the authored example, retain practice work, save deliberately and explicitly complete the exercise.

## Scope and authority

Target: `docs/frame/app/lib/main.dart`, `content.dart` and `session.dart`. The same Frame identity/canon governs the website and app. This brief extends the app's existing `docs/frame/app/DESIGN.md` with a surface strategy; it does not replace that file or claim a new platform verification. Extracted values are current on 14 October 2026.

## Composition and path

My learning and Progress are the two top-level destinations. Course overview, Lesson player and Exercise use the native navigation stack. My learning names Composition Essentials, expresses progress in text and points to the next lesson with one Continue action. Course overview retains outcome, prerequisite, equipment, canonical ID and all six planned lesson rows.

Use the implemented one-column 660px measure and 24px side padding. The 34/28/23px display hierarchy is calmer than the website's. Controls use eight-pixel corners and primary/outlined actions have a 52px minimum height. The Scaffold allows system insets and keyboard resizing; pages scroll rather than shrinking the note or translated text. The compact Frame header identity alone opts out of text scaling.

The first player offers deliberate playback, scrubbing, timed captions, an adaptive caption switch and a selectable transcript. The exercise offers a multiline note, a named local sample attachment and two different actions: Save draft and Mark exercise complete. Completion exposes the count and lesson 02. Lessons 02–06 show planned study and an honest media-not-produced state with a return action.

## Interaction and state

State comes from the local shared demonstration service. Idle, dirty, pending, confirmed draft, save failure and confirmed completion are distinct. A failure retains entered note and attachment and names retry. An edit during a save remains dirty after the older operation acknowledges. Duplicate save/completion controls and attachment changes disable while pending. A note or attachment is required for explicit completion.

Opening or playing the lesson never completes it. Successful explicit completion advances the recorded count from 0 of 6 to 1 of 6 and makes lesson 02 the next action. Refresh/cold-launch reads the stored record. Language and learner continuity must be described according to the actual verification record; a source implementation alone is not restart evidence.

The note has a permanent label, a four-to-ten-line range and a 2000-character limit. Focus uses a two-pixel Blue field stroke. Written progress, saving/recovery and captions use live-region semantics. Platform controls retain their native semantics; do not replace them with decorated custom imitations.

## Language and motion

The app localizes English and Arabic, uses IBM Plex Sans Arabic for Arabic interface text and isolates Latin title/ID runs. Device text scaling remains active outside the compact identity. Back/next arrows follow locale; the offset corner mark remains fixed. Player transport is explicitly left to right in both locales. Captions begin enabled and media begins paused.

Routes use Cupertino transitions on iOS and Flutter's Material forward-fade builder on Android. Device accessibility preferences govern platform motion behavior. Native reduced-motion, keyboard, text-scaling and restart claims require their separately recorded device checks.

## Evidence boundary

The native implementation, local shared records and actual device captures are different evidence classes. `docs/frame/verification/native/` contains real native captures; the early `qa-course-zero.png` is a player/source spot-check, not the final whole-journey record. Final handoff, controlled failure/retry, cold launch and device checks are reported by the native verification record when completed. Documentation never promotes a pending test into a completed check.
