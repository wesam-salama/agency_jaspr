part of '../site_sections.dart';

extension _WorkSection on AgencyPage {
  Component _work() => _el(
    'section',
    [
      _el('div', [
        _referenceHeading('work'),
        _el('div', [
          for (final project in content.workProjects)
            _el('article', [
              _el(
                'button',
                [
                  _el(
                    'div',
                    [
                      _image(
                        project.cardImage,
                        project.cardAlt ?? project.caseStudy.name,
                      ),
                      _el(
                        'canvas',
                        const [],
                        classes: 'work-particles',
                        attributes: {'aria-hidden': 'true', 'focusable': 'false'},
                      ),
                    ],
                    classes: 'work-thumb',
                    attributes: {'data-motion-loop': 'work'},
                  ),
                  _el('div', [
                    _el('p', [
                      _text(project.category),
                      if (project.status case final status?) _el('span', [_text(status)], classes: 'work-status'),
                    ], classes: 'work-category'),
                    _el('div', [
                      _el('h3', [_text(project.caseStudy.name)]),
                      _el('span', [_text(_t(UiTextKey.workViewCaseStudy))], classes: 'work-open'),
                    ], classes: 'work-title'),
                    _el('div', [
                      _el('span', [_text(project.index)], classes: 'work-index'),
                      _el('span', [_text(project.year)], classes: 'work-year'),
                      _el('p', [_text(project.disciplines)], classes: 'work-disciplines'),
                    ], classes: 'work-meta'),
                    _el('p', [_text(project.description)], classes: 'work-description'),
                  ], classes: 'work-info'),
                ],
                classes: 'work-item',
                attributes: {
                  'type': 'button',
                  'disabled': '',
                  'data-case': project.caseStudy.name,
                  'aria-haspopup': 'dialog',
                  'aria-controls': 'caseModal',
                  'aria-label': _t(UiTextKey.workOpenCaseAria, values: {'name': project.caseStudy.name}),
                },
              ),
            ], classes: 'work-project'),
        ], classes: 'work-grid'),
        _el('noscript', [
          _el('p', [
            _text(_t(UiTextKey.workNoScript)),
          ], classes: 'content-note'),
        ]),
      ], classes: 'wrap'),
    ],
    id: 'work',
    classes: 'surface-alt',
  );
}
