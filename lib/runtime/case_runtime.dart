import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../data/site_data.dart';
import '../models/site_models.dart';
import '../utils/image_assets.dart';
import 'case_transition.dart';
import 'dom_utils.dart';
import 'motion_runtime.dart';
import 'motion_state.dart';

class CaseRuntime {
  CaseRuntime({required this.motion, required this.events});

  final MotionRuntime motion;
  final EventScope events;
  bool get reduceMotion => motion.reduced;
  final Map<web.HTMLElement, String?> _previousInert = {};
  final Map<web.Element, double> _chapterVisibility = {};
  late final web.HTMLElement _modal;
  late final web.HTMLImageElement _heroImage;
  late final web.HTMLElement _title;
  late final web.HTMLElement _body;
  late final web.HTMLElement _meta;
  late final web.HTMLButtonElement _next;
  late final CaseTransitionTransaction _transition;
  EventScope? _contentEvents;
  web.IntersectionObserver? _chapterObserver;
  web.IntersectionObserver? _metricObserver;
  final MotionGeneration _contentGeneration = MotionGeneration();
  final MotionGeneration _countGeneration = MotionGeneration();
  final List<(web.HTMLElement, CaseMetric)> _metricValues = [];
  void Function()? _cancelCountFrames;
  bool _countsStarted = false;
  web.HTMLElement? _opener;
  CaseStudy? _current;
  int _currentIndex = 0;
  bool _backgroundLocked = false;
  bool _previousModalClass = false;
  bool _disposed = false;
  String _previousOverflow = '';
  String _previousOverflowPriority = '';

  bool get isOpen => !_modal.hasAttribute('hidden');

  void mount() {
    _modal = elementById<web.HTMLElement>('caseModal');
    _heroImage = elementById<web.HTMLImageElement>('cmImg');
    _title = elementById<web.HTMLElement>('cmTitle');
    _body = elementById<web.HTMLElement>('cmBody');
    _meta = elementById<web.HTMLElement>('cmMeta');
    _next = elementById<web.HTMLButtonElement>('cmNext');
    _transition = CaseTransitionTransaction(
      modal: _modal,
      presentation: elementById<web.HTMLElement>('cmPresentation'),
      image: _heroImage,
    );
    motion.addPolicyListener(_handleMotionPolicy);
    for (final item in documentElements('button.work-item[data-case]')) {
      events.listen(item, 'click', (event) {
        final name = item.getAttribute('data-case');
        final matches = caseStudies.where((study) => study.name == name);
        if (matches.isNotEmpty) {
          final trigger = item as web.HTMLElement;
          open(
            matches.first,
            opener: trigger,
            activation: _activationFor(trigger, event: event),
          );
        }
      });
      (item as web.HTMLButtonElement).disabled = false;
    }
    events.listen(elementById<web.HTMLButtonElement>('cmClose'), 'click', (_) => close());
    events.listen(_next, 'click', (_) {
      final activation = ActivationGeometry.capture(_heroImage, _next, useTriggerCenter: true);
      open(caseStudies[(_currentIndex + 1) % caseStudies.length], activation: activation);
    });
    events.listen(web.window, 'resize', (_) {
      _transition.cancel();
      _settleCounts();
    });
    events.listen(_modal, 'click', (event) {
      if (event.target == _modal) close();
    });
    events.listen(web.document, 'keydown', (event) {
      if (!isOpen || !event.isA<web.KeyboardEvent>()) return;
      final key = event as web.KeyboardEvent;
      if (key.key == 'Escape') {
        key.preventDefault();
        close();
      } else if (key.key == 'Tab') {
        _trapFocus(key);
      }
    });
    events.listen(web.document, 'focusin', (event) {
      final target = event.target;
      if (isOpen && target != null && target.isA<web.Node>() && !_modal.contains(target as web.Node)) {
        _title.focus(web.FocusOptions(preventScroll: true));
      }
    });
  }

  ActivationGeometry? _activationFor(web.HTMLElement trigger, {web.Event? event}) {
    final source = trigger.querySelector('.work-thumb img');
    if (source == null || !source.isA<web.HTMLImageElement>()) return null;
    return ActivationGeometry.capture(source as web.HTMLImageElement, trigger, event: event);
  }

