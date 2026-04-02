import '../../domain/entities/event_log.dart';
import '../../domain/repositories/event_log_repository.dart';

class EventLogRepositoryImpl implements EventLogRepository {
  @override
  Future<List<EventLog>> getEvents() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      EventLog(
        entity: 'Usuario 1',
        action: 'abre',
        timestamp: DateTime(2024, 3, 20, 13, 17),
      ),
      EventLog(
        entity: 'Usuario 1',
        action: 'cierra',
        timestamp: DateTime(2024, 3, 20, 13, 17),
      ),
      EventLog(
        entity: 'Usuario 2',
        action: 'abre',
        timestamp: DateTime(2024, 3, 20, 13, 17),
      ),
      EventLog(
        entity: 'Usuario 3',
        action: 'cierra',
        timestamp: DateTime(2024, 3, 20, 13, 17),
      ),
      EventLog(
        entity: 'Botón fisico ???',
        action: 'abre',
        timestamp: DateTime(2024, 3, 20, 13, 17),
      ),
      EventLog(
        entity: 'Juan',
        action: 'abre',
        timestamp: DateTime(2024, 3, 16, 15, 20),
      ),
      EventLog(
        entity: 'Carlos',
        action: 'Borra usuario Juan',
        timestamp: DateTime(2024, 3, 15, 12, 36),
      ),
      EventLog(
        entity: 'Carlos',
        action: 'Agrega usuario Pedro',
        timestamp: DateTime(2024, 3, 15, 8, 5),
      ),
      EventLog(
        entity: 'Usuario 4',
        action: 'abre',
        timestamp: DateTime(2024, 3, 14, 10, 30),
      ),
      EventLog(
        entity: 'Usuario 5',
        action: 'cierra',
        timestamp: DateTime(2024, 3, 14, 9, 15),
      ),
      EventLog(
        entity: 'Admin',
        action: 'Modifica configuración',
        timestamp: DateTime(2024, 3, 13, 16, 45),
      ),
      EventLog(
        entity: 'Sistema',
        action: 'Reinicio automático',
        timestamp: DateTime(2024, 3, 12, 3, 0),
      ),
    ];
  }
}
