@TestOn('vm')
library;

import 'package:agency_jaspr/l10n/site_content.dart';
import 'package:agency_jaspr/models/site_models.dart';
import 'package:agency_jaspr/site_document.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  test('Sift keeps its first-slot authored study distinct from client work', () {
    final content = siteContentFor(SiteLocale.en);
    final sift = content.caseStudies.first;

    expect(content.caseStudies.map((study) => study.name), [
      'Sift Coffee',
      'Form Architecture',
      'Frame Academy',
      'Fold Clothing',
    ]);
    expect(sift.isSelfInitiated, isTrue);
    expect(sift.isIllustrative, isTrue);
    expect(sift.client, 'Self-initiated studio project');
    expect(sift.timeline, 'Design study');
    expect(sift.layout, CaseLayout.stickyChapters);
    expect(sift.chapters, hasLength(4));
    expect(sift.chapters.map((chapter) => chapter.number), ['01', '02', '03', '04']);
    expect(sift.chapters.map((chapter) => chapter.body), everyElement(isNotEmpty));
    expect(sift.quote, isNull);
    expect(sift.metrics, isEmpty);
    expect(sift.transition, CaseTransition.accentCurtain);
    expect(content.caseStudies.map((study) => study.isSelfInitiated), everyElement(isTrue));
    expect(content.workProjects.map((project) => project.status), everyElement(isNotNull));
  });

  test('all languages preserve the Sift collection, asset paths and localized download meaning', () {
    final english = siteContentFor(SiteLocale.en).caseStudies.first;
    for (final locale in SiteLocale.values) {
      final content = siteContentFor(locale);
      final sift = content.caseStudies.first;
      final copy = [
        sift.client,
        sift.tag,
        sift.timeline,
        sift.deliverables,
        ...sift.paragraphs,
        for (final chapter in sift.chapters) '${chapter.title} ${chapter.body}',
      ].join(' ');
      for (final name in ['Everyday', 'Daybreak', 'After Hours']) {
        expect(copy, contains(name), reason: locale.code);
      }
      expect(copy, isNot(contains('Fenwick')), reason: locale.code);
      expect(sift.heroImage, english.heroImage);
      expect(sift.chapters.map((chapter) => chapter.image), english.chapters.map((chapter) => chapter.image));
      expect(sift.downloads.map((download) => download.href), [
        'assets/selected-work/sift/sift-brand-guide.pdf',
        'assets/selected-work/sift/sift-artwork.zip',
      ]);
      expect(sift.downloads.map((download) => download.format), ['PDF', 'ZIP']);
      for (final download in sift.downloads) {
        final aria = content.t(
          UiTextKey.caseDownloadAria,
          values: {'label': download.label, 'format': download.format},
        );
        expect(aria, contains(download.label));
        expect(aria, contains(download.format));
        expect(aria, isNot(contains('{')));
      }
      if (locale != SiteLocale.en) {
        expect(sift.client, isNot(english.client));
        expect(sift.timeline, isNot(english.timeline));
        expect(sift.downloads.first.label, isNot(english.downloads.first.label));
      }
      expect(sift.quote, isNull);
      expect(sift.metrics, isEmpty);
    }
  });

  testServer('preserves the Sift card and its concept label beside the new Form study', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    for (final locale in SiteLocale.values) {
      final path = locale == SiteLocale.en ? '/' : '/${locale.pathSegment}/';
      final document = (await tester.request(path)).document!;
      final content = siteContentFor(locale);
      final cards = document.querySelectorAll('#work .work-item');

      expect(cards, hasLength(4));
      expect(cards.first.attributes['data-case'], 'Sift Coffee');
      expect(cards.first.querySelector('h3')?.text, 'Sift Coffee');
      expect(cards.first.querySelector('.work-status')?.text, content.workProjects.first.status);
      expect(cards.first.querySelector('.work-year')?.text, '2026');
      expect(cards.first.querySelector('img')?.attributes['src'], 'assets/selected-work/sift/card.webp');
      expect(document.querySelectorAll('.work-status'), hasLength(4));
      expect(cards.skip(1).map((card) => card.attributes['data-case']), [
        'Form Architecture',
        'Frame Academy',
        'Fold Clothing',
      ]);
      expect(document.querySelectorAll('[data-case="Fenwick & Ash"]'), isEmpty);
    }
  });
}
