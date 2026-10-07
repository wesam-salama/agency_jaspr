import 'dart:math' as math;

import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import 'dom_utils.dart';

class CanvasRuntime {
  CanvasRuntime({required this.reduceMotion, required this.events, required this.frames});

  final bool reduceMotion;
  final EventScope events;
  final AnimationFrames frames;
  final List<_CanvasAnimation> _animations = [];

  void mount() {
    _animations.add(_HeroConstellation(reduceMotion, events, frames)..mount());
    for (final item in documentElements('.work-item')) {
      _animations.add(_WorkParticles(item as web.HTMLElement, reduceMotion, events, frames)..mount());
    }
  }

  void dispose() {
    for (final animation in _animations) {
      animation.dispose();
    }
  }
}

abstract class _CanvasAnimation {
  void dispose();
}

class _HeroNode {
  _HeroNode({
    required this.x,
    required this.y,
    required this.baseX,
    required this.baseY,
    required this.center,
    required this.label,
    required this.radius,
  });

  double x;
  double y;
  double baseX;
  double baseY;
  final bool center;
  final String label;
  final double radius;
  bool lit = false;
}

class _TrailPoint {
  const _TrailPoint(this.x, this.y, this.time);

  final double x;
  final double y;
  final double time;
}

class _HeroConstellation implements _CanvasAnimation {
  _HeroConstellation(this.reduceMotion, this.events, this.frames);

  final bool reduceMotion;
  final EventScope events;
  final AnimationFrames frames;
  late final web.HTMLCanvasElement _canvas;
  late final web.HTMLElement _wrap;
  late final web.CanvasRenderingContext2D _context;
  final List<_HeroNode> _nodes = [];
  final List<web.HTMLElement> _labels = [];
  final List<_TrailPoint> _trail = [];
  final Map<String, double> _segments = {};
  double _width = 0;
  double _height = 0;
  double _mouseX = -9999;
  double _mouseY = -9999;
  double _time = 0;
  bool _disposed = false;

  void mount() {
    _canvas = elementById<web.HTMLCanvasElement>('dotcanvas');
    _wrap = elementById<web.HTMLElement>('canvasWrap');
    _context = _canvas.getContext('2d')! as web.CanvasRenderingContext2D;
    _layout();
    for (final node in _nodes) {
      final label = web.document.createElement('div') as web.HTMLElement;
      label
        ..className = 'node-label${node.center ? ' center' : ''}'
        ..textContent = node.label;
      _wrap.append(label);
      _labels.add(label);
    }
    events.listen(_wrap, 'mousemove', _handleMouseMove, passive: true);
    events.listen(_wrap, 'mouseleave', (_) {
      _mouseX = -9999;
      _mouseY = -9999;
    });
    events.listen(web.window, 'resize', (_) => _layout(), passive: true);
    frames.request(_frame);
  }

  void _layout() {
    _width = _wrap.clientWidth.toDouble();
    _height = _wrap.clientHeight.toDouble();
    final dpr = math.min(web.window.devicePixelRatio, 2).toDouble();
    _canvas
      ..width = (_width * dpr).round()
      ..height = (_height * dpr).round();
    _canvas.style
      ..setProperty('width', '${_width}px')
      ..setProperty('height', '${_height}px');
    _context.setTransform(dpr.toJS, 0, 0, dpr, 0, 0);
    final centerX = _width / 2;
    final centerY = _height / 2;
    final radius = math.min(_width, _height) * .32;
    final previousLit = [for (final node in _nodes) node.lit];
    _nodes
      ..clear()
      ..add(
        _HeroNode(
          x: centerX,
          y: centerY,
          baseX: centerX,
          baseY: centerY,
          center: true,
          label: 'You',
          radius: 7,
        ),
      );
    const labels = ['Branding', 'Rebranding', 'Consultancy', 'Web Dev', 'App Dev', 'Maintenance'];
    for (var index = 0; index < labels.length; index++) {
      final angle = (math.pi * 2 / labels.length) * index - math.pi / 2;
      final x = centerX + math.cos(angle) * radius;
      final y = centerY + math.sin(angle) * radius;
      _nodes.add(
        _HeroNode(
          x: x,
          y: y,
          baseX: x,
          baseY: y,
          center: false,
          label: labels[index],
          radius: 5,
        ),
      );
    }
    for (var index = 0; index < math.min(previousLit.length, _nodes.length); index++) {
      _nodes[index].lit = previousLit[index];
    }
  }

