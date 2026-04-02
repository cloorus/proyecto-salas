/// Entidad de notificación de la aplicación
class AppNotification {
  final String id;
  final String? deviceId;
  final String? deviceName;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> metadata;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    this.deviceId,
    this.deviceName,
    required this.type,
    required this.title,
    required this.body,
    this.metadata = const {},
    required this.isRead,
    required this.createdAt,
  });

  /// Tipos de notificación disponibles
  static const String actionExecuted = 'action_executed';
  static const String deviceOffline = 'device_offline';
  static const String deviceOnline = 'device_online';
  static const String statusChange = 'status_change';

  /// Copia la notificación con campos actualizados
  AppNotification copyWith({
    String? id,
    String? deviceId,
    String? deviceName,
    String? type,
    String? title,
    String? body,
    Map<String, dynamic>? metadata,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotification && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}