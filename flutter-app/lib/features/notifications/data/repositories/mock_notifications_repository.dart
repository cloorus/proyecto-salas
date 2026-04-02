import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

/// Implementación mock del repositorio de notificaciones con datos de ejemplo
class MockNotificationsRepository implements NotificationsRepository {
  // Lista de notificaciones de ejemplo
  late List<AppNotification> _notifications;

  MockNotificationsRepository() {
    final now = DateTime.now();
    _notifications = [
      AppNotification(
        id: '1',
        deviceId: 'vita_001',
        deviceName: 'Portón Principal',
        type: AppNotification.actionExecuted,
        title: 'Carlos abrió Portón Principal',
        body: 'El dispositivo fue operado por Carlos hace 2 minutos',
        metadata: {
          'actorName': 'Carlos',
          'action': 'OPEN',
        },
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      AppNotification(
        id: '2',
        deviceId: 'vita_002',
        deviceName: 'VITA_APO1234',
        type: AppNotification.deviceOffline,
        title: 'VITA_APO1234 se desconectó',
        body: 'El dispositivo perdió la conexión hace 15 minutos',
        metadata: {
          'lastSeen': now.subtract(const Duration(minutes: 15)).toIso8601String(),
        },
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
      AppNotification(
        id: '3',
        deviceId: 'vita_003',
        deviceName: 'Portón Cochera',
        type: AppNotification.actionExecuted,
        title: 'María cerró Portón Cochera',
        body: 'El dispositivo fue operado por María hace 1 hora',
        metadata: {
          'actorName': 'María',
          'action': 'CLOSE',
        },
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      AppNotification(
        id: '4',
        deviceId: 'vita_002',
        deviceName: 'VITA_APO1234',
        type: AppNotification.deviceOnline,
        title: 'VITA_APO1234 volvió a conectarse',
        body: 'El dispositivo está nuevamente en línea hace 14 minutos',
        metadata: {
          'reconnectedAt': now.subtract(const Duration(minutes: 14)).toIso8601String(),
        },
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 14)),
      ),
      AppNotification(
        id: '5',
        deviceId: 'vita_004',
        deviceName: 'Portón Principal',
        type: AppNotification.actionExecuted,
        title: 'Apertura peatonal por Juan',
        body: 'Juan activó la apertura peatonal hace 3 horas',
        metadata: {
          'actorName': 'Juan',
          'action': 'PEDESTRIAN',
        },
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
    ];
  }

  @override
  Future<List<AppNotification>> getNotifications({
    int page = 0,
    int pageSize = 20,
  }) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Ordenar por fecha (más recientes primero)
    _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    // Aplicar paginación
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, _notifications.length);
    
    if (startIndex >= _notifications.length) {
      return [];
    }
    
    return _notifications.sublist(startIndex, endIndex);
  }

  @override
  Future<void> markAsRead(String id) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    _notifications = _notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 200));
    
    return _notifications.where((notification) => !notification.isRead).length;
  }
}