part of '../site_sections.dart';

extension _HeroSection on AgencyPage {
  Component _hero() => _el(
    'section',
    [
      _el('div', [
        _el(
          'div',
          [
            _sectionLabel(content.heroEyebrow),
            _el('h1', [
              _text(content.heroHeadlineParts.before),
              _el('span', [_text(content.heroHeadlineParts.emphasis)]),
              _text(content.heroHeadlineParts.after),
            ]),
            _el('p', [
              _text(
                content.heroDescription,
              ),
            ], classes: 'hero-copy'),
            _el('div', [
              _sectionLink(_t(UiTextKey.heroStartProject), 'contact', classes: 'btn btn-primary'),
              _sectionLink(_t(UiTextKey.heroSeeWork), 'work', classes: 'btn btn-secondary'),
            ], classes: 'hero-ctas'),
            _el('p', [_text(content.heroHint)], classes: 'hero-note'),
          ],
          id: 'heroInner',
          classes: 'hero-text',
        ),
        _el('div', [
          _el(
            'div',
            [
              _el('canvas', const [], classes: 'hero-ink', attributes: {'aria-hidden': 'true', 'focusable': 'false'}),
              _el(
                'svg',
                [
                  for (var i = 0; i < content.serviceNames.length; i++)
                    _el(
                      'line',
                      const [],
                      classes: 'hero-connection',
                      attributes: {
                        'x1': '240',
                        'y1': '220',
                        'x2': '${240 + math.cos(i * math.pi / 3 - math.pi / 2) * 162}',
                        'y2': '${220 + math.sin(i * math.pi / 3 - math.pi / 2) * 162}',
                        'data-i': '$i',
                      },
                    ),
                  _el('circle', const [], classes: 'hero-center', attributes: {'cx': '240', 'cy': '220', 'r': '9'}),
                ],
                classes: 'hero-network-lines',
                attributes: {'viewBox': '0 0 480 440', 'aria-hidden': 'true', 'focusable': 'false'},
              ),
              _el('span', [_text(_t(UiTextKey.heroYou))], classes: 'hero-you'),
              for (var i = 0; i < content.serviceNames.length; i++)
                _sectionLink(
                  content.serviceNames[i],
                  'service-$i',
                  classes: 'hero-node node-$i',
                  attributes: {'data-node': '$i'},
                ),
            ],
            classes: 'hero-network',
            attributes: {'data-motion-loop': 'hero'},
          ),
        ], classes: 'hero-visual'),
      ], classes: 'wrap hero-grid'),
      _marquee(),
    ],
    id: 'top',
    classes: 'hero',
    attributes: {'aria-label': content.heroEyebrow},
  );
}
