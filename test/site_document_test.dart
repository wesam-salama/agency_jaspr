@TestOn('vm')
library;

import 'dart:io';

import 'package:agency_jaspr/components/static_extras.dart' show serviceNames;
import 'package:agency_jaspr/data/site_data.dart';
import 'package:agency_jaspr/site_document.dart';
import 'package:agency_jaspr/utils/image_assets.dart';
import 'package:html/dom.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  test('App owns the native page instead of importing generated HTML', () {
    final source = File('lib/app.dart').readAsStringSync();

    expect(source, isNot(contains('generated/agency_markup.dart')));
    expect(source, isNot(contains('buildAgencyMarkup')));
  });

  testServer('prerenders document metadata and the complete native page', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final response = await tester.request('/');
    final document = response.document!;

    expect(response.statusCode, 200);
    expect(document.documentElement?.attributes['lang'], 'en');
    expect(document.querySelector('title')?.text, siteTitle);
    expect(document.querySelector('meta[name="description"]')?.attributes['content'], siteDescription);
    expect(document.querySelector('link[rel="stylesheet"]')?.attributes['href'], 'assets/styles.css');
    expect(document.querySelector('base'), isNull);
    expect(document.querySelectorAll('main'), hasLength(1));
    expect(document.querySelectorAll('main > section'), hasLength(8));
    expect(
      document.querySelectorAll('main > section').map((section) => section.id),
      orderedEquals(['top', 'services', 'work', 'process', 'engagement', 'studio', 'faq', 'contact']),
    );
    expect(document.querySelectorAll('.service'), hasLength(6));
    expect(document.querySelectorAll('.work-item'), hasLength(4));
    expect(document.querySelectorAll('.faq-item'), hasLength(5));
    expect(document.querySelectorAll('h1'), hasLength(1));
    expect(_normaliseWhitespace(document.querySelector('h1')!.text), heroHeadline);

    for (final item in document.querySelectorAll('.faq-item')) {
      expect(item.localName, 'details');
      expect(_normaliseWhitespace(item.querySelector('summary')!.text), isNotEmpty);
      expect(item.querySelector('p'), isNotNull);
    }
  });

  testServer('provides skip navigation and native links to every section', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final document = (await tester.request('/')).document!;
    final main = document.querySelector('#mainContent')!;
    final skipLink = document.querySelector('.skip-link')!;
    final burger = document.querySelector('#burgerBtn')!;
    final navigation = document.querySelector('#primaryNavigation')!;

    expect(main.localName, 'main');
    expect(main.attributes['tabindex'], '-1');
    expect(skipLink.localName, 'a');
    expect(skipLink.attributes['href'], '#mainContent');
    expect(_normaliseWhitespace(skipLink.text), isNotEmpty);
    expect(navigation.querySelectorAll('a'), hasLength(6));
    expect(
      navigation.querySelectorAll('a').map((link) => link.attributes['href']),
      orderedEquals(['#services', '#work', '#process', '#engagement', '#studio', '#faq']),
    );
    expect(document.querySelector('#siteHeader .nav-cta')?.attributes['href'], '#contact');
    expect(burger.localName, 'button');
    expect(burger.attributes['type'], 'button');
    expect(burger.attributes['aria-expanded'], 'false');
    expect(burger.attributes['aria-label'], isNotEmpty);
    expect(burger.attributes['aria-controls'], navigation.id);
    expect(burger.attributes.containsKey('disabled'), isTrue);
    final indicators = navigation.querySelectorAll('.nav-indicator');
    expect(indicators, hasLength(1));
    expect(indicators.single.attributes['aria-hidden'], 'true');
    expect(indicators.single.querySelector('a'), isNull);
    expect(indicators.single.attributes.containsKey('tabindex'), isFalse);
    expect(document.querySelector('#rail'), isNull);
    expect(
      document.querySelectorAll('[tabindex]').where((element) => int.parse(element.attributes['tabindex']!) > 0),
      isEmpty,
    );

    for (final link in document.querySelectorAll('a[href^="#"]')) {
      final target = link.attributes['href']!.substring(1);
      expect(target, isNotEmpty);
      expect(document.getElementById(target), isNotNull, reason: link.outerHtml);
    }
  });

  testServer('exposes service deliverables, the ordered process and independent FAQ disclosures', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final document = (await tester.request('/')).document!;
    final serviceElements = document.querySelectorAll('#services .service');

    for (var index = 0; index < services.length; index++) {
      final service = serviceElements[index];
      expect(service.querySelector('details'), isNull);
      expect(service.querySelector('.deliverables-label'), isNull);
      expect(
        service.querySelectorAll('.service-deliverables li').map((item) => _normaliseWhitespace(item.text)),
        orderedEquals(services[index].deliverables),
      );
      expect(service.querySelectorAll('[hidden]'), isEmpty);
    }

    final process = document.querySelector('#process .process-list')!;
    expect(process.localName, 'ol');
    expect(process.children.map((step) => step.localName), everyElement('li'));
    expect(
      process.querySelectorAll('h3').map((heading) => heading.text),
      orderedEquals(['Connect', 'Define', 'Design', 'Build', 'Launch', 'Maintain']),
    );

    for (final faq in document.querySelectorAll('#faq .faq-item')) {
      expect(faq.localName, 'details');
      expect(faq.attributes.containsKey('name'), isFalse, reason: 'Visitors can keep several answers open.');
      expect(faq.children.first.localName, 'summary');
      expect(faq.querySelector('summary svg')?.attributes['aria-hidden'], 'true');
      expect(faq.querySelector('summary svg')?.attributes['focusable'], 'false');
      expect(_normaliseWhitespace(faq.querySelector('.faq-question')!.text), isNotEmpty);
    }
  });

  testServer('keeps six native service links available alongside decorative hero animation', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final document = (await tester.request('/')).document!;
    final network = document.querySelector('#top .hero-network')!;
    final canvases = network.querySelectorAll('canvas');
    final links = network.querySelectorAll('a.hero-node');

    expect(canvases, hasLength(1));
    expect(canvases.single.attributes['aria-hidden'], 'true');
    expect(canvases.single.attributes['focusable'], 'false');
    expect(canvases.single.attributes.containsKey('tabindex'), isFalse);
    expect(network.attributes['aria-hidden'], isNull);
    expect(links, hasLength(6));
    expect(links.map((link) => _normaliseWhitespace(link.text)), orderedEquals(serviceNames));
    for (var index = 0; index < links.length; index++) {
      expect(links[index].attributes['href'], '#service-$index');
      expect(links[index].attributes['aria-hidden'], isNull);
      expect(document.querySelector('#service-$index h3')?.text, services[index].name);
    }
  });

  testServer('uses distinct decorative service motifs and portfolio canvas layers', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final document = (await tester.request('/')).document!;
    final icons = document.querySelectorAll('#services .service-icon');
    final motifs = <String>{};

    expect(icons, hasLength(6));
    for (final icon in icons) {
      final svgs = icon.querySelectorAll('svg');
      expect(icon.attributes['aria-hidden'], 'true');
      expect(svgs, hasLength(1));
      expect(svgs.single.attributes['focusable'], 'false');
      expect(svgs.single.querySelectorAll('circle, path, line, rect'), isNotEmpty);
      motifs.add(svgs.single.innerHtml);
    }
    expect(motifs, hasLength(6), reason: 'Each service needs its own visual motif.');

    final projects = document.querySelectorAll('.work-item');
    expect(projects, hasLength(4));
    expect(document.querySelectorAll('#work canvas'), hasLength(4));
    for (final project in projects) {
      final canvases = project.querySelectorAll('canvas');
      expect(canvases, hasLength(1));
      expect(canvases.single.attributes['aria-hidden'], 'true');
      expect(canvases.single.attributes['focusable'], 'false');
      expect(canvases.single.attributes.containsKey('tabindex'), isFalse);
      expect(project.querySelector('img[alt]')?.attributes['alt'], isNotEmpty);
      expect(project.attributes['aria-label'], isNotEmpty);
    }
  });

  testServer('prerenders pause controls and keeps repeated marquee content decorative', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final document = (await tester.request('/')).document!;
    final controls = document.querySelectorAll('.motion-toggle');
    final marquees = document.querySelectorAll('.motion-marquee-band');

    expect(controls, hasLength(2));
    for (final control in controls) {
      expect(control.localName, 'button');
      expect(control.attributes['type'], 'button');
      expect(control.attributes['aria-pressed'], 'false');
      expect(control.attributes, containsPair('disabled', ''));
      expect(_normaliseWhitespace(control.text), 'Pause animations');
      expect(control.attributes['aria-hidden'], isNull);
    }
    expect(document.querySelector('#top .motion-toggle'), isNotNull);
    expect(document.querySelector('footer .motion-toggle'), isNotNull);
    expect(document.querySelectorAll('.motion-preference .motion-status'), hasLength(2));
    expect(marquees, hasLength(2));
    for (final marquee in marquees) {
      expect(marquee.attributes['aria-hidden'], 'true');
      expect(marquee.querySelectorAll('a, button, input, select, textarea, [tabindex]'), isEmpty);
      for (final service in serviceNames) {
        expect(_normaliseWhitespace(marquee.text), contains(service));
      }
    }
  });

  testServer('shows reference work with accessible dialog triggers and a dormant dialog', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final document = (await tester.request('/')).document!;
    final modal = document.querySelector('#caseModal')!;
    final image = document.querySelector('#cmImg')!;
    final projects = document.querySelectorAll('.work-item');

    expect(
      projects.map((project) => project.attributes['data-case']),
      orderedEquals(caseStudies.map((study) => study.name)),
    );
    for (final project in projects) {
      expect(project.localName, 'button');
      expect(project.attributes['type'], 'button');
      expect(project.attributes['aria-haspopup'], 'dialog');
      expect(project.attributes['aria-controls'], modal.id);
      expect(project.attributes['aria-label'], isNotEmpty);
      expect(project.querySelector('.example-label'), isNull);
    }
    for (final duration in document.querySelectorAll('.service-duration')) {
      expect(duration.attributes['aria-label'], startsWith('Timing:'));
    }

    expect(modal.attributes, containsPair('hidden', ''));
    expect(modal.attributes['role'], 'dialog');
    expect(modal.attributes['aria-modal'], 'true');
    expect(modal.attributes['tabindex'], '-1');
    _assertIdReferences(document, modal.attributes['aria-labelledby']);
    _assertIdReferences(document, modal.attributes['aria-describedby']);
    expect(document.querySelector('#cmTitle')?.localName, 'h2');
    expect(document.querySelector('#cmDescription'), isNull);
    expect(document.querySelector('#cmExample'), isNull);
    expect(image.attributes, containsPair('hidden', ''));
    expect(image.attributes.containsKey('src'), isFalse);
    expect(image.attributes.containsKey('srcset'), isFalse);
    expect(document.querySelector('#cmClose')?.attributes['type'], 'button');
    expect(document.querySelector('#cmNext')?.attributes['type'], 'button');
    final presentation = modal.querySelector('#cmPresentation')!;
    expect(presentation.querySelector('#cmImg'), same(image));
    expect(presentation.querySelector('h1, h2, h3, button, .cm-toolbar, .cm-heading'), isNull);
    expect(modal.querySelector('#cmTitle'), isNotNull);
    expect(modal.querySelector('.cm-toolbar #cmClose'), isNotNull);
  });

  testServer('prerenders a labelled form with native optional service and timing controls', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final document = (await tester.request('/')).document!;
    final form = document.querySelector('#contactForm')!;
    final choices = form.querySelectorAll('input[type="checkbox"][name="services"]');
    final timing = form.querySelector('#timing')!;
    final draft = form.querySelector('#draftButton')!;

    expect(form.localName, 'form');
    expect(form.attributes['action'], 'mailto:hello@cr8.media');
    expect(form.attributes['method'], 'post');
    expect(form.attributes['enctype'], 'text/plain');
    expect(choices, hasLength(6));
    expect(choices.map((choice) => choice.attributes['value']), orderedEquals(serviceNames));
    expect(document.querySelectorAll('#constel .hit'), isEmpty);
    expect(document.querySelector('#constel')?.attributes['aria-hidden'], 'true');
    expect(document.querySelector('#constel svg')?.attributes['focusable'], 'false');
    for (final choice in choices) {
      expect(_hasWrappingLabel(choice), isTrue, reason: choice.outerHtml);
      expect(choice.attributes.containsKey('required'), isFalse);
      expect(choice.attributes.containsKey('checked'), isFalse);
    }
    expect(_normaliseWhitespace(form.querySelector('fieldset legend')!.text).toLowerCase(), contains('optional'));

    for (final id in ['name', 'email', 'message', 'timing']) {
      final control = form.querySelector('#$id')!;
      expect(_normaliseWhitespace(form.querySelector('label[for="$id"]')!.text), isNotEmpty);
      expect(control.attributes['name'], id);
      if (id != 'timing') {
        expect(control.attributes, containsPair('required', ''));
        _assertIdReferences(document, control.attributes['aria-describedby']);
        expect(form.querySelector('#$id-error')?.attributes, containsPair('hidden', ''));
      }
    }
    expect(form.querySelector('#name')?.attributes['autocomplete'], 'name');
    expect(form.querySelector('#email')?.attributes['type'], 'email');
    expect(form.querySelector('#email')?.attributes['autocomplete'], 'email');
    expect(form.querySelector('#message')?.localName, 'textarea');
    expect(timing.localName, 'select');
    expect(timing.attributes.containsKey('required'), isFalse);
    expect(
      timing.querySelectorAll('option').map((option) => option.attributes['value']),
      orderedEquals(['Not sure yet', 'As soon as practical', 'Within 1–3 months', 'Later']),
    );
    expect(draft.localName, 'button');
    expect(draft.attributes['type'], 'submit');
    expect(draft.attributes, containsPair('disabled', ''));
    expect(form.querySelector('#formStatus')?.attributes['role'], 'status');
    expect(form.querySelector('#formStatus')?.attributes['aria-live'], 'polite');
    expect(document.querySelector('#constelNote')?.attributes['aria-live'], 'polite');
    expect(form.querySelector('fieldset #constelNote'), isNotNull);
    expect(document.querySelector('#constelReset')?.attributes.containsKey('disabled'), isTrue);
    expect(
      document.querySelectorAll('#contact > .contact-grid > div').map((item) => item.className),
      orderedEquals(['contact-aside', 'contact-form-wrap', 'contact-connection']),
    );
    expect(document.querySelector('#contact .contact-email')?.attributes['href'], 'mailto:hello@cr8.media');
    expect(document.querySelector('#contact noscript'), isNotNull);
    expect(document.querySelector('#agencyRuntime'), isNotNull);
    expect(document.querySelectorAll('[onclick], [onkeydown], [onchange], [onsubmit]'), isEmpty);
  });

  testServer('uses valid local logos, fonts and dimensioned responsive WebP images', (tester) async {
    tester.pumpComponent(buildAgencyDocument());
    final document = (await tester.request('/')).document!;
    final images = document.querySelectorAll('.work-item img');
    final logos = document.querySelectorAll('.logo img');

    expect(images, hasLength(workProjects.length));
    for (var index = 0; index < images.length; index++) {
      final image = images[index];
      final asset = imageAssetFor(workProjects[index].cardImage)!;
      expect(image.attributes['src'], asset.src);
      expect(image.attributes['srcset'], asset.srcSet);
      expect(image.attributes['sizes'], isNotEmpty);
      expect(image.attributes['width'], '${asset.width}');
      expect(image.attributes['height'], '${asset.height}');
      expect(image.attributes['loading'], 'lazy');
      expect(image.attributes['decoding'], 'async');
      expect(image.attributes['alt'], isNotEmpty);
      for (final candidate in asset.srcSet.split(', ')) {
        _assertLocalWebP(candidate.split(' ').first);
      }
    }
    expect(logos, hasLength(2));
    for (final logo in logos) {
      final source = logo.attributes['src']!;
      expect(source, startsWith('assets/'));
      expect(source, endsWith('.svg'));
      expect(File('web/$source').readAsStringSync(), contains('<svg'));
      expect(int.parse(logo.attributes['width']!), greaterThan(0));
      expect(int.parse(logo.attributes['height']!), greaterThan(0));
      expect(logo.attributes['alt'], isNotEmpty);
    }
    for (final image in document.querySelectorAll('img[src]')) {
      final source = image.attributes['src']!;
      expect(source, startsWith('assets/'));
      expect(File('web/$source').existsSync(), isTrue, reason: source);
    }

    final stylesheet = File('web/assets/styles.css').readAsStringSync();
    expect(stylesheet, contains('@font-face'));
    final urls = RegExp(r'''url\(['"]?([^'")]+)''').allMatches(stylesheet).map((match) => match.group(1)!).toList();
    final fonts = urls.where((url) => url.endsWith('.woff2')).toList();
    expect(fonts, isNotEmpty);
    for (final font in fonts) {
      expect(font, startsWith('fonts/'));
      expect(File('web/assets/$font').lengthSync(), greaterThan(0));
    }
    expect(urls.where((url) => url.startsWith('http') || url.startsWith('//')), isEmpty);
  });
}

String _normaliseWhitespace(String value) => value.replaceAll(RegExp(r'\s+'), ' ').trim();

void _assertIdReferences(Document document, String? references) {
  expect(references, isNotNull);
  expect(references!.trim(), isNotEmpty);
  for (final id in references.split(RegExp(r'\s+'))) {
    expect(document.getElementById(id), isNotNull, reason: 'Unresolved accessible reference: $id');
  }
}

bool _hasWrappingLabel(Element control) {
  for (var ancestor = control.parent; ancestor != null; ancestor = ancestor.parent) {
    if (ancestor.localName == 'label' && _normaliseWhitespace(ancestor.text).isNotEmpty) return true;
  }
  return false;
}

void _assertLocalWebP(String source) {
  expect(source, startsWith('assets/images/'));
  expect(source, endsWith('.webp'));
  final file = File('web/$source');
  expect(file.existsSync(), isTrue, reason: source);
  final bytes = file.readAsBytesSync();
  expect(String.fromCharCodes(bytes.sublist(0, 4)), 'RIFF', reason: source);
  expect(String.fromCharCodes(bytes.sublist(8, 12)), 'WEBP', reason: source);
}
