import 'dart:math' as math;

import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import 'dom_utils.dart';
import 'motion_state.dart';

/// Owns motion preferences, visibility and the page's single canvas scheduler.
class MotionRuntime {
  MotionRuntime({required this.events});

  final EventScope events;
  final MotionState state = MotionState();
  final Set<void Function()> _listeners = {};
  final Map<int, (void Function(double), bool)> _tasks = {};
  final Map<web.Element, bool> _visibility = {};
  final Map<web.Element, web.Animation> _animations = {};
  final List<double> _frameCosts = [];
  late final web.MediaQueryList _reduction;
  late final web.HTMLElement _body;
  late final List<web.Element> _loops;
  late final List<web.HTMLButtonElement> _toggles;
  web.IntersectionObserver? _observer;
  web.PerformanceObserver? _performanceObserver;
  _HeroMotion? _hero;
  final List<_PortfolioMotion> _portfolio = [];
  web.HTMLElement? _navIndicator;
  web.HTMLElement? _navLink;
  web.Element? _wire;
  int? _frame;
  int _taskId = 0;
  int _frameCount = 0;
  int _longTasks = 0;
  double _longTaskMax = 0;
  double _lastTime = 0;
  double deltaSeconds = 0;
  bool _disposed = false;
  bool _profile = false;
  bool _longTaskSupported = false;
  String accent = '#ff4433';
  String foreground = '#f3f3f0';

  bool get reduced => state.reduced;
  bool get documentVisible => state.documentVisible;
  bool get ambientAllowed => state.ambientAllowed;
  bool isVisible(web.Element element) => _visibility[element] ?? false;

  void mount() {
    _body = web.document.body!;
    final palette = web.window.getComputedStyle(_body);
    final accentToken = palette.getPropertyValue('--accent').trim();
    final foregroundToken = palette.getPropertyValue('--fg').trim();
    if (accentToken.isNotEmpty) accent = accentToken;
    if (foregroundToken.isNotEmpty) foreground = foregroundToken;
    _reduction = web.window.matchMedia('(prefers-reduced-motion: reduce)');
    var paused = false;
    try {
      paused = web.window.sessionStorage.getItem('cr8-motion-paused') == 'true';
    } catch (_) {
      // A blocked storage API must not affect the controls or static page.
    }
    state.update(reducedBySystem: _reduction.matches, userPaused: paused, documentVisible: !web.document.hidden);
    _loops = documentElements('[data-motion-loop]');
    _toggles = documentElements('.motion-toggle').cast<web.HTMLButtonElement>();
    events.listen(_reduction, 'change', (_) => _change(reducedBySystem: _reduction.matches));
    events.listen(web.document, 'visibilitychange', (_) => _change(documentVisible: !web.document.hidden));
    for (final button in _toggles) {
      events.listen(button, 'click', (_) {
        _change(userPaused: !state.userPaused);
        try {
          web.window.sessionStorage.setItem('cr8-motion-paused', '${state.userPaused}');
        } catch (_) {
          // Preferences still work for the current page when storage is blocked.
        }
      });
      button.disabled = false;
    }
    _profile = web.window.location.search.contains('motionProfile=1');
    if (_profile) _mountProfiling();
    _mountVisibility();
    final network = web.document.querySelector('.hero-network');
    if (network != null) _hero = _HeroMotion(this, network as web.HTMLElement)..mount();
    var index = 0;
    for (final thumb in documentElements('.work-thumb')) {
      _portfolio.add(_PortfolioMotion(this, thumb as web.HTMLElement, ++index)..mount());
    }
    _mountSupportingMotion();
    _sync();
  }

  void addPolicyListener(void Function() listener) => _listeners.add(listener);
  void removePolicyListener(void Function() listener) => _listeners.remove(listener);

  void setModalOpen(bool open) => _change(modalOpen: open);

