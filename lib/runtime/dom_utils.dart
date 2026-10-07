import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

List<web.Element> documentElements(String selector) {
  final nodes = web.document.querySelectorAll(selector);
  return [for (var index = 0; index < nodes.length; index++) nodes.item(index)! as web.Element];
}

List<web.Element> childElements(web.Element parent, String selector) {
  final nodes = parent.querySelectorAll(selector);
  return [for (var index = 0; index < nodes.length; index++) nodes.item(index)! as web.Element];
}

T elementById<T extends web.Element>(String id) => web.document.getElementById(id)! as T;

void setClass(web.Element element, String className, bool enabled) {
  if (enabled) {
    element.classList.add(className);
  } else {
    element.classList.remove(className);
  }
}

class EventScope {
  EventScope() : _controller = web.AbortController();

  final web.AbortController _controller;

  void listen(
    web.EventTarget target,
    String type,
    void Function(web.Event event) callback, {
    bool passive = false,
  }) {
    target.addEventListener(
      type,
      callback.toJS,
      web.AddEventListenerOptions(signal: _controller.signal, passive: passive),
    );
  }

  void dispose() => _controller.abort();
}

class AnimationFrames {
  final Set<int> _scheduled = {};

  void request(void Function(num time) callback) {
    late int requestId;
    requestId = web.window.requestAnimationFrame(
      ((num time) {
        _scheduled.remove(requestId);
        callback(time);
      }).toJS,
    );
    _scheduled.add(requestId);
  }

  void dispose() {
    for (final requestId in _scheduled) {
      web.window.cancelAnimationFrame(requestId);
    }
    _scheduled.clear();
  }
}
