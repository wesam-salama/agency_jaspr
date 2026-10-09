/// Motion preferences and temporary conditions that govern ambient animation.
class MotionState {
  MotionState({
    bool reducedBySystem = false,
    bool userPaused = false,
    bool documentVisible = true,
    bool modalOpen = false,
  }) : _reducedBySystem = reducedBySystem,
       _userPaused = userPaused,
       _documentVisible = documentVisible,
       _modalOpen = modalOpen;

  bool _reducedBySystem;
  bool _userPaused;
  bool _documentVisible;
  bool _modalOpen;

  bool get reducedBySystem => _reducedBySystem;
  bool get userPaused => _userPaused;
  bool get documentVisible => _documentVisible;
  bool get modalOpen => _modalOpen;

  bool get reduced => reducedBySystem || userPaused;
  bool get ambientAllowed => !reduced && documentVisible && !modalOpen;

  /// Updates only supplied flags and reports whether the state changed.
  bool update({bool? reducedBySystem, bool? userPaused, bool? documentVisible, bool? modalOpen}) {
    final nextReducedBySystem = reducedBySystem ?? _reducedBySystem;
    final nextUserPaused = userPaused ?? _userPaused;
    final nextDocumentVisible = documentVisible ?? _documentVisible;
    final nextModalOpen = modalOpen ?? _modalOpen;
    final changed =
        nextReducedBySystem != _reducedBySystem ||
        nextUserPaused != _userPaused ||
        nextDocumentVisible != _documentVisible ||
        nextModalOpen != _modalOpen;

    _reducedBySystem = nextReducedBySystem;
    _userPaused = nextUserPaused;
    _documentVisible = nextDocumentVisible;
    _modalOpen = nextModalOpen;
    return changed;
  }
}

/// Rejects callbacks belonging to an interrupted or superseded transition.
class MotionGeneration {
  int _current = 0;
  bool _active = false;
  bool _disposed = false;

  int get current => _current;
  bool get active => _active;
  bool get disposed => _disposed;

  /// Starts a transition. A disposed generation never accepts new work.
  int begin() {
    if (_disposed) return _current;
    _active = true;
    return ++_current;
  }

  bool accepts(int token) => !_disposed && _active && token == _current;

  /// Invalidates all callbacks from the current transition.
  void cancel() {
    ++_current;
    _active = false;
  }

  /// Finishes only the current transition, without ending newer work.
  bool finish(int token) {
    if (!accepts(token)) return false;
    _active = false;
    return true;
  }

  void dispose() {
    if (_disposed) return;
    cancel();
    _disposed = true;
  }
}