  void open(CaseStudy study, {web.HTMLElement? opener, ActivationGeometry? activation}) {
    if (_disposed) return;
    activation ??= opener != null
        ? _activationFor(opener)
        : (isOpen ? ActivationGeometry.capture(_heroImage, _next, useTriggerCenter: true) : null);
    _cancelTransientWork();
    if (!isOpen) {
      final active = web.document.activeElement;
      _opener = opener ?? (active != null && active.isA<web.HTMLElement>() ? active as web.HTMLElement : null);
      _lockBackground();
      motion.setModalOpen(true);
    }
    _populate(study);
    _modal.removeAttribute('hidden');
    _modal.scrollTop = 0;
    _title.focus(web.FocusOptions(preventScroll: true));
    if (!reduceMotion && motion.documentVisible) _transition.run(study.transition, activation);
  }

  void _populate(CaseStudy study) {
    _current = study;
    _currentIndex = caseStudies.indexOf(study);
    _countsStarted = false;
    final token = _contentGeneration.begin();
    _contentEvents = EventScope();
    _applyImage(_heroImage, study.heroImage, '${study.name} illustrative project imagery', loading: 'eager');
    _heroImage.removeAttribute('hidden');
    _contentEvents!.listen(_heroImage, 'error', (_) {
      if (_contentGeneration.accepts(token)) _transition.cancel();
    });
    _title.textContent = study.name;
    elementById<web.HTMLElement>('cmTag').textContent = study.tag;
    elementById<web.HTMLElement>('cmExample').textContent = study.isIllustrative
        ? 'Illustrative case study'
        : 'Case study';
    elementById<web.HTMLElement>('cmDescription').textContent = study.isIllustrative
        ? 'Names, testimonials, timelines and results are illustrative, not verified client evidence. Images are visual references, not finished deliverables.'
        : 'Project scope, timeline and results.';
    _meta.textContent = '';
    for (final entry in <(String, String)>[
      (study.isIllustrative ? 'Example client' : 'Client', study.client),
      ('Role', study.role),
      (study.isIllustrative ? 'Example timeline' : 'Timeline', study.timeline),
      ('Deliverables', study.deliverables),
    ]) {
      final item = _element('div');
      item
        ..append(_element('span', classes: 'k', text: entry.$1))
        ..append(_element('span', classes: 'v', text: entry.$2));
      _meta.append(item);
    }
    _renderBody(study);
    final next = caseStudies[(_currentIndex + 1) % caseStudies.length];
    _next.textContent = '${next.isIllustrative ? 'Next example' : 'Next project'}: ${next.name}';
  }

  void _renderBody(CaseStudy study) {
    _body.textContent = '';
    final lede = _element('p', classes: 'cm-lede');
    lede
      ..append(web.document.createTextNode(study.lede.before))
      ..append(_element('em', text: study.lede.emphasis))
      ..append(web.document.createTextNode(study.lede.after));
    _body.append(lede);
    switch (study.layout) {
      case CaseLayout.split:
        _renderSplit(study);
      case CaseLayout.horizontalScroll:
        _renderHorizontal(study);
      case CaseLayout.stickyChapters:
        _renderSticky(study);
      case CaseLayout.statistics:
        _renderStatistics(study);
    }
  }

  void _renderSplit(CaseStudy study) {
    final split = _element('div', classes: 'cm-split');
    final aside = _element('aside', classes: 'cm-side');
    for (final fact in study.facts) {
      final row = _element('div', classes: 'sk');
      row
        ..append(_element('span', classes: 'k', text: fact.label))
        ..append(_element('span', classes: 'v', text: fact.value));
      aside.append(row);
    }
    final content = _element('div');
    _appendParagraphs(content, study.paragraphs);
    _appendFigures(content, study);
    if (study.quote case final quote?) content.append(_quote(quote, study));
    split
      ..append(aside)
      ..append(content);
    _body.append(split);
  }

