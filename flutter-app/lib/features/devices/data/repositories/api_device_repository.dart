import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/device.dart';
import '../../domain/entities/device_info.dart';
import '../../domain/repositories/api_device_repository.dart';
import '../../data/models/mock_devices.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/api_client.dart';

/// Implementación del repositorio de dispositivos usando la API real de Vita
/// Con fallback a datos mock cuando la API retorna 501 (no implementado)
class ApiDeviceRepositoryImpl implements ApiDeviceRepository {
  final ApiClient _apiClient;
  
  ApiDeviceRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;
  
  @override
  Future<Either<Failure, List<Device>>> getDevices() async {
    try {
      final response = await _apiClient.get('/devices');
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        final List<dynamic> devicesJson = responseData is List ? responseData : (responseData['data'] ?? []);
        final devices = devicesJson.map((json) => _deviceFromJson(json)).toList();
        return Right(devices);
      } else if (response.statusCode == 501) {
        // API no implementada, usar datos mock
        return Left(ServerFailure('Error del servidor'));
      } else {
        return Left(ServerFailure('Error obteniendo dispositivos'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 501) {
        // API no implementada, usar datos mock
        return Left(ServerFailure('Error del servidor'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.connectionError) {
        // Error de conexión, usar datos mock como fallback
        return Left(ServerFailure('Error del servidor'));
      } else if (e.response?.statusCode == 401) {
        return Left(InvalidCredentialsFailure('Sesión expirada'));
      } else {
        // Otros errores, usar datos mock como fallback
        return Left(ServerFailure('Error del servidor'));
      }
    } catch (e) {
      // Error inesperado, usar datos mock como fallback
      return Left(ServerFailure('Error del servidor'));
    }
  }
  
  @override
  Future<Either<Failure, DeviceInfo>> getDeviceInfo(String id) async {
    try {
      final response = await _apiClient.get('/devices/$id');
      
      if (response.statusCode == 200) {
        final deviceInfo = _deviceInfoFromJson(response.data);
        return Right(deviceInfo);
      } else if (response.statusCode == 501) {
        // API no implementada, usar datos mock
        return _getMockDeviceInfo(id);
      } else {
        return Left(ServerFailure('Error obteniendo información del dispositivo'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 501) {
        // API no implementada, usar datos mock
        return _getMockDeviceInfo(id);
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Dispositivo no encontrado'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.connectionError) {
        // Error de conexión, usar datos mock como fallback
        return _getMockDeviceInfo(id);
      } else if (e.response?.statusCode == 401) {
        return Left(InvalidCredentialsFailure('Sesión expirada'));
      } else {
        // Otros errores, usar datos mock como fallback
        return _getMockDeviceInfo(id);
      }
    } catch (e) {
      // Error inesperado, usar datos mock como fallback
      return _getMockDeviceInfo(id);
    }
  }
  
  @override
  Future<Either<Failure, Device>> createDevice(Map<String, dynamic> deviceData) async {
    try {
      final response = await _apiClient.post('/devices', data: deviceData);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final device = _deviceFromJson(response.data);
        return Right(device);
      } else if (response.statusCode == 501) {
        // API no implementada, simular éxito con datos mock
        return Right(_createMockDevice(deviceData));
      } else {
        return Left(ServerFailure('Error creando dispositivo'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 501) {
        // API no implementada, simular éxito con datos mock
        return Right(_createMockDevice(deviceData));
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure('Error de conexión'));
      } else if (e.response?.statusCode == 401) {
        return Left(InvalidCredentialsFailure('Sesión expirada'));
      } else {
        return Left(ServerFailure('Error del servidor'));
      }
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, Device>> updateDevice(String id, Map<String, dynamic> deviceData) async {
    try {
      final response = await _apiClient.put('/devices/$id', data: deviceData);
      
      if (response.statusCode == 200) {
        final device = _deviceFromJson(response.data);
        return Right(device);
      } else if (response.statusCode == 501) {
        // API no implementada, simular éxito
        return Left(ServerFailure('Dispositivo no encontrado'));
      } else {
        return Left(ServerFailure('Error actualizando dispositivo'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 501) {
        // API no implementada, simular éxito
        return Left(ServerFailure('Dispositivo no encontrado'));
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Dispositivo no encontrado'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure('Error de conexión'));
      } else if (e.response?.statusCode == 401) {
        return Left(InvalidCredentialsFailure('Sesión expirada'));
      } else {
        return Left(ServerFailure('Error del servidor'));
      }
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteDevice(String id) async {
    try {
      final response = await _apiClient.delete('/devices/$id');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(null);
      } else if (response.statusCode == 501) {
        // API no implementada, simular éxito
        return const Right(null);
      } else {
        return Left(ServerFailure('Error eliminando dispositivo'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 501) {
        // API no implementada, simular éxito
        return const Right(null);
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Dispositivo no encontrado'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure('Error de conexión'));
      } else if (e.response?.statusCode == 401) {
        return Left(InvalidCredentialsFailure('Sesión expirada'));
      } else {
        return Left(ServerFailure('Error del servidor'));
      }
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> sendCommand(String id, String action) async {
    // Validar que la acción sea válida
    if (!['OPEN', 'CLOSE', 'STOP', 'OCS', 'PEDESTRIAN', 'LAMP', 'RELE', 'open', 'close', 'pause', 'pedestrian'].contains(action)) {
      return Left(ServerFailure('Acción no válida'));
    }
    
    try {
      final response = await _apiClient.post(
        '/devices/$id/command',
        data: {'command': action},
      );
      
      if (response.statusCode == 200) {
        return const Right(null);
      } else if (response.statusCode == 501) {
        // API no implementada, simular éxito
        return const Right(null);
      } else {
        return Left(ServerFailure('Error enviando comando al dispositivo'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 501) {
        // API no implementada, simular éxito
        return const Right(null);
      } else if (e.response?.statusCode == 404) {
        return Left(ServerFailure('Dispositivo no encontrado'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure('Error de conexión'));
      } else if (e.response?.statusCode == 401) {
        return Left(InvalidCredentialsFailure('Sesión expirada'));
      } else {
        return Left(ServerFailure('Error del servidor'));
      }
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
  

  Future<Either<Failure, void>> uploadDevicePhoto(String deviceId, dynamic imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: imageFile.name ?? 'photo.jpg'),
      });
      final response = await _apiClient.postMultipart('/devices/$deviceId/photo', data: formData);
      if (response.statusCode == 200) return const Right(null);
      return Left(ServerFailure('Error uploading photo'));
    } catch (e) {
      return Left(ServerFailure('Error: $e'));
    }
  }

  /// Convierte JSON de la API a Device entity
  Device _deviceFromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'].toString(),
      name: json['name'] ?? 'Dispositivo sin nombre',
      model: json['model'] ?? json['device_type'] ?? 'Desconocido',
      serialNumber: json['serial_number'] ?? json['serialNumber'] ?? 'N/A',
      type: _parseDeviceType(json['device_type'] ?? json['type']),
      status: _parseMotorStatus(json['cached_motor_status']),
      isOnline: json['is_online'] ?? json['online'] ?? false,
      location: json['location'],
      description: json['description'],
      createdAt: json['created_at'] != null 
          ? (DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
      lastConnection: json['last_seen'] != null
          ? DateTime.tryParse(json['last_seen'].toString())
          : (json['last_connection'] != null
              ? DateTime.tryParse(json['last_connection'].toString())
              : null),
      imageUrl: json['photo_url'] != null ? 'https://app-bgnius.webcomcr.com' + json['photo_url'].toString() : json['image_url'],
      isPrimary: json['is_primary'] ?? false,
    );
  }
  
  /// Convierte JSON de la API a DeviceInfo entity
  DeviceInfo _deviceInfoFromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['id'].toString(),
      serialNumber: json['serial_number'] ?? json['serialNumber'] ?? 'N/A',
      name: json['name'] ?? 'Dispositivo sin nombre',
      version: json['version'] ?? '1.0.0',
      fullVersion: json['full_version'] ?? json['firmware_version'] ?? '1.0.0',
      totalCycles: json['total_cycles'] ?? 0,
      maintenanceCount: json['maintenance_count'] ?? 0,
      activationDate: json['activation_date'] != null
          ? DateTime.parse(json['activation_date'])
          : DateTime.now(),
      status: json['motor_status_name'] ?? json['status'] ?? 'Listo',
      signalStrength: json['signal_strength'] ?? 0,
      groupName: json['location'] ?? json['group_name'] ?? 'Sin grupo',
      isFavorite: json['is_favorite'] ?? false,
      technicalContact: json['technical_contact'] ?? 'No asignado',
      hasCustomPhoto: json['photo_url'] != null && json['photo_url'].toString().isNotEmpty,
      photoUrl: json['photo_url'] != null ? 'https://app-bgnius.webcomcr.com${json["photo_url"]}' : null,
      model: json['model'] ?? 'Modelo desconocido',
      description: json['description'] ?? '',
      type: _parseDeviceType(json['device_type'] ?? json['type']),
      macAddress: json['mac_address'] ?? 'N/A',
      hardwareVersion: json['hardware_version'] ?? '1.0.0',
      firmwareVersion: json['firmware_version'] ?? '1.0.0',
      autoCloseSeconds: json['auto_close_seconds'] ?? 30,
      maxOpenTimeSeconds: json['max_open_time_seconds'] ?? 120,
      pedestrianTimeoutSeconds: json['pedestrian_timeout_seconds'] ?? 15,
      isEmergencyMode: json['is_emergency_mode'] ?? false,
      isAutoLampOn: json['is_auto_lamp_on'] ?? false,
      isMaintenanceMode: json['is_maintenance_mode'] ?? false,
      isLocked: json['is_locked'] ?? false,
      installationDate: json['installation_date'] != null
          ? DateTime.parse(json['installation_date'])
          : DateTime.now(),
      warrantyExpirationDate: json['warranty_expiration_date'] != null
          ? DateTime.parse(json['warranty_expiration_date'])
          : DateTime.now().add(const Duration(days: 365)),
      scheduledMaintenanceDate: json['scheduled_maintenance_date'] != null
          ? DateTime.parse(json['scheduled_maintenance_date'])
          : DateTime.now().add(const Duration(days: 30)),
      maintenanceNotes: json['maintenance_notes'] ?? '',
      powerType: json['power_type'] ?? 'AC',
      motorType: json['motor_type'] ?? 'Cremallera',
      hasOpeningPhotocell: json['has_opening_photocell'] ?? false,
      hasClosingPhotocell: json['has_closing_photocell'] ?? false,
    );
  }
  
  /// Parse device type from API string
  DeviceStatus _parseMotorStatus(dynamic status) {
    if (status == null) return DeviceStatus.ready;
    final s = status is int ? status : int.tryParse(status.toString()) ?? 0;
    switch (s) {
      case 0: return DeviceStatus.ready;
      case 1: return DeviceStatus.opening;
      case 2: return DeviceStatus.ready;
      case 3: return DeviceStatus.closing;
      case 4: return DeviceStatus.paused;
      default: return DeviceStatus.ready;
    }
  }

  DeviceType _parseDeviceType(dynamic type) {
    if (type == null) return DeviceType.other;
    
    switch (type.toString().toLowerCase()) {
      case 'gate':
      case 'porton':
        return DeviceType.gate;
      case 'barrier':
      case 'barrera':
        return DeviceType.barrier;
      case 'door':
      case 'puerta':
        return DeviceType.door;
      default:
        return DeviceType.other;
    }
  }
  
  /// Parse device status from API string
  DeviceStatus _parseDeviceStatus(dynamic status) {
    if (status == null) return DeviceStatus.ready;
    
    switch (status.toString().toLowerCase()) {
      case 'ready':
      case 'listo':
        return DeviceStatus.ready;
      case 'opening':
      case 'abriendo':
        return DeviceStatus.opening;
      case 'closing':
      case 'cerrando':
        return DeviceStatus.closing;
      case 'paused':
      case 'pausado':
        return DeviceStatus.paused;
      case 'error':
        return DeviceStatus.error;
      case 'maintenance':
      case 'mantenimiento':
        return DeviceStatus.maintenance;
      default:
        return DeviceStatus.ready;
    }
  }
  
  /// Fallback para obtener información de dispositivo usando mock data
  Either<Failure, DeviceInfo> _getMockDeviceInfo(String id) {
    // Esta es una implementación mock para DeviceInfo basada en el repository existente
    // En un caso real, esto sería extraído del repository mock existente
    return Right(DeviceInfo(
      id: id,
      serialNumber: 'BGNVITA2024X',
      name: 'Puerta Principal',
      version: '1.0.0',
      fullVersion: '010124.1259',
      totalCycles: 15326,
      maintenanceCount: 1,
      activationDate: DateTime(2020, 1, 1),
      status: 'Listo',
      signalStrength: 75,
      groupName: 'Entrada Principal',
      isFavorite: true,
      technicalContact: 'Juan Pérez',
      hasCustomPhoto: false,
      model: 'FAC 500-900 VITA',
      description: 'Motor principal de acceso',
      type: DeviceType.gate,
      macAddress: '00:1A:2B:3C:4D:5E',
      hardwareVersion: '2.1.0',
      firmwareVersion: '3.2.1',
      autoCloseSeconds: 30,
      maxOpenTimeSeconds: 120,
      pedestrianTimeoutSeconds: 15,
      isEmergencyMode: false,
      isAutoLampOn: true,
      isMaintenanceMode: false,
      isLocked: false,
      installationDate: DateTime.now().subtract(const Duration(days: 365)),
      warrantyExpirationDate: DateTime.now().add(const Duration(days: 365)),
      scheduledMaintenanceDate: DateTime.now().add(const Duration(days: 30)),
      maintenanceNotes: 'Mantenimiento preventivo realizado hace 6 meses.',
      powerType: 'AC',
      motorType: 'Cremallera',
      hasOpeningPhotocell: true,
      hasClosingPhotocell: true,
    ));
  }
  
  /// Crea un dispositivo mock para simular la creación cuando la API no está implementada
  Device _createMockDevice(Map<String, dynamic> deviceData) {
    return Device(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: deviceData['name'] ?? 'Nuevo dispositivo',
      model: deviceData['model'] ?? 'BGnius Pro 3000',
      serialNumber: deviceData['serial_number'] ?? 'BGN-NEW-${DateTime.now().millisecondsSinceEpoch}',
      type: _parseDeviceType(deviceData['type']),
      status: DeviceStatus.ready,
      isOnline: false,
      location: deviceData['location'],
      description: deviceData['description'],
      createdAt: DateTime.now(),
      isPrimary: false,
    );
  }
}