  void _change({bool? reducedBySystem, bool? userPaused, bool? documentVisible, bool? modalOpen}) {
    if (_disposed) return;
    if (!state.update(
      reducedBySystem: reducedBySystem,
      userPaused: userPaused,
      documentVisible: documentVisible,
      modalOpen: modalOpen,
    )) {
      return;
    }
    if (!ambientAllowed) _cancelAnimations();
    _sync();
  }

  void _mountVisibility() {
    try {
      _observer = web.IntersectionObserver(
        ((JSArray<web.IntersectionObserverEntry> entries, web.IntersectionObserver observer) {
          for (final entry in entries.toDart) {
            _visibility[entry.target] = entry.isIntersecting;
          }
          _sync(notifyPolicy: false);
        }).toJS,
        web.IntersectionObserverInit(threshold: 0.toJS),
      );
      for (final element in _loops) {
        _observer!.observe(element);
      }
    } catch (_) {
      // Without observation, retain static artwork rather than invisible loops.
      _observer?.disconnect();
      _observer = null;
    }
  }

  void _sync({bool notifyPolicy = true}) {
    if (_disposed) return;
    setClass(_body, 'motion-reduced', state.reducedBySystem);
    setClass(_body, 'motion-paused', state.userPaused);
    final root = web.document.documentElement!;
    setClass(root, 'motion-reduced', state.reducedBySystem);
    setClass(root, 'motion-paused', state.userPaused);
    final status = state.reducedBySystem
        ? 'Reduced by your device preference.'
        : state.userPaused
        ? 'Paused · activate to resume.'
        : 'Animations on.';
    for (final label in documentElements('.motion-status')) {
      if (label.textContent != status) label.textContent = status;
    }
    for (final button in _toggles) {
      button.setAttribute('aria-pressed', '${state.userPaused}');
      button.title = state.reducedBySystem
          ? 'Your device preference reduces animation. This toggle also pauses animation when that preference changes.'
          : state.userPaused
          ? 'Animation is paused. Activate to resume.'
          : 'Pause continuous and spatial animation.';
    }
    for (final element in _loops) {
      setClass(element, 'motion-running', ambientAllowed && isVisible(element));
    }
    _hero?.sync();
    for (final effect in _portfolio) {
      effect.sync();
    }
    if (notifyPolicy) {
      for (final listener in _listeners.toList()) {
        listener();
      }
    }
    _ensureFrame();
    _publishProfile();
  }

  /// All frame-based effects share one browser callback. Background tasks are
  /// additionally suspended while a case dialog owns the visitor's attention.
  void Function() registerFrameTask(void Function(double timestamp) callback, {bool background = false}) {
    if (_disposed) return () {};
    final id = ++_taskId;
    _tasks[id] = (callback, background);
    _ensureFrame();
    return () {
      _tasks.remove(id);
      _ensureFrame();
      _publishProfile();
    };
  }

  bool get _hasRunnableTasks => !reduced && documentVisible && _tasks.values.any((task) => !task.$2 || ambientAllowed);

  void _ensureFrame() {
    if (_disposed || !_hasRunnableTasks) {
      if (_frame != null) web.window.cancelAnimationFrame(_frame!);
      _frame = null;
      _lastTime = 0;
      return;
    }
    _frame ??= web.window.requestAnimationFrame(_tick.toJS);
  }

  void _tick(double timestamp) {
    _frame = null;
    if (_disposed || !_hasRunnableTasks) return;
    deltaSeconds = _lastTime == 0 ? 1 / 60 : ((timestamp - _lastTime) / 1000).clamp(0.0, .032);
    _lastTime = timestamp;
    final start = _profile ? web.window.performance.now() : 0.0;
    for (final entry in _tasks.entries.toList()) {
      if (!_tasks.containsKey(entry.key) || (entry.value.$2 && !ambientAllowed)) continue;
      entry.value.$1(timestamp);
    }
    if (_profile) {
      _frameCosts.add(web.window.performance.now() - start);
      if (_frameCosts.length > 600) _frameCosts.removeAt(0);
      _frameCount++;
    }
    _ensureFrame();
    if (_profile && _frameCount % 60 == 0) _publishProfile();
  }