  void _renderHorizontal(CaseStudy study) {
    _appendParagraphs(_body, study.paragraphs);
    final scroller = _element(
      'div',
      classes: 'cm-hscroll',
      attributes: {
        'tabindex': '0',
        'role': 'region',
        'aria-label': '${study.name} project chapters; use left and right arrow keys to scroll',
      },
    );
    for (final chapter in study.chapters) {
      final card = _element('figure', classes: 'cm-hch');
      card
        ..append(
          _image(chapter.image, '${study.name} example: ${chapter.title}', sizes: '(max-width: 860px) 90vw, 520px'),
        )
        ..append(_element('figcaption', classes: 'cap', text: 'Visual reference · ${chapter.number} ${chapter.title}'));
      if (chapter.body case final body?) card.append(_element('p', text: body));
      scroller.append(card);
    }
    _contentEvents!.listen(scroller, 'keydown', (event) {
      if (!event.isA<web.KeyboardEvent>() || event.target != scroller) return;
      final key = event as web.KeyboardEvent;
      if (key.key != 'ArrowLeft' && key.key != 'ArrowRight' && key.key != 'Home' && key.key != 'End') return;
      key.preventDefault();
      if (key.key == 'Home') {
        scroller.scrollLeft = 0;
      } else if (key.key == 'End') {
        scroller.scrollLeft = scroller.scrollWidth.toDouble();
      } else {
        final step = scroller.clientWidth * .8 * (key.key == 'ArrowLeft' ? -1 : 1);
        scroller.scrollBy(web.ScrollToOptions(left: step, behavior: reduceMotion ? 'auto' : 'smooth'));
      }
    });
    _body
      ..append(scroller)
      ..append(
        _element(
          'p',
          classes: 'cm-hint',
          text: 'Scroll the chapters sideways, or focus them and use the left and right arrow keys.',
        ),
      );
    if (study.quote case final quote?) _body.append(_quote(quote, study));
  }

  void _renderSticky(CaseStudy study) {
    final sticky = _element('div', classes: 'cm-sticky');
    final left = _element('div', classes: 'cm-stickyleft', attributes: {'aria-hidden': 'true'});
    if (study.chapters.isNotEmpty) {
      left
        ..append(_element('div', id: 'chNum', classes: 'chn', text: study.chapters.first.number))
        ..append(_element('div', id: 'chTitle', classes: 'cht', text: study.chapters.first.title))
        ..append(_element('div', classes: 'chp', text: 'Explore the chapters'));
    }
    final chapters = _element('div');
    final blocks = <web.HTMLElement>[];
    for (final chapter in study.chapters) {
      final block = _element(
        'section',
        classes: 'cm-chblock',
        attributes: {
          'data-ch': chapter.number,
          'data-title': chapter.title,
        },
      );
      block
        ..append(_element('h3', text: '${chapter.number} ${chapter.title}'))
        ..append(
          _image(chapter.image, '${study.name} example: ${chapter.title}', sizes: '(max-width: 860px) 90vw, 680px'),
        );
      if (chapter.body case final body?) block.append(_element('p', text: body));
      block.append(_element('p', classes: 'content-note', text: 'Visual reference for this concept direction.'));
      chapters.append(block);
      blocks.add(block);
    }
    sticky
      ..append(left)
      ..append(chapters);
    _body.append(sticky);
    _observeChapters(blocks);
    if (study.quote case final quote?) _body.append(_quote(quote, study));
  }

  void _observeChapters(List<web.HTMLElement> blocks) {
    final token = _contentGeneration.current;
    try {
      _chapterObserver = web.IntersectionObserver(
        ((JSArray<web.IntersectionObserverEntry> entries, web.IntersectionObserver observer) {
          if (!_contentGeneration.accepts(token) || !isOpen || _current?.layout != CaseLayout.stickyChapters) return;
          for (final entry in entries.toDart) {
            _chapterVisibility[entry.target] = entry.isIntersecting ? entry.intersectionRatio : 0;
          }
          web.Element? current;
          var largestRatio = 0.0;
          for (final entry in _chapterVisibility.entries) {
            if (entry.value > largestRatio) {
              current = entry.key;
              largestRatio = entry.value;
            }
          }
          if (current != null) {
            web.document.getElementById('chNum')?.textContent = current.getAttribute('data-ch');
            web.document.getElementById('chTitle')?.textContent = current.getAttribute('data-title');
          }
        }).toJS,
        web.IntersectionObserverInit(
          root: _modal,
          threshold: [0, .25, .5, .75, 1].map((value) => value.toJS).toList().toJS,
        ),
      );
      for (final block in blocks) {
        _chapterObserver!.observe(block);
      }
    } catch (_) {
      // Every chapter has its own heading when observation is unavailable.
      _chapterObserver?.disconnect();
      _chapterObserver = null;
    }
  }

