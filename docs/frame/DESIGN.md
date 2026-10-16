---
name: Frame Academy — The next frame
description: Practical creative learning with a clear next step.
colors:
  canvas: "#F7F9FC"
  ink: "#18243D"
  blue: "#244CCD"
  mint: "#A7E3CE"
  coral: "#FF8A6C"
  muted: "#52627B"
  rule: "#CBD4E2"
  success: "#225C47"
  error: "#A92F33"
  white: "#FFFFFF"
  blue-hover: "#1739AC"
  artwork-blue: "#E9EEF9"
  artwork-coral: "#FBEDE9"
  artwork-mint: "#E2F3EC"
  progress-web: "#DDE4F2"
  progress-native: "#E0E6F1"
  recovery-surface: "#FFF1EF"
  workbook-ground: "#E9EDF4"
typography:
  display:
    fontFamily: "Space Grotesk, sans-serif"
    fontSize: "56px"
    fontWeight: 600
    lineHeight: 1.12
    letterSpacing: "-.03em"
  headline:
    fontFamily: "Space Grotesk, sans-serif"
    fontSize: "36px"
    fontWeight: 600
    lineHeight: 1.12
    letterSpacing: "-.025em"
  title:
    fontFamily: "Space Grotesk, sans-serif"
    fontSize: "24px"
    fontWeight: 600
    lineHeight: 1.12
    letterSpacing: "-.02em"
  body:
    fontFamily: "Inter, sans-serif"
    fontSize: "18px"
    fontWeight: 400
    lineHeight: 1.55
  label:
    fontFamily: "Inter, sans-serif"
    fontSize: "14px"
    lineHeight: 1.55
  control:
    fontFamily: "Inter, sans-serif"
    fontSize: "16px"
    fontWeight: 600
    lineHeight: 1.5
  filter-label:
    fontFamily: "Inter, sans-serif"
    fontSize: "14px"
    fontWeight: 600
    lineHeight: 1.55
  arabic-display:
    fontFamily: "IBM Plex Sans Arabic, sans-serif"
    fontSize: "56px"
    fontWeight: 600
    lineHeight: 1.35
    letterSpacing: "normal"
  arabic-body:
    fontFamily: "IBM Plex Sans Arabic, sans-serif"
    fontSize: "18px"
    fontWeight: 400
    lineHeight: 1.55
    letterSpacing: "normal"
  native-display:
    fontFamily: "Space Grotesk"
    fontSize: "34px"
    fontWeight: 600
    lineHeight: 1.18
  native-headline:
    fontFamily: "Space Grotesk"
    fontSize: "28px"
    fontWeight: 600
    lineHeight: 1.25
  native-title:
    fontFamily: "Space Grotesk"
    fontSize: "23px"
    fontWeight: 600
    lineHeight: 1.25
  native-body:
    fontFamily: "Inter"
    fontSize: "17px"
    lineHeight: 1.5
  native-body-medium:
    fontFamily: "Inter"
    fontSize: "15px"
    lineHeight: 1.45
  native-control:
    fontFamily: "Inter"
    fontSize: "16px"
    fontWeight: 600
  workbook-display:
    fontFamily: "Space Grotesk, sans-serif"
    fontSize: "56px"
    fontWeight: 600
    lineHeight: 1.16
  workbook-headline:
    fontFamily: "Space Grotesk, sans-serif"
    fontSize: "38px"
    fontWeight: 600
    lineHeight: 1.16
  workbook-body:
    fontFamily: "Inter, sans-serif"
    fontSize: "18px"
    lineHeight: 1.65
rounded:
  control: "8px"
  artwork: "12px"
spacing:
  small: "8px"
  related: "12px"
  control-gap: "16px"
  compact-group: "20px"
  group: "24px"
  artwork-padding: "28px"
  passage: "32px"
  panel: "40px"
  record: "48px"
  wide: "64px"
  section: "88px"
