import '../entities/event_log.dart';

abstract class EventLogRepository {
  Future<List<EventLog>> getEvents();
}
