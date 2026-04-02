import '../../../../core/services/api_client.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

class ApiNotificationsRepository implements NotificationsRepository {
  @override
  Future<List<AppNotification>> getNotifications({
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final response = await ApiClient.instance.get('/notifications', queryParameters: {
        'skip': page * pageSize,
        'limit': pageSize,
      });
      final data = response.data;
      final List items = data is List ? data : (data['data'] ?? []);
      return items.map<AppNotification>((json) => AppNotification(
        id: (json['id'] ?? '').toString(),
        title: json['title'] ?? 'Notificacion',
        body: json['body'] ?? json['message'] ?? '',
        type: json['type']?.toString() ?? 'system',
        createdAt: json['created_at'] != null
            ? (DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now())
            : DateTime.now(),
        isRead: json['is_read'] ?? json['read'] ?? false,
        deviceId: json['device_id']?.toString(),
        deviceName: json['device_name'],
      )).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await ApiClient.instance.put('/notifications/$id/read');
    } catch (_) {}
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await ApiClient.instance.put('/notifications/read-all');
    } catch (_) {}
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await ApiClient.instance.get('/notifications/unread-count');
      return response.data['count'] ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