components:
  button-primary:
    backgroundColor: "{colors.blue}"
    textColor: "{colors.white}"
    typography: "{typography.control}"
    rounded: "{rounded.control}"
    padding: "14px 22px"
  button-primary-hover:
    backgroundColor: "{colors.blue-hover}"
    textColor: "{colors.white}"
  button-secondary:
    backgroundColor: "transparent"
    textColor: "{colors.ink}"
    typography: "{typography.control}"
    rounded: "{rounded.control}"
    padding: "14px 22px"
  text-action:
    backgroundColor: "transparent"
    textColor: "{colors.blue}"
    typography: "{typography.control}"
    padding: "8px 0"
  filter-select:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    typography: "{typography.filter-label}"
    rounded: "{rounded.control}"
    padding: "12px 16px"
  native-button-primary:
    backgroundColor: "{colors.blue}"
    textColor: "{colors.white}"
    typography: "{typography.native-control}"
    rounded: "{rounded.control}"
    padding: "14px 22px"
  native-practice-field:
    backgroundColor: "{colors.white}"
    textColor: "{colors.ink}"
    rounded: "{rounded.control}"
  preview-dialog:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink}"
    rounded: "{rounded.artwork}"
    padding: "28px"
  practice-note:
    backgroundColor: "{colors.white}"
    textColor: "{colors.muted}"
    rounded: "{rounded.control}"
    padding: "20px"
  native-recovery:
    backgroundColor: "{colors.recovery-surface}"
    textColor: "{colors.error}"
    typography: "{typography.native-body-medium}"
    rounded: "{rounded.control}"
    padding: "18px"
---

# Design System: Frame Academy

## Overview

**Creative North Star: "The next frame"**

The next frame identifies a course or a useful next step. Bright reading surfaces, precise blue actions and two offset open corners give practical creative learning a clear, active identity. Authored examples lead the discovery experience; the learning interface gives the lesson, practice note and next action more room than decoration.

This is the implemented Frame system, extracted on 14 October 2026 from the responsive website, Flutter app, editable identity masters and workbook stylesheet. The approved language comes from [direction-contract.md](design/direction-contract.md) and [identity-spec.md](design/identity-spec.md). Frame Academy is the full brand; Frame is its compact app name. The identity remains scoped to this project. The agency root `DESIGN.md` and `.impeccable/design.json` continue to own the CR8.Media shell.

**Key Characteristics:**

- Bright canvas, dark reading text, blue actions and limited mint/coral teaching artwork.
- A custom vector wordmark and two offset L corners with a fixed orientation.
- Different density for discovery, learning and workbook reading, with a shared hierarchy.
- Textual progress and a named next lesson beside the primary action.
- Natural Arabic shaping, readable Latin records and equivalent recovery actions.

The surface-specific jobs and compositions live in [.impeccable/surfaces/website.md](.impeccable/surfaces/website.md), [app.md](.impeccable/surfaces/app.md) and [workbooks.md](.impeccable/surfaces/workbooks.md). The agency case remains an Experience surface governed by the existing shell and its four-chapter `horizontalScroll` layout. [documentation-check.md](verification/documentation-check.md) separates source extraction from recorded application verification.

## Colors

The palette combines a cool, bright canvas with a crisp functional blue. Mint and coral support visual instruction and restrained chapter distinction.

### Primary

- **Frame Blue** carries primary actions, links, selected navigation, lesson indices and focus. Primary actions pair it with White; their authored web hover uses the deeper Blue Hover.

### Secondary

- **Practice Mint** carries exercise artwork, native captions and completion backgrounds with Midnight Ink or Progress Green.
- **Sketch Coral** carries artwork emphasis with Midnight Ink. Its lighter Artwork Coral field separates the filmmaking cover on the website.

### Neutral

- **Studio White** is the main reading canvas. **White** separates native fields and the retained practice note.
- **Midnight Ink** carries headings, prose, structural geometry and the video loading ground.
- **Slate Text** carries secondary reading and necessary control boundaries. The website's border variable resolves to this same value.
- **Blueprint Rule** carries decorative separation and buffered-video information. It does not carry necessary field boundaries.
- **Artwork Blue** and **Artwork Mint** separate course artwork and supporting practice panels without adding another action hue.
- **Web Progress Track** and **Native Progress Track** are the observed inactive progress grounds for their respective surfaces.
- **Workbook Ground** separates digital workbook pages from the browser canvas; printed pages use White around Studio White content.

