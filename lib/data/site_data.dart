import '../models/site_models.dart';

// Retained agency reference copy plus four authorised self-initiated studies;
// runtime stays app-owned.

const heroEyebrow = "Brand & product studio";
const heroHeadline = "Every brand is a handful of points. We draw the line between them.";
const heroDescription =
    "Creative Media is a small studio working across branding, rebranding, consultancy, web development, app development and the maintenance that keeps it all standing up. One team, one line of thought, from first sketch to shipped product.";
const heroHint = "Hover the six points to draw the line · move the cursor to leave ink";

const sectionCopy = <String, SectionCopy>{
  "services": SectionCopy(
    "What we do",
    "Six services. One dot each.",
    "Six is not the whole studio. Add the seventh dot, you, the client, and the shape closes. Every service below can run alone or as part of a bigger program.",
  ),
  "work": SectionCopy(
    "Selected work",
    "Recent lines drawn.",
    "Hover and the dots step aside as the picture appears. Click and each case opens with its own transition.",
  ),
  "process": SectionCopy(
    "How it works",
    "Six steps, in order, connected as you go.",
    "The scope changes from project to project. The order, and what's delivered at each stage, rarely does. Timeframes below are typical, not fixed.",
  ),
  "engagement": SectionCopy(
    "How we work together",
    "Three ways in.",
    "Most projects start as one of these. We'll tell you honestly which one fits before you commit to anything.",
  ),
  "faq": SectionCopy(
    "Questions",
    "Before you ask.",
    "Anything else, use the form below. We reply within a day or two.",
  ),
  "studio": SectionCopy("The studio", "A small team, on purpose.", ""),
  "contact": SectionCopy(
    "Get in touch",
    "Tell us what you need. We'll do the rest.",
    "Pick your points. The line to \"You\" draws itself, the shape closes, and it all travels with the email.",
  ),
};

const processSteps = <ProcessStep>[
  ProcessStep(
    name: "Connect",
    duration: "3–5 days",
    description:
        "We start with your business, your market and the gap between where you are and where you want to be, before we suggest anything.",
    deliverables: [
      "Discovery call & stakeholder interviews",
      "Competitor & market scan",
      "Written summary of what we heard",
    ],
  ),
  ProcessStep(
    name: "Define",
    duration: "~1 week",
    description:
        "Positioning, naming and scope get settled here, before design work starts, not worked out alongside it.",
    deliverables: ["Positioning & naming workshop", "Scope document & timeline", "Success metrics agreed with you"],
  ),
  ProcessStep(
    name: "Design",
    duration: "2–4 weeks",
    description:
        "Identity, interface, or both, designed to carry the decisions made in the step before, not to look good in isolation.",
    deliverables: [
      "Concept direction & design system",
      "Structured review rounds",
      "Tracked feedback, not scattered comments",
    ],
  ),
  ProcessStep(
    name: "Build",
    duration: "3–8 weeks",
    description:
        "Sites and apps are written by hand and tested against your real content, on real devices, not placeholder text on a laptop.",
    deliverables: [
      "Development in weekly sprints",
      "Staging environment to review as we go",
      "QA across browsers & devices",
    ],
  ),
  ProcessStep(
    name: "Launch",
    duration: "~1 week",
    description: "We ship, check every device we can reach, and hand over something you actually know how to run.",
    deliverables: ["Pre-launch checklist", "DNS / App Store & Play Store submission", "Walkthrough with your team"],
  ),
  ProcessStep(
    name: "Maintain",
    duration: "Ongoing",
    description: "Ongoing support keeps it fast and current, so launch day isn't the best day it ever looks.",
    deliverables: ["Monthly check-ins", "Updates & uptime monitoring", "Priority fixes & small changes"],
  ),
];

