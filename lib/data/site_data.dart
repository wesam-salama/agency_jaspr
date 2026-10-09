import '../models/site_models.dart';

// Authored reference copy from ../agency_website.html; runtime stays app-owned.

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
    duration: '2–4 weeks',
    description: 'Identity systems built to hold up at any size: favicon, packaging, or the side of a building.',
    deliverables: ['Strategy & positioning input', 'Logo, colour, type & identity system', 'Brand guidelines document'],
  ),
  Service(
    name: 'Rebranding',
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
    duration: '1–2 weeks',
    description: 'Positioning, naming and go-to-market thinking, worked through before a single pixel moves.',
    deliverables: ['Market & competitor scan', 'Positioning & naming workshop', 'Written recommendation & scope doc'],
  ),
  Service(
    name: 'Web development',
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
    duration: 'Ongoing',
    description: 'Ongoing care: updates, monitoring and small fixes handled before they become big ones.',
    deliverables: ['Monthly updates & uptime monitoring', 'Priority bug fixes', 'Small content & feature changes'],
  ),
];

const caseStudies = <CaseStudy>[
  CaseStudy(
    name: 'Fenwick & Ash',
    isIllustrative: true,
    transition: CaseTransition.accentCurtain,
    heroImage: 'assets/images/fenwick-hero.jpg',
    tag: 'Rebrand & Web · 2025',
    client: 'Fenwick & Ash Ltd.',
    role: 'Identity, web design & build',
    timeline: '9 weeks',
    deliverables: 'Identity system, guidelines, site, CMS',
    layout: CaseLayout.split,
    lede: CaseLede(
      'Forty years of joinery, rebuilt for a design-forward audience ',
      'without losing the workshop',
      ' underneath it.',
    ),
    facts: [
      CaseFact('Problem', 'Brand older than its audience'),
      CaseFact('Move', 'Keep the workshop, rebuild the voice'),
      CaseFact('System', 'Wordmark, grid, timber palette'),
      CaseFact('Web', 'Hand-built, CMS-handover'),
    ],
    paragraphs: [
      "Fenwick & Ash made beautiful furniture and looked like a phone directory advert. The audit kept everything earned (the name, the heritage, the client book) and cut everything that wasn’t.",
      'The site runs on the same grid. Every project page is a case file: commission, wood, hours at the bench. The team edits it themselves through a CMS handover.',
    ],
    figures: [
      CaseFigure('assets/images/fenwick-room.jpg', 'Art direction: rooms, not showrooms'),
      CaseFigure('assets/images/fenwick-chair.jpg', 'Product photography: one object, one light'),
    ],
    quote: CaseQuote(
      '“They kept forty years of history and still made us look like the future.”',
      'E. Fenwick, Managing Director',
    ),
  ),
  CaseStudy(
    name: 'Loop',
    isIllustrative: true,
    transition: CaseTransition.accentCurtain,
    heroImage: 'assets/images/loop-hero.jpg',
    tag: 'Product & App · 2024',
    client: 'Loop Health Ltd.',
    role: 'Product design, iOS & Android',
    timeline: '11 weeks',
    deliverables: 'Design system, app, store launch',
    layout: CaseLayout.horizontalScroll,
    lede: CaseLede('A habit tracker people actually ', 'keep opening', ', from onboarding flow to App Store.'),
    paragraphs: [
      'Most habit apps are guilt machines. Loop is built around streaks that forgive: miss a day and the line bends, it doesn’t break. That single product decision shaped the whole design system: soft curves, warm darks, one accent.',
    ],
    chapters: [
      CaseChapter(number: '01', title: 'Onboarding: 90 seconds max', image: 'assets/images/loop-onboarding.jpg'),
      CaseChapter(number: '02', title: 'Streaks that bend, not break', image: 'assets/images/loop-phone.jpg'),
      CaseChapter(number: '03', title: 'Home-screen widgets', image: 'assets/images/loop-widgets.jpg'),
      CaseChapter(number: '04', title: 'Weekly review, no guilt', image: 'assets/images/loop-review.jpg'),
    ],
    quote: CaseQuote(
      '“D30 retention doubled against the old prototype. The forgiveness mechanic did that.”',
      'Product Lead, Loop',
    ),
  ),
  CaseStudy(
    name: 'Marrow',
    isIllustrative: true,
    transition: CaseTransition.accentCurtain,
    heroImage: 'assets/images/marrow-hero.jpg',
    tag: 'Brand & Consultancy · 2024',
    client: 'Marrow Butchery Co.',
    role: 'Naming, positioning, identity',
    timeline: '6 weeks',
    deliverables: 'Name, voice, identity, packaging',
    layout: CaseLayout.stickyChapters,
    lede: CaseLede('A direct-to-consumer butchery entering a ', 'crowded shelf', ': named, positioned, dressed.'),
    chapters: [
      CaseChapter(
        number: '01',
        title: 'Naming',
        body:
            'Shortlists went from forty names to four to one. “Marrow” won because it’s the part of the animal chefs fight over: depth, richness, the good stuff.',
        image: 'assets/images/marrow-food.jpg',
      ),
      CaseChapter(
        number: '02',
        title: 'Positioning',
        body:
            'The shelf already shouts “artisanal small-batch”. Marrow is positioned on provenance transparency: farm, distance, days aged, printed on every pack.',
        image: 'assets/images/marrow-salad.jpg',
      ),
      CaseChapter(
        number: '03',
        title: 'Identity',
        body:
            'The identity is a butcher’s block of a wordmark, blood-red accent, and packaging that reads like a spec sheet. It stands out by standing still.',
        image: 'assets/images/marrow-pack.jpg',
      ),
    ],
  ),
  CaseStudy(
    name: 'Northline',
    isIllustrative: true,
    transition: CaseTransition.accentCurtain,
    heroImage: 'assets/images/northline-hero.jpg',
    tag: 'Web Development · 2023',
    client: 'Northline Logistics',
    role: 'UX, full-stack rebuild',
    timeline: '14 weeks',
    deliverables: 'Platform, routing engine, dashboards',
    layout: CaseLayout.statistics,
    lede: CaseLede(
      'A logistics platform rebuilt from the database up, for speed and for the ',
      'people using it daily',
      '.',
    ),
    metrics: [
      CaseMetric(68, '%', 0, 'Faster route queries'),
      CaseMetric(12400, '', 0, 'Routes re-planned daily'),
      CaseMetric(.4, 's', 1, 'Median dashboard load'),
    ],
    paragraphs: [
      'The old system took eleven seconds to draw a morning board. Dispatchers had memorised workarounds. We rebuilt the query layer first, then the UI around the three questions a dispatcher actually asks: what’s late, what’s empty, what’s next.',
    ],
    figures: [
      CaseFigure('assets/images/northline-city.jpg', 'The network: 400 vehicles, one board'),
      CaseFigure('assets/images/northline-field.jpg', 'Routing engine: recalculated every 90 seconds'),
    ],
    quote: CaseQuote(
      '“The morning board loads before my coffee does. That’s the whole review.”',
      'Operations Director, Northline',
    ),
  ),
];

