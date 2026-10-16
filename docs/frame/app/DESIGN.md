# Frame Academy learning app

Mode: Operate. Platform: Flutter adaptive, native iOS locally verified separately in the evidence record.

The learning surface uses the approved Frame identity, separate from the agency and Form Architecture. Its purpose is to return a learner to the next useful lesson and preserve practice work through a save failure.

Tokens: Studio White #F7F9FC, Midnight Ink #18243D, Frame Blue #244CCD, Practice Mint #A7E3CE, Sketch Coral #FF8A6C, Slate Text #52627B, Progress Green #225C47 and Recovery Red #A92F33. White on Blue carries primary actions. Ink on Mint carries practice and confirmed completion. Input boundaries use Slate Text; focus uses a 2px Blue stroke.

Space Grotesk carries display titles and the Frame wordmark. Inter carries English controls/prose. IBM Plex Sans Arabic carries Arabic without added tracking. Original Google Fonts TTFs and OFL licences are bundled under assets/fonts. The fixed-size Frame wordmark is identity artwork; interface text follows device scaling and wraps.

Two offset L-shaped corners form the symbol. Relative to a 100-unit square, paths are M14 60 V14 H62 and M40 86 H86 V38, with 12-unit strokes. The identity orientation stays fixed in RTL; back/next navigation follows language direction.

Spacing uses 8/12/16/24/28/40px. Content has 24px horizontal padding and a 660px maximum measure. Artwork has 12px corners; controls have 8px corners. Primary buttons are at least 52px high. Native push/back transitions use Cupertino on iOS and Material on Android. The Scaffold respects safe-area/system insets and keyboard resizing. The app follows device reduced-motion preferences through Flutter route semantics.

Five destinations: My learning and Progress are top-level tabs; Course overview, Lesson player and Exercise use the navigation stack. Controls retain native semantics and keyboard focus. Course choice lists prerequisite, equipment, planned curriculum and exact canonical ID. Arabic keeps Composition Essentials and FA-PH-01 in isolated Latin runs.

The actual 30-second authored lesson never plays automatically. LTR video transport is explicit in both locales. Captions can be toggled, and the selectable transcript comes from the authored media source. Lessons 02–06 show planned study and an honest media-not-produced state.

Saving, confirmed saved, failure and retry are separate UI states. A failure retains the note and sample attachment. Only an acknowledged shared-service response changes saved status. Explicit completion advances 0/6 to 1/6; playback alone does not. On a cold launch, the next step comes from persisted server progress.
