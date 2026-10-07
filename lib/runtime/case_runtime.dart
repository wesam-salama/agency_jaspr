import 'dart:async';
import 'dart:math' as math;

import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../data/site_data.dart';
import '../models/site_models.dart';
import 'dom_utils.dart';

class CaseRuntime {
  CaseRuntime({
    required this.reduceMotion,
    required this.events,
    required this.frames,
    required this.timers,
  });

  final bool reduceMotion;
  final EventScope events;
  final AnimationFrames frames;
  final List<Timer> timers;

  late final web.HTMLElement _modal;
  late final web.HTMLElement _hero;
  late final web.HTMLImageElement _heroImage;
  late final web.HTMLElement _body;
  late final web.HTMLElement _meta;
  late final web.HTMLButtonElement _next;
  late final web.HTMLElement _curtain;
  int _currentIndex = 0;
  CaseStudy? _current;

  bool get isOpen => !_modal.hasAttribute('hidden');

  void mount() {
    _modal = elementById<web.HTMLElement>('caseModal');
    _hero = elementById<web.HTMLElement>('cmHero');
    _heroImage = elementById<web.HTMLImageElement>('cmImg');
    _body = elementById<web.HTMLElement>('cmBody');
    _meta = elementById<web.HTMLElement>('cmMeta');
    _next = elementById<web.HTMLButtonElement>('cmNext');
    _curtain = elementById<web.HTMLElement>('curtain');

    for (final item in documentElements('.work-item')) {
      events.listen(item, 'click', (event) {
        event.preventDefault();
        final study = _studyForName(item.getAttribute('data-case'));
        final thumb = item.querySelector('.work-thumb')!;
        final rect = thumb.getBoundingClientRect();
        final mouse = event.isA<web.MouseEvent>() ? event as web.MouseEvent : null;
        open(study, rect, mouse?.clientX ?? web.window.innerWidth / 2, mouse?.clientY ?? web.window.innerHeight / 2);
      });
    }
    events.listen(elementById<web.HTMLButtonElement>('cmClose'), 'click', (_) => close());
    events.listen(web.window, 'keydown', (event) {
      if (event.isA<web.KeyboardEvent>() && (event as web.KeyboardEvent).key == 'Escape' && isOpen) close();
    });
    events.listen(_next, 'click', (_) {
      final nextStudy = caseStudies[(_currentIndex + 1) % caseStudies.length];
      final rect = _next.getBoundingClientRect();
      open(nextStudy, rect, rect.left + rect.width / 2, rect.top + rect.height / 2);
    });
    events.listen(_modal, 'scroll', (_) => updateStickyChapter(), passive: true);
  }

  CaseStudy _studyForName(String? name) => caseStudies.firstWhere((study) => study.name == name);

  void open(CaseStudy study, web.DOMRect rect, num cursorX, num cursorY) {
    _modal.classList
      ..remove('tunnel-in')
      ..remove('tunnel-settled');
    _modal.style
      ..setProperty('clip-path', '')
      ..setProperty('transition', '');

    if (reduceMotion) {
      _populate(study);
      _show();
      return;
    }

    if (study.transition == CaseTransition.accentCurtain) {
      _curtain.style.setProperty('transform-origin', 'left center');
      _curtain.classList.add('cover');
      timers.add(
        Timer(const Duration(milliseconds: 580), () {
          _populate(study);
          _show();
          _curtain.style.setProperty('transform-origin', 'right center');
          _curtain.classList.remove('cover');
        }),
      );
      return;
    }

    _populate(study);
    _show();
    switch (study.transition) {
      case CaseTransition.sharedElementExpand:
        _sharedElementTransition(study, rect);
      case CaseTransition.cursorIris:
        _irisTransition(cursorX, cursorY);
      case CaseTransition.tunnelZoom:
        _tunnelTransition(study, rect);
      case CaseTransition.accentCurtain:
        break;
    }
  }

  void _populate(CaseStudy study) {
    _current = study;
    _currentIndex = caseStudies.indexOf(study);
    _heroImage
      ..src = study.heroImage
      ..alt = study.name;
    elementById<web.HTMLElement>('cmTag').textContent = study.tag;
    elementById<web.HTMLElement>('cmTitle').textContent = study.name;
    _meta.textContent = '';
    for (final entry in <(String, String)>[
      ('Client', study.client),
      ('Role', study.role),
      ('Timeline', study.timeline),
      ('Deliverables', study.deliverables),
    ]) {
      final item = _element('div');
      item
        ..append(_element('span', classes: 'k', text: entry.$1))
        ..append(_element('span', classes: 'v', text: entry.$2));
      _meta.append(item);
    }
    _renderBody(study);
    _modal.scrollTop = 0;
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
    _appendFigures(content, study.figures);
    if (study.quote case final quote?) content.append(_quote(quote));
    split
      ..append(aside)
      ..append(content);
    _body.append(split);
  }

