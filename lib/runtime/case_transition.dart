import 'dart:async';
import 'dart:math' as math;

import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../models/site_models.dart';
import 'motion_state.dart';

/// Captured before the dialog changes, so Next never measures the new study.
class ActivationGeometry {
  const ActivationGeometry({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.x,
    required this.y,
    required this.imageSource,
    required this.imageReady,
  });

  final double left;
  final double top;
  final double width;
  final double height;
  final double x;
  final double y;
  final String imageSource;
  final bool imageReady;

  bool get usable =>
      imageReady &&
      imageSource.isNotEmpty &&
      [left, top, width, height, x, y].every((value) => value.isFinite) &&
      width > 0 &&
      height > 0;

  static ActivationGeometry capture(
    web.HTMLImageElement image,
    web.HTMLElement trigger, {
    web.Event? event,
    bool useTriggerCenter = false,
  }) {
    final rect = image.getBoundingClientRect();
    final triggerRect = trigger.getBoundingClientRect();
    var x = triggerRect.left + triggerRect.width / 2;
    var y = triggerRect.top + triggerRect.height / 2;
    if (!useTriggerCenter && event != null && event.isA<web.MouseEvent>()) {
      final mouse = event as web.MouseEvent;
      // Keyboard-generated clicks have detail zero and no pointer location.
      if (mouse.detail > 0) {
        x = mouse.clientX.toDouble();
        y = mouse.clientY.toDouble();
      }
    }
    return ActivationGeometry(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      x: x,
      y: y,
      imageSource: image.currentSrc.isEmpty ? image.src : image.currentSrc,
      imageReady: image.complete && image.naturalWidth > 0,
    );
  }
}

/// An entrance owns all its effects, decorations and delayed callbacks.
/// Cancellation never changes dialog content, focus, or visibility.
class CaseTransitionTransaction {
  CaseTransitionTransaction({required this.modal, required this.presentation, required this.image});

  final web.HTMLElement modal;
  final web.HTMLElement presentation;
  final web.HTMLImageElement image;
  final MotionGeneration _generation = MotionGeneration();
  final List<web.Animation> _animations = [];
  final List<web.HTMLElement> _decorations = [];
  Timer? _coverTimer;
  String? _imageOpacity;
  String _imageOpacityPriority = '';

  /// Matches the reference's viewport curtain, independently of image geometry.
  void coverAndReveal(void Function() onCovered) {
    cancel();
    if (_generation.disposed) return;
    final token = _generation.begin();
    try {
      final curtain = _decoration('div', 'cm-transition-curtain');
      web.document.body!.append(curtain);
      _animate(
        curtain,
        [
          {'transform': 'scaleX(0)', 'transformOrigin': 'left center'},
          {'transform': 'scaleX(1)', 'transformOrigin': 'left center'},
        ],
        550,
        token: token,
        easing: 'cubic-bezier(.7,0,.3,1)',
      );
      _coverTimer = Timer(const Duration(milliseconds: 580), () {
        _coverTimer = null;
        if (!_generation.accepts(token)) return;
        try {
          onCovered();
          if (!_generation.accepts(token)) return;
          _animate(
            curtain,
            [
              {'transform': 'scaleX(1)', 'transformOrigin': 'right center'},
              {'transform': 'scaleX(0)', 'transformOrigin': 'right center'},
            ],
            550,
            token: token,
            easing: 'cubic-bezier(.7,0,.3,1)',
            completes: true,
          );
        } catch (_) {
          cancel();
          onCovered();
        }
      });
    } catch (_) {
      // Missing animation support still opens the requested details immediately.
      cancel();
      onCovered();
    }
  }