  void _mountProfiling() {
    try {
      _longTaskSupported = web.PerformanceObserver.supportedEntryTypes.toDart.any((type) => type.toDart == 'longtask');
      if (!_longTaskSupported) return;
      _performanceObserver = web.PerformanceObserver(
        ((web.PerformanceObserverEntryList list, web.PerformanceObserver observer) {
          for (final entry in list.getEntries().toDart) {
            _longTasks++;
            _longTaskMax = math.max(_longTaskMax, entry.duration);
          }
          _publishProfile();
        }).toJS,
      )..observe(web.PerformanceObserverInit(type: 'longtask'));
    } catch (_) {
      _performanceObserver = null;
      _longTaskSupported = false;
    }
  }

  void _publishProfile() {
    if (!_profile) return;
    final target = web.document.getElementById('agencyRuntime');
    if (target == null) return;
    final costs = [..._frameCosts]..sort();
    final p95 = costs.isEmpty ? 0.0 : costs[((costs.length - 1) * .95).ceil()];
    target
      ..setAttribute('data-motion-frame-p95', p95.toStringAsFixed(3))
      ..setAttribute('data-motion-frame-max', costs.isEmpty ? '0' : costs.last.toStringAsFixed(3))
      ..setAttribute('data-motion-frame-count', '$_frameCount')
      ..setAttribute('data-motion-tasks', '${_tasks.length}')
      ..setAttribute('data-motion-raf', _frame == null ? '0' : '1')
      ..setAttribute('data-motion-long-tasks', '$_longTasks')
      ..setAttribute('data-motion-long-task-supported', '$_longTaskSupported')
      ..setAttribute('data-motion-long-task-max', _longTaskMax.toStringAsFixed(3))
      ..setAttribute('data-motion-reduced', '$reduced')
      ..setAttribute('data-motion-visible', '$documentVisible');
  }

  void _play(web.Element target, Map<String, Object> frames, int milliseconds) {
    _animations.remove(target)?.cancel();
    if (reduced || !documentVisible || state.modalOpen) return;
    try {
      final animation = target.animate(
        frames.jsify()! as JSObject,
        web.KeyframeAnimationOptions(duration: milliseconds.toJS, easing: 'cubic-bezier(.16,1,.3,1)'),
      );
      _animations[target] = animation;
      animation.onfinish = ((web.Event event) {
        if (_animations[target] == animation) _animations.remove(target);
        animation.cancel();
      }).toJS;
    } catch (_) {
      // Canonical CSS and SVG attributes already represent the final state.
    }
  }

  void redrawConstellation() {
    for (final line in documentElements('#constel .cl.sel')) {
      _play(line, {
        'strokeDashoffset': ['1', '0'],
      }, 400);
    }
    final shape = web.document.getElementById('constShape');
    if (shape != null) {
      _play(shape, {
        'strokeDashoffset': ['1', '0'],
      }, 400);
    }
  }

  void markNavigation(web.Element? link) {
    if (link == null || _navIndicator == null) return;
    _navLink = link as web.HTMLElement;
    final parent = web.document.getElementById('primaryNavigation')!.getBoundingClientRect();
    final rect = link.getBoundingClientRect();
    if (rect.width == 0) return;
    _navIndicator!.style
      ..setProperty('width', '5px')
      ..setProperty('transform', 'translateX(${rect.left - parent.left + rect.width / 2 - 2.5}px)');
    _navIndicator!.classList.add('is-visible');
  }