  void _renderStatistics(CaseStudy study) {
    if (study.isIllustrative) {
      _body.append(
        _element(
          'p',
          classes: 'content-note',
          text: 'Illustrative results for this example, not verified client outcomes.',
        ),
      );
    }
    final metrics = _element(
      'div',
      classes: 'cm-stats',
      attributes: {'role': 'group', 'aria-label': study.isIllustrative ? 'Illustrative results' : 'Results'},
    );
    for (final metric in study.metrics) {
      final card = _element('div');
      final value = '${_formatMetric(metric.target, metric.decimals)}${metric.suffix}';
      final number = _element('div', classes: 'n');
      final visualValue = _element('span', text: value, attributes: {'aria-hidden': 'true'});
      number
        ..append(_element('span', classes: 'visually-hidden', text: value))
        ..append(visualValue);
      _metricValues.add((visualValue, metric));
      card
        ..append(number)
        ..append(_element('div', classes: 'l', text: metric.label));
      metrics.append(card);
    }
    _body.append(metrics);
    _observeMetrics(metrics, study);
    _appendParagraphs(_body, study.paragraphs);
    _appendFigures(_body, study);
    if (study.quote case final quote?) _body.append(_quote(quote, study));
  }

  void _observeMetrics(web.HTMLElement metrics, CaseStudy study) {
    if (reduceMotion || !motion.documentVisible || study.metrics.isEmpty) return;
    final token = _contentGeneration.current;
    try {
      _metricObserver = web.IntersectionObserver(
        ((JSArray<web.IntersectionObserverEntry> entries, web.IntersectionObserver observer) {
          if (!_contentGeneration.accepts(token) || _disposed || !isOpen || _current != study) return;
          for (final entry in entries.toDart) {
            if (entry.target != metrics) continue;
            if (entry.isIntersecting && entry.intersectionRatio >= .25) {
              _startCounts();
            } else if (_countsStarted) {
              // A single bounded run settles if the visitor scrolls away.
              _settleCounts();
            }
          }
        }).toJS,
        web.IntersectionObserverInit(root: _modal, threshold: [0.toJS, .25.toJS].toJS),
      );
      _metricObserver!.observe(metrics);
    } catch (_) {
      _settleCounts();
    }
  }

  void _startCounts() {
    if (_countsStarted || reduceMotion || !motion.documentVisible || !isOpen) return;
    _countsStarted = true;
    final token = _countGeneration.begin();
    double? startedAt;
    for (final (element, metric) in _metricValues) {
      element.textContent = '${_formatMetric(0, metric.decimals)}${metric.suffix}';
    }
    _cancelCountFrames = motion.registerFrameTask((timestamp) {
      if (!_countGeneration.accepts(token) || _disposed || !isOpen) return;
      startedAt ??= timestamp;
      final progress = ((timestamp - startedAt!) / 1300).clamp(0.0, 1.0);
      final inverse = 1 - progress;
      final eased = 1 - inverse * inverse * inverse;
      for (final (element, metric) in _metricValues) {
        element.textContent = '${_formatMetric(metric.target * eased, metric.decimals)}${metric.suffix}';
      }
      if (progress >= 1) _settleCounts();
    });
  }

  void _settleCounts() {
    _countsStarted = true;
    _countGeneration.cancel();
    _cancelCountFrames?.call();
    _cancelCountFrames = null;
    _metricObserver?.disconnect();
    _metricObserver = null;
    for (final (element, metric) in _metricValues) {
      element.textContent = '${_formatMetric(metric.target, metric.decimals)}${metric.suffix}';
    }
  }

  void _handleMotionPolicy() {
    _transition.cancel();
    _settleCounts();
  }

  void _appendParagraphs(web.HTMLElement parent, List<String> paragraphs) {
    for (final paragraph in paragraphs) {
      parent.append(_element('p', classes: 'cm-paras', text: paragraph));
    }
  }

  void _appendFigures(web.HTMLElement parent, CaseStudy study) {
    for (final figure in study.figures) {
      final element = _element('figure', classes: 'cm-fig');
      element
        ..append(_image(figure.image, '${study.name} example: ${figure.caption}'))
        ..append(_element('figcaption', text: figure.caption));
      parent.append(element);
    }
  }

  web.HTMLElement _quote(CaseQuote quote, CaseStudy study) {
    final element = _element('blockquote', classes: 'cm-quote');
    if (study.isIllustrative) {
      element.append(_element('span', classes: 'example-label', text: 'Illustrative testimonial'));
    }
    element
      ..append(_element('p', text: quote.text))
      ..append(_element('footer', text: quote.attribution));
    return element;
  }

  web.HTMLImageElement _image(String source, String alt, {String sizes = '(max-width: 860px) 90vw, 960px'}) {
    final image = web.document.createElement('img') as web.HTMLImageElement;
    _applyImage(image, source, alt, sizes: sizes);
    return image;
  }