  void _renderHorizontal(CaseStudy study) {
    _appendParagraphs(_body, study.paragraphs);
    final scroller = _element('div', classes: 'cm-hscroll');
    for (final chapter in study.chapters) {
      final card = _element('div', classes: 'cm-hch');
      card
        ..append(_image(chapter.image))
        ..append(_element('div', classes: 'cap', text: '${chapter.number} ${chapter.title}'));
      scroller.append(card);
    }
    _body
      ..append(scroller)
      ..append(_element('p', classes: 'cm-hint', text: '← drag / scroll →'));
    if (study.quote case final quote?) _body.append(_quote(quote));
  }

  void _renderSticky(CaseStudy study) {
    final sticky = _element('div', classes: 'cm-sticky');
    final left = _element('div', classes: 'cm-stickyleft');
    left
      ..append(_element('div', id: 'chNum', classes: 'chn', text: study.chapters.first.number))
      ..append(_element('div', id: 'chTitle', classes: 'cht', text: study.chapters.first.title))
      ..append(_element('div', classes: 'chp', text: 'Scroll the chapters →'));
    final chapters = _element('div');
    for (final chapter in study.chapters) {
      final block = _element(
        'div',
        classes: 'cm-chblock',
        attributes: {'data-ch': chapter.number, 'data-title': chapter.title},
      );
      block
        ..append(_image(chapter.image))
        ..append(_element('p', text: chapter.body ?? ''));
      chapters.append(block);
    }
    sticky
      ..append(left)
      ..append(chapters);
    _body.append(sticky);
  }

  void _renderStatistics(CaseStudy study) {
    final metrics = _element('div', classes: 'cm-stats');
    for (final metric in study.metrics) {
      final card = _element('div');
      card
        ..append(
          _element(
            'div',
            classes: 'n',
            text: '0${metric.suffix}',
            attributes: {
              'data-count': '${metric.target}',
              'data-suffix': metric.suffix,
              'data-dec': '${metric.decimals}',
            },
          ),
        )
        ..append(_element('div', classes: 'l', text: metric.label));
      metrics.append(card);
    }
    _body.append(metrics);
    _appendParagraphs(_body, study.paragraphs);
    _appendFigures(_body, study.figures);
    if (study.quote case final quote?) _body.append(_quote(quote));
    _runCounts(study);
  }

  void _appendParagraphs(web.HTMLElement parent, List<String> paragraphs) {
    for (final paragraph in paragraphs) {
      parent.append(_element('p', classes: 'cm-paras', text: paragraph));
    }
  }

  void _appendFigures(web.HTMLElement parent, List<CaseFigure> figures) {
    for (final figure in figures) {
      final element = _element('figure', classes: 'cm-fig');
      element
        ..append(_image(figure.image))
        ..append(_element('figcaption', text: figure.caption));
      parent.append(element);
    }
  }

  web.HTMLElement _quote(CaseQuote quote) {
    final element = _element('blockquote', classes: 'cm-quote');
    element
      ..append(web.document.createTextNode(quote.text))
      ..append(_element('footer', text: quote.attribution));
    return element;
  }

  web.HTMLImageElement _image(String src) {
    final image = web.document.createElement('img') as web.HTMLImageElement;
    return image
      ..src = src
      ..alt = ''
      ..loading = 'lazy';
  }

