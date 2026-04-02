import '../services/api_client.dart';
import '../../features/devices/domain/entities/device.dart';

/// Service to fetch devices from the real API
class DeviceService {
  static DeviceService? _instance;
  static DeviceService get instance => _instance ??= DeviceService._();
  DeviceService._();

  /// Fetch all devices for the current user
  Future<List<Device>> getDevices() async {
    try {
      final response = await ApiClient.instance.get('/devices');
      final List data = response.data is List ? response.data : (response.data['data'] ?? []);
      return data.map((json) => _deviceFromJson(json)).toList();
    } catch (e) {
      print('[DeviceService] Error fetching devices: $e');
      rethrow;
    }
  }

  /// Fetch a single device by ID
  Future<Device> getDeviceById(String id) async {
    try {
      final response = await ApiClient.instance.get('/devices/$id');
      return _deviceFromJson(response.data);
    } catch (e) {
      print('[DeviceService] Error fetching device $id: $e');
      rethrow;
    }
  }

  /// Fetch full device details (with users, events, session, actions)
  Future<Map<String, dynamic>> getDeviceFull(String id) async {
    try {
      final response = await ApiClient.instance.get('/devices/$id/full');
      return response.data;
    } catch (e) {
      print('[DeviceService] Error fetching device full $id: $e');
      rethrow;
    }
  }

  /// Send a command to a device
  Future<Map<String, dynamic>> sendCommand(String deviceId, String command) async {
    try {
      final response = await ApiClient.instance.post(
        '/devices/$deviceId/command',
        data: {'command': command},
      );
      return response.data;
    } catch (e) {
      print('[DeviceService] Error sending command: $e');
      rethrow;
    }
  }

  /// Get device parameters
  Future<Map<String, dynamic>> getParams(String deviceId) async {
    try {
      final response = await ApiClient.instance.get('/devices/$deviceId/params');
      return response.data;
    } catch (e) {
      print('[DeviceService] Error fetching params: $e');
      rethrow;
    }
  }

  /// Update device parameters
  Future<void> updateParams(String deviceId, Map<String, dynamic> params) async {
    try {
      await ApiClient.instance.put('/devices/$deviceId/params', data: params);
    } catch (e) {
      print('[DeviceService] Error updating params: $e');
      rethrow;
    }
  }

  /// Get shared users for a device
  Future<List<Map<String, dynamic>>> getDeviceUsers(String deviceId) async {
    try {
      final response = await ApiClient.instance.get('/devices/$deviceId/users');
      final data = response.data;
      if (data is List) return List<Map<String, dynamic>>.from(data);
      if (data is Map && data.containsKey('users')) return List<Map<String, dynamic>>.from(data['users']);
      return [];
    } catch (e) {
      print('[DeviceService] Error fetching device users: $e');
      rethrow;
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await ApiClient.instance.get('/users/me');
      return response.data;
    } catch (e) {
      print('[DeviceService] Error fetching profile: $e');
      rethrow;
    }
  }

  /// Get notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await ApiClient.instance.get('/notifications');
      final data = response.data;
      if (data is List) return List<Map<String, dynamic>>.from(data);
      if (data is Map && data.containsKey('data')) return List<Map<String, dynamic>>.from(data['data']);
      return [];
    } catch (e) {
      print('[DeviceService] Error fetching notifications: $e');
      return [];
    }
  }

  /// Convert API JSON to Device entity
  Device _deviceFromJson(Map<String, dynamic> json) {
    return Device(
      id: (json['id'] ?? json['device_id'] ?? 0).toString(),
      name: json['name'] ?? 'Sin nombre',
      model: json['model'] ?? json['device_type'] ?? 'unknown',
      serialNumber: json['serial_number'] ?? '',
      type: _parseDeviceType(json['device_type']),
      status: _parseDeviceStatus(json['cached_motor_status']),
      isOnline: json['is_online'] ?? false,
      location: json['location'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      lastConnection: json['last_seen'] != null
          ? DateTime.tryParse(json['last_seen'].toString())
          : null,
      imageUrl: json['image_url'],
      isPrimary: json['is_primary'] ?? false,
    );
  }

  DeviceType _parseDeviceType(String? type) {
    switch (type?.toLowerCase()) {
      case 'gate': return DeviceType.gate;
      case 'barrier': return DeviceType.barrier;
      case 'door': return DeviceType.door;
      default: return DeviceType.other;
    }
  }

  DeviceStatus _parseDeviceStatus(dynamic status) {
    if (status == null) return DeviceStatus.ready;
    final s = status is int ? status : int.tryParse(status.toString()) ?? 0;
    switch (s) {
      case 0: return DeviceStatus.ready; // Open
      case 1: return DeviceStatus.opening;
      case 2: return DeviceStatus.ready; // Closed
      case 3: return DeviceStatus.closing;
      case 4: return DeviceStatus.paused;
      case 5: return DeviceStatus.ready; // PedOpen
      case 6: return DeviceStatus.opening; // PedOpening
      default: return DeviceStatus.ready;
    }
  }
}
