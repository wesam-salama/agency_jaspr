import 'dart:math' as math;

import 'package:jaspr/jaspr.dart';

import '../data/site_data.dart';
import '../utils/image_assets.dart';
import 'static_extras.dart' show serviceNames;

Component _el(String tag, List<Component> children, {String? id, String? classes, Map<String, String>? attributes}) =>
    Component.element(tag: tag, id: id, classes: classes, attributes: attributes, children: children);

Component _text(String value) => Component.text(value);
Component _link(String label, String href, {String? classes, Map<String, String>? attributes}) =>
    _el('a', [_text(label)], classes: classes, attributes: {'href': href, ...?attributes});

Component _logo() => _el(
  'a',
  [
    _el(
      'img',
      const [],
      attributes: {'src': 'assets/cr8-logo.svg', 'width': '116', 'height': '30', 'alt': 'CR8.Media'},
    ),
    _el(
      'svg',
      [
        _el(
          'polyline',
          const [],
          attributes: {'points': '5,5 18,5 32,5 32,19 18,19 5,19 5,32 18,32 32,32', 'pathLength': '1'},
        ),
      ],
      classes: 'logo-signature',
      attributes: {'viewBox': '0 0 38 38', 'aria-hidden': 'true', 'focusable': 'false'},
    ),
  ],
  classes: 'logo',
  attributes: {'href': '#top', 'aria-label': 'CR8.Media — home'},
);

Component _image(String source, String alt, {String? classes, String sizes = '(max-width: 700px) 100vw, 50vw'}) {
  final asset = imageAssetFor(source);
  return _el(
    'img',
    const [],
    classes: classes,
    attributes: {
      'src': asset?.src ?? source,
      if (asset != null) ...{
        'srcset': asset.srcSet,
        'sizes': sizes,
        'width': '${asset.width}',
        'height': '${asset.height}',
      },
      'alt': alt,
      'loading': 'lazy',
      'decoding': 'async',
    },
  );
}

Component _heading(String title, String intro, {String? id}) => _el('div', [
  _el('h2', [_text(title)], id: id),
  _el('p', [_text(intro)], classes: 'section-intro'),
], classes: 'section-heading');

Component _motionToggle() => _el('div', [
  _el(
    'button',
    [_text('Pause animations')],
    classes: 'motion-toggle',
    attributes: {'type': 'button', 'aria-pressed': 'false', 'disabled': ''},
  ),
  _el('span', const [], classes: 'motion-status'),
], classes: 'motion-preference');

Component _marquee({bool footer = false}) => _el(
  'div',
  [
    _el('div', [
      for (var repeat = 0; repeat < 2; repeat++)
        _el('span', [
          _text('CR8.MEDIA'),
          for (final name in const ['Branding', 'Rebranding', 'Consultancy', 'Web Dev', 'App Dev', 'Maintenance']) ...[
            _el('i', [_text('•')]),
            _text(name),
          ],
          _el('i', [_text('•')]),
        ]),
    ], classes: 'motion-marquee'),
  ],
  classes: 'motion-marquee-band${footer ? ' footer-marquee' : ' hero-marquee'}',
  attributes: {'aria-hidden': 'true', 'data-motion-loop': 'marquee'},
);

