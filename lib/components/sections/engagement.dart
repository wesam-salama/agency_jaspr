part of '../site_sections.dart';

extension _EngagementSection on AgencyPage {
  Component _engagement() => _el(
    'section',
    [
      _el('div', [
        _referenceHeading('engagement'),
        _el('div', [
          for (var i = 0; i < content.engagements.length; i++)
            _el('article', [
              _el('span', [_text(content.engagements[i].tag)], classes: 'engagement-tag'),
              _el('h3', [_text(content.engagements[i].name)]),
              _el('p', [_text(content.engagements[i].description)]),
              _el('ul', [
                for (final feature in content.engagements[i].features) _el('li', [_text(feature)]),
              ], classes: 'engagement-features'),
              _el('p', [_text(content.engagements[i].terms)], classes: 'engagement-terms'),
            ], classes: 'engagement-option${i == 1 ? ' featured' : ''}'),
        ], classes: 'engage-grid'),
      ], classes: 'wrap'),
    ],
    id: 'engagement',
    classes: 'surface-alt',
  );
}
