import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event_log.dart';
import '../../data/repositories/event_log_repository_impl.dart';

final eventLogRepositoryProvider = Provider((ref) => EventLogRepositoryImpl());

final eventLogProvider = FutureProvider<List<EventLog>>((ref) async {
  final repository = ref.watch(eventLogRepositoryProvider);
  return repository.getEvents();
});