  void _handleMouseMove(web.Event event) {
    if (!event.isA<web.MouseEvent>()) return;
    final mouseEvent = event as web.MouseEvent;
    final rect = _wrap.getBoundingClientRect();
    _mouseX = mouseEvent.clientX - rect.left;
    _mouseY = mouseEvent.clientY - rect.top;
    if (!reduceMotion) {
      _trail.add(_TrailPoint(_mouseX, _mouseY, web.window.performance.now()));
      if (_trail.length > 40) _trail.removeAt(0);
    }
    for (var index = 0; index < _nodes.length; index++) {
      final node = _nodes[index];
      if (!node.lit && _distance(_mouseX, _mouseY, node.x, node.y) < 24) {
        node.lit = true;
        _labels[index].classList.add('lit');
      }
    }
  }

  void _frame(num _) {
    if (_disposed) return;
    _time += reduceMotion ? 0 : .012;
    final now = web.window.performance.now();
    for (var index = 0; index < _nodes.length; index++) {
      final node = _nodes[index];
      if (reduceMotion) continue;
      if (node.center) {
        node
          ..x = node.baseX + math.sin(_time * 1.7 + index * .3) * 6
          ..y = node.baseY + math.cos(_time * 1.4 + index * .5) * 6;
      } else {
        final speed = 1.2 + (index % 3) * .25;
        final phase = index * 1.1 + _time * speed;
        node
          ..x = node.baseX + math.cos(phase) * 8 + math.sin(_time * .7 + index) * 4
          ..y = node.baseY + math.sin(phase * .9) * 8 + math.cos(_time * .8 + index * .7) * 4;
      }
    }

    _context.clearRect(0, 0, _width, _height);
    for (var index = 1; index < _trail.length; index++) {
      final start = _trail[index - 1];
      final end = _trail[index];
      final age = (now - end.time) / 600;
      if (age > 1) continue;
      _context
        ..strokeStyle = 'rgba(255,68,51,${.35 * (1 - age)})'.toJS
        ..lineWidth = 1.4
        ..beginPath()
        ..moveTo(start.x, start.y)
        ..lineTo(end.x, end.y)
        ..stroke();
    }

    final lit = _nodes.where((node) => node.lit).toList();
    for (var index = 1; index < lit.length; index++) {
      final key = '${lit[index - 1].label}>${lit[index].label}';
      final progress = math.min(1, (_segments[key] ?? 0) + .06).toDouble();
      _segments[key] = progress;
      _context
        ..strokeStyle = 'rgba(255,68,51,.85)'.toJS
        ..lineWidth = 1.6
        ..beginPath()
        ..moveTo(lit[index - 1].x, lit[index - 1].y)
        ..lineTo(
          lit[index - 1].x + (lit[index].x - lit[index - 1].x) * progress,
          lit[index - 1].y + (lit[index].y - lit[index - 1].y) * progress,
        )
        ..stroke();
    }
    if (lit.length == 6) _nodes.first.lit = true;
    if (_nodes.first.lit) {
      for (var index = 1; index < _nodes.length; index++) {
        _context
          ..strokeStyle = 'rgba(255,68,51,.5)'.toJS
          ..lineWidth = 1
          ..beginPath()
          ..moveTo(_nodes.first.x, _nodes.first.y)
          ..lineTo(_nodes[index].x, _nodes[index].y)
          ..stroke();
      }
    }

    final center = _nodes.first;
    for (var index = 1; index < _nodes.length; index++) {
      final node = _nodes[index];
      final near = math.max(0, 1 - _distance(_mouseX, _mouseY, node.x, node.y) / 120);
      if (!node.lit) {
        _context
          ..strokeStyle = 'rgba(255,68,51,${.15 + near * .4})'.toJS
          ..lineWidth = 1
          ..beginPath()
          ..moveTo(center.x, center.y)
          ..lineTo(node.x, node.y)
          ..stroke();
      }
    }

    for (var index = 0; index < _nodes.length; index++) {
      final node = _nodes[index];
      final near = math.max(0, 1 - _distance(_mouseX, _mouseY, node.x, node.y) / 100);
      if (near > .1) {
        final glowRadius = node.radius + 16 + near * 20;
        final gradient = _context.createRadialGradient(node.x, node.y, 0, node.x, node.y, glowRadius);
        gradient
          ..addColorStop(0, 'rgba(255,68,51,${near * .35})')
          ..addColorStop(1, 'rgba(255,68,51,0)');
        _context
          ..beginPath()
          ..arc(node.x, node.y, glowRadius, 0, math.pi * 2)
          ..fillStyle = gradient
          ..fill();
      }
      _context
        ..beginPath()
        ..arc(node.x, node.y, node.radius + near * 3, 0, math.pi * 2)
        ..fillStyle = (node.center ? '#ff4433' : (near > .15 || node.lit ? '#ff4433' : '#f3f3f0')).toJS
        ..fill();
      _labels[index].style
        ..setProperty('transform', 'translate(-50%,-160%) scale(${near > .2 ? 1.08 : 1})')
        ..setProperty('left', '${node.x}px')
        ..setProperty('top', '${node.y}px')
        ..setProperty('border-color', near > .2 || node.lit ? 'var(--accent)' : 'var(--line)')
        ..setProperty('color', near > .2 || node.lit ? '#fff' : '');
    }
    frames.request(_frame);
  }

