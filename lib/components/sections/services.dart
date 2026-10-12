part of '../site_sections.dart';

extension _ServicesSection on AgencyPage {
  Component _services() => _el('section', [
    _el('div', [
      _referenceHeading('services'),
      _el('div', [
        for (var i = 0; i < content.services.length; i++)
          _el(
            'article',
            [
              _el('div', [
                _el('h3', [_text(content.services[i].name)]),
                _el(
                  'span',
                  [_text(content.services[i].duration)],
                  classes: 'service-duration',
                  attributes: {
                    'aria-label': _t(UiTextKey.timingAria, values: {'timing': content.services[i].duration}),
                  },
                ),
              ], classes: 'service-title'),
              _el('p', [_text(content.services[i].description)]),
              _el('div', [
                _el('ul', [
                  for (final item in content.services[i].deliverables) _el('li', [_text(item)]),
                ]),
              ], classes: 'service-deliverables'),
              _serviceIcon(i),
              _sectionLink(
                content.services[i].ctaLabel,
                'contact',
                classes: 'service-cta text-link',
                attributes: {'data-service': '$i'},
              ),
            ],
            id: 'service-$i',
            classes: 'service',
          ),
      ], classes: 'services-grid'),
    ], classes: 'wrap'),
  ], id: 'services');
}
