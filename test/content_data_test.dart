import 'package:agency_jaspr/components/static_extras.dart';
import 'package:agency_jaspr/data/site_data.dart';
import 'package:agency_jaspr/models/site_models.dart';
import 'package:agency_jaspr/utils/mailto.dart';
import 'package:test/test.dart';

void main() {
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

    test('preserves four case layouts with a shared reference curtain entrance', () {
      expect(caseStudies, hasLength(4));
      expect(caseStudies.map((study) => study.layout).toSet(), CaseLayout.values.toSet());
      expect(caseStudies.map((study) => study.transition), everyElement(CaseTransition.accentCurtain));
      expect(caseStudies[0].figures, hasLength(2));
      expect(caseStudies[1].chapters, hasLength(4));
      expect(caseStudies[2].chapters, hasLength(3));
      expect(caseStudies[3].metrics, hasLength(3));
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
      expect(paths, everyElement(startsWith('assets/images/')));
      expect(paths, everyElement(isNot(contains('://'))));
      expect(paths.toSet(), hasLength(paths.length));
    });
  });

  group('contact mailto', () {
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