  double _distance(double x1, double y1, double x2, double y2) {
    final x = x1 - x2;
    final y = y1 - y2;
    return math.sqrt(x * x + y * y);
  }

  @override
  void dispose() {
    _disposed = true;
    for (final label in _labels) {
      label.remove();
    }
  }
}

class _WorkDot {
  const _WorkDot({
    required this.x,
    required this.y,
    required this.scatterX,
    required this.scatterY,
    required this.delay,
    required this.red,
    required this.phase,
  });

  final double x;
  final double y;
  final double scatterX;
  final double scatterY;
  final double delay;
  final bool red;
  final double phase;
}

class _WorkParticles implements _CanvasAnimation {
  _WorkParticles(this.item, this.reduceMotion, this.events, this.frames);

  final web.HTMLElement item;
  final bool reduceMotion;
  final EventScope events;
  final AnimationFrames frames;
  late final web.HTMLCanvasElement _canvas;
  late final web.HTMLElement _thumb;
  late final web.CanvasRenderingContext2D _context;
  final List<_WorkDot> _dots = [];
  final math.Random _random = math.Random();
  double _width = 0;
  double _height = 0;
  double _progress = 0;
  double _target = 0;
  bool _disposed = false;

  void mount() {
    _canvas = item.querySelector('canvas')! as web.HTMLCanvasElement;
    _thumb = item.querySelector('.work-thumb')! as web.HTMLElement;
    _context = _canvas.getContext('2d')! as web.CanvasRenderingContext2D;
    _size();
    events.listen(web.window, 'resize', (_) => _size(), passive: true);
    events.listen(item, 'mouseenter', (_) => _target = 1);
    events.listen(item, 'mouseleave', (_) => _target = 0);
    frames.request(_frame);
  }

  void _size() {
    _width = _thumb.clientWidth.toDouble();
    _height = _thumb.clientHeight.toDouble();
    _canvas
      ..width = _width.round()
      ..height = _height.round();
    _dots.clear();
    final columns = math.max(1, (_width / 26).round());
    final rows = math.max(1, (_height / 26).round());
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        final angle = _random.nextDouble() * math.pi * 2;
        final distance = 50 + _random.nextDouble() * 110;
        _dots.add(
          _WorkDot(
            x: (column + .5) * (_width / columns),
            y: (row + .5) * (_height / rows),
            scatterX: math.cos(angle) * distance,
            scatterY: math.sin(angle) * distance,
            delay: _random.nextDouble() * .45,
            red: _random.nextDouble() < .14,
            phase: _random.nextDouble() * math.pi * 2,
          ),
        );
      }
    }
  }

  void _frame(num _) {
    if (_disposed) return;
    _progress += (_target - _progress) * .08;
    _context.clearRect(0, 0, _width, _height);
    final now = web.window.performance.now();
    for (final dot in _dots) {
      final linear = (_progress * 1.35 - dot.delay * .35).clamp(0, 1);
      final eased = linear * linear * (3 - 2 * linear);
      final alpha = (1 - eased) * (dot.red ? .8 : .5);
      if (alpha <= .02) continue;
      final radius = (dot.red ? 2.2 : 1.7) + (reduceMotion ? 0 : math.sin(now / 700 + dot.phase) * .3);
      _context
        ..globalAlpha = alpha
        ..fillStyle = (dot.red ? '#ff4433' : '#f3f3f0').toJS
        ..beginPath()
        ..arc(dot.x + dot.scatterX * eased, dot.y + dot.scatterY * eased, radius, 0, math.pi * 2)
        ..fill();
    }
    _context.globalAlpha = 1;
    frames.request(_frame);
  }

  @override
  void dispose() => _disposed = true;
}