  void run(CaseTransition transition, ActivationGeometry? activation) {
    if (transition == CaseTransition.accentCurtain) {
      coverAndReveal(() {});
      return;
    }
    cancel();
    if (_generation.disposed || activation == null || !activation.usable) return;
    if (image.complete && image.naturalWidth == 0) return;
    final target = presentation.getBoundingClientRect();
    if (target.width <= 0 || target.height <= 0) return;
    final token = _generation.begin();
    try {
      switch (transition) {
        case CaseTransition.sharedElementExpand:
          final clone = _fixedClone(activation, target);
          _hideImage();
          _animate(
            clone,
            [
              {
                'transform':
                    'translate(${activation.left - target.left}px, ${activation.top - target.top}px) '
                    'scale(${activation.width / target.width}, ${activation.height / target.height})',
                'opacity': 1,
              },
              {'transform': 'translate(0px, 0px) scale(1, 1)', 'opacity': 1},
            ],
            650,
            token: token,
            completes: true,
          );
        case CaseTransition.accentCurtain:
          // Handled before the image-dependent entrance guards above.
          break;
        case CaseTransition.cursorIris:
          final x = activation.x - target.left;
          final y = activation.y - target.top;
          final radius = math.sqrt(
            math.pow(math.max(x.abs(), (target.width - x).abs()), 2) +
                math.pow(math.max(y.abs(), (target.height - y).abs()), 2),
          );
          _animate(
            presentation,
            [
              {'clipPath': 'circle(0px at ${x}px ${y}px)'},
              {'clipPath': 'circle(${radius + 1}px at ${x}px ${y}px)'},
            ],
            650,
            token: token,
            completes: true,
          );
        case CaseTransition.tunnelZoom:
          final clone = _fixedClone(activation, target, useSourceSize: true);
          final dx = target.left + target.width / 2 - (activation.left + activation.width / 2);
          final dy = target.top + target.height / 2 - (activation.top + activation.height / 2);
          _animate(
            clone,
            [
              {'transform': 'translate(0px, 0px) scale(1)', 'opacity': 1, 'filter': 'blur(0px)'},
              {'transform': 'translate(${dx}px, ${dy}px) scale(1.6)', 'opacity': 0, 'filter': 'blur(6px)'},
            ],
            700,
            token: token,
          );
          _animate(
            presentation,
            [
              {'transform': 'scale(.94)', 'opacity': .55, 'filter': 'blur(3px)'},
              {'transform': 'scale(1)', 'opacity': 1, 'filter': 'blur(0px)'},
            ],
            700,
            token: token,
            completes: true,
          );
      }
    } catch (_) {
      // Missing WAAPI support or malformed image geometry opens immediately.
      cancel();
    }
  }

  web.HTMLImageElement _fixedClone(
    ActivationGeometry source,
    web.DOMRect target, {
    bool useSourceSize = false,
  }) {
    final clone = _decoration('img', 'cm-transition-clone') as web.HTMLImageElement;
    clone
      ..src = source.imageSource
      ..alt = '';
    clone.style
      ..setProperty('position', 'fixed')
      ..setProperty('inset', 'auto')
      ..setProperty('left', '${useSourceSize ? source.left : target.left}px')
      ..setProperty('top', '${useSourceSize ? source.top : target.top}px')
      ..setProperty('width', '${useSourceSize ? source.width : target.width}px')
      ..setProperty('height', '${useSourceSize ? source.height : target.height}px')
      ..setProperty('transform-origin', useSourceSize ? 'center' : 'top left')
      ..setProperty('z-index', '1');
    modal.append(clone);
    return clone;
  }

  web.HTMLElement _decoration(String tag, String classes) {
    final element = web.document.createElement(tag) as web.HTMLElement;
    element
      ..className = classes
      ..setAttribute('aria-hidden', 'true');
    _decorations.add(element);
    return element;
  }

  void _hideImage() {
    _imageOpacity = image.style.getPropertyValue('opacity');
    _imageOpacityPriority = image.style.getPropertyPriority('opacity');
    image.style.setProperty('opacity', '0');
  }

  void _animate(
    web.Element element,
    List<Map<String, Object?>> frames,
    int milliseconds, {
    required int token,
    bool completes = false,
    String easing = 'cubic-bezier(.16,1,.3,1)',
  }) {
    final animation = element.animate(
      frames.jsify() as JSObject,
      web.KeyframeAnimationOptions(
        duration: milliseconds.toJS,
        easing: easing,
        fill: 'both',
      ),
    );
    _animations.add(animation);
    if (completes) {
      animation.onfinish = ((web.Event _) {
        if (_generation.finish(token)) _clearOwnedEffects();
      }).toJS;
    }
  }

  void _clearOwnedEffects() {
    _coverTimer?.cancel();
    _coverTimer = null;
    for (final animation in _animations) {
      try {
        animation.onfinish = null;
        animation.cancel();
      } catch (_) {
        // Cleanup must still restore content if an animation API fails.
      }
    }
    _animations.clear();
    for (final decoration in _decorations) {
      decoration.remove();
    }
    _decorations.clear();
    if (_imageOpacity case final previous?) {
      if (previous.isEmpty) {
        image.style.removeProperty('opacity');
      } else {
        image.style.setProperty('opacity', previous, _imageOpacityPriority);
      }
      _imageOpacity = null;
    }
  }

  void cancel() {
    _generation.cancel();
    _clearOwnedEffects();
  }

  void dispose() {
    cancel();
    _generation.dispose();
  }
}