  web.HTMLElement _element(
    String tag, {
    String? id,
    String? classes,
    String? text,
    Map<String, String>? attributes,
  }) {
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

  void _runCounts(CaseStudy study) {
    final elements = childElements(_body, '[data-count]');
    for (var index = 0; index < elements.length; index++) {
      final element = elements[index] as web.HTMLElement;
      final metric = study.metrics[index];
      if (reduceMotion) {
        element.textContent = '${_formatMetric(metric.target, metric.decimals)}${metric.suffix}';
        continue;
      }
      num? start;
      void animate(num time) {
        start ??= time;
        final progress = math.min(1, (time - start!) / 1300);
        final eased = 1 - math.pow(1 - progress, 3);
        element.textContent = '${_formatMetric(metric.target * eased, metric.decimals)}${metric.suffix}';
        if (progress < 1 && _current == study && isOpen) frames.request(animate);
      }

      frames.request(animate);
    }
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

  void updateStickyChapter() {
    if (!isOpen || _current?.layout != CaseLayout.stickyChapters) return;
    final blocks = childElements(_body, '.cm-chblock');
    web.Element? best;
    var bestVisible = 0.0;
    for (final block in blocks) {
      final rect = block.getBoundingClientRect();
      final visible = math.max(0, math.min(rect.bottom, web.window.innerHeight) - math.max(rect.top, 0)).toDouble();
      if (visible >= rect.height * .5 && visible > bestVisible) {
        best = block;
        bestVisible = visible;
      }
    }
    if (best != null) {
      elementById<web.HTMLElement>('chNum').textContent = best.getAttribute('data-ch');
      elementById<web.HTMLElement>('chTitle').textContent = best.getAttribute('data-title');
    }
  }

  void _show() {
    _modal.removeAttribute('hidden');
    web.document.body!.style.setProperty('overflow', 'hidden');
    web.document.body!.classList.add('modal-open');
    _modal.scrollTop = 0;
    frames.request((_) => updateStickyChapter());
  }

  web.HTMLImageElement _flyClone(String src, web.DOMRect rect) {
    final clone = web.document.createElement('img') as web.HTMLImageElement;
    clone
      ..src = src
      ..className = 'fly';
    clone.style
      ..setProperty('left', '${rect.left}px')
      ..setProperty('top', '${rect.top}px')
      ..setProperty('width', '${rect.width}px')
      ..setProperty('height', '${rect.height}px');
    web.document.body!.append(clone);
    return clone;
  }

  void _sharedElementTransition(CaseStudy study, web.DOMRect rect) {
    _heroImage.style.setProperty('opacity', '0');
    final clone = _flyClone(study.heroImage, rect);
    final heroRect = _hero.getBoundingClientRect();
    frames.request(
      (_) => frames.request((_) {
        clone.style
          ..setProperty('left', '${heroRect.left}px')
          ..setProperty('top', '${heroRect.top}px')
          ..setProperty('width', '${heroRect.width}px')
          ..setProperty('height', '${heroRect.height}px');
      }),
    );
    timers.add(
      Timer(const Duration(milliseconds: 680), () {
        _heroImage.style.setProperty('opacity', '1');
        clone.remove();
      }),
    );
  }

  void _irisTransition(num cursorX, num cursorY) {
    _modal.style.setProperty('clip-path', 'circle(0px at ${cursorX}px ${cursorY}px)');
    frames.request(
      (_) => frames.request((_) {
        _modal.style
          ..setProperty('transition', 'clip-path .8s cubic-bezier(.7,0,.3,1)')
          ..setProperty('clip-path', 'circle(140% at ${cursorX}px ${cursorY}px)');
      }),
    );
    timers.add(
      Timer(const Duration(milliseconds: 900), () {
        _modal.style
          ..setProperty('transition', '')
          ..setProperty('clip-path', '');
      }),
    );
  }

  void _tunnelTransition(CaseStudy study, web.DOMRect rect) {
    _modal.classList.add('tunnel-in');
    final clone = _flyClone(study.heroImage, rect);
    frames.request(
      (_) => frames.request((_) {
        final moveX = web.window.innerWidth / 2 - (rect.left + rect.width / 2);
        final moveY = web.window.innerHeight / 2 - (rect.top + rect.height / 2);
        clone.style
          ..setProperty('transform', 'translate(${moveX}px,${moveY}px) scale(1.6)')
          ..setProperty('filter', 'blur(6px)')
          ..setProperty('opacity', '0');
        _modal.classList.add('tunnel-settled');
      }),
    );
    timers.add(
      Timer(const Duration(milliseconds: 750), () {
        clone.remove();
        _modal.classList
          ..remove('tunnel-in')
          ..remove('tunnel-settled');
      }),
    );
  }

  void close() {
    if (!isOpen) return;
    _modal.setAttribute('hidden', '');
    web.document.body!.style.setProperty('overflow', '');
    web.document.body!.classList.remove('modal-open');
    _modal.classList
      ..remove('tunnel-in')
      ..remove('tunnel-settled');
    _modal.style.setProperty('clip-path', '');
  }

  void dispose() {
    close();
  }
}
