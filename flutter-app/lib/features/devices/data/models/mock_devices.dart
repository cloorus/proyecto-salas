import '../../domain/entities/device.dart';

/// Datos mock de dispositivos
class MockDevices {
  MockDevices._();

  static final List<Device> devices = [
    Device(
      id: '1',
      name: 'Puerta principal',
      model: 'BGnius Pro 3000',
      serialNumber: 'BGN-PT-001234',
      type: DeviceType.gate,
      status: DeviceStatus.ready,
      isOnline: true,
      location: 'Entrada Principal - Edificio A',
      description: 'Portón automático de acceso principal',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      lastConnection: DateTime.now().subtract(const Duration(minutes: 5)),
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80',
      isPrimary: true,
    ),
    Device(
      id: '2',
      name: 'Casa de playa',
      model: 'BGnius Door 1500',
      serialNumber: 'BGN-DR-009012',
      type: DeviceType.door,
      status: DeviceStatus.ready,
      isOnline: false,
      location: 'Acceso Trasero - Zona de Carga',
      description: 'Puerta de acceso trasero',
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      lastConnection: DateTime.now().subtract(const Duration(hours: 3)),
      imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=400&q=80',
    ),
    Device(
      id: '3',
      name: 'Cochera #1',
      model: 'BGnius Barrier 2000',
      serialNumber: 'BGN-BR-005678',
      type: DeviceType.barrier,
      status: DeviceStatus.ready,
      isOnline: true,
      location: 'Estacionamiento Nivel 1',
      description: 'Barrera vehicular automatizada',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      lastConnection: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    Device(
      id: '4',
      name: 'Dispositivo A',
      model: 'BGnius Pro 3000',
      serialNumber: 'BGN-PT-003456',
      type: DeviceType.gate,
      status: DeviceStatus.maintenance,
      isOnline: false,
      location: 'Garaje Subterráneo',
      description: 'Portón de garaje residencial',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastConnection: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Device(
      id: '5',
      name: 'Dispositivo B',
      model: 'BGnius Barrier 2000',
      serialNumber: 'BGN-BR-007890',
      type: DeviceType.barrier,
      status: DeviceStatus.ready,
      isOnline: true,
      location: 'Salida Principal',
      description: 'Barrera de control de salida',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      lastConnection: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    Device(
      id: '6',
      name: 'ETC',
      model: 'BGnius Access 1000',
      serialNumber: 'BGN-AC-001122',
      type: DeviceType.gate,
      status: DeviceStatus.ready,
      isOnline: true,
      location: 'Entrada de Servicio',
      description: 'Control de acceso ETC',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      lastConnection: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
    Device(
      id: '7',
      name: 'ETC-Pocos permisos',
      model: 'BGnius Basic',
      serialNumber: 'BGN-TC-00999',
      type: DeviceType.gate,
      status: DeviceStatus.ready,
      isOnline: true,
      location: 'Acceso Restringido',
      description: 'Dispositivo con permisos limitados',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      lastConnection: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  /// Obtiene un dispositivo por ID
  static Device? getById(String id) {
    try {
      return devices.firstWhere((device) => device.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene dispositivos en línea
  static List<Device> getOnlineDevices() {
    return devices.where((device) => device.isOnline).toList();
  }

  /// Obtiene dispositivos fuera de línea
  static List<Device> getOfflineDevices() {
    return devices.where((device) => !device.isOnline).toList();
  }
}
