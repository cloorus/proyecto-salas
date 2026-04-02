import '../entities/device.dart';

// Entidad para información básica del dispositivo BLE detectado
class BleDeviceInfo {
  final String id;
  final String name;
  final int rssi; // Señal strength
  final String serialNumber;

  const BleDeviceInfo({
    required this.id,
    required this.name,
    required this.rssi,
    required this.serialNumber,
  });
}

// Entidad para información completa del dispositivo después de la conexión
class DeviceDetails {
  final String serialNumber;
  final String firmwareVersion;
  final String model;
  final String motorType;

  const DeviceDetails({
    required this.serialNumber,
    required this.firmwareVersion,
    required this.model,
    required this.motorType,
  });
}

// Configuración inicial del dispositivo
class DeviceConfiguration {
  final String deviceName;
  final String location;
  final String description;
  final String deviceType; // 'gate', 'door', 'barrier'

  const DeviceConfiguration({
    required this.deviceName,
    required this.location,
    required this.description,
    required this.deviceType,
  });
}

abstract class ProvisioningRepository {
  /// Escanea dispositivos VITA cercanos via BLE
  Stream<List<BleDeviceInfo>> scanBLE();

  /// Se conecta a un dispositivo BLE específico
  Future<void> connectBLE(String deviceId);

  /// Lee información completa del dispositivo conectado
  Future<DeviceDetails> readDeviceInfo(String deviceId);

  /// Configura el dispositivo con los datos iniciales
  Future<void> configureDevice(String deviceId, DeviceConfiguration config);

  /// Desconecta del dispositivo BLE actual
  Future<void> disconnect();
}