### Feedback

- **Progress Green** accompanies written confirmed-save and completion feedback.
- **Recovery Red** accompanies an explanation and retry action. The native **Recovery Surface** provides a light container behind the icon and message.

**The Confirmed State Rule.** A saved color or completion icon accompanies a confirmed operation and written status. Color alone never asserts saved progress.

## Typography

Space Grotesk carries Latin headings and compact brand text. Inter carries Latin prose, labels and controls. IBM Plex Sans Arabic replaces both roles in Arabic with natural shaping and no added tracking. The vector wordmark is custom path artwork; it is separate from the website and app headers, which render their compact brand wording in Space Grotesk.

All three families are bundled locally. Web and workbook pages use the project's WOFF2 files; the native app uses original TTFs. Arabic regular and semibold are distinct files. SIL OFL notices and the source/checksum register are retained with the font assets. Do not substitute the native files with a conversion made from the Latin web subsets.

The frontmatter records the implemented desktop roles. Website headings use balanced wrapping; prose caps at 70 characters, with shorter supporting measures. Course captions use a slightly larger title (25px) than the general title role; detail/enrolment headings use 48px on desktop. At 980px, the general hero becomes 48px. At 760px, the hero is 40px, section titles 28px and body 16px. At 440px, the hero is 36px and detail heading 34px. Native display/headline/title roles are 34/28/23px; body roles are 17/15px. These are separate task scales, not one universal type size.

Website Arabic headings retain their responsive sizes but use a 1.35 line height and normal tracking. Native Arabic swaps the explicit families while retaining its implemented role sizes and line heights; its heading, title, body and label roles explicitly set `letterSpacing: 0` to remove inherited Latin tracking. Interface text participates in native device scaling and wraps; only the compact Frame header identity opts out of scaling. Workbook Arabic uses the same reading hierarchy with its Arabic family. Latin titles, course IDs, learner codes and numeric fragments are isolated; the learner's note keeps its own writing direction.

**The Arabic Shaping Rule.** Arabic uses its local family and natural spacing. Keep identity geometry fixed, isolate Latin records, and let translated labels wrap rather than shrinking them to match English.

## Layout

The website has a 1160px content measure and 32px desktop gutters. Distinct sections are separated by 88px, with a 64px first-section offset. Related content uses 8–32px gaps; larger paired passages use 64px. These observed values include deliberate 20/28/40px steps alongside the eight-unit rhythm.

The discovery hero pairs copy and cover artwork in 1.08:1 columns. Three courses form a three-column grid; overview/curriculum, preview and enrolment use paired content with visible decision facts. The cover remains a contained 4:5 object, rather than a cropped thumbnail. The lesson poster uses its complete 16:9 ratio. The detail artwork sticks at 32px only on larger screens.

At 980px, column gaps and artwork reduce. At 760px, gutters become 24px, paired sections stack, the detail artwork returns to document flow, and the catalogue becomes one course per row with artwork beside its caption. The header wraps into a brand/language row followed by visible navigation. At 440px, gutters become 20px, each course places its cover above the caption, filters become full-width rows and curriculum actions wrap below lesson text. The page remains naturally scrollable at each width.

The shared-record panel has three columns for progress, next action and retained draft, divided with logical borders. It stacks at 760px, keeping progress first and the named next lesson next. Progress has both a textual count and a bar; the website track is 8px high and the native track 4px.

Native pages use one scrollable column, a 660px maximum measure and directional padding of 24px sides, 16px top and 40px bottom. The top bar is 62px high. The Scaffold accommodates system insets and keyboard resizing. CourseArt crops the text-free `composition-source.png` photograph with `BoxFit.cover` at 1.65:1 in course overview and 2.4:1 in the compact learning view. A separate localized title overlay keeps course wording readable; the crop does not cut embedded cover typography. The player uses the actual video ratio. The note grows from four to ten lines and remains reachable when the keyboard is present.

