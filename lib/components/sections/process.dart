part of '../site_sections.dart';

extension _ProcessSection on AgencyPage {
  Component _process() => _el('section', [
    _el('div', [
      _referenceHeading('process'),
      _el(
        'div',
        [
          _el('div', const [], classes: 'timeline-line', attributes: {'aria-hidden': 'true'}),
          _el('div', const [], id: 'timelineFill', classes: 'timeline-fill', attributes: {'aria-hidden': 'true'}),
          _el('ol', [
            for (var i = 0; i < content.processSteps.length; i++)
              _el('li', [
                _el('span', const [], classes: 'step-point', attributes: {'aria-hidden': 'true'}),
                _el('span', [
                  _text(_t(UiTextKey.stepLabel, values: {'number': '${i + 1}'.padLeft(2, '0')})),
                ], classes: 'step-number'),
                _el('div', [
                  _el('h3', [_text(content.processSteps[i].name)]),
                  _el('span', [_text(content.processSteps[i].duration)], classes: 'step-duration'),
                ], classes: 'step-heading'),
                _el('p', [_text(content.processSteps[i].description)]),
                _el('ul', [
                  for (final deliverable in content.processSteps[i].deliverables) _el('li', [_text(deliverable)]),
                ], classes: 'process-deliverables'),
              ], classes: 'process-step'),
          ], classes: 'process-list'),
        ],
        id: 'timelineEl',
        classes: 'process-timeline',
      ),
    ], classes: 'wrap'),
  ], id: 'process');
}