  void _mountSupportingMotion() {
    _navIndicator = web.document.querySelector('.nav-indicator') as web.HTMLElement?;
    final first = web.document.querySelector('#primaryNavigation a');
    markNavigation(first);
    events.listen(web.window, 'resize', (_) => markNavigation(_navLink));
    for (final link in documentElements('.nav-cta, .hero-ctas a')) {
      events.listen(link, 'click', (event) => _drawWire(link as web.HTMLElement, event));
    }
    try {
      final progress = web.IntersectionObserver(
        ((JSArray<web.IntersectionObserverEntry> entries, web.IntersectionObserver observer) {
          for (final entry in entries.toDart) {
            if (entry.isIntersecting) {
              entry.target.classList.add('is-active');
              observer.unobserve(entry.target);
            }
          }
        }).toJS,
        web.IntersectionObserverInit(threshold: .3.toJS),
      );
      // Store a disposal callback alongside the other motion-owned resources.
      _cleanup.add(() => progress.disconnect());
      for (final step in documentElements('.process-step')) {
        progress.observe(step);
      }
    } catch (_) {
      for (final step in documentElements('.process-step')) {
        step.classList.add('is-active');
      }
    }
  }

  final List<void Function()> _cleanup = [];

  void _drawWire(web.HTMLElement link, web.Event event) {
    _wire?.remove();
    _wire = null;
    if (reduced || !documentVisible || state.modalOpen) return;
    final href = link.getAttribute('href');
    if (href == null || !href.startsWith('#')) return;
    final destination = web.document.getElementById(href.substring(1));
    if (destination == null) return;
    final sourceRect = link.getBoundingClientRect();
    final targetRect = destination.getBoundingClientRect();
    final click = event.isA<web.MouseEvent>() ? event as web.MouseEvent : null;
    final x1 = click != null && click.detail > 0 ? click.clientX.toDouble() : sourceRect.left + sourceRect.width / 2;
    final y1 = click != null && click.detail > 0 ? click.clientY.toDouble() : sourceRect.top + sourceRect.height / 2;
    final x2 = targetRect.left + math.min(240, targetRect.width / 2);
    final y2 = (targetRect.top + 60).clamp(80.0, math.max(80.0, web.window.innerHeight - 80.0));
    final svg = web.document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg
      ..setAttribute('class', 'motion-wire')
      ..setAttribute('aria-hidden', 'true')
      ..setAttribute('focusable', 'false')
      ..setAttribute('viewBox', '0 0 ${web.window.innerWidth} ${web.window.innerHeight}')
      ..setAttribute('width', '${web.window.innerWidth}')
      ..setAttribute('height', '${web.window.innerHeight}');
    final line = web.document.createElementNS('http://www.w3.org/2000/svg', 'line');
    line
      ..setAttribute('x1', '$x1')
      ..setAttribute('y1', '$y1')
      ..setAttribute('x2', '$x2')
      ..setAttribute('y2', '$y2')
      ..setAttribute('pathLength', '1')
      ..setAttribute('stroke-dasharray', '1');
    svg.append(line);
    web.document.body!.append(svg);
    _wire = svg;
    try {
      final animation = svg.animate(
        {
              'opacity': [1, 1, 0],
              'offset': [0, .7, 1],
            }.jsify()!
            as JSObject,
        web.KeyframeAnimationOptions(duration: 750.toJS),
      );
      _animations[svg] = animation;
      _play(line, {
        'strokeDashoffset': ['1', '0'],
      }, 550);
      animation.onfinish = ((web.Event event) {
        _animations.remove(svg);
        animation.cancel();
        svg.remove();
        if (_wire == svg) _wire = null;
      }).toJS;
    } catch (_) {
      svg.remove();
      _wire = null;
    }
  }

  void _cancelAnimations() {
    for (final animation in _animations.values) {
      animation.cancel();
    }
    _animations.clear();
    _wire?.remove();
    _wire = null;
  }

