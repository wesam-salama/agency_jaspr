@TestOn('vm')
library;

import 'dart:io';

import 'package:agency_jaspr/l10n/site_content.dart';
import 'package:agency_jaspr/models/site_models.dart';
import 'package:agency_jaspr/site_document.dart';
import 'package:agency_jaspr/utils/image_assets.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  test('Form replaces slot 02 with an honest split case and preserves its neighbours', () {
    final content = siteContentFor(SiteLocale.en);
    final form = content.caseStudies[1];
    final card = content.workProjects[1];

    expect(content.caseStudies.map((study) => study.name), [
      'Sift Coffee',
      'Form Architecture',
      'Frame Academy',
      'Fold Clothing',
    ]);
    expect(form.layout, CaseLayout.split);
    expect(form.transition, CaseTransition.accentCurtain);
    expect(form.isSelfInitiated, isTrue);
    expect(form.isIllustrative, isTrue);
    expect(form.client, 'Self-initiated studio project');
    expect(form.timeline, 'Design & implementation study');
    expect(form.quote, isNull);
    expect(form.metrics, isEmpty);
    expect(form.chapters, isEmpty);
    expect(card.index, '02');
    expect(card.year, '2026');
    expect(card.category, 'Rebrand & website relaunch');
    expect(card.status, 'Studio concept');
    expect(
      card.description,
      'A material-led identity and project website that make architectural decisions easier to explore.',
    );
    expect(content.caseStudies.first.layout, CaseLayout.stickyChapters);
    expect(content.caseStudies[2].layout, CaseLayout.horizontalScroll);
    expect(content.caseStudies.last.layout, CaseLayout.statistics);
  });

  test('each language preserves study names, fictional facts, implementation boundaries and ordered evidence', () {
    final source = siteContentFor(SiteLocale.en).caseStudies[1];
    const figureNames = [
      'baseline',
      'redesign',
      'identity-system',
      'project-desktop',
      'project-mobile',
      'enquiry-states',
      'cms-edit',
      'details/wordmark',
      'details/image-crop',
      'details/project-facts',
    ];
    for (final locale in SiteLocale.values) {
      final content = siteContentFor(locale);
      final form = content.caseStudies[1];
      final copy = [
        form.client,
        form.tag,
        form.timeline,
        form.deliverables,
        ...form.paragraphs,
        for (final fact in form.facts) '${fact.label} ${fact.value}',
        for (final figure in form.figures) figure.caption,
      ].join(' ');
      for (final name in ['Courtyard House', 'Line Studio', 'Shore Library']) {
        expect(copy, contains(name), reason: locale.code);
      }
      for (final fact in ['2025', '2026', '240 m²', '180 m²', '620 m²', '3:4']) {
        expect(copy, contains(fact), reason: locale.code);
      }
      expect(form.heroAlt, isNotEmpty);
      expect(content.workProjects[1].cardAlt, isNotEmpty);
      expect(form.facts, hasLength(8));
      expect(form.paragraphs, hasLength(6));
      expect(form.figures.map((figure) => figure.image), [
        for (final name in figureNames) 'assets/selected-work/form/$name.webp',
      ]);
      expect(form.figures.map((figure) => figure.caption), everyElement(isNotEmpty));
      expect(form.quote, isNull);
      expect(form.metrics, isEmpty);
      expect(copy, isNot(contains('Loop')));
      expect(form.downloads.map((link) => link.href), source.downloads.map((link) => link.href));
      expect(form.downloads.map((link) => link.isDownload), [false, false, true]);
      for (final link in form.downloads) {
        final aria = content.t(
          link.isDownload ? UiTextKey.caseDownloadAria : UiTextKey.caseOpenAria,
          values: {'label': link.label, 'format': link.format},
        );
        expect(aria, contains(link.label));
        expect(aria, isNot(contains('{')));
      }
      if (locale != SiteLocale.en) {
        expect(form.client, isNot(source.client));
        expect(form.paragraphs.first, isNot(source.paragraphs.first));
        expect(form.figures.first.caption, isNot(source.figures.first.caption));
        expect(form.downloads.first.label, isNot(source.downloads.first.label));
      }
    }
  });

  test('Form presentation assets and local demonstration destinations exist', () {
    final content = siteContentFor(SiteLocale.en);
    final form = content.caseStudies[1];
    for (final source in [
      content.workProjects[1].cardImage,
      form.heroImage,
      ...form.figures.map((figure) => figure.image),
    ]) {
      expect(imageAssetFor(source), isNotNull, reason: source);
      expect(File('web/$source').existsSync(), isTrue, reason: source);
    }
    for (final link in form.downloads) {
      expect(File('web/${link.href}').existsSync(), isTrue, reason: link.href);
    }
    expect(File('web/assets/selected-work/form/site/baseline.html').existsSync(), isTrue);
  });

  testServer('prerenders the Form card with localized labels while agency enquiry stays intact', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    for (final locale in SiteLocale.values) {
      final path = locale == SiteLocale.en ? '/' : '/${locale.pathSegment}/';
      final document = (await tester.request(path)).document!;
      final content = siteContentFor(locale);
      final cards = document.querySelectorAll('#work .work-item');
      final card = cards[1];
      expect(cards, hasLength(4));
      expect(card.attributes['data-case'], 'Form Architecture');
      expect(card.querySelector('h3')?.text, 'Form Architecture');
      expect(card.querySelector('.work-status')?.text, content.workProjects[1].status);
      expect(card.querySelector('.work-description')?.text.trim(), content.workProjects[1].description);
      expect(card.querySelector('img')?.attributes['src'], 'assets/selected-work/form/card.webp');
      expect(card.querySelector('img')?.attributes['alt'], content.workProjects[1].cardAlt);
      expect(card.querySelector('img')?.attributes['width'], '1600');
      expect(card.querySelector('img')?.attributes['height'], '1000');
      expect(card.attributes['aria-haspopup'], 'dialog');
      expect(card.attributes['aria-controls'], 'caseModal');
      expect(document.querySelectorAll('[data-case="Loop"]'), isEmpty);
      expect(document.querySelector('#contactForm input[name="name"]')?.attributes.containsKey('required'), isTrue);
      expect(document.querySelector('#contactForm input[name="email"]')?.attributes.containsKey('required'), isTrue);
      expect(document.querySelector('#contactForm textarea')?.attributes.containsKey('required'), isTrue);
      expect(document.querySelector('#draftButton')?.text, content.t(UiTextKey.formSend));
    }
  });
}
