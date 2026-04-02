import '../entities/app_notification.dart';

/// Repositorio abstracto para gestionar notificaciones
abstract class NotificationsRepository {
  /// Obtiene la lista de notificaciones del usuario con paginación
  /// 
  /// [page] - Número de página (empezando en 0)
  /// [pageSize] - Cantidad de elementos por página
  Future<List<AppNotification>> getNotifications({
    int page = 0,
    int pageSize = 20,
  });

  /// Marca una notificación como leída
  /// 
  /// [id] - ID de la notificación a marcar como leída
  Future<void> markAsRead(String id);

  /// Marca todas las notificaciones como leídas
  Future<void> markAllAsRead();

  /// Obtiene el número de notificaciones no leídas
  Future<int> getUnreadCount();
}