  void dispose() {
    _disposed = true;
    _hero?.dispose();
    for (final effect in _portfolio) {
      effect.dispose();
    }
    _observer?.disconnect();
    _performanceObserver?.disconnect();
    for (final cleanup in _cleanup) {
      cleanup();
    }
    _cancelAnimations();
    if (_frame != null) web.window.cancelAnimationFrame(_frame!);
    _frame = null;
    _tasks.clear();
    _listeners.clear();
    for (final loop in _loops) {
      loop.classList.remove('motion-running');
    }
    for (final button in _toggles) {
      button.disabled = true;
    }
    web.document.documentElement?.classList
      ?..remove('motion-reduced')
      ..remove('motion-paused');
  }
}

abstract class _CanvasMotion {
  _CanvasMotion(this.motion, this.container, this.selector);
  final MotionRuntime motion;
  final web.HTMLElement container;
  final String selector;
  late final web.HTMLCanvasElement canvas;
  web.CanvasRenderingContext2D? context;
  web.ResizeObserver? observer;
  void Function()? cancelFrame;
  double width = 0;
  double height = 0;
  double left = 0;
  double top = 0;

  void mountCanvas() {
    canvas = container.querySelector(selector)! as web.HTMLCanvasElement;
    try {
      context = canvas.getContext('2d') as web.CanvasRenderingContext2D?;
      if (context == null) return;
      resize();
      observer = web.ResizeObserver(
        ((JSArray<web.ResizeObserverEntry> entries, web.ResizeObserver observer) => resize()).toJS,
      )..observe(container);
      motion.events.listen(web.window, 'scroll', (_) => cachePosition(), passive: true);
      container.classList.add('motion-ready');
    } catch (_) {
      context = null;
      container.classList.remove('motion-ready');
      observer?.disconnect();
    }
  }

  void cachePosition() {
    final rect = container.getBoundingClientRect();
    left = rect.left;
    top = rect.top;
  }

  void resize() {
    final rect = container.getBoundingClientRect();
    left = rect.left;
    top = rect.top;
    width = rect.width;
    height = rect.height;
    if (width <= 0 || height <= 0) return;
    resized();
    final dpr = web.window.devicePixelRatio.clamp(1.0, 2.0);
    canvas.width = (width * dpr).round();
    canvas.height = (height * dpr).round();
    context?.setTransform(dpr.toJS, 0, 0, dpr, 0, 0);
  }

  bool get running => context != null && width > 0 && motion.ambientAllowed && motion.isVisible(container);
  void resized() {}
  void sync();
  void frame(double timestamp);
  void start() => cancelFrame ??= motion.registerFrameTask(frame, background: true);
  void stop() {
    cancelFrame?.call();
    cancelFrame = null;
  }

  void dispose() {
    stop();
    observer?.disconnect();
    motion.removePolicyListener(sync);
    container.classList.remove('motion-ready');
  }
}

class _HeroMotion extends _CanvasMotion {
  _HeroMotion(MotionRuntime motion, web.HTMLElement container) : super(motion, container, '.hero-ink');
  late final List<web.HTMLElement> nodes;
  late final List<web.SVGElement> lines;
  late final web.SVGElement center;
  late final web.MediaQueryList finePointer;
  final Set<int> discovered = {};
  final Map<int, double> drawn = {};
  final List<(double, double, double)> trail = [];
  bool hovered = false;
  bool focused = false;
  bool pressed = false;
  double phase = 0;
  double mouseX = -10000;
  double mouseY = -10000;
  double? _frozenPhase;
  final List<double> _dotOffsets = [];