final workProjects = List<WorkProject>.unmodifiable([
  WorkProject(
    index: '01',
    year: '2025',
    disciplines: 'Identity · Web · CMS',
    cardImage: 'assets/images/fenwick-card.jpg',
    category: 'Rebrand & Web',
    description:
        "A 40-year furniture maker's identity, rebuilt for a design-forward audience without losing the workshop underneath it.",
    caseStudy: caseStudies[0],
  ),
  WorkProject(
    index: '02',
    year: '2024',
    disciplines: 'Product · iOS · Android',
    cardImage: 'assets/images/loop-card.jpg',
    category: 'Product & App',
    description: 'A habit-tracking app taken from onboarding flow to App Store: design system, build and launch.',
    caseStudy: caseStudies[1],
  ),
  WorkProject(
    index: '03',
    year: '2024',
    disciplines: 'Naming · Positioning · Identity',
    cardImage: 'assets/images/marrow-card.jpg',
    category: 'Brand & Consultancy',
    description: 'Naming and positioning for a direct-to-consumer butchery brand entering a crowded shelf.',
    caseStudy: caseStudies[2],
  ),
  WorkProject(
    index: '04',
    year: '2023',
    disciplines: 'UX · Build · Database',
    cardImage: 'assets/images/northline-card.jpg',
    category: 'Web Development',
    description: 'A logistics platform rebuilt from the database up, for speed and for the people using it daily.',
    caseStudy: caseStudies[3],
  ),
]);