Logical spacing follows locale on the website and native layout. Back/next arrows follow language direction. The logo, open artwork corners and photographic comparison keep their fixed orientation. The native video transport and website video element remain explicitly left to right in both languages.

Workbooks use a 1000px screen measure, 64px page padding and paired examples; below 700px, pages use 28px padding and examples stack. Print uses A4, a 12mm page margin, 12mm × 8mm section padding and the final compact print overrides. Full workbook layout and PDF-specific evidence belong to the Read surface brief.

## Elevation & Depth

Reading and operation are flat by default. Tonal artwork fields, rules and whitespace separate content. The native top bar and bottom navigation explicitly have zero elevation. The website uses authored shadow only for a cover as an object and for the modal layer; it does not lift every course caption or learning block.

The sidecar records the exact web cover drop shadows, preview-dialog shadow and backdrop. Cover hover lifts by 4px in the hero and 5px in course cards over 350ms with the implemented easing. It is a user-triggered cue. There is no automatic lesson playback or authored ambient loop in the Frame website.

**The Immediate Reduction Rule.** Device reduced motion removes the website's transitions, animations, smooth scrolling and artwork lift. Native route motion follows Flutter's platform transition behavior and device accessibility preference; verification claims must point to the native record.

## Shapes

Controls have gently squared corners using the control radius; artwork, media and modal containers use the artwork radius. Necessary controls use a one-pixel Slate Text border. Focus is a three-pixel Blue outline with a five-pixel offset on web actions/selects/summary controls; the native text field uses a two-pixel Blue focused stroke. One-pixel Blueprint Rules separate reading groups.

The identity symbol is constructed in a 100-unit square from `M14 60 V14 H62` and `M40 86 H86 V38`, with a 12-unit stroke, butt endpoints and miter joins. Both corners stay in their original orientation in RTL. The native painter traces the same geometry, reversing the second path's traversal without changing its shape. Clear space is 12 symbol units. Digital proof sizes are 24/32/48px for the symbol, 160/240px for the compact wordmark and 320px for the full lockup.

The primary lockup combines that symbol with five custom path letters and an editable ACADEMY descriptor below them. Compact, monochrome, reverse and app-icon variants reuse the master structure. The web hero's large CSS corners are a related viewing motif; the two rectangular outlines in its exercise teaser are practice artwork, not replacements for the identity symbol. Course covers keep an 800 × 1000 source composition, large title, discipline, ID, planned study data and the same authored visual example across locales.

**The Fixed Mark Rule.** Preserve the two offset L paths and their orientation. Mirror directional interface cues independently; do not borrow Form's single architectural frame or close the Frame window.

## Components

### Actions and navigation

Primary website actions are Blue with White text, the control radius, a 48px minimum height and 14px × 22px padding. They deepen on hover and move down one pixel while pressed. At narrow widths padding reduces to 14px × 18px. Secondary actions are transparent with a Slate Text boundary and Ink text. Text actions are Blue, underlined and at least 44px high; hover thickens the underline. Buttons disable during pending requests and retain written feedback.

Native filled and outlined actions have a 52px minimum height and 48px minimum width. Filled actions use the explicit native control role and 14px × 22px padding; outlined actions retain the same radius and Slate Text border. Platform adaptive caption switches and attachment checkboxes retain their native semantics and state presentation.

Website navigation uses visible 14px semibold links with a Blue underline for hover/current state. At 760px the links wrap in document flow and use 13px type with a 36px minimum link height. The language action remains a separate bordered control of at least 44px. Native My learning and Progress are the two top-level navigation destinations; Course overview, Lesson player and Exercise use the navigation stack. Native selected navigation has a Mint indicator and no elevation.

### Course discovery and fields

The course card is cover artwork followed by a readable caption, canonical ID, planned study time, availability and explicit course link. Course detail places outcome, prerequisite and equipment before the commitment action. The light rule separates curriculum rows; Blue indices, text and the explicit preview action keep the sequence readable.

