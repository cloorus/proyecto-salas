import '../../domain/entities/device_info.dart';
import '../../domain/entities/device.dart'; // Import for DeviceType
import '../../domain/repositories/device_repository.dart';
import 'package:flutter/foundation.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  @override
  Future<DeviceInfo> getDeviceInfo(String id) async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data matching the design/requirements
    return DeviceInfo(
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
    );
  }

  @override
  Future<void> updateDevice(DeviceInfo device) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, this would update the backend
    debugPrint('Device updated: ${device.name}');
  }

  @override
  Future<void> createDevice(Map<String, dynamic> deviceData) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    // In a real app, this would create the device in the backend
    debugPrint('Device created: ${deviceData['name']}');
  }
}