  void mount() {
    nodes = childElements(container, '.hero-node').cast<web.HTMLElement>();
    lines = childElements(container, '.hero-connection').cast<web.SVGElement>();
    center = container.querySelector('.hero-center')! as web.SVGElement;
    finePointer = web.window.matchMedia('(pointer: fine)');
    mountCanvas();
    motion.events.listen(container, 'pointerenter', (_) => hovered = true);
    motion.events.listen(container, 'pointerleave', (_) {
      hovered = false;
      mouseX = mouseY = -10000;
    });
    motion.events.listen(container, 'pointerdown', (_) => pressed = true, passive: true);
    motion.events.listen(web.window, 'pointerup', (_) => pressed = false, passive: true);
    motion.events.listen(web.window, 'pointercancel', (_) => pressed = false, passive: true);
    motion.events.listen(container, 'focusin', (_) => focused = true);
    motion.events.listen(container, 'focusout', (event) {
      final next = event.isA<web.FocusEvent>() ? (event as web.FocusEvent).relatedTarget : null;
      focused = next != null && next.isA<web.Node>() && container.contains(next as web.Node);
    });
    motion.events.listen(container, 'pointermove', (event) {
      if (!running || !finePointer.matches || !event.isA<web.PointerEvent>()) return;
      final pointer = event as web.PointerEvent;
      mouseX = pointer.clientX - left;
      mouseY = pointer.clientY - top;
      trail.add((mouseX, mouseY, web.window.performance.now()));
      if (trail.length > 40) trail.removeAt(0);
    }, passive: true);
    for (var i = 0; i < nodes.length; i++) {
      void discover(web.Event event) {
        discovered.add(i);
        nodes[i].classList.add('discovered');
        lines[i].classList.add('active');
        if (!running) drawn[i] = 1;
      }

      motion.events.listen(nodes[i], 'pointerenter', discover);
      motion.events.listen(nodes[i], 'focus', discover);
      motion.events.listen(nodes[i], 'pointerdown', discover, passive: true);
    }
    sync();
  }

  @override
  void resized() {
    _dotOffsets
      ..clear()
      ..addAll(nodes.map((node) => node.getBoundingClientRect().height / 2 + 7));
  }

  @override
  void sync() {
    if (running) {
      start();
    } else {
      stop();
      trail.clear();
      context?.clearRect(0, 0, width, height);
      if (motion.reduced) {
        for (final index in discovered) {
          drawn[index] = 1;
        }
      }
      _positionNodes(static: true);
    }
  }

  void _positionNodes({bool static = false}) {
    final settled = static;
    if (hovered || focused || pressed) {
      _frozenPhase ??= phase;
    } else {
      _frozenPhase = null;
    }
    final at = _frozenPhase ?? phase;
    final amplitude = width < 380 ? 4.0 : 8.0;
    final cx = 240.0 + (settled ? 0 : math.sin(at * 1.7) * 6);
    final cy = 220.0 + (settled ? 0 : math.cos(at * 1.4) * 6);
    center
      ..setAttribute('cx', '$cx')
      ..setAttribute('cy', '$cy');
    for (var i = 0; i < nodes.length; i++) {
      final angle = i * math.pi / 3 - math.pi / 2;
      final dx = settled ? 0.0 : math.cos(at * (1.2 + i % 3 * .25) + i * 1.1) * amplitude;
      final dy = settled ? 0.0 : math.sin(at * 1.1 + i * 1.1) * amplitude;
      nodes[i].style
        ..setProperty('--drift-x', '${finePointer.matches ? dx * width / 480 : 0}px')
        ..setProperty('--drift-y', '${finePointer.matches ? dy * height / 440 : 0}px');
      final x = 240 + math.cos(angle) * 162 + dx;
      final y = 220 + math.sin(angle) * 162 + dy + (static || height == 0 ? 0 : _dotOffsets[i] * 440 / height);
      final progress = drawn[i] ?? (discovered.contains(i) ? 1.0 : 0.0);
      lines[i]
        ..setAttribute('x1', '$cx')
        ..setAttribute('y1', '$cy')
        ..setAttribute('x2', '$x')
        ..setAttribute('y2', '$y');
      // Only discovered connections draw; neutral spokes remain understandable.
      if (discovered.contains(i)) {
        lines[i].setAttribute('pathLength', '1');
        lines[i].style
          ..setProperty('stroke-dasharray', '1')
          ..setProperty('stroke-dashoffset', '${1 - progress}');
      }
      if (context != null && !static) {
        final px = x * width / 480;
        final py = y * height / 440;
        final near = (1 - math.sqrt(math.pow(mouseX - px, 2) + math.pow(mouseY - py, 2)) / 100).clamp(0.0, 1.0);
        context!
          ..beginPath()
          ..arc(px, py, 3 + near * 2, 0, math.pi * 2)
          ..fillStyle = (near > .1 || discovered.contains(i) ? motion.accent : motion.foreground).toJS;
        context!.fill();
      }
    }
    setClass(container, 'connections-complete', discovered.length == 6);
  }

