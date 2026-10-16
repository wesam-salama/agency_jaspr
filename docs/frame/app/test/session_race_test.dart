import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:frame_academy/session.dart';

class DelayedApi extends FrameApi {
  final reads = <Completer<Map<String, dynamic>>>[];
  final writes = <Completer<Map<String, dynamic>>>[];

  @override
  Future<Map<String, dynamic>> request(
    String path, [
    Map<String, dynamic>? body,
  ]) {
    final response = Completer<Map<String, dynamic>>();
    (body == null ? reads : writes).add(response);
    return response.future;
  }
}

Map<String, dynamic> record(
  String learner, {
  int revision = 1,
  bool complete = false,
  String note = '',
}) => {
  'learner': learner,
  'enrolments': ['FA-PH-01'],
  'completed': complete ? ['01'] : <String>[],
  'drafts': {
    '01': {'note': note, 'attachment': false},
  },
  'revision': revision,
};

void main() {
  test('Late resume read cannot replace the linked learner record', () async {
    final api = DelayedApi();
    final session = LearningSession(api: api);
    final resumed = session.refresh();
    final linked = session.refresh(learnerId: 'demo-ar');
    api.reads[1].complete(
      record('demo-ar', revision: 3, complete: true, note: 'ملاحظة محفوظة'),
    );
    await linked;
    api.reads[0].complete(record('demo', note: 'Earlier English draft'));
    await resumed;
    expect(session.learner, 'demo-ar');
    expect(session.record!['learner'], 'demo-ar');
    expect(session.localNote, 'ملاحظة محفوظة');
    expect(session.count, 1);
    expect(session.confirmed, true);
    expect(session.loading, false);
  });

  for (final readDuringWrite in [false, true]) {
    test(
      'Read ${readDuringWrite ? 'during' : 'before'} completion cannot undo its acknowledgement',
      () async {
        final api = DelayedApi();
        final session = LearningSession(api: api)..accept(record('demo'));
        Future<void>? refresh;
        if (!readDuringWrite) refresh = session.refresh();
        session.edit('Confirmed saved note');
        final save = session.save(complete: true);
        if (readDuringWrite) refresh = session.refresh();
        api.writes.single.complete(
          record(
            'demo',
            revision: 2,
            complete: true,
            note: 'Confirmed saved note',
          ),
        );
        expect(await save, true);
        expect(session.loading, false);
        api.reads.single.complete(record('demo'));
        await refresh;
        expect(session.count, 1);
        expect(session.nextLesson, '02');
        expect(session.localNote, 'Confirmed saved note');
        expect(session.record!['drafts']['01']['note'], 'Confirmed saved note');
        expect(session.confirmed, true);
        expect(session.pending, false);
        expect(session.loading, false);
      },
    );
  }
}
