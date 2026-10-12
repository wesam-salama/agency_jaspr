import '../data/site_data.dart' as source;
import '../models/site_models.dart';

part 'arabic_content.dart';
part 'french_content.dart';
part 'ui_text.dart';

/// URL languages supported by the statically generated site.
enum SiteLocale {
  en('en', '', 'English', false),
  ar('ar', 'ar', 'العربية', true),
  fr('fr', 'fr', 'Français', false);

  const SiteLocale(this.code, this.pathSegment, this.nativeLabel, this.isRtl);

  final String code;
  final String pathSegment;
  final String nativeLabel;
  final bool isRtl;
  String get direction => isRtl ? 'rtl' : 'ltr';

  static SiteLocale fromCode(String? code) => SiteLocale.values.firstWhere(
    (locale) => locale.code == code,
    orElse: () => SiteLocale.en,
  );
}

class SiteContent {
  const SiteContent({
    required this.locale,
    required this.siteTitle,
    required this.siteDescription,
    required this.heroEyebrow,
    required this.heroHeadline,
    required this.heroHeadlineParts,
    required this.heroDescription,
    required this.heroHint,
    required this.sectionCopy,
    required this.processSteps,
    required this.engagements,
    required this.studioParagraphs,
    required this.studioValues,
    required this.faqs,
    required this.services,
    required this.caseStudies,
    required this.workProjects,
    required this.serviceNames,
    required this.timingLabels,
    required this.uiText,
  });

  final SiteLocale locale;
  final String siteTitle;
  final String siteDescription;
  final String heroEyebrow;
  final String heroHeadline;
  final CaseLede heroHeadlineParts;
  final String heroDescription;
  final String heroHint;
  final Map<String, SectionCopy> sectionCopy;
  final List<ProcessStep> processSteps;
  final List<Engagement> engagements;
  final List<String> studioParagraphs;
  final List<String> studioValues;
  final List<(String, String)> faqs;
  final List<Service> services;
  final List<CaseStudy> caseStudies;
  final List<WorkProject> workProjects;
  final List<String> serviceNames;
  final Map<String, String> timingLabels;
  final Map<UiTextKey, String> uiText;

  String t(UiTextKey key, {Map<String, String> values = const {}}) {
    final template = uiText[key];
    if (template == null) throw StateError('Missing ${locale.code} translation: $key');
    return template.replaceAllMapped(RegExp(r'\{(\w+)\}'), (match) {
      final name = match.group(1)!;
      final value = values[name];
      if (value == null) throw ArgumentError.value(name, 'values', 'Missing interpolation value for $key');
      return value;
    });
  }

  /// Keep metric values shared while presenting punctuation for this language.
  String formatMetric(num value, int decimals) {
    final parts = value.toStringAsFixed(decimals).split('.');
    final thousands = switch (locale) {
      SiteLocale.en => ',',
      SiteLocale.ar => '٬',
      SiteLocale.fr => ' ',
    };
    final decimal = switch (locale) {
      SiteLocale.en => '.',
      SiteLocale.ar => '٫',
      SiteLocale.fr => ',',
    };
    final whole = parts.first;
    final output = StringBuffer();
    for (var index = 0; index < whole.length; index++) {
      if (index > 0 && (whole.length - index) % 3 == 0) output.write(thousands);
      output.write(whole[index]);
    }
    if (parts.length > 1) {
      output
        ..write(decimal)
        ..write(parts.last);
    }
    return output.toString();
  }

  /// Expand the compact seconds suffix for assistive reading of case results.
  /// Other metric values retain their visible wording.
  String spokenMetricValue(CaseMetric metric) {
    final number = formatMetric(metric.target, metric.decimals);
    if (metric.suffix == 's' || metric.suffix == 'ث') {
      return switch (locale) {
        SiteLocale.en => '$number ${metric.target == 1 ? 'second' : 'seconds'}',
        SiteLocale.ar => '$number ثانية',
        SiteLocale.fr => '$number ${metric.target > 1 ? 'secondes' : 'seconde'}',
      };
    }
    return '$number${metric.suffix}';
  }
}

