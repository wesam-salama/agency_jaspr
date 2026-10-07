import 'dart:math' as math;

import 'package:jaspr/jaspr.dart';

const serviceNames = <String>[
  'Branding',
  'Rebranding',
  'Consultancy',
  'Web Dev',
  'App Dev',
  'Maintenance',
];

Component _element(
  String tag,
  List<Component> children, {
  String? id,
  String? classes,
  Map<String, String>? attributes,
}) => Component.element(tag: tag, id: id, classes: classes, attributes: attributes, children: children);

List<Component> buildMarqueeChildren() => List.generate(2, (_) {
  final children = <Component>[.text('CR8.MEDIA')];
  for (final service in serviceNames) {
    children
      ..add(.text(' '))
      ..add(_element('i', [.text('•')]))
      ..add(.text(' ${service.toUpperCase()}'));
  }
  children
    ..add(.text(' '))
    ..add(_element('i', [.text('•')]))
    ..add(.text(' '));
  return _element('span', children);
});

List<Component> buildRailChildren() {
  const stops = <(String, String)>[
    ('top', 'Intro'),
    ('services', 'Services'),
    ('work', 'Work'),
    ('process', 'Process'),
    ('engagement', 'Engagement'),
    ('studio', 'Studio'),
    ('faq', 'FAQ'),
    ('contact', 'Contact: every line ends here'),
  ];

  return [
    _element('div', const [], classes: 'rail-fill'),
    _element('div', const [], classes: 'rail-line'),
    for (var index = 0; index < stops.length; index++)
      _element(
        'button',
        [
          _element('i', const []),
          _element('span', [.text(stops[index].$2)], classes: 'lbl'),
        ],
        classes: index == stops.length - 1 ? 'last' : null,
        attributes: {'type': 'button', 'data-target': stops[index].$1},
      ),
  ];
}

List<Component> buildStatGraphic(String value) {
  if (value == 'inf') {
    return [
      _element(
        'svg',
        [
          _element(
            'path',
            const [],
            classes: 'inf-p',
            attributes: {'d': 'M12 20 C12 10 26 10 32 20 C38 30 52 30 52 20 C52 10 38 10 32 20 C26 30 12 30 12 20 Z'},
          ),
          _element('circle', const [], classes: 'inf-d', attributes: {'r': '3'}),
        ],
        classes: 'inf',
        attributes: {'viewBox': '0 0 64 40'},
      ),
    ];
  }

  const font = <String, List<String>>{
    '0': ['111', '101', '101', '101', '111'],
    '1': ['010', '110', '010', '010', '111'],
    '6': ['111', '100', '111', '101', '111'],
  };

  return [
    for (final character in value.split(''))
      _element(
        'span',
        [
          for (var row = 0; row < 5; row++)
            for (var column = 0; column < 3; column++)
              _element(
                'i',
                const [],
                classes: font[character]![row][column] == '1' ? 'onw' : null,
                attributes: {'data-d': '${(row * 3 + column) * 28}'},
              ),
        ],
        classes: 'dm',
      ),
  ];
}

List<Component> buildConstellationChildren() {
  const centerX = 160.0;
  const centerY = 102.0;
  final positions = List.generate(serviceNames.length, (index) {
    final angle = (math.pi * 2 / serviceNames.length) * index - math.pi / 2;
    return (centerX + math.cos(angle) * 112, centerY + math.sin(angle) * 64);
  });

  String number(double value) => value == value.roundToDouble() ? value.toInt().toString() : value.toString();

  return [
    _element(
      'svg',
      [
        _element(
          'polyline',
          const [],
          id: 'constShape',
          classes: 'shape',
          attributes: {'pathLength': '1', 'points': ''},
        ),
        for (var index = 0; index < serviceNames.length; index++)
          _element(
            'line',
            const [],
            classes: 'cl',
            attributes: {
              'data-i': '$index',
              'x1': number(centerX),
              'y1': number(centerY),
              'x2': number(positions[index].$1),
              'y2': number(positions[index].$2),
            },
          ),
        _element(
          'circle',
          const [],
          classes: 'you',
          attributes: {'cx': number(centerX), 'cy': number(centerY), 'r': '6'},
        ),
        _element(
          'text',
          [.text('You')],
          attributes: {'x': number(centerX), 'y': number(centerY + 22), 'text-anchor': 'middle'},
        ),
        for (var index = 0; index < serviceNames.length; index++)
          _element(
            'g',
            [
              _element(
                'circle',
                const [],
                classes: 'cd',
                attributes: {
                  'data-i': '$index',
                  'cx': number(positions[index].$1),
                  'cy': number(positions[index].$2),
                  'r': '7',
                },
              ),
              _element(
                'text',
                [.text(serviceNames[index])],
                attributes: {
                  'x': number(positions[index].$1),
                  'y': number(positions[index].$2 < centerY ? positions[index].$2 - 16 : positions[index].$2 + 24),
                  'text-anchor': 'middle',
                },
              ),
              _element(
                'circle',
                const [],
                classes: 'hit',
                attributes: {
                  'data-i': '$index',
                  'cx': number(positions[index].$1),
                  'cy': number(positions[index].$2),
                  'r': '20',
                  'role': 'button',
                  'tabindex': '0',
                  'aria-label': 'Toggle ${serviceNames[index]}',
                },
              ),
            ],
            classes: 'idle',
            attributes: {'style': 'animation-delay:${index * .45}s'},
          ),
      ],
      attributes: {'viewBox': '0 0 320 204', 'aria-label': 'Select project services'},
    ),
  ];
}