Component _serviceIcon(int index) {
  final shapes = switch (index) {
    0 => <Component>[
      _el('circle', const [], classes: 'icon-c1', attributes: {'cx': '24', 'cy': '32', 'r': '15'}),
      _el('circle', const [], classes: 'icon-c2 icon-accent', attributes: {'cx': '40', 'cy': '32', 'r': '15'}),
    ],
    1 => <Component>[
      _el('g', [
        _el('circle', const [], attributes: {'cx': '32', 'cy': '32', 'r': '18', 'stroke-dasharray': '3 7'}),
        _el('circle', const [], classes: 'icon-accent icon-dot', attributes: {'cx': '32', 'cy': '14', 'r': '3'}),
      ], classes: 'icon-spin'),
    ],
    2 => <Component>[
      _el('line', const [], attributes: {'x1': '32', 'y1': '32', 'x2': '16', 'y2': '16', 'stroke-width': '1'}),
      _el('line', const [], attributes: {'x1': '32', 'y1': '32', 'x2': '48', 'y2': '16', 'stroke-width': '1'}),
      _el('line', const [], attributes: {'x1': '32', 'y1': '32', 'x2': '32', 'y2': '50', 'stroke-width': '1'}),
      _el('circle', const [], classes: 'icon-accent icon-dot', attributes: {'cx': '32', 'cy': '32', 'r': '4.5'}),
      _el('circle', const [], classes: 'icon-node-a icon-dot', attributes: {'cx': '16', 'cy': '16', 'r': '3'}),
      _el('circle', const [], classes: 'icon-node-b icon-dot', attributes: {'cx': '48', 'cy': '16', 'r': '3'}),
      _el('circle', const [], classes: 'icon-node-c icon-dot', attributes: {'cx': '32', 'cy': '50', 'r': '3'}),
    ],
    3 => <Component>[
      _el('rect', const [], attributes: {'x': '8', 'y': '12', 'width': '48', 'height': '40', 'rx': '4'}),
      _el('line', const [], attributes: {'x1': '8', 'y1': '22', 'x2': '56', 'y2': '22'}),
      _el('circle', const [], classes: 'icon-dot', attributes: {'cx': '14', 'cy': '17', 'r': '1.5'}),
      _el('circle', const [], classes: 'icon-dot', attributes: {'cx': '20', 'cy': '17', 'r': '1.5'}),
      _el(
        'path',
        const [],
        classes: 'icon-code-l icon-accent',
        attributes: {'d': 'M26 31l-7 7 7 7', 'stroke-width': '1.6'},
      ),
      _el(
        'path',
        const [],
        classes: 'icon-code-r icon-accent',
        attributes: {'d': 'M38 31l7 7-7 7', 'stroke-width': '1.6'},
      ),
      _el('line', const [], classes: 'icon-slash', attributes: {'x1': '34.5', 'y1': '29', 'x2': '29.5', 'y2': '49'}),
    ],
    4 => <Component>[
      _el('rect', const [], attributes: {'x': '20', 'y': '6', 'width': '24', 'height': '52', 'rx': '6'}),
      _el(
        'circle',
        const [],
        classes: 'icon-bounce icon-accent icon-dot',
        attributes: {'cx': '32', 'cy': '18', 'r': '3.5'},
      ),
    ],
    _ => <Component>[
      _el('g', [
        _el('circle', const [], attributes: {'cx': '32', 'cy': '10', 'r': '3'}),
        _el('circle', const [], attributes: {'cx': '54', 'cy': '32', 'r': '3'}),
        _el('circle', const [], attributes: {'cx': '32', 'cy': '54', 'r': '3'}),
        _el('circle', const [], attributes: {'cx': '10', 'cy': '32', 'r': '3'}),
      ], classes: 'icon-orbit icon-dot'),
      _el('circle', const [], classes: 'icon-accent icon-dot', attributes: {'cx': '32', 'cy': '32', 'r': '5.5'}),
    ],
  };
  return _el(
    'div',
    [
      _el('svg', shapes, attributes: {'viewBox': '0 0 64 64', 'focusable': 'false'}),
    ],
    classes: 'service-icon',
    attributes: {'aria-hidden': 'true', 'data-motion-loop': 'service'},
  );
}

class AgencyPage extends StatelessComponent {
  const AgencyPage({super.key});

  @override
  Component build(BuildContext context) => Component.fragment([
    _link('Skip to content', '#mainContent', classes: 'skip-link'),
    const SiteHeader(),
    _el(
      'main',
      [
        _hero(),
        _services(),
        _work(),
        _process(),
        _engagement(),
        _studio(),
        _faq(),
        _contact(),
      ],
      id: 'mainContent',
      attributes: {'tabindex': '-1'},
    ),
    _el('footer', [
      _marquee(footer: true),
      _el('div', [
        _logo(),
        _el('p', [_text('Every line ends at a conversation.')]),
        _link('hello@cr8.media', 'mailto:hello@cr8.media'),
      ], classes: 'wrap footer-main'),
      _el('div', [
        _el('small', [_text('© 2026 CR8.Media')]),
        _el('small', [_text('Case studies, results and engagement examples are illustrative.')]),
        _motionToggle(),
        _link('Back to top', '#top'),
      ], classes: 'wrap footer-bottom'),
    ], id: 'siteFooter'),
    _caseDialog(),
  ]);
}

class SiteHeader extends StatelessComponent {
  const SiteHeader({super.key});

