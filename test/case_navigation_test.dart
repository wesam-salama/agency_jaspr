import 'package:agency_jaspr/runtime/case_navigation.dart';
import 'package:test/test.dart';

void main() {
  test('keeps details pending until covered and commits only once', () {
    final navigation = CaseNavigation();
    var commits = 0;
    final token = navigation.begin(() => commits++);

    expect(navigation.pending, isTrue);
    expect(commits, 0);
    expect(navigation.commit(token), isTrue);
    expect(navigation.pending, isFalse);
    expect(commits, 1);
    expect(navigation.commit(token), isFalse);
    expect(commits, 1);
  });

  test('replacement rejects the previous covered callback', () {
    final navigation = CaseNavigation();
    final opened = <String>[];
    final old = navigation.begin(() => opened.add('Loop'));
    final latest = navigation.begin(() => opened.add('Marrow'));

    expect(navigation.commit(old), isFalse);
    expect(navigation.pending, isTrue);
    expect(navigation.commit(latest), isTrue);
    expect(opened, ['Marrow']);
  });

  test('dismissal prevents a delayed opening and permits a fresh request', () {
    final navigation = CaseNavigation();
    final opened = <String>[];
    final cancelled = navigation.begin(() => opened.add('Loop'));

    navigation.cancel();
    navigation.settle();
    expect(navigation.pending, isFalse);
    expect(navigation.commit(cancelled), isFalse);
    expect(opened, isEmpty);

    final fresh = navigation.begin(() => opened.add('Northline'));
    expect(navigation.commit(fresh), isTrue);
    expect(opened, ['Northline']);
  });

  test('policy interruption settles the latest request once', () {
    final navigation = CaseNavigation();
    final opened = <String>[];
    final old = navigation.begin(() => opened.add('Loop'));
    final latest = navigation.begin(() => opened.add('Fenwick & Ash'));

    navigation.settle();
    navigation.settle();
    expect(navigation.pending, isFalse);
    expect(navigation.commit(old), isFalse);
    expect(navigation.commit(latest), isFalse);
    expect(opened, ['Fenwick & Ash']);
  });

  test('clears pending state before the callback can start newer navigation', () {
    final navigation = CaseNavigation();
    final opened = <String>[];
    late int latest;
    final first = navigation.begin(() {
      expect(navigation.pending, isFalse);
      opened.add('Loop');
      latest = navigation.begin(() => opened.add('Marrow'));
    });

    expect(navigation.commit(first), isTrue);
    expect(navigation.pending, isTrue);
    expect(navigation.commit(first), isFalse);
    expect(navigation.commit(latest), isTrue);
    expect(opened, ['Loop', 'Marrow']);
  });

  test('disposal prevents queued and subsequent openings', () {
    final navigation = CaseNavigation();
    var commits = 0;
    final pending = navigation.begin(() => commits++);

    navigation.dispose();
    expect(navigation.commit(pending), isFalse);
    final later = navigation.begin(() => commits++);
    navigation.settle();
    expect(navigation.commit(later), isFalse);
    expect(navigation.pending, isFalse);
    expect(commits, 0);
  });
}