Catalogue discipline and level selects have persistent labels, a Slate Text boundary, the control radius and 48px minimum height. Loading, filtered results, an empty result and failure/retry are distinct states. Empty/error views retain the active filters and provide a useful recovery action. Loading cover shapes are static rather than an animated shimmer.

The native practice field has a persistent label and question hint, White fill, the control radius, visible focused stroke, multiline input and a 2000-character limit. The local sample attachment has its own checkbox, written demo explanation, semantic image description and visible preview. A save failure keeps both entered note and selected attachment in place.

### Preview and lesson

The website opens the authored lesson in a native dialog with a named title, 48px close action, user-operated video, captions, full transcript and exercise. The dialog is capped at 860px, leaves 16px around the viewport and can scroll. Opening focuses the close control; close/Escape pauses media and restores the originating action. Route changes also close the preview. A missing-media state keeps the explanation and retry action visible.

The native player begins paused, offers explicit play/pause and scrubbing, a left-to-right time readout, a captions toggle and a selectable expandable transcript. Its caption area has a 56px minimum height with 12px × 10px padding and a Mint active ground. Actual media duration is shown separately from planned study time. Leaving for the exercise pauses playback. Later lessons expose the planned study and honest media-unavailable explanation with a return-to-lesson-01 action.

### Progress, practice and recovery

The learning overview shows a course name, written count, progress track, next lesson title and one Continue action. The saved web note uses a White control-radius panel with 20px padding, preserved line breaks, arbitrary-word wrapping and automatic text direction.

The app exposes idle practice, unsaved changes, pending save, confirmed draft, failure/retry and explicit completion as separate states. Its recovery block uses the Recovery Surface, red icon/message, 18px padding and an outlined retry action; it is a live region. Progress/status and caption changes also have live-region semantics. Save draft and Mark exercise complete are separate actions. Completion is enabled only when a note or sample attachment exists, and a confirmed completion names lesson 02 as the next step. Playback does not complete a lesson.

The shared demonstration service owns saved state; interface feedback must follow its acknowledgement. An edit made while saving leaves the newer local draft unsaved rather than relabelling it saved. Pending actions disable duplicate saves and attachment changes. Native refreshes accept only the current requested learner and read generation; enrol/save invalidate older reads before the request and after its response. This prevents delayed resume reads from replacing a linked learner or restoring zero progress after confirmed completion. The recorded media is 30 seconds; lesson 01 remains eight planned study minutes and Composition Essentials remains six lessons/62 planned minutes. These curriculum figures do not imply six produced lesson videos.

The website's registered course URI opens the matching native Course overview. The iOS SceneDelegate forwards cold and warm UIScene links to app_links; Dart validates the exact course route and coalesces duplicate deliveries within one second. [Native verification](verification/native-verification.md) records actual stopped-app website handoffs and the English/Arabic failure, retry, explicit completion and app-restart journeys. Keyboard/focus, 1.6× text scale and disabled animations remain separately labelled widget checks, not physical-device certification.

## Do's and Don'ts

### Do:

- **Do** retain Studio White, Midnight Ink, Frame Blue and the approved limited Mint/Coral roles.
- **Do** keep the custom identity masters, two offset L paths, butt endpoints and fixed orientation.
- **Do** place course decision facts before commitment and the named next lesson beside textual progress.
- **Do** use actual course artwork, media and implementation captures with their recorded provenance.
- **Do** preserve entered work through failure and wait for acknowledged persistence before saved feedback.
- **Do** shape Arabic naturally, isolate Latin records and allow text expansion and device scaling.
- **Do** keep the Frame world scoped separately from the CR8.Media shell and Form Architecture.

### Don't:

- **Don't** use small White functional text on Mint or Coral, or Blueprint Rule as a necessary field boundary.
- **Don't** mirror the identity mark or the authored photographic comparison with the interface.
- **Don't** complete a lesson when it is opened or played, or describe a saved draft as completion.
- **Don't** autoplay media or make hover the only way to reveal a course or action.
- **Don't** turn planned curriculum durations into produced-video claims.
- **Don't** add instructors, reviews, credentials, learner counts, client history or business outcomes without evidence.
