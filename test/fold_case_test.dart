@TestOn('vm')
library;

import 'package:agency_jaspr/l10n/site_content.dart';
import 'package:agency_jaspr/models/site_models.dart';
import 'package:agency_jaspr/site_document.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  test('Fold completes the four authorised studies with a narrative statistics case', () {
    final content = siteContentFor(SiteLocale.en);
    final fold = content.caseStudies[3];
    final card = content.workProjects[3];
    expect(content.caseStudies.map((study) => study.name), [
      'Sift Coffee',
      'Form Architecture',
      'Frame Academy',
      'Fold Clothing',
    ]);
    expect(fold.layout, CaseLayout.statistics);
    expect(fold.transition, CaseTransition.accentCurtain);
    expect(fold.isSelfInitiated, isTrue);
    expect(fold.isIllustrative, isTrue);
    expect(fold.client, 'Self-initiated studio project');
    expect(fold.timeline, 'Design & implementation study');
    expect(fold.metrics, isEmpty);
    expect(fold.quote, isNull);
    expect(fold.figures, hasLength(5));
    expect(fold.figures.map((figure) => figure.image.split('/').last), [
      'identity.webp',
      'continuity.webp',
      'measurements.webp',
      'shopping.webp',
      'maintenance.webp',
    ]);
    expect(card.index, '04');
    expect(card.year, '2026');
    expect(card.status, 'Studio concept');
    expect(card.category, 'Ecommerce Brand & Store');
    expect(card.description, 'A considered clothing identity and a store concept built around clear product choices.');
    expect(fold.paragraphs.join(' '), contains('Demo checkout — no payment or order will be placed.'));
    expect(fold.paragraphs.join(' '), contains('half-widths, not body circumferences'));
    expect(fold.paragraphs.join(' '), contains('registered separately from actual store captures'));
  });

  test('all Fold editions retain the catalogue, basket, evidence scope and usable destinations', () {
    final source = siteContentFor(SiteLocale.en).caseStudies[3];
    for (final locale in SiteLocale.values) {
      final content = siteContentFor(locale);
      final fold = content.caseStudies[3];
      final copy = fold.paragraphs.join(' ');
      for (final fixture in [
        'Collection 01: Everyday Structure',
        'Box Shirt',
        'Pleat Trouser',
        'Layer Vest',
        'Field Overshirt',
        'Stone/XS',
        'Chalk/M',
        'Ink/M',
        '1.1',
        r'$95',
        r'$145',
        r'$240',
        r'$12',
        r'$0',
        r'$252',
      ]) {
        expect(copy, contains(fixture), reason: locale.code);
      }
      expect(fold.heroAlt, isNotEmpty);
      expect(content.workProjects[3].cardAlt, isNotEmpty);
      expect(content.workProjects[3].status, isNotEmpty);
      expect(fold.figures.map((figure) => figure.image), source.figures.map((figure) => figure.image));
      expect(fold.figures.map((figure) => figure.caption), everyElement(isNotEmpty));
      expect(fold.metrics, isEmpty);
      expect(fold.quote, isNull);
      expect(fold.downloads.map((download) => download.isDownload), [false, false, true]);
      expect(fold.downloads.map((download) => download.format), ['HTML', 'HTML', 'ZIP']);
      expect(fold.downloads.map((download) => download.href), [
        'assets/selected-work/fold/site/index.html${locale == SiteLocale.ar ? '?lang=ar' : ''}',
        'assets/selected-work/fold/shopping-flow.html${locale == SiteLocale.ar ? '?lang=ar' : ''}',
        'assets/selected-work/fold/fold-source.zip',
      ]);
      if (locale != SiteLocale.en) {
        expect(fold.client, isNot(source.client));
        expect(fold.paragraphs.first, isNot(source.paragraphs.first));
        expect(fold.figures.first.caption, isNot(source.figures.first.caption));
        expect(fold.downloads.first.label, isNot(source.downloads.first.label));
      }
      expect(copy, isNot(contains('Northline')));
    }
  });

  testServer('Fold card has localized honest status while the complete agency shell remains', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    for (final locale in SiteLocale.values) {
      final content = siteContentFor(locale);
      final path = locale == SiteLocale.en ? '/' : '/${locale.pathSegment}/';
      final document = (await tester.request(path)).document!;
      final cards = document.querySelectorAll('#work .work-item');
      final fold = cards.last;
      expect(cards, hasLength(4));
      expect(document.querySelectorAll('.work-status'), hasLength(4));
      expect(fold.attributes['data-case'], 'Fold Clothing');
      expect(fold.querySelector('.work-status')!.text, content.workProjects[3].status);
      expect(fold.querySelector('img')!.attributes['alt'], content.workProjects[3].cardAlt);
      expect(fold.querySelector('img')!.attributes['src'], 'assets/selected-work/fold/card.webp');
      expect(document.querySelectorAll('[data-case="Northline"]'), isEmpty);
      for (final selector in ['#siteHeader', '#caseModal', '#cmNext', '#contactForm', '#message', '#siteFooter']) {
        expect(document.querySelector(selector), isNotNull, reason: '${locale.code} $selector');
      }
    }
  });
}
