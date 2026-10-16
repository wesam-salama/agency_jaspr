import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

const apiBase = String.fromEnvironment(
  'FRAME_API',
  defaultValue: 'http://127.0.0.1:8803',
);

class FrameApi {
  Future<Map<String, dynamic>> request(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 6);
    try {
      final request = await client.openUrl(
        body == null ? 'GET' : 'POST',
        Uri.parse('$apiBase$path'),
      );
      if (body != null) {
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode(body));
      }
      final response = await request.close().timeout(
        const Duration(seconds: 8),
      );
      final text = await utf8.decoder.bind(response).join();
      if (response.statusCode >= 400) throw const SaveException();
      return jsonDecode(text) as Map<String, dynamic>;
    } finally {
      client.close();
    }
  }
}

class SaveException implements Exception {
  const SaveException();
}

class LearningSession extends ChangeNotifier {
  LearningSession({FrameApi? api, this.learner = 'demo'})
    : api = api ?? FrameApi();
  final FrameApi api;
  String learner;
  Map<String, dynamic>? record;
  bool loading = true;
  bool pending = false;
  bool offline = false;
  String? error;
  String localNote = '';
  bool localAttachment = false;
  bool dirty = false;
  bool confirmed = false;
  int _readGeneration = 0;

  void _invalidateReads() {
    _readGeneration++;
    loading = false;
  }

  int get count => (record?['completed'] as List? ?? []).length;
  bool get enrolled =>
      (record?['enrolments'] as List? ?? []).contains('FA-PH-01');
  bool get firstComplete =>
      (record?['completed'] as List? ?? []).contains('01');
  String get nextLesson => firstComplete ? '02' : '01';
  int get revision => record?['revision'] as int? ?? 0;

  void accept(Map<String, dynamic> data, {bool loadDraft = false}) {
    record = data;
    if (loadDraft) {
      final drafts = data['drafts'] as Map? ?? {};
      final draft = drafts['01'] as Map? ?? {};
      localNote = draft['note'] as String? ?? '';
      localAttachment = draft['attachment'] == true;
      confirmed = localNote.isNotEmpty || localAttachment;
      dirty = false;
    }
  }

  Future<void> refresh({String? learnerId}) async {
    if (learnerId != null && learnerId != learner) {
      learner = learnerId;
      record = null;
      localNote = '';
      localAttachment = false;
      confirmed = false;
      dirty = false;
    }
    loading = true;
    error = null;
    final requestedLearner = learner;
    final generation = ++_readGeneration;
    bool isCurrent() =>
        generation == _readGeneration && requestedLearner == learner;
    notifyListeners();
    try {
      final data = await api.request(
        '/api/session?learner=${Uri.encodeQueryComponent(requestedLearner)}',
      );
      if (!isCurrent()) return;
      accept(data, loadDraft: !dirty);
      offline = false;
    } catch (_) {
      if (!isCurrent()) return;
      offline = true;
      error = 'load';
    }
    if (!isCurrent()) return;
    loading = false;
    notifyListeners();
  }

  Future<bool> enrol() async {
    _invalidateReads();
    pending = true;
    error = null;
    notifyListeners();
    try {
      final result = await api.request('/api/enrol', {
        'learner': learner,
        'courseId': 'FA-PH-01',
      });
      _invalidateReads();
      accept(result);
      offline = false;
      pending = false;
      notifyListeners();
      return true;
    } catch (_) {
      _invalidateReads();
      error = 'enrol';
      pending = false;
      notifyListeners();
      return false;
    }
  }

  void edit(String note) {
    localNote = note;
    dirty = true;
    confirmed = false;
    error = null;
    notifyListeners();
  }

  void attach(bool attachment) {
    localAttachment = attachment;
    dirty = true;
    confirmed = false;
    error = null;
    notifyListeners();
  }

  Future<bool> save({bool complete = false}) async {
    _invalidateReads();
    pending = true;
    confirmed = false;
    error = null;
    notifyListeners();
    final noteAtSave = localNote;
    final attachmentAtSave = localAttachment;
    try {
      final result = await api.request(
        complete ? '/api/complete' : '/api/draft',
        {
          'learner': learner,
          'lessonId': '01',
          'note': noteAtSave,
          'attachment': attachmentAtSave,
        },
      );
      _invalidateReads();
      accept(result);
      dirty = localNote != noteAtSave || localAttachment != attachmentAtSave;
      confirmed = !dirty;
      offline = false;
      pending = false;
      notifyListeners();
      return true;
    } catch (_) {
      _invalidateReads();
      error = complete ? 'complete' : 'save';
      pending = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> failNext() async {
    await api.request('/api/test/fail-next', {'learner': learner});
  }
}