  @override
  void frame(double timestamp) {
    phase += motion.deltaSeconds * .72;
    final ctx = context!;
    ctx.clearRect(0, 0, width, height);
    trail.removeWhere((point) => timestamp - point.$3 > 600);
    for (var i = 1; i < trail.length; i++) {
      final a = trail[i - 1];
      final b = trail[i];
      final alpha = .45 * (1 - (timestamp - b.$3) / 600).clamp(0.0, 1.0);
      ctx
        ..globalAlpha = alpha
        ..strokeStyle = motion.accent.toJS
        ..lineWidth = 1.4
        ..beginPath()
        ..moveTo(a.$1, a.$2)
        ..lineTo(b.$1, b.$2)
        ..stroke();
    }
    ctx.globalAlpha = 1;
    for (final index in discovered) {
      drawn[index] = math.min(1.0, (drawn[index] ?? 0) + motion.deltaSeconds / .4);
    }
    _positionNodes();
  }
}

class _PortfolioMotion extends _CanvasMotion {
  _PortfolioMotion(MotionRuntime motion, web.HTMLElement container, this.seed)
    : super(motion, container, '.work-particles');
  final int seed;
  final List<(double, double, double, double, bool)> particles = [];
  bool active = false;
  double progress = 0;
  double phase = 0;

  void mount() {
    mountCanvas();
    final item = container.closest('.work-item')!;
    motion.events.listen(item, 'pointerenter', (_) => active = true);
    motion.events.listen(item, 'pointerleave', (_) => active = false);
    motion.events.listen(item, 'focus', (_) => active = true);
    motion.events.listen(item, 'blur', (_) => active = false);
    sync();
  }

  @override
  void resized() {
    final random = math.Random(seed);
    particles.clear();
    final cols = math.max(1, (width / 26).round());
    final rows = math.max(1, (height / 26).round());
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < cols; column++) {
        if (particles.length >= 500) return;
        final angle = random.nextDouble() * math.pi * 2;
        final distance = 50 + random.nextDouble() * 90;
        particles.add((
          (column + .5) * width / cols,
          (row + .5) * height / rows,
          math.cos(angle) * distance,
          math.sin(angle) * distance,
          random.nextDouble() < .14,
        ));
      }
    }
  }

  @override
  void sync() {
    if (running) {
      start();
    } else {
      stop();
      context?.clearRect(0, 0, width, height);
    }
  }

  @override
  void frame(double timestamp) {
    phase += motion.deltaSeconds;
    final desired = active ? 1.0 : 0.0;
    progress += (desired - progress) * (1 - math.exp(-motion.deltaSeconds * 9));
    final eased = progress * progress * (3 - 2 * progress);
    final ctx = context!;
    ctx.clearRect(0, 0, width, height);
    for (var i = 0; i < particles.length; i++) {
      final dot = particles[i];
      ctx
        ..globalAlpha = (1 - eased) * (dot.$5 ? .65 : .24)
        ..fillStyle = (dot.$5 ? motion.accent : motion.foreground).toJS
        ..beginPath()
        ..arc(
          dot.$1 + dot.$3 * eased,
          dot.$2 + dot.$4 * eased,
          (dot.$5 ? 2.0 : 1.3) + math.sin(phase * 1.4 + i) * .18,
          0,
          math.pi * 2,
        )
        ..fill();
    }
    ctx.globalAlpha = 1;
  }
}