final SiteContent _english = SiteContent(
  locale: SiteLocale.en,
  siteTitle: 'Creative Media — Branding, Web & App Development',
  siteDescription:
      'Creative Media: branding, rebranding, consultancy, web development, app development and maintenance. One team, one line of thought.',
  heroEyebrow: source.heroEyebrow,
  heroHeadline: source.heroHeadline,
  heroHeadlineParts: const CaseLede('Every brand is a handful of points. We draw the ', 'line', ' between them.'),
  heroDescription: source.heroDescription,
  heroHint: source.heroHint,
  sectionCopy: source.sectionCopy,
  processSteps: source.processSteps,
  engagements: source.engagements,
  studioParagraphs: source.studioParagraphs,
  studioValues: source.studioValues,
  faqs: source.faqs,
  services: source.services,
  caseStudies: source.caseStudies,
  workProjects: source.workProjects,
  serviceNames: const ['Branding', 'Rebranding', 'Consultancy', 'Web Dev', 'App Dev', 'Maintenance'],
  timingLabels: const {
    'unsure': 'Not sure yet',
    'soon': 'As soon as practical',
    'oneToThree': 'Within 1–3 months',
    'later': 'Later',
  },
  uiText: _englishUi,
);

final SiteContent _arabic = _arabicContent();
final SiteContent _french = _frenchContent();

SiteContent siteContentFor(SiteLocale locale) => switch (locale) {
  SiteLocale.en => _english,
  SiteLocale.ar => _arabic,
  SiteLocale.fr => _french,
};

class _CaseCopy {
  const _CaseCopy({
    required this.tag,
    required this.role,
    required this.timeline,
    required this.deliverables,
    required this.lede,
    this.paragraphs = const [],
    this.facts = const [],
    this.figureCaptions = const [],
    this.chapterTitles = const [],
    this.chapterBodies = const [],
    this.metricLabels = const [],
    this.metricSuffixes = const [],
    this.quote,
  });

  final String tag;
  final String role;
  final String timeline;
  final String deliverables;
  final CaseLede lede;
  final List<String> paragraphs;
  final List<CaseFact> facts;
  final List<String> figureCaptions;
  final List<String> chapterTitles;
  final List<String?> chapterBodies;
  final List<String> metricLabels;
  final List<String> metricSuffixes;
  final CaseQuote? quote;
}

List<CaseStudy> _localizedCases(List<_CaseCopy> copies) {
  assert(copies.length == source.caseStudies.length);
  return List<CaseStudy>.unmodifiable([
    for (var i = 0; i < source.caseStudies.length; i++) _localizedCase(source.caseStudies[i], copies[i]),
  ]);
}

CaseStudy _localizedCase(CaseStudy base, _CaseCopy copy) {
  assert(copy.figureCaptions.length == base.figures.length);
  assert(copy.chapterTitles.length == base.chapters.length);
  assert(copy.chapterBodies.length == base.chapters.length);
  assert(copy.metricLabels.length == base.metrics.length);
  assert(copy.metricSuffixes.length == base.metrics.length);
  return CaseStudy(
    name: base.name,
    isIllustrative: base.isIllustrative,
    transition: base.transition,
    heroImage: base.heroImage,
    tag: copy.tag,
    client: base.client,
    role: copy.role,
    timeline: copy.timeline,
    deliverables: copy.deliverables,
    layout: base.layout,
    lede: copy.lede,
    paragraphs: copy.paragraphs,
    facts: copy.facts,
    figures: [
      for (var i = 0; i < base.figures.length; i++) CaseFigure(base.figures[i].image, copy.figureCaptions[i]),
    ],
    chapters: [
      for (var i = 0; i < base.chapters.length; i++)
        CaseChapter(
          number: base.chapters[i].number,
          title: copy.chapterTitles[i],
          image: base.chapters[i].image,
          body: copy.chapterBodies[i],
        ),
    ],
    metrics: [
      for (var i = 0; i < base.metrics.length; i++)
        CaseMetric(base.metrics[i].target, copy.metricSuffixes[i], base.metrics[i].decimals, copy.metricLabels[i]),
    ],
    quote: copy.quote,
  );
}

class _WorkCopy {
  const _WorkCopy(this.disciplines, this.category, this.description);
  final String disciplines;
  final String category;
  final String description;
}

List<WorkProject> _localizedWork(List<CaseStudy> cases, List<_WorkCopy> copies) {
  assert(copies.length == source.workProjects.length);
  return List<WorkProject>.unmodifiable([
    for (var i = 0; i < source.workProjects.length; i++)
      WorkProject(
        index: source.workProjects[i].index,
        year: source.workProjects[i].year,
        disciplines: copies[i].disciplines,
        cardImage: source.workProjects[i].cardImage,
        category: copies[i].category,
        description: copies[i].description,
        caseStudy: cases[i],
      ),
  ]);
}
