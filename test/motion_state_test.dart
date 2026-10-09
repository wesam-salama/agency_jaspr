import 'package:agency_jaspr/runtime/motion_state.dart';
import 'package:test/test.dart';

void main() {
  group('MotionState', () {
    test('permits ambient motion in a visible, unpaused page by default', () {
      final state = MotionState();

      expect(state.reduced, isFalse);
      expect(state.ambientAllowed, isTrue);
      expect(state.update(), isFalse);
      expect(state.update(documentVisible: true, userPaused: false), isFalse);
    });

    test('explicit resume cannot override the system reduced motion preference', () {
      final state = MotionState(reducedBySystem: true, userPaused: true);

      expect(state.update(userPaused: false), isTrue);
      expect(state.userPaused, isFalse);
      expect(state.reducedBySystem, isTrue);
      expect(state.reduced, isTrue);
      expect(state.ambientAllowed, isFalse);

      expect(state.update(reducedBySystem: false), isTrue);
      expect(state.reduced, isFalse);
      expect(state.ambientAllowed, isTrue);
    });

    test('system preference changes preserve a user pause', () {
      final state = MotionState(userPaused: true);

      state.update(reducedBySystem: true);
      state.update(reducedBySystem: false);

      expect(state.userPaused, isTrue);
      expect(state.reduced, isTrue);
      expect(state.ambientAllowed, isFalse);
      state.update(userPaused: false);
      expect(state.ambientAllowed, isTrue);
    });

    test('restores motion only after both visibility and modal blockers clear', () {
      final state = MotionState();

      state.update(documentVisible: false);
      expect(state.reduced, isFalse);
      expect(state.ambientAllowed, isFalse);
      state.update(modalOpen: true);
      state.update(documentVisible: true);
      expect(state.ambientAllowed, isFalse);
      state.update(modalOpen: false);
      expect(state.ambientAllowed, isTrue);

      state.update(documentVisible: false, modalOpen: true);
      state.update(modalOpen: false);
      expect(state.ambientAllowed, isFalse);
      state.update(documentVisible: true);
      expect(state.ambientAllowed, isTrue);
    });

    test('closing a modal and returning to the page cannot clear a user pause', () {
      final state = MotionState(userPaused: true, documentVisible: false, modalOpen: true);

      expect(state.update(documentVisible: true, modalOpen: false), isTrue);
      expect(state.userPaused, isTrue);
      expect(state.reduced, isTrue);
      expect(state.ambientAllowed, isFalse);
      expect(state.update(documentVisible: true, modalOpen: false), isFalse);
    });

    test('reports flag changes even when ambient motion remains suspended', () {
      final state = MotionState(reducedBySystem: true);

      expect(state.update(modalOpen: true), isTrue);
      expect(state.ambientAllowed, isFalse);
      expect(state.update(modalOpen: true), isFalse);
      expect(state.update(modalOpen: false, documentVisible: false), isTrue);
      expect(state.modalOpen, isFalse);
      expect(state.documentVisible, isFalse);
      expect(state.reducedBySystem, isTrue);
    });

    test('allows ambient motion only when every policy condition permits it', () {
      for (final reducedBySystem in [false, true]) {
        for (final userPaused in [false, true]) {
          for (final documentVisible in [false, true]) {
            for (final modalOpen in [false, true]) {
              final state = MotionState(
                reducedBySystem: reducedBySystem,
                userPaused: userPaused,
                documentVisible: documentVisible,
                modalOpen: modalOpen,
              );

              expect(state.reduced, reducedBySystem || userPaused);
              expect(
                state.ambientAllowed,
                !reducedBySystem && !userPaused && documentVisible && !modalOpen,
                reason: 'system=$reducedBySystem, paused=$userPaused, visible=$documentVisible, modal=$modalOpen',
              );
            }
          }
        }
      }
    });
  });

  group('MotionGeneration', () {
    test('accepts callbacks only while a started transition is active', () {
      final generation = MotionGeneration();

      expect(generation.accepts(generation.current), isFalse);
      final token = generation.begin();
      expect(generation.active, isTrue);
      expect(generation.accepts(token), isTrue);
      expect(generation.accepts(token + 1), isFalse);
      expect(generation.finish(token), isTrue);
      expect(generation.active, isFalse);
      expect(generation.accepts(token), isFalse);
      expect(generation.finish(token), isFalse);
    });

    test('a stale completion cannot end the next transition', () {
      final generation = MotionGeneration();
      final first = generation.begin();
      final next = generation.begin();

      expect(next, greaterThan(first));
      expect(generation.accepts(first), isFalse);
      expect(generation.finish(first), isFalse);
      expect(generation.active, isTrue);
      expect(generation.accepts(next), isTrue);
      expect(generation.finish(next), isTrue);
    });

    test('closing cancels callbacks and reopening authorizes only the new transition', () {
      final generation = MotionGeneration();
      final opening = generation.begin();

      generation.cancel();
      expect(generation.current, greaterThan(opening));
      expect(generation.active, isFalse);
      expect(generation.accepts(opening), isFalse);
      expect(generation.finish(opening), isFalse);

      final reopened = generation.begin();
      expect(generation.finish(opening), isFalse);
      expect(generation.accepts(reopened), isTrue);
      expect(generation.finish(reopened), isTrue);
    });

    test('cancellation revokes a queued completion even before another transition begins', () {
      final generation = MotionGeneration();
      final token = generation.begin();
      final queuedCompletions = <bool Function()>[() => generation.finish(token)];

      generation.cancel();

      expect(queuedCompletions.single(), isFalse);
      expect(generation.active, isFalse);
    });

    test('disposal revokes pending work and permanently refuses subsequent starts', () {
      final generation = MotionGeneration();
      final token = generation.begin();

      generation.dispose();
      expect(generation.disposed, isTrue);
      expect(generation.active, isFalse);
      expect(generation.accepts(token), isFalse);
      expect(generation.finish(token), isFalse);
      final afterDisposal = generation.begin();
      expect(generation.active, isFalse);
      expect(generation.accepts(afterDisposal), isFalse);
      expect(generation.finish(afterDisposal), isFalse);

      final disposedCurrent = generation.current;
      generation.dispose();
      expect(generation.current, disposedCurrent);
      expect(generation.disposed, isTrue);
    });
  });
}
