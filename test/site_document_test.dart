@TestOn('vm')
library;

import 'package:agency_jaspr/site_document.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  testServer('prerenders the exact document metadata and complete page', (tester) async {
    tester.pumpComponent(buildAgencyDocument());

    final response = await tester.request('/');
    final document = response.document!;

    expect(response.statusCode, 200);
    expect(document.documentElement?.attributes['lang'], 'en');
    expect(document.querySelector('title')?.text, siteTitle);
    expect(document.querySelector('meta[name="description"]')?.attributes['content'], siteDescription);
    expect(document.querySelector('link[rel="stylesheet"]')?.attributes['href'], 'assets/styles.css');
    expect(document.querySelector('base'), isNull);

    expect(document.querySelectorAll('section'), hasLength(8));
    expect(document.querySelectorAll('.service'), hasLength(6));
    expect(document.querySelectorAll('.work-item'), hasLength(4));
    expect(document.querySelectorAll('.faq-item'), hasLength(5));
    expect(document.querySelectorAll('#rail button'), hasLength(8));
    expect(document.querySelectorAll('#constel .hit'), hasLength(6));
    expect(document.querySelectorAll('#caseModal'), hasLength(1));
    expect(document.querySelectorAll('#contactForm'), hasLength(1));
  });

  testServer('preserves navigation, accessibility, and hydration hooks', (tester) async {
    tester.pumpComponent(buildAgencyDocument());

    final document = (await tester.request('/')).document!;
    final burger = document.querySelector('#burgerBtn')!;
    final modal = document.querySelector('#caseModal')!;

    expect(burger.attributes['aria-expanded'], 'false');
    expect(burger.attributes['aria-label'], 'Toggle menu');
    expect(modal.attributes, containsPair('hidden', ''));
    expect(document.querySelector('#constel .hit')?.attributes['role'], 'button');
    expect(document.querySelector('#constel .hit')?.attributes['tabindex'], '0');
    expect(document.querySelector('#agencyRuntime'), isNotNull);
    expect(document.querySelectorAll('[onclick]'), isEmpty);
    expect(document.outerHtml, isNot(contains('https://')));
  });
}
