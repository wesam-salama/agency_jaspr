import 'dart:async';
import 'dart:math' as math;

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../components/static_extras.dart' show serviceNames;
import '../utils/mailto.dart';
import 'case_runtime.dart';
import 'canvas_runtime.dart';
import 'dom_utils.dart';

@client
class AgencyRuntime extends StatefulComponent {
  const AgencyRuntime({super.key});

  @override
  State<AgencyRuntime> createState() => _AgencyRuntimeState();
}

class _AgencyRuntimeState extends State<AgencyRuntime> {
  AgencyDomRuntime? _runtime;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      Timer.run(() {
        if (!mounted) return;
        _runtime = AgencyDomRuntime()..mount();
      });
    }
  }

  @override
  Component build(BuildContext context) => span(
    id: 'agencyRuntime',
    attributes: const {'hidden': '', 'aria-hidden': 'true'},
    const [],
  );

  @override
  void dispose() {
    _runtime?.dispose();
    super.dispose();
  }
}

class AgencyDomRuntime {
  final EventScope _events = EventScope();
  final AnimationFrames _frames = AnimationFrames();
  final List<Timer> _timers = [];
  final Set<int> _pickedServices = {};

  late final bool reduceMotion;
  late final CaseRuntime cases;
  late final CanvasRuntime canvases;
  bool _scrollFramePending = false;
  bool _statsStarted = false;

  void mount() {
    reduceMotion = web.window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    cases = CaseRuntime(reduceMotion: reduceMotion, events: _events, frames: _frames, timers: _timers)..mount();
    canvases = CanvasRuntime(reduceMotion: reduceMotion, events: _events, frames: _frames)..mount();
    _mountMenu();
    _mountAnchorsAndRail();
    _mountContact();
    _mountConstellation();
    _mountScrollRuntime();
    _mountFooterLinks();
  }

