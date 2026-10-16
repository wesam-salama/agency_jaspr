import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frame_academy/main.dart';
import 'package:frame_academy/session.dart';

class TestApi extends FrameApi {
  Map<String, dynamic> data = {
    'learner': 'demo',
    'displayName': 'Demo learner',
    'enrolments': <String>[],
    'completed': <String>[],
    'drafts': <String, dynamic>{},
    'revision': 0,
  };
  bool fail = false;
  Completer<void>? gate;
  @override
  Future<Map<String, dynamic>> request(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    if (path.startsWith('/api/session')) return Map.of(data);
    if (path == '/api/test/fail-next') {
      fail = true;
      return {};
    }
    if (gate != null) await gate!.future;
    if (fail) {
      fail = false;
      throw const SaveException();
    }
    data = Map.of(data)..['revision'] = (data['revision'] as int) + 1;
    if (path == '/api/enrol') data['enrolments'] = ['FA-PH-01'];
    if (path == '/api/draft' || path == '/api/complete') {
      data['drafts'] = {
        '01': {'note': body!['note'], 'attachment': body['attachment']},
      };
      if (path == '/api/complete') data['completed'] = ['01'];
    }
    return Map.of(data);
  }
}

void main() {
  test(
    'A fresh learner starts at zero and enrolment matches FA-PH-01',
    () async {
      final s = LearningSession(api: TestApi());
      await s.refresh();
      expect(s.count, 0);
      expect(s.nextLesson, '01');
      expect(s.enrolled, false);
      await s.enrol();
      expect(s.enrolled, true);
      expect(s.count, 0);
    },
  );
  test('Saving status waits for confirmed persistence', () async {
    final api = TestApi();
    final s = LearningSession(api: api);
    await s.refresh();
    s.edit('Move the subject to the edge.');
    api.gate = Completer<void>();
    final future = s.save();
    expect(s.pending, true);
    expect(s.confirmed, false);
    api.gate!.complete();
    await future;
    expect(s.pending, false);
    expect(s.confirmed, true);
    expect(s.count, 0);
  });
  test(
    'Controlled failure retains note and attachment; retry really saves',
    () async {
      final api = TestApi();
      final s = LearningSession(api: api);
      await s.refresh();
      s.edit('The edge makes more space feel visible.');
      s.attach(true);
      await s.failNext();
      expect(await s.save(), false);
      expect(s.localNote, 'The edge makes more space feel visible.');
      expect(s.localAttachment, true);
      expect(s.confirmed, false);
      expect(s.error, 'save');
      expect(await s.save(), true);
      expect(s.confirmed, true);
      expect(api.data['drafts']['01']['attachment'], true);
    },
  );
  test(
    'Playing is separate from explicit completion, restart resumes 02',
    () async {
      final api = TestApi();
      final s = LearningSession(api: api);
      await s.refresh();
      await s.enrol();
      s.edit('I compared two photographs.');
      await s.save();
      expect(s.count, 0);
      await s.save(complete: true);
      expect(s.count, 1);
      final restarted = LearningSession(api: api);
      await restarted.refresh();
      expect(restarted.count, 1);
      expect(restarted.nextLesson, '02');
      expect(restarted.localNote, 'I compared two photographs.');
    },
  );
  test(
    'An edit while a save is pending never gains a false Saved status',
    () async {
      final api = TestApi();
      final s = LearningSession(api: api);
      await s.refresh();
      s.edit('First draft');
      api.gate = Completer<void>();
      final save = s.save();
      s.edit('Newer draft');
      api.gate!.complete();
      await save;
      expect(s.confirmed, false);
      expect(s.dirty, true);
      expect(s.localNote, 'Newer draft');
      expect(api.data['drafts']['01']['note'], 'First draft');
    },
  );
  testWidgets(
    'Keyboard Tab and Enter open the course; Back restores the opener focus',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        FrameApp(session: LearningSession(api: TestApi()), links: false),
      );
      await tester.pumpAndSettle();
      final languageText = find
          .descendant(
            of: find.byKey(const ValueKey('language')),
            matching: find.byType(Text),
          )
          .first;
      Focus.of(tester.element(languageText)).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final courseText = find
          .descendant(
            of: find.byKey(const ValueKey('course-overview')),
            matching: find.byType(Text),
          )
          .first;
      final opener = Focus.of(tester.element(courseText));
      for (
        var i = 0;
        i < 8 && FocusManager.instance.primaryFocus != opener;
        i++
      ) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
      }
      expect(FocusManager.instance.primaryFocus, opener);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('enrol-or-continue')), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus, opener);
      await tester.pumpWidget(const SizedBox());
    },
  );
  for (final arabic in [false, true]) {
    testWidgets(
      '${arabic ? 'Arabic RTL' : 'English'} phone and large text remain usable',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.platformDispatcher.textScaleFactorTestValue = 1.6;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        tester.platformDispatcher.accessibilityFeaturesTestValue =
            FakeAccessibilityFeatures(disableAnimations: true);
        addTearDown(
          tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
        );
        final s = LearningSession(api: TestApi());
        await tester.pumpWidget(
          FrameApp(session: s, initialArabic: arabic, links: false),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(arabic ? 'اكتمل 0 من 6 دروس' : '0 of 6 lessons complete'),
          findsOneWidget,
        );
        expect(
          Directionality.of(
            tester.element(find.byKey(const ValueKey('progress-text'))),
          ),
          arabic ? TextDirection.rtl : TextDirection.ltr,
        );
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.byKey(const ValueKey('overview-link')));
        await tester.tap(find.byKey(const ValueKey('overview-link')));
        await tester.pumpAndSettle();
        expect(find.text('FA-PH-01'), findsOneWidget);
        expect(
          find.text(
            arabic ? 'لا تحتاج إلى دورة سابقة.' : 'No prior course required.',
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