  @override
  Component build(BuildContext context) => _el('header', [
    _el(
      'nav',
      [
        _logo(),
        _el(
          'ul',
          [
            _el('li', const [], classes: 'nav-indicator', attributes: {'aria-hidden': 'true'}),
            for (final entry in const [
              ('Services', 'services'),
              ('Work', 'work'),
              ('Process', 'process'),
              ('Studio', 'studio'),
            ])
              _el('li', [_link(entry.$1, '#${entry.$2}')]),
          ],
          id: 'primaryNavigation',
          classes: 'nav-links',
        ),
        _link('Start a project', '#contact', classes: 'nav-cta'),
        _el(
          'button',
          [
            _el(
              'svg',
              [
                _el('path', const [], attributes: {'d': 'M3 6h18M3 12h18M3 18h18'}),
              ],
              attributes: {'viewBox': '0 0 24 24', 'width': '24', 'height': '24', 'aria-hidden': 'true'},
            ),
          ],
          id: 'burgerBtn',
          classes: 'burger',
          attributes: {
            'type': 'button',
            'aria-label': 'Open menu',
            'aria-expanded': 'false',
            'aria-controls': 'primaryNavigation',
            'disabled': '',
          },
        ),
      ],
      classes: 'wrap',
      attributes: {'aria-label': 'Main navigation'},
    ),
  ], id: 'siteHeader');
}

Component _hero() => _el(
  'section',
  [
    _el('div', [
      _el(
        'div',
        [
          _el('h1', [
            _text('Brand, web and apps. '),
            _el('span', [_text('One connected studio.')]),
          ]),
          _el('p', [
            _text(
              'For founders and marketing leads who need the pieces to work together. We connect strategy, design and development, from the first idea to the next chapter.',
            ),
          ], classes: 'hero-copy'),
          _el('div', [
            _link('Start a project', '#contact', classes: 'btn btn-primary'),
            _link('Explore example work', '#work', classes: 'btn btn-secondary'),
          ], classes: 'hero-ctas'),
          _el('p', [_text('One brief. Brand, web, apps and ongoing care.')], classes: 'hero-note'),
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
                for (var i = 0; i < serviceNames.length; i++)
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
            _el('span', [_text('Your project')], classes: 'hero-you'),
            for (var i = 0; i < serviceNames.length; i++)
              _link(serviceNames[i], '#service-$i', classes: 'hero-node node-$i', attributes: {'data-node': '$i'}),
          ],
          classes: 'hero-network',
          attributes: {'data-motion-loop': 'hero'},
        ),
        _el('div', [
          _el('p', [_text('Six disciplines. Connected around your project.')], classes: 'network-caption'),
          _motionToggle(),
        ], classes: 'network-controls'),
      ], classes: 'hero-visual'),
    ], classes: 'wrap hero-grid'),
    _marquee(),
  ],
  id: 'top',
  classes: 'hero',
  attributes: {'aria-label': 'Brand, web and apps'},
);

Component _services() => _el('section', [
  _el('div', [
    _heading(
      'Start with what you need.',
      'One discipline or a connected programme. These are the pieces we can bring together.',
    ),
    _el('div', [
      for (var i = 0; i < services.length; i++)
        _el(
          'article',
          [
            _el('div', [
              _el('h3', [_text(services[i].name)]),
              _el(
                'span',
                [_text(services[i].duration)],
                classes: 'service-duration',
                attributes: {'aria-label': 'Illustrative timing: ${services[i].duration}'},
              ),
            ], classes: 'service-title'),
            _el('p', [_text(services[i].description)]),
            _el('details', [
              _el('summary', [_text('Example deliverables')]),
              _el('ul', [
                for (final item in services[i].deliverables) _el('li', [_text(item)]),
              ]),
            ], classes: 'service-details'),
            _serviceIcon(i),
            _link(
              'Discuss ${services[i].name.toLowerCase()}',
              '#contact',
              classes: 'service-cta text-link',
              attributes: {'data-service': '$i'},
            ),
          ],
          id: 'service-$i',
          classes: 'service',
        ),
    ], classes: 'services-grid'),
    _el('p', [
      _text('Timescales and deliverables are illustrative. A project brief defines the scope.'),
    ], classes: 'content-note'),
  ], classes: 'wrap'),
], id: 'services');

