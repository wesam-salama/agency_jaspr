import 'package:agency_jaspr/components/static_extras.dart';
import 'package:agency_jaspr/data/site_data.dart';
import 'package:agency_jaspr/l10n/site_content.dart';
import 'package:agency_jaspr/models/site_models.dart';
import 'package:agency_jaspr/utils/mailto.dart';
import 'package:test/test.dart';

void main() {
  test('Arabic and French cover the same sections, cases, and interface keys as English', () {
    final english = siteContentFor(SiteLocale.en);
    for (final locale in [SiteLocale.ar, SiteLocale.fr]) {
      final translated = siteContentFor(locale);
      expect(translated.uiText.keys.toSet(), UiTextKey.values.toSet(), reason: locale.code);
      expect(translated.uiText.values, everyElement(isNotEmpty), reason: locale.code);
      expect(translated.sectionCopy.keys.toSet(), english.sectionCopy.keys.toSet(), reason: locale.code);
      expect(translated.services, hasLength(english.services.length), reason: locale.code);
      expect(translated.caseStudies, hasLength(english.caseStudies.length), reason: locale.code);
      expect(translated.workProjects, hasLength(english.workProjects.length), reason: locale.code);
      for (var index = 0; index < english.caseStudies.length; index++) {
        final source = english.caseStudies[index];
        final localized = translated.caseStudies[index];
        expect(localized.name, source.name);
        expect(localized.heroImage, source.heroImage);
        expect(localized.metrics.map((metric) => metric.target), source.metrics.map((metric) => metric.target));
        expect(localized.figures, hasLength(source.figures.length));
        expect(localized.chapters, hasLength(source.chapters.length));
      }
    }
  });

  test('formats shared case-study results for each language', () {
    expect(siteContentFor(SiteLocale.en).formatMetric(12400, 0), '12,400');
    expect(siteContentFor(SiteLocale.ar).formatMetric(12400, 0), '12٬400');
    expect(siteContentFor(SiteLocale.fr).formatMetric(12400, 0), '12 400');
    expect(siteContentFor(SiteLocale.en).formatMetric(.4, 1), '0.4');
    expect(siteContentFor(SiteLocale.ar).formatMetric(.4, 1), '0٫4');
    expect(siteContentFor(SiteLocale.fr).formatMetric(.4, 1), '0,4');
  });

  test('reads the compact case-study seconds metric in full in each language', () {
    for (final (locale, visual, spoken) in <(SiteLocale, String, String)>[
      (SiteLocale.en, '0.4s', '0.4 seconds'),
      (SiteLocale.ar, '0٫4ث', '0٫4 ثانية'),
      (SiteLocale.fr, '0,4s', '0,4 seconde'),
    ]) {
      final content = siteContentFor(locale);
      final seconds = CaseMetric(.4, locale == SiteLocale.ar ? 'ث' : 's', 1, 'Fixture seconds');
      expect(seconds.target, .4);
      expect('${content.formatMetric(seconds.target, seconds.decimals)}${seconds.suffix}', visual);
      expect(content.spokenMetricValue(seconds), spoken);
      expect(content.spokenMetricValue(const CaseMetric(68, '%', 0, 'Fixture percentage')), '68%');
    }
  });

  group('reference content', () {
    test('contains every service and work project in reference order', () {
      expect(services, hasLength(6));
      expect(
        services.map((service) => service.name),
        orderedEquals([
          'Branding',
          'Rebranding',
          'Consultancy',
          'Web development',
          'App development',
          'Maintenance',
        ]),
      );
      expect(
        serviceNames,
        orderedEquals(['Branding', 'Rebranding', 'Consultancy', 'Web Dev', 'App Dev', 'Maintenance']),
      );
      expect(
        workProjects.map((project) => project.caseStudy.name),
        orderedEquals(caseStudies.map((study) => study.name)),
      );
    });

    test('keeps all four renderer families and the shared curtain for the authored studies', () {
      expect(caseStudies, hasLength(4));
      expect(caseStudies.map((study) => study.layout), [
        CaseLayout.stickyChapters,
        CaseLayout.split,
        CaseLayout.horizontalScroll,
        CaseLayout.statistics,
      ]);
      expect(caseStudies.map((study) => study.transition), everyElement(CaseTransition.accentCurtain));
      expect(caseStudies[0].chapters, hasLength(4));
      expect(caseStudies[1].figures, hasLength(10));
      expect(caseStudies[1].chapters, isEmpty);
      expect(caseStudies[2].chapters, hasLength(4));
      expect(caseStudies[3].metrics, isEmpty);
    });

    test('labels every sample case study as illustrative', () {
      expect(caseStudies.map((study) => study.isIllustrative), everyElement(isTrue));
      expect(workProjects.map((project) => project.caseStudy.isIllustrative), everyElement(isTrue));
    });

    test('all case-study assets are deterministic local paths', () {
      final paths = <String>[
        for (final project in workProjects) project.cardImage,
        for (final study in caseStudies) ...[
          study.heroImage,
          for (final figure in study.figures) figure.image,
          for (final chapter in study.chapters) chapter.image,
        ],
      ];

      expect(paths, isNotEmpty);
      expect(paths, everyElement(startsWith('assets/')));
      expect(paths, everyElement(isNot(contains('://'))));
      expect(paths.toSet(), hasLength(paths.length));
    });
  });

  group('contact mailto', () {
    test('localizes draft labels while preserving the visitor message and service IDs', () {
      const message = 'A bilingual launch — إطلاق ثنائي اللغة';
      for (final locale in [SiteLocale.ar, SiteLocale.fr]) {
        final content = siteContentFor(locale);
        final uri = Uri.parse(
          buildProjectMailto(
            name: 'Élodie',
            email: 'elodie@example.com',
            selectedServices: const ['0', '3'],
            message: message,
            timing: 'oneToThree',
            locale: locale,
          ),
        );
        final body = uri.queryParameters['body']!;
        expect(uri.queryParameters['subject'], content.t(UiTextKey.mailtoSubject, values: {'name': 'Élodie'}));
        expect(body, contains('${content.t(UiTextKey.mailtoName)}: Élodie'));
        expect(body, contains(content.serviceNames[0]));
        expect(body, contains(content.serviceNames[3]));
        expect(body, contains(content.timingLabels['oneToThree']));
        expect(body.endsWith(message), isTrue);
        expect(
          Uri.parse(
            buildProjectMailto(
              name: 'Élodie',
              email: 'elodie@example.com',
              selectedServices: const [],
              message: message,
              timing: 'unsure',
              locale: locale,
            ),
          ).queryParameters['body'],
          isNot(contains('${content.t(UiTextKey.mailtoTiming)}:')),
        );
      }
    });
    test('encodes selected reference labels exactly', () {
      expect(
        buildProjectMailto(
          name: 'Ada Lovelace',
          email: 'ada@example.com',
          selectedServices: const ['Branding', 'Web Dev'],
          message: 'Build it, please.',
        ),
        'mailto:hello@cr8.media?subject=New%20project%20enquiry%2C%20Ada%20Lovelace&body='
        'Name%3A%20Ada%20Lovelace%0AEmail%3A%20ada%40example.com%0APoints%3A%20Branding%20%2B%20Web%20Dev'
        '%0A%0ABuild%20it%2C%20please.',
      );
    });

    test('uses the original empty-selection fallback', () {
      final uri = Uri.parse(
        buildProjectMailto(name: 'Sam', email: 'sam@example.com', selectedServices: const [], message: ''),
      );

      expect(uri.scheme, 'mailto');
      expect(uri.path, 'hello@cr8.media');
      expect(uri.queryParameters['body'], 'Name: Sam\nEmail: sam@example.com\nPoints: Not sure yet\n\n');
    });

    test('omits timing for missing, blank, and undecided values without changing the URI', () {
      final original = buildProjectMailto(
        name: 'Ada Lovelace',
        email: 'ada@example.com',
        selectedServices: const ['Branding', 'Web Dev'],
        message: 'Build it, please.',
      );

      for (final timing in [null, '', ' \t\n ', 'Not sure yet', '  Not sure yet  ']) {
        expect(
          buildProjectMailto(
            name: 'Ada Lovelace',
            email: 'ada@example.com',
            selectedServices: const ['Branding', 'Web Dev'],
            message: 'Build it, please.',
            timing: timing,
          ),
          original,
          reason: 'Timing value: $timing',
        );
      }
    });

    test('places a trimmed timing selection after points and before the project goal', () {
      final uri = Uri.parse(
        buildProjectMailto(
          name: 'Sam',
          email: 'sam@example.com',
          selectedServices: const ['Web Dev', 'Branding'],
          message: 'Launch the new site.',
          timing: '  Within 3 months  ',
        ),
      );

      expect(
        uri.queryParameters['body'],
        'Name: Sam\nEmail: sam@example.com\nPoints: Web Dev + Branding\nTiming: Within 3 months\n\nLaunch the new site.',
      );
    });

    test('preserves Unicode, reserved characters, and caller service order', () {
      const name = 'وسام & Élodie?';
      const email = 'studio+brief@example.com';
      const message = 'موقع جديد 🌍\nUse #1 + 50% = “yes” & revisit?';
      final result = buildProjectMailto(
        name: name,
        email: email,
        selectedServices: const ['App Dev', 'Branding & identity', 'Web Dev'],
        message: message,
        timing: '  3–6 months & flexible?  ',
      );
      final uri = Uri.parse(result);

      expect(uri.path, 'hello@cr8.media');
      expect(uri.fragment, isEmpty);
      expect(uri.queryParameters.keys, unorderedEquals(['subject', 'body']));
      expect(uri.queryParameters['subject'], 'New project enquiry, $name');
      expect(
        uri.queryParameters['body'],
        'Name: $name\nEmail: $email\nPoints: App Dev + Branding & identity + Web Dev'
        '\nTiming: 3–6 months & flexible?\n\n$message',
      );
      for (final encodedCharacter in ['%26', '%2B', '%25', '%23']) {
        expect(result, contains(encodedCharacter));
      }
    });
  });
}