  void _applyImage(
    web.HTMLImageElement image,
    String source,
    String alt, {
    String sizes = '(max-width: 860px) 100vw, 1200px',
    String loading = 'lazy',
  }) {
    final asset = imageAssetFor(source);
    image
      ..alt = alt
      ..decoding = 'async'
      ..loading = loading
      ..sizes = sizes;
    if (asset != null) {
      image
        ..width = asset.width
        ..height = asset.height
        ..srcset = asset.srcSet
        ..src = asset.src;
    } else {
      image
        ..removeAttribute('srcset')
        ..removeAttribute('width')
        ..removeAttribute('height')
        ..src = source;
    }
  }

  web.HTMLElement _element(String tag, {String? id, String? classes, String? text, Map<String, String>? attributes}) {
    final element = web.document.createElement(tag) as web.HTMLElement;
    if (id != null) element.id = id;
    if (classes != null) element.className = classes;
    if (text != null) element.textContent = text;
    if (attributes != null) {
      for (final entry in attributes.entries) {
        element.setAttribute(entry.key, entry.value);
      }
    }
    return element;
  }

  String _formatMetric(num value, int decimals) {
    if (decimals > 0) return value.toStringAsFixed(decimals);
    final digits = value.round().toString();
    final output = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      if (index > 0 && (digits.length - index) % 3 == 0) output.write(',');
      output.write(digits[index]);
    }
    return output.toString();
  }

  void _trapFocus(web.KeyboardEvent event) {
    final focusable =
        childElements(
              _modal,
              'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])',
            )
            .where((element) => element.getClientRects().length > 0 && element.closest('[hidden], [inert]') == null)
            .cast<web.HTMLElement>()
            .toList();
    if (focusable.isEmpty) {
      event.preventDefault();
      _title.focus();
      return;
    }
    final active = web.document.activeElement;
    final index = focusable.indexWhere((element) => element == active);
    if (index < 0 || (!event.shiftKey && index == focusable.length - 1) || (event.shiftKey && index == 0)) {
      event.preventDefault();
      (event.shiftKey ? focusable.last : focusable.first).focus();
    }
  }

  void _lockBackground() {
    if (_backgroundLocked) return;
    _backgroundLocked = true;
    for (final element in documentElements(
      '#siteHeader, #mainContent, #siteFooter, .skip-link',
    ).cast<web.HTMLElement>()) {
      _previousInert[element] = element.getAttribute('inert');
      element.setAttribute('inert', '');
    }
    final body = web.document.body!;
    _previousOverflow = body.style.getPropertyValue('overflow');
    _previousOverflowPriority = body.style.getPropertyPriority('overflow');
    _previousModalClass = body.classList.contains('modal-open');
    body.style.setProperty('overflow', 'hidden');
    body.classList.add('modal-open');
  }

  void _cancelTransientWork() {
    _contentGeneration.cancel();
    _transition.cancel();
    _settleCounts();
    _metricValues.clear();
    _countsStarted = false;
    _chapterObserver?.disconnect();
    _chapterObserver = null;
    _chapterVisibility.clear();
    _contentEvents?.dispose();
    _contentEvents = null;
  }

  void close() {
    _cancelTransientWork();
    final wasOpen = isOpen;
    _modal.setAttribute('hidden', '');
    if (_backgroundLocked) {
      for (final entry in _previousInert.entries) {
        if (entry.value == null) {
          entry.key.removeAttribute('inert');
        } else {
          entry.key.setAttribute('inert', entry.value!);
        }
      }
      _previousInert.clear();
      final body = web.document.body!;
      if (_previousOverflow.isEmpty) {
        body.style.removeProperty('overflow');
      } else {
        body.style.setProperty('overflow', _previousOverflow, _previousOverflowPriority);
      }
      setClass(body, 'modal-open', _previousModalClass);
      _backgroundLocked = false;
    }
    if (wasOpen) {
      final opener = _opener;
      if (opener != null && opener.isConnected && opener.closest('[inert]') == null) {
        opener.focus(web.FocusOptions(preventScroll: true));
      } else {
        final main = web.document.getElementById('mainContent');
        if (main != null && main.isA<web.HTMLElement>()) {
          (main as web.HTMLElement).focus(web.FocusOptions(preventScroll: true));
        }
      }
    }
    _opener = null;
    motion.setModalOpen(false);
  }

  void dispose() {
    _disposed = true;
    close();
    motion.removePolicyListener(_handleMotionPolicy);
    _transition.dispose();
    _contentGeneration.dispose();
    _countGeneration.dispose();
  }
}
