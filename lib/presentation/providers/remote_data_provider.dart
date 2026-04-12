import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/remote/api_service.dart';

String examIdsToKey(Set<String>? examIds) {
  if (examIds == null || examIds.isEmpty) return '';
  final sorted = examIds.toList()..sort();
  return sorted.join(',');
}

Set<String>? keyToExamIds(String key) {
  if (key.trim().isEmpty) return null;
  return key
      .split(',')
      .map((id) => id.trim())
      .where((id) => id.isNotEmpty)
      .toSet();
}

final deadlinesProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, key) async {
  return ApiService.instance.fetchDeadlines(
    prioritizedExamIds: keyToExamIds(key),
  );
});

final timelineEventsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, key) async {
  return ApiService.instance.fetchTimelineEvents(
    prioritizedExamIds: keyToExamIds(key),
  );
});