  void _mountMenu() {
    final header = elementById<web.HTMLElement>('siteHeader');
    final burger = elementById<web.HTMLButtonElement>('burgerBtn');
    _events.listen(burger, 'click', (_) {
      final open = header.classList.toggle('open');
      burger.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
    for (final link in documentElements('.nav-links a')) {
      _events.listen(link, 'click', (_) {
        header.classList.remove('open');
        burger.setAttribute('aria-expanded', 'false');
        cases.close();
      });
    }
  }

  void _mountAnchorsAndRail() {
    for (final button in documentElements('#rail button')) {
      _events.listen(button, 'click', (_) {
        cases.close();
        final target = web.document.getElementById(button.getAttribute('data-target') ?? '');
        target?.scrollIntoView(web.ScrollIntoViewOptions(behavior: reduceMotion ? 'auto' : 'smooth'));
      });
    }

    final wire = elementById<web.SVGElement>('wire');
    final line = elementById<web.SVGElement>('wireLine');
    for (final link in documentElements('.nav-cta, .hero-ctas a')) {
      _events.listen(link, 'click', (event) {
        cases.close();
        if (reduceMotion || !event.isA<web.MouseEvent>()) return;
        final mouseEvent = event as web.MouseEvent;
        final href = link.getAttribute('href');
        if (href == null || !href.startsWith('#')) return;
        final target = web.document.getElementById(href.substring(1));
        if (target == null) return;
        final rect = target.getBoundingClientRect();
        final x2 = rect.left + math.min(240, rect.width / 2);
        final y2 = math.max(80, math.min(web.window.innerHeight - 80, rect.top + 60));
        final length = math.sqrt(math.pow(x2 - mouseEvent.clientX, 2) + math.pow(y2 - mouseEvent.clientY, 2));
        wire
          ..setAttribute('width', '${web.window.innerWidth}')
          ..setAttribute('height', '${web.window.innerHeight}');
        line
          ..setAttribute('x1', '${mouseEvent.clientX}')
          ..setAttribute('y1', '${mouseEvent.clientY}')
          ..setAttribute('x2', '$x2')
          ..setAttribute('y2', '$y2');
        line.style
          ..setProperty('transition', 'none')
          ..setProperty('stroke-dasharray', '$length')
          ..setProperty('stroke-dashoffset', '$length');
        wire.style.setProperty('opacity', '1');
        _frames.request((_) {
          line.style
            ..setProperty('transition', 'stroke-dashoffset .55s cubic-bezier(.7,0,.3,1)')
            ..setProperty('stroke-dashoffset', '0');
        });
        _timers.add(Timer(const Duration(milliseconds: 750), () => wire.style.setProperty('opacity', '0')));
      });
    }
  }

  void _mountContact() {
    final form = elementById<web.HTMLFormElement>('contactForm');
    _events.listen(form, 'submit', (event) {
      event.preventDefault();
      final uri = buildProjectMailto(
        name: elementById<web.HTMLInputElement>('name').value,
        email: elementById<web.HTMLInputElement>('email').value,
        selectedServices: [for (final index in _pickedServices.toList()..sort()) serviceNames[index]],
        message: elementById<web.HTMLTextAreaElement>('message').value,
      );
      web.window.location.href = uri;
    });
  }

  void _mountConstellation() {
    final constellation = elementById<web.HTMLElement>('constel');
    for (final hit in childElements(constellation, '.hit')) {
      void toggle() {
        final index = int.parse(hit.getAttribute('data-i')!);
        if (!_pickedServices.add(index)) _pickedServices.remove(index);
        _updateConstellation();
      }

      _events.listen(hit, 'click', (_) => toggle());
      _events.listen(hit, 'keydown', (event) {
        if (event.isA<web.KeyboardEvent>()) {
          final keyboardEvent = event as web.KeyboardEvent;
          if (keyboardEvent.key != 'Enter' && keyboardEvent.key != ' ') return;
          keyboardEvent.preventDefault();
          toggle();
        }
      });
    }
    _events.listen(elementById<web.HTMLButtonElement>('constelReset'), 'click', (_) {
      _pickedServices.clear();
      _updateConstellation();
    });
    _updateConstellation();
  }

  void _updateConstellation() {
    final selected = _pickedServices.toList()..sort();
    final constellation = elementById<web.HTMLElement>('constel');
    for (var index = 0; index < serviceNames.length; index++) {
      final enabled = _pickedServices.contains(index);
      setClass(constellation.querySelector('.cd[data-i="$index"]')!, 'sel', enabled);
      setClass(constellation.querySelector('.cl[data-i="$index"]')!, 'sel', enabled);
    }

    final shape = elementById<web.SVGElement>('constShape');
    final note = elementById<web.HTMLParagraphElement>('constelNote');
    if (selected.isEmpty) {
      shape
        ..classList.remove('on')
        ..setAttribute('points', '');
      note.textContent = 'No points selected yet.';
      return;
    }

    const centerX = 160.0;
    const centerY = 102.0;
    final points = selected
        .map((index) {
          final angle = (math.pi * 2 / serviceNames.length) * index - math.pi / 2;
          return '${centerX + math.cos(angle) * 112},${centerY + math.sin(angle) * 64}';
        })
        .join(' ');
    shape
      ..setAttribute('points', '$centerX,$centerY $points $centerX,$centerY')
      ..style.setProperty('stroke-dashoffset', '1')
      ..classList.add('on');
    _frames.request((_) => _frames.request((_) => shape.style.setProperty('stroke-dashoffset', '0')));
    note.textContent = '';
    note.append(web.document.createTextNode('You + '));
    for (var index = 0; index < selected.length; index++) {
      if (index > 0) note.append(web.document.createTextNode(' + '));
      final bold = web.document.createElement('b')..textContent = serviceNames[selected[index]];
      note.append(bold);
    }
    note.append(web.document.createTextNode(', the shape closes.'));
  }

  void _mountScrollRuntime() {
    void schedule([web.Event? _]) {
      if (_scrollFramePending) return;
      _scrollFramePending = true;
      _frames.request((_) {
        _scrollFramePending = false;
        _updateScrollRuntime();
      });
    }

    _events.listen(web.window, 'scroll', schedule, passive: true);
    _events.listen(web.window, 'resize', schedule, passive: true);
    _updateScrollRuntime();
  }

  void _updateScrollRuntime() {
    final viewportHeight = web.window.innerHeight.toDouble();
    for (final element in documentElements('.reveal:not(.in)')) {
      final rect = element.getBoundingClientRect();
      if (rect.top < viewportHeight - 60 && rect.bottom > 0) element.classList.add('in');
    }

    if (!reduceMotion) {
      final y = math.min(web.window.scrollY, 500);
      final hero = elementById<web.HTMLElement>('heroInner');
      hero.style
        ..setProperty('transform', 'translateY(${-y * .12}px)')
        ..setProperty('opacity', '${math.max(0, 1 - y / 420)}');
    }

    final timeline = elementById<web.HTMLElement>('timelineEl');
    final timelineRect = timeline.getBoundingClientRect();
    final progress = (viewportHeight * .7 - timelineRect.top).clamp(0, timelineRect.height);
    elementById<web.HTMLElement>('timelineFill').style.setProperty('height', '${progress}px');
    for (final row in documentElements('.t-row')) {
      setClass(row, 'active', (row as web.HTMLElement).offsetTop <= progress + 8);
    }

    if (!_statsStarted) {
      final stats = elementById<web.HTMLElement>('statsGrid');
      final rect = stats.getBoundingClientRect();
      final visible = math.max(0, math.min(rect.bottom, viewportHeight) - math.max(rect.top, 0));
      if (visible >= rect.height * .5) {
        _statsStarted = true;
        for (final dot in childElements(stats, 'i.onw')) {
          (dot as web.HTMLElement).style.setProperty('transition-delay', '${dot.getAttribute('data-d')}ms');
          dot.classList.add('on');
        }
      }
    }

    final links = documentElements('.nav-links a');
    if (links.isNotEmpty) {
      final midpoint = web.window.scrollY + viewportHeight * .4;
      var active = links.first;
      for (final link in links) {
        final href = link.getAttribute('href');
        final section = href == null ? null : web.document.querySelector(href);
        if (section != null && (section as web.HTMLElement).offsetTop <= midpoint) active = link;
      }
      final htmlActive = active as web.HTMLElement;
      elementById<web.HTMLElement>('navDot').style.setProperty(
        'left',
        '${htmlActive.offsetLeft + htmlActive.offsetWidth / 2}px',
      );
    }

    final documentElement = web.document.documentElement!;
    final maxScroll = documentElement.scrollHeight - web.window.innerHeight;
    (elementById<web.HTMLElement>('rail').querySelector('.rail-fill')! as web.HTMLElement).style.setProperty(
      'height',
      '${maxScroll > 0 ? web.window.scrollY / maxScroll * 100 : 0}%',
    );
    const stopIds = ['top', 'services', 'work', 'process', 'engagement', 'studio', 'faq', 'contact'];
    final railMidpoint = web.window.scrollY + viewportHeight * .5;
    var activeStop = 0;
    for (var index = 0; index < stopIds.length; index++) {
      final section = web.document.getElementById(stopIds[index]);
      if (section != null && (section as web.HTMLElement).offsetTop <= railMidpoint) activeStop = index;
    }
    final railButtons = documentElements('#rail button');
    for (var index = 0; index < railButtons.length; index++) {
      setClass(railButtons[index], 'active', index == activeStop);
      setClass(railButtons[index], 'passed', index < activeStop);
    }

    cases.updateStickyChapter();
  }

  void _mountFooterLinks() {
    for (final link in documentElements('.foot-links a')) {
      _events.listen(link, 'click', (event) => event.preventDefault());
    }
  }

  void dispose() {
    canvases.dispose();
    cases.dispose();
    for (final timer in _timers) {
      timer.cancel();
    }
    _events.dispose();
    _frames.dispose();
  }
}