const engagements = <Engagement>[
  Engagement(
    name: "Project",
    tag: "One-off",
    description: "A single deliverable, start to finish: a rebrand, a new site, or a new app.",
    features: [
      "Fixed scope, fixed price",
      "One discipline or a closely related pair",
      "Handover at the end, not a slow fade-out",
    ],
    terms: "Typically 4–10 weeks",
  ),
  Engagement(
    name: "Program",
    tag: "Most common",
    description:
        "Multiple disciplines running together: a rebrand and a website, or an app with ongoing design support.",
    features: [
      "Coordinated across brand, web & product",
      "One point of contact for everything",
      "Phased delivery, reviewed as we go",
    ],
    terms: "Typically 2–4 months",
  ),
  Engagement(
    name: "Partner",
    tag: "Ongoing",
    description: "A monthly retainer for teams who want a design & dev partner on call, not a one-off vendor.",
    features: ["Reserved capacity each month", "Covers maintenance and new work", "Month-to-month, no lock-in"],
    terms: "Monthly, cancel anytime",
  ),
];

const studioParagraphs = [
  "Creative Media stays small enough that the people who pitch the work are the people who do it. No handoffs to a second team once the contract's signed.",
  "We work with founders and marketing leads who treat a brand and its website as one connected system, not a logo here, a site there, and a hope that they'll match.",
];
const studioValues = [
  "One team from strategy through to shipped product",
  "Everything built from scratch, no themes, no templates",
  "Design decisions judged against the brief, not a trend",
  "Maintenance included, not sold as an afterthought",
];

const faqs = <(String, String)>[
  (
    "How long does a typical project take?",
    "Most single-discipline projects run 4–10 weeks; branding is on the shorter end, apps on the longer end. Combined programs (brand + web, for example) usually run 2–4 months. You'll get a specific timeline before anything is signed off.",
  ),
  (
    "Do you work with early-stage startups, or only established brands?",
    "Both. Early-stage teams tend to lean on the Consultancy and Branding services first; established brands more often come in for a rebrand or a rebuild. Scope flexes to match the stage you're at.",
  ),
  (
    "What's actually included in maintenance?",
    "Software and plugin updates, uptime and error monitoring, priority bug fixes, and small content or feature changes: the kind of upkeep that otherwise gets put off until something breaks.",
  ),
  (
    "Do you work with teams outside the UK?",
    "Yes. Most collaboration happens over call and async review, so time zones with a few hours of overlap work fine. We'll flag it early if a project needs more in-person time than that allows.",
  ),
  (
    "Can we bring you in for just one part, the website say?",
    "Yes. Each of the six services can be booked on its own as a Project engagement. If it later needs a companion piece, a brand to sit behind that website for instance, we can fold it into a Program without starting over.",
  ),
];

const services = <Service>[
  Service(
    name: 'Branding',
    ctaLabel: 'Build your brand →',
    duration: '2–4 weeks',
    description: 'Identity systems built to hold up at any size: favicon, packaging, or the side of a building.',
    deliverables: ['Strategy & positioning input', 'Logo, colour, type & identity system', 'Brand guidelines document'],
  ),
  Service(
    name: 'Rebranding',
    ctaLabel: 'Refresh your brand →',
    duration: '3–5 weeks',
    description:
        "For businesses that have outgrown the story they started with. We keep what's earned, cut what isn't.",
    deliverables: [
      'Audit of existing brand equity',
      'Refreshed or rebuilt identity system',
      'Rollout plan across touchpoints',
    ],
  ),
  Service(
    name: 'Consultancy',
    ctaLabel: 'Shape your strategy →',
    duration: '1–2 weeks',
    description: 'Positioning, naming and go-to-market thinking, worked through before a single pixel moves.',
    deliverables: ['Market & competitor scan', 'Positioning & naming workshop', 'Written recommendation & scope doc'],
  ),
  Service(
    name: 'Web development',
    ctaLabel: 'Build your website →',
    duration: '3–8 weeks',
    description: 'Fast, considered sites written by hand, not assembled from a theme or a page builder.',
    deliverables: [
      'Custom design & build, no templates',
      'CMS handover, if you need to self-edit',
      'Performance & basic SEO pass',
    ],
  ),
  Service(
    name: 'App development',
    ctaLabel: 'Build your app →',
    duration: '6–12 weeks',
    description: 'Native and cross-platform products designed to be opened again tomorrow, not just once.',
    deliverables: [
      'Product design & interaction flows',
      'iOS, Android or cross-platform build',
      'App Store / Play Store submission',
    ],
  ),
  Service(
    name: 'Maintenance',
    ctaLabel: 'Get ongoing support →',
    duration: 'Ongoing',
    description: 'Ongoing care: updates, monitoring and small fixes handled before they become big ones.',
    deliverables: ['Monthly updates & uptime monitoring', 'Priority bug fixes', 'Small content & feature changes'],
  ),
];

