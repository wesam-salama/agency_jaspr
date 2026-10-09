import '../models/site_models.dart';

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
      'Editable content handover, if you need it',
      'Performance & search visibility basics',
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
    transition: CaseTransition.sharedElementExpand,
    heroImage: 'assets/images/fenwick-hero.jpg',
    tag: 'Rebrand & Web · 2025',
    client: 'Fenwick & Ash Ltd.',
    role: 'Identity, web design & build',
    timeline: '9 weeks',
    deliverables: 'Identity system, guidelines, editable site',
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
      CaseFact('Web', 'Custom-built, editable website handover'),
    ],
    paragraphs: [
      "Fenwick & Ash made beautiful furniture and looked like a phone directory advert. The audit kept everything earned (the name, the heritage, the client book) and cut everything that wasn’t.",
      'The site runs on the same grid. Every project page is a case file: commission, wood, hours at the bench. The team can edit their own content after handover.',
    ],
    figures: [
      CaseFigure('assets/images/fenwick-room.jpg', 'Art-direction reference: rooms and materials'),
      CaseFigure('assets/images/fenwick-chair.jpg', 'Photography reference: object and light'),
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
      '“Retention after 30 days doubled against the old prototype. The forgiveness mechanic did that.”',
      'Product Lead, Loop',
    ),
  ),
  CaseStudy(
    name: 'Marrow',
    isIllustrative: true,
    transition: CaseTransition.cursorIris,
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
    transition: CaseTransition.tunnelZoom,
    heroImage: 'assets/images/northline-hero.jpg',
    tag: 'Web Development · 2023',
    client: 'Northline Logistics',
    role: 'User experience, complete platform rebuild',
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
      CaseFigure('assets/images/northline-city.jpg', 'Visual reference: network context'),
      CaseFigure('assets/images/northline-field.jpg', 'Visual reference: routing context'),
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
    disciplines: 'Identity · Web · Editable content',
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
    disciplines: 'User experience · Build · Database',
    cardImage: 'assets/images/northline-card.jpg',
    category: 'Web Development',
    description: 'A logistics platform rebuilt from the database up, for speed and for the people using it daily.',
    caseStudy: caseStudies[3],
  ),
]);
