enum CaseTransition { sharedElementExpand, accentCurtain, cursorIris, tunnelZoom }

enum CaseLayout { split, horizontalScroll, stickyChapters, statistics }

class Service {
  const Service({required this.name, required this.duration, required this.description, required this.deliverables});

  final String name;
  final String duration;
  final String description;
  final List<String> deliverables;
}

class CaseLede {
  const CaseLede(this.before, this.emphasis, this.after);

  final String before;
  final String emphasis;
  final String after;
}

class CaseFigure {
  const CaseFigure(this.image, this.caption);

  final String image;
  final String caption;
}

class CaseQuote {
  const CaseQuote(this.text, this.attribution);

  final String text;
  final String attribution;
}

class CaseFact {
  const CaseFact(this.label, this.value);

  final String label;
  final String value;
}

class CaseChapter {
  const CaseChapter({required this.number, required this.title, required this.image, this.body});

  final String number;
  final String title;
  final String image;
  final String? body;
}

class CaseMetric {
  const CaseMetric(this.target, this.suffix, this.decimals, this.label);

  final double target;
  final String suffix;
  final int decimals;
  final String label;
}

class CaseStudy {
  const CaseStudy({
    required this.name,
    required this.isIllustrative,
    required this.transition,
    required this.heroImage,
    required this.tag,
    required this.client,
    required this.role,
    required this.timeline,
    required this.deliverables,
    required this.layout,
    required this.lede,
    this.paragraphs = const [],
    this.facts = const [],
    this.figures = const [],
    this.chapters = const [],
    this.metrics = const [],
    this.quote,
  });

  final String name;
  final bool isIllustrative;
  final CaseTransition transition;
  final String heroImage;
  final String tag;
  final String client;
  final String role;
  final String timeline;
  final String deliverables;
  final CaseLayout layout;
  final CaseLede lede;
  final List<String> paragraphs;
  final List<CaseFact> facts;
  final List<CaseFigure> figures;
  final List<CaseChapter> chapters;
  final List<CaseMetric> metrics;
  final CaseQuote? quote;
}

class WorkProject {
  const WorkProject({
    required this.index,
    required this.year,
    required this.disciplines,
    required this.cardImage,
    required this.category,
    required this.description,
    required this.caseStudy,
  });

  final String index;
  final String year;
  final String disciplines;
  final String cardImage;
  final String category;
  final String description;
  final CaseStudy caseStudy;
}
