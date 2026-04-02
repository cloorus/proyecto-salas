import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../data/repositories/api_notifications_repository.dart';

/// Estado de las notificaciones
class NotificationsState {
  final List<AppNotification> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Provider del repositorio de notificaciones
final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return ApiNotificationsRepository();
});

/// Provider del estado de notificaciones
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(ref.read(notificationsRepositoryProvider));
});

/// Notifier para gestionar el estado de las notificaciones
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsNotifier(this._repository) : super(const NotificationsState()) {
    // Cargar notificaciones y conteo no leído al inicializar
    loadNotifications();
    loadUnreadCount();
  }

  /// Carga la lista de notificaciones
  Future<void> loadNotifications({int page = 0, int pageSize = 20}) async {
    try {
      if (page == 0) {
        state = state.copyWith(isLoading: true, error: null);
      }

      final notifications = await _repository.getNotifications(
        page: page,
        pageSize: pageSize,
      );

      if (page == 0) {
        // Primera página: reemplazar lista completa
        state = state.copyWith(
          notifications: notifications,
          isLoading: false,
        );
      } else {
        // Páginas siguientes: agregar a la lista existente
        state = state.copyWith(
          notifications: [...state.notifications, ...notifications],
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Carga el conteo de notificaciones no leídas
  Future<void> loadUnreadCount() async {
    try {
      final unreadCount = await _repository.getUnreadCount();
      state = state.copyWith(unreadCount: unreadCount);
    } catch (e) {
      // Ignorar errores del conteo de no leídas para no afectar la UI principal
    }
  }

  /// Marca una notificación como leída
  Future<void> markAsRead(String id) async {
    try {
      await _repository.markAsRead(id);
      
      // Actualizar el estado local
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == id) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      // Actualizar conteo de no leídas
      final newUnreadCount = updatedNotifications.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Marca todas las notificaciones como leídas
  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      
      // Actualizar el estado local
      final updatedNotifications = state.notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Refresca las notificaciones
  Future<void> refresh() async {
    await Future.wait([
      loadNotifications(page: 0),
      loadUnreadCount(),
    ]);
  }
}