const caseStudies = <CaseStudy>[
  CaseStudy(
    name: 'Sift Coffee',
    isIllustrative: true,
    isSelfInitiated: true,
    transition: CaseTransition.accentCurtain,
    heroImage: 'assets/selected-work/sift/hero.webp',
    tag: 'Brand Strategy & Identity · 2026',
    client: 'Self-initiated studio project',
    role: 'Strategy, naming, identity & packaging',
    timeline: 'Design study',
    deliverables: 'Identity system, bilingual packaging, brewing cards & brand guide',
    layout: CaseLayout.stickyChapters,
    lede: CaseLede(
      'A coffee identity shaped around ',
      'clear choices',
      ', from the first label to the last small detail.',
    ),
    paragraphs: [
      'Sift Coffee is a self-initiated brand study for curious home brewers. The idea is simple: a small collection, a clear place to start, and useful information wherever someone meets the brand. Good coffee. Clearly chosen.',
      'Three directions give the collection a clear rhythm: Everyday for a rounded daily cup, Daybreak for brighter flavours, and After Hours for a deeper profile. Shared label rules make the differences easy to find while holding the range together.',
    ],
    chapters: [
      CaseChapter(
        number: '01',
        title: 'A line that makes a choice',
        image: 'assets/selected-work/sift/identity.webp',
        body:
            'Sift suggests selecting and refining. The Selected Line gives that idea a visible form: five horizontal rules, with one longer cobalt rule. Warm paper, dark ink and an optically spaced wordmark keep the system precise without making it cold. The same motif works on a label, a brewing card and a small profile icon.',
      ),
      CaseChapter(
        number: '02',
        title: 'Three clear starting points',
        image: 'assets/selected-work/sift/range.webp',
        body:
            'Everyday is the rounded daily starting point, Daybreak the brighter direction, and After Hours the deeper cup. Roast orange, cobalt and dark ink distinguish them, while written names keep the range readable in grayscale. Every label puts product, flavour direction and weight before specialist detail.',
      ),
      CaseChapter(
        number: '03',
        title: 'English and Arabic, considered together',
        image: 'assets/selected-work/sift/bilingual.webp',
        body:
            'English and Arabic share a deliberate reading hierarchy. Arabic has its own natural shaping, spacing and line height; it is not squeezed into a translated footnote. Origin, process and variable roast-date fields sit where they can be found. The 250 g and 1 kg formats use the same rules at comfortable sizes.',
      ),
      CaseChapter(
        number: '04',
        title: 'An identity beyond the bag',
        image: 'assets/selected-work/sift/applications.webp',
        body:
            'Brewing cards, a sample box, shipping materials and reusable layouts carry the same identity beyond the front label. Editable artwork and the brand guide make the decisions inspectable: optical logo sizes, bilingual hierarchy, product identifiers and clear handling of variable information. The handoff pairs reusable artwork with clear usage rules, so each new application can keep the same level of care.',
      ),
    ],
    downloads: [
      CaseDownload(
        label: 'Brand guide',
        href: 'assets/selected-work/sift/sift-brand-guide.pdf',
        format: 'PDF',
      ),
      CaseDownload(
        label: 'Editable artwork',
        href: 'assets/selected-work/sift/sift-artwork.zip',
        format: 'ZIP',
      ),
    ],
  ),
  CaseStudy(
    name: 'Form Architecture',
    isIllustrative: true,
    isSelfInitiated: true,
    transition: CaseTransition.accentCurtain,
    heroImage: 'assets/selected-work/form/hero.webp',
    heroAlt: 'Form Architecture identity and actual homepage excerpt beside a generated Courtyard House spatial study.',
    tag: 'Rebrand & Website Relaunch · 2026',
    client: 'Self-initiated studio project',
    role: 'Concept strategy, identity, art direction, UX/UI & website implementation',
    timeline: 'Design & implementation study',
    deliverables: 'Identity, architectural study imagery, responsive website, project editor & enquiry demo',
    layout: CaseLayout.split,
    lede: CaseLede(
      'A material-led identity and project website that make ',
      'architectural decisions',
      ' easier to explore.',
    ),
    paragraphs: [
      'Form Architecture is a self-initiated rebrand and website study. Architecture shaped around how people live is the positioning: light, material, movement and use become the way to explain each space. The three architectural studies are fictional; their generated imagery and authored diagrams are recorded in the source register.',
      'The fictional starting identity presented projects as disconnected images. We created that baseline for this exercise, then defined a clearer way to connect space, context and enquiry. Both versions use Courtyard House, Line Studio and Shore Library, so the comparison holds the project content steady.',
      'Recognition comes from keeping the Form name and open-frame cue. A refined vector wordmark, a vertical 3:4 frame with a lower-right opening, and a chalk, charcoal, sage and clay palette carry the same idea through navigation, stationery and project facts. Cormorant Garamond gives editorial passages room; Instrument Sans and IBM Plex Sans Arabic keep information useful in both directions.',
      'The responsive website puts a brief beside its spatial response and gives each study an ordered story. Project facts, captions and material details explain what the image shows. English and Arabic use the same records, with natural Arabic shaping and readable Latin project names.',
      'Discuss a similar project carries the selected study into Contact. Inline validation preserves the draft, names the missing information and focuses the first invalid field. Preview demo receipt ends with a clear message: Demo complete. This enquiry has not been sent.',
      'The local project editor makes content inspectable: stable IDs, unique slugs, bilingual titles, facts, ordered chapters, image descriptions and separate desktop/mobile focal points. Edit, preview and publish demonstrate a local content change; required fields block an incomplete publication. The website, editor and receipt are working demonstrations, with no commercial launch or architectural construction claim.',
    ],
    facts: [
      CaseFact('Positioning', 'Architecture shaped around how people live.'),
      CaseFact('Recognition retained', 'Form name · open structural frame'),
      CaseFact('Canonical studies', 'Courtyard House · Line Studio · Shore Library'),
      CaseFact('Courtyard House', 'Residential study · 2025 · fictional Mediterranean setting · 240 m²'),
      CaseFact('Line Studio', 'Workplace study · 2026 · fictional international urban setting · 180 m²'),
      CaseFact('Shore Library', 'Cultural-space study · 2026 · fictional coastal setting · 620 m²'),
      CaseFact('Digital scope', 'Responsive site · local project editor · contextual enquiry demo'),
      CaseFact(
        'Image authorship',
        'Generated architectural study imagery and authored conceptual diagrams; source register included.',
      ),
    ],
    figures: [
      CaseFigure(
        'assets/selected-work/form/baseline.webp',
        'Fictional starting identity created for this rebrand study. The actual baseline homepage uses the same three studies, a two-line wordmark and slate-blue frame.',
      ),
      CaseFigure(
        'assets/selected-work/form/redesign.webp',
        'The same homepage viewport after the rebrand: retained recognition, material-led colour, consistent image ratios and project information beside the relevant image.',
      ),
      CaseFigure(
        'assets/selected-work/form/identity-system.webp',
        'One identity system connects the custom wordmark, open 3:4 frame, colour roles, editorial and functional type, and English/Arabic applications.',
      ),
      CaseFigure(
        'assets/selected-work/form/project-desktop.webp',
        'Actual Courtyard House project page: light, privacy and a planted courtyard organize the narrative alongside the canonical 240 m² study facts.',
      ),
      CaseFigure(
        'assets/selected-work/form/project-mobile.webp',
        'The implemented mobile project page keeps image, caption and explanation in a purposeful sequence, with comfortably readable facts and controls.',
      ),
      CaseFigure(
        'assets/selected-work/form/enquiry-states.webp',
        'Actual entered draft, inline validation and demo receipt. An invalid enquiry preserves the draft and explains the next action; the receipt states that nothing has been sent.',
      ),
      CaseFigure(
        'assets/selected-work/form/cms-edit.webp',
        'The implemented project editor and its corresponding page change: edit, preview and local publish, with required fields and image focal points under structured control.',
      ),
      CaseFigure(
        'assets/selected-work/form/details/wordmark.webp',
        'The wordmark clear-space rule holds across a narrow navigation bar and printed-cover artwork.',
      ),
      CaseFigure(
        'assets/selected-work/form/details/image-crop.webp',
        'Desktop and mobile crops preserve the same meaningful spatial feature; separate focal points remain editable and the full image remains inspectable.',
      ),
      CaseFigure(
        'assets/selected-work/form/details/project-facts.webp',
        'Facts, units and captions keep a consistent reading order in English and Arabic, with optional facts omitted when absent.',
      ),
    ],
    downloads: [
      CaseDownload(
        label: 'Explore Form website',
        href: 'assets/selected-work/form/site/index.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Open project editor',
        href: 'assets/selected-work/form/site/editor.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(label: 'Editable sources', href: 'assets/selected-work/form/form-source.zip', format: 'ZIP'),
    ],
  ),
  CaseStudy(
    name: 'Frame Academy',
    isIllustrative: true,
    isSelfInitiated: true,
    transition: CaseTransition.accentCurtain,
    heroImage: 'assets/selected-work/frame/hero.webp',
    layout: CaseLayout.horizontalScroll,
    tag: 'Brand, Website & App · 2026',
    heroAlt: 'Frame Academy workbook artwork with actual course discovery and native app continuation screens.',
    client: 'Self-initiated studio project',
    role: 'Strategy, identity, course artwork, web & Flutter mobile app',
    timeline: 'Design & implementation study',
    deliverables: 'Editable identity and workbooks, captioned lesson, EN/AR website, iOS demo & shared saved progress',
    lede: CaseLede(
      'A creative academy shaped around ',
      'the next useful step',
      ', from choosing a course to returning to the lesson.',
    ),
    paragraphs: [
      'Frame Academy is a self-initiated learning brand for practical photography, filmmaking and visual design. Make your next idea is its invitation: a clear place to start, a small exercise to try and a useful next step. Composition Essentials connects the discovery website with a running Flutter learning app.',
      'Two offset open corners give course artwork a point of view. Space Grotesk, Inter and naturally shaped IBM Plex Sans Arabic carry a bright canvas, midnight ink and crisp blue actions. The expressive workbook becomes a quieter learning surface, with course outcome and equipment visible before enrolment.',
      'The recorded English and Arabic journeys start at 0 of 6. An authored lesson has captions and a transcript; its actual media duration is separate from the planned curriculum. A confirmed exercise save, explicit completion and app restart preserve 1 of 6 complete and continue at lesson 02, Find the subject. A controlled save failure keeps the note available for successful retry. This is a local demonstration, with no instructor-review or commercial-launch claim.',
    ],
    chapters: [
      CaseChapter(
        number: '01',
        title: 'Choose with clarity',
        body:
            'Actual course detail puts the outcome, equipment and prerequisite beside the decision. Composition Essentials is FA-PH-01: six lessons and 62 planned study minutes. The first authored preview explains the exercise before the learner continues as Demo learner.',
        image: 'assets/selected-work/frame/course-discovery.webp',
      ),
      CaseChapter(
        number: '02',
        title: 'Carry the identity',
        body:
            'The custom wordmark, two displaced L corners, course covers and exercise sheets share one measured system. The mark keeps its orientation across locales; Arabic text shapes naturally and directional controls follow the reading direction.',
        image: 'assets/selected-work/frame/identity.webp',
      ),
      CaseChapter(
        number: '03',
        title: 'Keep the next step visible',
        body:
            'The actual native app after restart shows 1 of 6 lessons complete beside the next action: 02 Find the subject. Enrolment, progress and exercise drafts use the same local demonstration record as the website. Opening the player alone never completes a lesson.',
        image: 'assets/selected-work/frame/lesson-continuation.webp',
      ),
      CaseChapter(
        number: '04',
        title: 'Recover without losing work',
        body:
            'A controlled failed save leaves the practice note intact. Retry confirms persistence before saved feedback appears; completion remains a separate action. Actual English and Arabic captures show the retained work, saved exercise and useful next step.',
        image: 'assets/selected-work/frame/exercise-recovery.webp',
      ),
    ],
    downloads: [
      CaseDownload(
        label: 'Explore Frame Academy',
        href: 'assets/selected-work/frame/site/index.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Watch the recorded journey',
        href: 'assets/selected-work/frame/demo-journey.mp4',
        format: 'MP4',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Editable project sources',
        href: 'assets/selected-work/frame/frame-source.zip',
        format: 'ZIP',
      ),
    ],
  ),
  CaseStudy(
    name: 'Fold Clothing',
    isIllustrative: true,
    isSelfInitiated: true,
    transition: CaseTransition.accentCurtain,
    heroImage: 'assets/selected-work/fold/hero.webp',
    heroAlt: 'Bespoke FOLD signature with a four-garment capsule, presented through generated garment concept imagery.',
    tag: 'Ecommerce Brand & Store · 2026',
    client: 'Self-initiated studio project',
    role: 'Strategy, identity, garment art direction, UX/UI & store implementation',
    timeline: 'Design & implementation study',
    deliverables: 'Editable identity, packaging, garment imagery, EN/AR store & simulated checkout',
    layout: CaseLayout.statistics,
    metrics: [],
    lede: CaseLede(
      'A considered clothing identity and a store built around ',
      'clear product choices',
      '.',
    ),
    paragraphs: [
      'Fold Clothing is a self-initiated ecommerce brand and store study. Clothes that give your day room is the proposition: useful silhouettes, considered construction and clear choices. Collection 01: Everyday Structure brings together Box Shirt, Pleat Trouser, Layer Vest and Field Overshirt.',
      'The FOLD wordmark and pattern-cut line system take their cues from garment construction. Ivory, Ink, Citrine and Deep olive frame the collection; Archivo carries the editorial voice and DM Sans the shopping information. Naturally shaped IBM Plex Sans Arabic gives the Arabic store its own comfortable reading rhythm.',
      'A locked pattern defines each garment before image production: the shirt’s five-button placket and single chest pocket, the trouser’s forward pleats and side pockets, the vest’s four buttons and two patch pockets, and the overshirt’s six buttons and two chest pockets. The generated garment visuals are concept art, registered separately from actual store captures. Materials, stock and prices are illustrative catalogue fixtures.',
      'The implemented English and Arabic store keeps colour, imagery, size and SKU together. URL-based filters retain the selection; size must be chosen explicitly before adding. Layer Vest Stone/XS is labelled unavailable. A change of size rechecks stock rather than silently accepting a different variant.',
      'Size guidance states the measurement method before the table: these are laid-flat garment measurements, with chest and waist shown as half-widths, not body circumferences. Centimetres and inches stay readable beside sizes XS–XL, including in the Arabic layout.',
      'The complete demonstration journey selects Box Shirt Chalk/M at \$95 and Pleat Trouser Ink/M at \$145. The basket is \$240, plus \$12 demo shipping and \$0 test tax: \$252. The checkout states “Demo checkout — no payment or order will be placed.” A simulated action ends with a deterministic demo reference and the same basket summary.',
      'The versioned demo cart stays on this browser, with stock limits, removal Undo and Clear demo cart. Recoverable failures retain valid cart contents and entered shipping details for retry. The first working version exposed a keyboard issue: changing cart quantity or size sent focus to the page body. Version 1.1 keeps cart order stable and restores the intended edited or next control, including after retry. Editable artwork, store source and an actual shopping-flow recording make the local implementation inspectable; no commercial launch or business result is claimed.',
    ],
    figures: [
      CaseFigure(
        'assets/selected-work/fold/case/identity.webp',
        'The authored FOLD identity: a cut in the wordmark, purposeful pattern lines, bilingual hierarchy and editable packaging artwork.',
      ),
      CaseFigure(
        'assets/selected-work/fold/case/continuity.webp',
        'Generated garment concept imagery across front, back and construction detail, reviewed against the locked pattern and colour canon. These are not photographs of manufactured garments.',
      ),
      CaseFigure(
        'assets/selected-work/fold/case/measurements.webp',
        'Actual size guidance makes the laid-flat method explicit. Chest and waist are half-widths; cm and inches stay associated with each size in English and Arabic.',
      ),
      CaseFigure(
        'assets/selected-work/fold/case/shopping.webp',
        'Actual shopping screens connect explicit variant selection with the \$240 basket and \$252 demo total. Unavailable stock remains named and the checkout clearly explains its simulation.',
      ),
      CaseFigure(
        'assets/selected-work/fold/case/maintenance.webp',
        'Actual before/after maintenance evidence: quantity and size changes originally lost keyboard focus. Version 1.1 preserves cart order and restores the intended edited or next control, including after retry.',
      ),
    ],
    downloads: [
      CaseDownload(
        label: 'Explore Fold store',
        href: 'assets/selected-work/fold/site/index.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Watch the shopping flow',
        href: 'assets/selected-work/fold/shopping-flow.html',
        format: 'HTML',
        isDownload: false,
      ),
      CaseDownload(
        label: 'Editable project sources',
        href: 'assets/selected-work/fold/fold-source.zip',
        format: 'ZIP',
      ),
    ],
  ),
];

final workProjects = List<WorkProject>.unmodifiable([
  WorkProject(
    index: '01',
    year: '2026',
    disciplines: 'Strategy · Identity · Packaging',
    cardImage: 'assets/selected-work/sift/card.webp',
    category: 'Brand Strategy & Identity',
    status: 'Studio concept',
    description:
        'A coffee identity built around clear choices, considered packaging and equal care in English and Arabic.',
    caseStudy: caseStudies[0],
  ),
  WorkProject(
    index: '02',
    year: '2026',
    disciplines: 'Rebrand · UX/UI · Web',
    cardImage: 'assets/selected-work/form/card.webp',
    cardAlt: 'Actual Form Architecture website preview with a generated architectural courtyard study.',
    category: 'Rebrand & website relaunch',
    status: 'Studio concept',
    description: 'A material-led identity and project website that make architectural decisions easier to explore.',
    caseStudy: caseStudies[1],
  ),
  WorkProject(
    index: '03',
    year: '2026',
    disciplines: 'Strategy · Identity · Web · Mobile app',
    category: 'Brand, Website & App',
    description:
        'A creative learning concept connecting course discovery with a clear, continuous learning experience.',
    status: 'Studio concept',
    cardAlt: 'Actual Composition Essentials website detail and Frame native app with saved 1-of-6 progress.',
    cardImage: 'assets/selected-work/frame/card.webp',
    caseStudy: caseStudies[2],
  ),
  WorkProject(
    index: '04',
    year: '2026',
    disciplines: 'Strategy · Identity · Ecommerce · Maintenance',
    cardImage: 'assets/selected-work/fold/card.webp',
    cardAlt: 'Bespoke FOLD signature beside a generated Field Overshirt concept.',
    category: 'Ecommerce Brand & Store',
    status: 'Studio concept',
    description: 'A considered clothing identity and a store concept built around clear product choices.',
    caseStudy: caseStudies[3],
  ),
]);
