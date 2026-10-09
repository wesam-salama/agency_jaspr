@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:agency_jaspr/data/site_data.dart';
import 'package:agency_jaspr/site_document.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:jaspr_test/server_test.dart';

final reference = jsonDecode(File('test/fixtures/reference_copy.json').readAsStringSync()) as Map<String, dynamic>;
String text(Element? element) => element!.text.replaceAll(RegExp(r'\s+'), ' ').trim();
List<String> texts(Element element, String selector) => element.querySelectorAll(selector).map(text).toList();

void main() {
  test('copy fixture agrees with the original HTML when present beside the checkout', () {
    final original = File('../agency_website.html');
    if (!original.existsSync()) return;
    final document = parse(original.readAsStringSync());
    for (final entry in (reference['sections'] as Map).entries) {
      final section = document.querySelector('#${entry.key}')!;
      expect(text(section.querySelector('.eyebrow')), entry.value['label']);
      expect(text(section.querySelector('h2')), entry.value['title']);
      expect(text(section.querySelector('.side')), entry.value['introduction']);
    }
    expect(text(document.querySelector('.hero h1')), reference['hero']['title']);
    expect(text(document.querySelector('.hero .lede')), reference['hero']['description']);
    final rows = document.querySelectorAll('.t-row');
    for (var i = 0; i < rows.length; i++) {
      expect(text(rows[i].querySelector('p')), reference['process'][i]['description']);
      expect(texts(rows[i], 'li'), reference['process'][i]['deliverables']);
    }
  });

  testServer('renders the reference wording throughout all eight sections and footer', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final document = (await tester.request('/')).document!;
    expect(text(document.querySelector('#top h1')), reference['hero']['title']);
    expect(text(document.querySelector('#top .section-label')), reference['hero']['label']);
    expect(text(document.querySelector('.hero-copy')), reference['hero']['description']);
    expect(text(document.querySelector('.hero-note')), reference['hero']['hint']);
    expect(texts(document.querySelector('.hero-ctas')!, 'a'), ['Start a project →', 'See our work']);
    for (final entry in (reference['sections'] as Map).entries) {
      final section = document.querySelector('#${entry.key}')!;
      expect(text(section.querySelector('.section-label')), entry.value['label']);
      expect(text(section.querySelector('h2')), entry.value['title']);
      expect(text(section.querySelector('.section-intro')), entry.value['introduction']);
    }
    final services = document.querySelectorAll('#services .service');
    for (var i = 0; i < services.length; i++) {
      final expected = reference['services'][i];
      expect(text(services[i].querySelector('h3')), expected['name']);
      expect(text(services[i].querySelector('.service-duration')), expected['duration']);
      expect(text(services[i].querySelector('p')), expected['description']);
      expect(texts(services[i], 'li'), expected['deliverables']);
    }
    final work = document.querySelectorAll('#work .work-item');
    for (var i = 0; i < work.length; i++) {
      final expected = reference['work'][i];
      expect(text(work[i].querySelector('h3')), expected['name']);
      expect(text(work[i].querySelector('.work-category')), expected['category']);
      expect(text(work[i].querySelector('.work-description')), expected['description']);
      expect(text(work[i].querySelector('.work-disciplines')), contains(expected['disciplines']));
    }
    final rows = document.querySelectorAll('.process-step');
    expect(rows, hasLength(6));
    for (var i = 0; i < rows.length; i++) {
      final expected = reference['process'][i];
      expect(text(rows[i].querySelector('.step-number')), expected['number']);
      expect(text(rows[i].querySelector('h3')), expected['name']);
      expect(text(rows[i].querySelector('.step-duration')), expected['duration']);
      expect(text(rows[i].querySelector('p')), expected['description']);
      expect(texts(rows[i], 'li'), expected['deliverables']);
    }
    expect(document.querySelector('#timelineEl #timelineFill'), isNotNull);
    expect(document.querySelector('#timelineFill')!.attributes['aria-hidden'], 'true');
    final engagements = document.querySelectorAll('.engagement-option');
    for (var i = 0; i < engagements.length; i++) {
      final expected = reference['engagement'][i];
      expect(text(engagements[i].querySelector('h3')), expected['name']);
      expect(text(engagements[i].querySelector('.engagement-tag')), expected['tag']);
      expect(text(engagements[i].querySelector('p')), expected['description']);
      expect(texts(engagements[i], 'li'), expected['features']);
      expect(text(engagements[i].querySelector('.engagement-terms')), expected['terms']);
    }
    final studio = document.querySelector('#studio')!;
    expect(text(studio.querySelector('h2')), reference['studio']['title']);
    expect(texts(studio, '.studio-lead'), reference['studio']['paragraphs']);
    expect(texts(studio, 'li'), reference['studio']['values']);
    final faqs = document.querySelectorAll('.faq-item');
    for (var i = 0; i < faqs.length; i++) {
      expect(text(faqs[i].querySelector('summary')), reference['faq'][i]['question']);
      expect(text(faqs[i].querySelector('p')), reference['faq'][i]['answer']);
    }
    final contact = document.querySelector('#contact')!;
    expect(text(contact.querySelector('h2')), reference['contact']['title']);
    expect(text(contact.querySelector('.contact-intro')), reference['contact']['introduction']);
    expect(text(contact.querySelector('#constelReset')), reference['contact']['reset']);
    expect(text(contact.querySelector('#constelNote')), reference['contact']['empty']);
    expect(text(contact.querySelector('#draftButton')), reference['contact']['submit']);
    expect(text(document.querySelector('.footer-bottom small')), reference['footer']);
    expect(document.querySelectorAll('.example-label, #cmExample, #cmDescription'), isEmpty);
    expect(text(document.querySelector('#cmClose')), 'Close ✕');
    expect(text(document.querySelector('#cmNext')), 'Next project →');
  });

  test('all four case studies retain reference text, figures, quotes, chapters and metrics', () {
    for (final study in caseStudies) {
      final expected = reference['cases'][study.name];
      expect(study.tag, expected['tag']);
      expect(study.client, expected['client']);
      expect(study.role, expected['role']);
      expect(study.timeline, expected['timeline']);
      expect(study.deliverables, expected['deliver']);
      expect('${study.lede.before}${study.lede.emphasis}${study.lede.after}', parseFragment(expected['lede']).text);
      expect(study.paragraphs, expected['paras'] ?? []);
      expect(study.facts.map((fact) => [fact.label, fact.value]).toList(), expected['side'] ?? []);
      expect(study.figures.map((figure) => figure.caption).toList(), [
        for (final figure in expected['figs'] ?? []) figure[1],
      ]);
      if (study.quote case final quote?) {
        expect([quote.text, quote.attribution], expected['quote']);
      }
      final chapters = expected['chapters'] ?? [];
      for (var i = 0; i < study.chapters.length; i++) {
        final chapter = study.chapters[i];
        if (chapter.body == null) {
          expect('${chapter.number} ${chapter.title}', chapters[i][0]);
        } else {
          expect([chapter.number, chapter.title, chapter.body], chapters[i].take(3).toList());
        }
      }
      expect(
        study.metrics.map((metric) => [metric.target, metric.suffix, metric.decimals, metric.label]).toList(),
        expected['stats'] ?? [],
      );
      // Copy restoration does not turn example claims into verified evidence.
      expect(study.isIllustrative, isTrue);
    }
  });
}
