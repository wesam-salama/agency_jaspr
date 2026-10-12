part of '../site_sections.dart';

extension _FaqSection on AgencyPage {
  Component _faq() => _el(
    'section',
    [
      _el('div', [
        _referenceHeading('faq'),
        _el('div', [
          for (final item in content.faqs)
            _el('details', [
              _el('summary', [
                _el('span', [_text(item.$1)], classes: 'faq-question'),
                _el(
                  'svg',
                  [
                    _el('path', const [], attributes: {'d': 'M4 12h16'}),
                    _el('path', const [], classes: 'faq-plus-stroke', attributes: {'d': 'M12 4v16'}),
                  ],
                  classes: 'faq-indicator',
                  attributes: {'viewBox': '0 0 24 24', 'aria-hidden': 'true', 'focusable': 'false'},
                ),
              ]),
              _el('p', [_text(item.$2)]),
            ], classes: 'faq-item'),
        ], classes: 'faq-list'),
      ], classes: 'wrap'),
    ],
    id: 'faq',
    classes: 'surface-alt',
  );
}