Component _work() => _el(
  'section',
  [
    _el('div', [
      _heading(
        'See how the pieces connect.',
        'Four illustrative projects, from a brand’s first impression to the product people use. These examples demonstrate the approach; they are not verified client results.',
      ),
      _el('div', [
        for (final project in workProjects)
          _el('article', [
            _el(
              'button',
              [
                _el(
                  'div',
                  [
                    _image(
                      project.cardImage,
                      '${project.caseStudy.name} — illustrative ${project.category.toLowerCase()} project',
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
                  _el('div', [
                    _el('h3', [_text(project.caseStudy.name)]),
                    _el('span', [_text('View example')], classes: 'work-open'),
                  ], classes: 'work-title'),
                  _el('p', [_text(project.disciplines)], classes: 'work-disciplines'),
                  _el('p', [_text(project.description)], classes: 'work-description'),
                  _el('span', [
                    _text(project.caseStudy.isIllustrative ? 'Illustrative project' : 'Client project'),
                  ], classes: 'example-label'),
                ], classes: 'work-info'),
              ],
              classes: 'work-item',
              attributes: {
                'type': 'button',
                'disabled': '',
                'data-case': project.caseStudy.name,
                'aria-haspopup': 'dialog',
                'aria-controls': 'caseModal',
                'aria-label': 'Explore ${project.caseStudy.name} example',
              },
            ),
          ], classes: 'work-project'),
      ], classes: 'work-grid'),
      _el('noscript', [
        _el('p', [
          _text(
            'Project images and summaries are shown above. Email us to discuss how the approach could fit your project.',
          ),
        ], classes: 'content-note'),
      ]),
    ], classes: 'wrap'),
  ],
  id: 'work',
  classes: 'surface-alt',
);

const _processSteps = <(String, String)>[
  (
    'Connect',
    'Start with the business, the audience and the problem. A focused brief gives the work a useful direction.',
  ),
  ('Define', 'Connect positioning, naming and scope. Agree what the project should make possible before designing.'),
  ('Design', 'Build the identity, interface or both around the same decisions. Review the work against the brief.'),
  (
    'Build',
    'Turn the design into a working site or product. Review progress with real content and useful interactions.',
  ),
  ('Launch', 'Check the experience, prepare the release and make the handover understandable.'),
  ('Maintain', 'Keep the work current through a support scope that fits the project.'),
];

Component _process() => _el('section', [
  _el('div', [
    _heading(
      'A clear path from brief to build.',
      'An example process with six connected stages. Scope and timing are agreed for each project.',
    ),
    _el('ol', [
      for (var i = 0; i < _processSteps.length; i++)
        _el('li', [
          _el('span', [_text('${i + 1}'.padLeft(2, '0'))], classes: 'step-number', attributes: {'aria-hidden': 'true'}),
          _el('div', [
            _el('h3', [_text(_processSteps[i].$1)]),
            _el('p', [_text(_processSteps[i].$2)]),
          ]),
        ], classes: 'process-step'),
    ], classes: 'process-list'),
  ], classes: 'wrap'),
], id: 'process');

const _engagements = <(String, String, String)>[
  (
    'Project',
    'One clear outcome.',
    'A defined piece of work, such as an identity, a website or an app. Start by describing the outcome you need.',
  ),
  (
    'Programme',
    'The pieces, together.',
    'Connected disciplines working towards one launch or change: brand and web, or product design and development.',
  ),
  (
    'Partner',
    'Support for the next chapter.',
    'An ongoing collaboration for teams with evolving design, development and maintenance needs.',
  ),
];

Component _engagement() => _el(
  'section',
  [
    _el('div', [
      _heading(
        'Three ways to work together.',
        'Example engagement models. The right scope comes from the conversation, not a package chosen in advance.',
      ),
      _el('div', [
        for (final item in _engagements)
          _el('article', [
            _el('h3', [_text(item.$1)]),
            _el('p', [_text(item.$2)], classes: 'engagement-lead'),
            _el('p', [_text(item.$3)]),
            _link('Talk about a ${item.$1.toLowerCase()}', '#contact', classes: 'text-link'),
          ], classes: 'engagement-option'),
      ], classes: 'engage-grid'),
    ], classes: 'wrap'),
  ],
  id: 'engagement',
  classes: 'surface-alt',
);

Component _studio() => _el('section', [
  _el('div', [
    _el('h2', [_text('One brief. One connected point of view.')]),
    _el('div', [
      _el('p', [
        _text(
          'A brand and its digital products should tell the same story. CR8.Media brings those conversations together, so the identity, the interface and the next release can move in one direction.',
        ),
      ], classes: 'studio-lead'),
      _el('p', [
        _text(
          'For founders and marketing leads: bring the business problem, the audience and what needs to change. We can start with one discipline and connect the rest when the project needs it.',
        ),
      ]),
      _link('Let’s connect the pieces', '#contact', classes: 'text-link'),
    ]),
  ], classes: 'wrap studio-grid'),
], id: 'studio');

const _faqs = <(String, String)>[
  (
    'Can we start with one service?',
    'Yes. The website’s six disciplines can be discussed individually or as part of a connected brief. Select the ones you have in mind, or leave the selection open.',
  ),
  (
    'How long would a project take?',
    'The service timings on this page are illustrative planning examples. The scope, review process and delivery schedule need to be agreed for your project.',
  ),
  (
    'Are these real client case studies?',
    'The four projects, names, testimonials and results are illustrative examples. They show how a brief and its connected work could be presented; they are not verified client evidence.',
  ),
  (
    'What should we include in the brief?',
    'Tell us the goal, the audience and what needs to change. Add the services and a rough timing if you know them. Budget can be discussed in the email conversation.',
  ),
  (
    'What happens when we open an email draft?',
    'Your selections and brief are prepared for your email app. Nothing is sent from this website. Review and send the draft there, or use the email address shown below.',
  ),
];

Component _faq() => _el(
  'section',
  [
    _el('div', [
      _heading('A few things to know.', 'Clear answers before the first conversation.'),
      _el('div', [
        for (final item in _faqs)
          _el('details', [
            _el('summary', [_text(item.$1)]),
            _el('p', [_text(item.$2)]),
          ], classes: 'faq-item'),
      ], classes: 'faq-list'),
    ], classes: 'wrap'),
  ],
  id: 'faq',
  classes: 'surface-alt',
);

Component _field(String label, String id, Component input, {String? help}) => _el('div', [
  _el('label', [_text(label)], attributes: {'for': id}),
  input,
  if (help != null) _el('p', [_text(help)], id: '$id-hint', classes: 'field-hint'),
  _el('p', const [], id: '$id-error', classes: 'field-error', attributes: {'hidden': ''}),
], classes: 'form-field');

Component _contact() => _el('section', [
  _el('div', [
    _el('div', [
      _el('h2', [_text('What should we connect next?')]),
      _el('p', [
        _text(
          'A first identity, a better website, an app or the next chapter. Start with the goal; we can work out the right pieces together.',
        ),
      ], classes: 'contact-intro'),
      _el('p', [_text('Prefer a direct conversation?')], classes: 'direct-contact'),
      _link('hello@cr8.media', 'mailto:hello@cr8.media', classes: 'contact-email'),
    ], classes: 'contact-aside'),
    _el('div', [
      _el(
        'form',
        [
          _el('p', [_text('Name, email and project goal are required.')], classes: 'form-intro'),
          _el('div', [
            _field(
              'Name',
              'name',
              _el(
                'input',
                const [],
                id: 'name',
                attributes: {
                  'name': 'name',
                  'type': 'text',
                  'autocomplete': 'name',
                  'required': '',
                  'maxlength': '120',
                  'aria-describedby': 'name-error',
                },
              ),
            ),
            _field(
              'Email',
              'email',
              _el(
                'input',
                const [],
                id: 'email',
                attributes: {
                  'name': 'email',
                  'type': 'email',
                  'autocomplete': 'email',
                  'required': '',
                  'maxlength': '254',
                  'aria-describedby': 'email-error',
                },
              ),
            ),
          ], classes: 'form-row'),
          _el('fieldset', [
            _el('legend', [
              _text('What do you need? '),
              _el('span', [_text('Optional')]),
            ]),
            _el('div', [
              for (var i = 0; i < serviceNames.length; i++)
                _el('label', [
                  _el(
                    'input',
                    const [],
                    attributes: {'type': 'checkbox', 'name': 'services', 'value': serviceNames[i], 'data-i': '$i'},
                  ),
                  _el('span', [_text(services[i].name)]),
                ], classes: 'service-choice'),
            ], classes: 'service-choices'),
            _el(
              'button',
              [_text('Not sure yet — clear selections')],
              id: 'constelReset',
              classes: 'clear-services',
              attributes: {'type': 'button', 'disabled': ''},
            ),
            _el(
              'p',
              [_text('No services selected. We can discuss the right starting point.')],
              id: 'constelNote',
              classes: 'constel-note',
              attributes: {'role': 'status', 'aria-live': 'polite', 'aria-atomic': 'true'},
            ),
          ]),
          _field(
            'Project goal',
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
                'placeholder': 'Who is it for, and what needs to change?',
                'aria-describedby': 'message-hint message-error',
              },
            ),
            help: 'A few sentences are enough.',
          ),
          _field(
            'Rough timing (optional)',
            'timing',
            _el(
              'select',
              [
                for (final timing in const ['Not sure yet', 'As soon as practical', 'Within 1–3 months', 'Later'])
                  _el('option', [_text(timing)], attributes: {'value': timing}),
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
            [_text('Open email draft')],
            id: 'draftButton',
            classes: 'btn btn-primary',
            attributes: {'type': 'submit', 'disabled': ''},
          ),
          _el('p', [
            _text('Review and send from your email app. Nothing is sent from this page.'),
          ], classes: 'field-hint'),
        ],
        id: 'contactForm',
        attributes: {'action': 'mailto:hello@cr8.media', 'method': 'post', 'enctype': 'text/plain'},
      ),
      _el('noscript', [
        _el('p', [
          _text('Use hello@cr8.media to share your goal, services and rough timing.'),
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
    serviceNames.length,
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
        _el('text', [_text('Your project')], attributes: {'x': '$cx', 'y': '${cy + 22}', 'text-anchor': 'middle'}),
        for (var i = 0; i < points.length; i++) ...[
          _el(
            'circle',
            const [],
            classes: 'cd idle',
            attributes: {'data-i': '$i', 'cx': '${points[i].$1}', 'cy': '${points[i].$2}', 'r': '5'},
          ),
          _el(
            'text',
            [_text(serviceNames[i])],
            attributes: {
              'x': '${points[i].$1}',
              'y': '${points[i].$2 + (points[i].$2 < cy ? -14 : 22)}',
              'text-anchor': 'middle',
            },
          ),
        ],
      ],
      attributes: {'viewBox': '0 0 320 240', 'focusable': 'false'},
    ),
  ];
}

Component _caseDialog() => _el(
  'div',
  [
    _el('div', [
      _el('div', [
        _el('span', [_text('Illustrative case study')], id: 'cmExample', classes: 'example-label'),
        _el(
          'button',
          [_text('Close case study')],
          id: 'cmClose',
          classes: 'dialog-close',
          attributes: {'type': 'button'},
        ),
      ], classes: 'cm-toolbar'),
      _el(
        'div',
        [
          _el(
            'div',
            [
              _el('img', const [], id: 'cmImg', attributes: {'alt': '', 'hidden': '', 'decoding': 'async'}),
            ],
            id: 'cmPresentation',
            classes: 'cm-presentation',
          ),
          _el('div', [
            _el('h2', const [], id: 'cmTitle', attributes: {'tabindex': '-1'}),
            _el('p', const [], id: 'cmTag'),
          ], classes: 'cm-heading'),
        ],
        id: 'cmHero',
        classes: 'cm-hero',
      ),
      _el('div', const [], id: 'cmMeta', classes: 'cm-meta'),
      _el(
        'p',
        [
          _text(
            'Names, testimonials, timelines and results are illustrative. Images are visual references, not finished deliverables.',
          ),
        ],
        id: 'cmDescription',
        classes: 'content-note',
      ),
      _el('div', const [], id: 'cmBody', classes: 'cm-body'),
      _el('div', [
        _el(
          'button',
          [_text('Next example project')],
          id: 'cmNext',
          classes: 'btn btn-secondary',
          attributes: {'type': 'button'},
        ),
      ], classes: 'cm-foot'),
    ], classes: 'cm-content'),
  ],
  id: 'caseModal',
  classes: 'case-modal',
  attributes: {
    'hidden': '',
    'role': 'dialog',
    'aria-modal': 'true',
    'aria-labelledby': 'cmTitle',
    'aria-describedby': 'cmDescription',
    'tabindex': '-1',
  },
);
