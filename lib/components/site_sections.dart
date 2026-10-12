import 'dart:math' as math;

import 'package:jaspr/jaspr.dart';

import '../l10n/site_content.dart';
import '../utils/image_assets.dart';

part 'sections/hero.dart';
part 'sections/services.dart';
part 'sections/work.dart';
part 'sections/process.dart';
part 'sections/engagement.dart';
part 'sections/studio.dart';
part 'sections/faq.dart';
part 'sections/contact.dart';

Component _el(String tag, List<Component> children, {String? id, String? classes, Map<String, String>? attributes}) =>
    Component.element(tag: tag, id: id, classes: classes, attributes: attributes, children: children);

Component _text(String value) => Component.text(value);
Component _link(String label, String href, {String? classes, Map<String, String>? attributes}) =>
    _el('a', [_text(label)], classes: classes, attributes: {'href': href, ...?attributes});

class AgencyPage extends StatelessComponent {
  const AgencyPage({required this.content, required this.basePath, super.key});

  final SiteContent content;
  final String basePath;

  String _t(UiTextKey key, {Map<String, String> values = const {}}) => content.t(key, values: values);
  String _href(String id) => content.locale == SiteLocale.en ? '#$id' : '$basePath${content.locale.pathSegment}/#$id';
  Component _sectionLink(String label, String id, {String? classes, Map<String, String>? attributes}) =>
      _link(label, _href(id), classes: classes, attributes: {'data-section': id, ...?attributes});

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
    attributes: {'href': _href('top'), 'data-section': 'top', 'aria-label': _t(UiTextKey.logoHome)},
  );

  Component _image(
    String source,
    String alt, {
    String? classes,
    String sizes =
        '(max-width: 480px) calc(100vw - 40px), (max-width: 860px) calc(100vw - 64px), '
        '(max-width: 1200px) calc((100vw - 64px) / 2), 568px',
  }) {
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

  Component _sectionLabel(String label) => _el('p', [_text(label)], classes: 'section-label');

  Component _heading(String title, String intro, {required String label, String? id}) => _el('div', [
    _el('div', [
      _sectionLabel(label),
      _el('h2', [_text(title)], id: id),
    ], classes: 'section-title'),
    _el('p', [_text(intro)], classes: 'section-intro'),
  ], classes: 'section-heading');

  Component _referenceHeading(String section) {
    final copy = content.sectionCopy[section]!;
    return _heading(copy.title, copy.introduction, label: copy.label);
  }

  Component _marquee({bool footer = false}) => _el(
    'div',
    [
      _el('div', [
        // Fill wide screens before the client fits the loop to the viewport.
        for (var repeat = 0; repeat < 4; repeat++)
          _el('span', [
            _text('CR8.MEDIA'),
            for (final name in content.serviceNames) ...[
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

  @override
  Component build(BuildContext context) => Component.fragment([
    _sectionLink(_t(UiTextKey.skipToContent), 'mainContent', classes: 'skip-link'),
    _header(),
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
        _el('div', [
          _link('hello@cr8.media', 'mailto:hello@cr8.media'),
          _sectionLink(_t(UiTextKey.backToTop), 'top'),
        ], classes: 'footer-links'),
        _el('small', [_text(_t(UiTextKey.footerCopy))], classes: 'footer-copy'),
      ], classes: 'wrap footer-row'),
    ], id: 'siteFooter'),
    _caseDialog(),
  ]);
  Component _header() => _el('header', [
    _el(
      'nav',
      [
        _logo(),
        _el(
          'ul',
          [
            _el('li', const [], classes: 'nav-indicator', attributes: {'aria-hidden': 'true'}),
            for (final entry in [
              (_t(UiTextKey.navServices), 'services'),
              (_t(UiTextKey.navWork), 'work'),
              (_t(UiTextKey.navProcess), 'process'),
              (_t(UiTextKey.navEngagement), 'engagement'),
              (_t(UiTextKey.navStudio), 'studio'),
              (_t(UiTextKey.navFaq), 'faq'),
            ])
              _el('li', [_sectionLink(entry.$1, entry.$2)]),
          ],
          id: 'primaryNavigation',
          classes: 'nav-links',
        ),
        _sectionLink(_t(UiTextKey.navStartProject), 'contact', classes: 'nav-cta'),
        _languageSwitcher(),
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
            'aria-label': _t(UiTextKey.openMenu),
            'aria-expanded': 'false',
            'aria-controls': 'primaryNavigation',
            'disabled': '',
          },
        ),
      ],
      classes: 'wrap',
      attributes: {'aria-label': _t(UiTextKey.navMainAria)},
    ),
  ], id: 'siteHeader');

  Component _languageSwitcher() => _el('details', [
    _el(
      'summary',
      [
        _el('strong', [_text(content.locale.nativeLabel)], attributes: {'lang': content.locale.code}),
      ],
      attributes: {'aria-label': _t(UiTextKey.languageSelectorAria)},
    ),
    _el('ul', [
      for (final locale in SiteLocale.values)
        _el('li', [
          _link(
            locale.nativeLabel,
            locale == SiteLocale.en ? basePath : '$basePath${locale.pathSegment}/',
            attributes: {
              'lang': locale.code,
              'hreflang': locale.code,
              'data-language-link': locale.code,
              'aria-label': _t(UiTextKey.languageSwitchTo, values: {'language': locale.nativeLabel}),
              if (locale == content.locale) 'aria-current': 'page',
            },
          ),
        ]),
    ]),
    _el('p', const [], classes: 'language-switch-status', attributes: {'role': 'status', 'aria-live': 'polite'}),
  ], classes: 'language-switcher');

  Component _caseDialog() => _el(
    'div',
    [
      _el('div', [
        _el('div', [
          _el(
            'button',
            [_text(_t(UiTextKey.caseClose))],
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
        _el('div', const [], id: 'cmBody', classes: 'cm-body'),
        _el('div', [
          _el('small', [_text(_t(UiTextKey.caseScrollHint))]),
          _el(
            'button',
            [_text(_t(UiTextKey.nextProject))],
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
      'aria-describedby': 'cmTag',
      'tabindex': '-1',
    },
  );
}
