part of '../site_sections.dart';

extension _ContactSection on AgencyPage {
  Component _field(String label, String id, Component input, {String? help}) => _el('div', [
    _el('label', [_text(label)], attributes: {'for': id}),
    input,
    if (help != null) _el('p', [_text(help)], id: '$id-hint', classes: 'field-hint'),
    _el('p', const [], id: '$id-error', classes: 'field-error', attributes: {'hidden': ''}),
  ], classes: 'form-field');

  Component _contact() => _el('section', [
    _el('div', [
      _el('div', [
        _sectionLabel(content.sectionCopy['contact']!.label),
        _el('h2', [_text(content.sectionCopy['contact']!.title)]),
        _el('p', [
          _text(
            content.sectionCopy['contact']!.introduction,
          ),
        ], classes: 'contact-intro'),
        _el('p', [_text(_t(UiTextKey.contactPreferDirect))], classes: 'direct-contact'),
        _link('hello@cr8.media', 'mailto:hello@cr8.media', classes: 'contact-email', attributes: {'dir': 'ltr'}),
      ], classes: 'contact-aside'),
      _el('div', [
        _el(
          'form',
          [
            _el('p', [_text(_t(UiTextKey.formIntro))], classes: 'form-intro'),
            _el('div', [
              _field(
                _t(UiTextKey.formName),
                'name',
                _el(
                  'input',
                  const [],
                  id: 'name',
                  attributes: {
                    'name': 'name',
                    'type': 'text',
                    'autocomplete': 'name',
                    'placeholder': _t(UiTextKey.formNamePlaceholder),
                    'required': '',
                    'maxlength': '120',
                    'aria-describedby': 'name-error',
                  },
                ),
              ),
              _field(
                _t(UiTextKey.formEmail),
                'email',
                _el(
                  'input',
                  const [],
                  id: 'email',
                  attributes: {
                    'name': 'email',
                    'type': 'email',
                    'autocomplete': 'email',
                    'placeholder': _t(UiTextKey.formEmailPlaceholder),
                    'dir': 'ltr',
                    'required': '',
                    'maxlength': '254',
                    'aria-describedby': 'email-error',
                  },
                ),
              ),
            ], classes: 'form-row'),
            _el('fieldset', [
              _el('legend', [
                _text(_t(UiTextKey.formServicesLegend)),
                _el('span', [_text(_t(UiTextKey.optional))]),
              ]),
              _el('div', [
                for (var i = 0; i < content.serviceNames.length; i++)
                  _el('label', [
                    _el(
                      'input',
                      const [],
                      attributes: {'type': 'checkbox', 'name': 'services', 'value': '$i', 'data-i': '$i'},
                    ),
                    _el('span', [_text(content.services[i].name)]),
                  ], classes: 'service-choice'),
              ], classes: 'service-choices'),
              _el(
                'button',
                [_text(_t(UiTextKey.clearServices))],
                id: 'constelReset',
                classes: 'clear-services',
                attributes: {'type': 'button', 'disabled': ''},
              ),
              _el(
                'p',
                [_text(_t(UiTextKey.constellationEmpty))],
                id: 'constelNote',
                classes: 'constel-note',
                attributes: {'role': 'status', 'aria-live': 'polite', 'aria-atomic': 'true'},
              ),
            ]),
            _field(
              _t(UiTextKey.formMessage),
              'message',
              _el(
                'textarea',
                const [],
                id: 'message',
                attributes: {
                  'name': 'message',
                  'rows': '4',
                  'required': '',
                  'maxlength': '3000',
                  'placeholder': _t(UiTextKey.formMessagePlaceholder),
                  'aria-describedby': 'message-hint message-error',
                },
              ),
              help: _t(UiTextKey.formMessageHelp),
            ),
            _field(
              _t(UiTextKey.formTiming),
              'timing',
              _el(
                'select',
                [
                  for (final timing in const ['unsure', 'soon', 'oneToThree', 'later'])
                    _el('option', [_text(content.timingLabels[timing]!)], attributes: {'value': timing}),
                ],
                id: 'timing',
                attributes: {'name': 'timing'},
              ),
            ),
            _el(
              'p',
              const [],
              id: 'formStatus',
              classes: 'form-status',
              attributes: {'role': 'status', 'aria-live': 'polite'},
            ),
            _el(
              'button',
              [_text(_t(UiTextKey.formSend))],
              id: 'draftButton',
              classes: 'btn btn-primary',
              attributes: {'type': 'submit', 'disabled': ''},
            ),
            _el('p', [
              _text(_t(UiTextKey.formEmailClientNotice)),
            ], classes: 'field-hint'),
          ],
          id: 'contactForm',
          attributes: {'action': 'mailto:hello@cr8.media', 'method': 'post', 'enctype': 'text/plain'},
        ),
        _el('noscript', [
          _el('p', [
            _text(_t(UiTextKey.formNoScript)),
          ], classes: 'content-note'),
        ]),
      ], classes: 'contact-form-wrap'),
      _el('div', [
        _el(
          'div',
          buildProjectConstellation(),
          id: 'constel',
          classes: 'constel',
          attributes: {'aria-hidden': 'true', 'data-motion-loop': 'contact'},
        ),
      ], classes: 'contact-connection'),
    ], classes: 'wrap contact-grid'),
  ], id: 'contact');

  List<Component> buildProjectConstellation() {
    const cx = 160.0;
    const cy = 112.0;
    final points = List.generate(
      content.serviceNames.length,
      (i) => (cx + math.cos(i * math.pi / 3 - math.pi / 2) * 106, cy + math.sin(i * math.pi / 3 - math.pi / 2) * 76),
    );
    return [
      _el(
        'svg',
        [
          for (var i = 0; i < points.length; i++)
            _el(
              'line',
              const [],
              classes: 'cl',
              attributes: {
                'data-i': '$i',
                'x1': '$cx',
                'y1': '$cy',
                'x2': '${points[i].$1}',
                'y2': '${points[i].$2}',
                'pathLength': '1',
              },
            ),
          _el('polyline', const [], id: 'constShape', classes: 'shape', attributes: {'points': '', 'pathLength': '1'}),
          _el('circle', const [], classes: 'you', attributes: {'cx': '$cx', 'cy': '$cy', 'r': '6'}),
          _el(
            'text',
            [_text(_t(UiTextKey.heroYou))],
            attributes: {
              'x': '$cx',
              'y': '${cy + 22}',
              'text-anchor': 'middle',
              'direction': content.locale.direction,
            },
          ),
          for (var i = 0; i < points.length; i++) ...[
            _el(
              'circle',
              const [],
              classes: 'cd idle',
              attributes: {'data-i': '$i', 'cx': '${points[i].$1}', 'cy': '${points[i].$2}', 'r': '5'},
            ),
            _el(
              'text',
              [_text(content.serviceNames[i])],
              attributes: {
                'x': '${points[i].$1}',
                'y': '${points[i].$2 + (points[i].$2 < cy ? -14 : 22)}',
                'text-anchor': 'middle',
                'direction': content.locale.direction,
              },
            ),
          ],
        ],
        attributes: {'viewBox': '0 0 320 240', 'focusable': 'false'},
      ),
    ];
  }
}
