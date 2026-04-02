import 'dart:async';
import '../../domain/repositories/provisioning_repository.dart';

class MockProvisioningRepository implements ProvisioningRepository {
  String? _connectedDeviceId;

  @override
  Stream<List<BleDeviceInfo>> scanBLE() async* {
    // Simula espera inicial (vacío)
    await Future.delayed(const Duration(seconds: 1));
    yield [];

    // Simula encontrar dispositivos después de 3 segundos
    await Future.delayed(const Duration(seconds: 2));
    
    yield [
      const BleDeviceInfo(
        id: 'ble_vita_001',
        name: 'VITA-Gate-8291',
        rssi: -45, // Señal fuerte
        serialNumber: 'SN-VITA-8291',
      ),
      const BleDeviceInfo(
        id: 'ble_vita_002',
        name: 'VITA-Door-9156',
        rssi: -65, // Señal media
        serialNumber: 'SN-VITA-9156',
      ),
    ];
  }

  @override
  Future<void> connectBLE(String deviceId) async {
    // Simula conexión BLE (2 segundos)
    await Future.delayed(const Duration(seconds: 2));
    
    // Simular fallo ocasional para testing
    if (deviceId == 'fail_test') {
      throw Exception('Error de conexión BLE');
    }
    
    _connectedDeviceId = deviceId;
  }

  @override
  Future<DeviceDetails> readDeviceInfo(String deviceId) async {
    if (_connectedDeviceId != deviceId) {
      throw Exception('Dispositivo no conectado');
    }

    // Simula lectura de información del dispositivo
    await Future.delayed(const Duration(milliseconds: 800));

    // Devolver información mock basada en el ID
    if (deviceId == 'ble_vita_001') {
      return const DeviceDetails(
        serialNumber: 'SN-VITA-8291',
        firmwareVersion: 'v2.1.4',
        model: 'VITA Smart Gate Pro',
        motorType: 'Servo HD-180°',
      );
    } else {
      return const DeviceDetails(
        serialNumber: 'SN-VITA-9156',
        firmwareVersion: 'v2.0.8',
        model: 'VITA Smart Door',
        motorType: 'Linear Actuator 12V',
      );
    }
  }

  @override
  Future<void> configureDevice(String deviceId, DeviceConfiguration config) async {
    if (_connectedDeviceId != deviceId) {
      throw Exception('Dispositivo no conectado');
    }

    // Simula envío de configuración via BLE
    await Future.delayed(const Duration(seconds: 1));

    // Simular fallo si el nombre está vacío
    if (config.deviceName.trim().isEmpty) {
      throw Exception('Nombre del dispositivo requerido');
    }
  }

  @override
  Future<void> disconnect() async {
    // Simula desconexión BLE
    await Future.delayed(const Duration(milliseconds: 300));
    _connectedDeviceId = null;
  }
}
