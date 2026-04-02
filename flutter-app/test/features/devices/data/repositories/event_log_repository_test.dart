import 'package:flutter_test/flutter_test.dart';
import 'package:bgnius_vita/features/devices/data/repositories/event_log_repository_impl.dart';
import 'package:bgnius_vita/features/devices/domain/entities/event_log.dart';

void main() {
  late EventLogRepositoryImpl repository;

  setUp(() {
    repository = EventLogRepositoryImpl();
  });

  group('EventLogRepositoryImpl', () {
    test('getEvents returns a list of EventLog', () async {
      final result = await repository.getEvents();
      
      expect(result, isA<List<EventLog>>());
      expect(result.isNotEmpty, true);
      expect(result.length, 12); // Based on the mock data
    });

    test('getEvents returns correct mock data values', () async {
      final result = await repository.getEvents();
      final firstEvent = result.first;

      expect(firstEvent.entity, 'Usuario 1');
      expect(firstEvent.action, 'abre');
      expect(firstEvent.timestamp, DateTime(2024, 3, 20, 13, 17));
    });
  });
}
