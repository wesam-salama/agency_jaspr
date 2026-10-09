import 'motion_state.dart';

/// Commits only the latest requested case, once its curtain has covered the page.
class CaseNavigation {
  final MotionGeneration _generation = MotionGeneration();
  void Function()? _commit;

  bool get pending => _commit != null;

  int begin(void Function() commit) {
    cancel();
    if (_generation.disposed) return _generation.current;
    _commit = commit;
    return _generation.begin();
  }

  bool commit(int token) {
    if (!_generation.finish(token)) return false;
    final callback = _commit;
    _commit = null;
    callback?.call();
    return true;
  }

  /// Policy changes reveal the requested case immediately instead of abandoning it.
  void settle() => commit(_generation.current);

  /// Dismissal and replacement must never reveal a cancelled case later.
  void cancel() {
    _generation.cancel();
    _commit = null;
  }

  void dispose() {
    cancel();
    _generation.dispose();
  }
}
