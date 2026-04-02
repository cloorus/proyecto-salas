import '../../domain/entities/device_group.dart';
import '../../../devices/data/models/mock_devices.dart';

/// Datos mock de grupos implementando requerimiento de grupo "TODOS"
class MockGroups {
  MockGroups._();

  /// ID del grupo TODOS (constante para referencias)
  static const String todosGroupId = 'group_todos';

  /// Getter dinámico para obtener la lista actualizada de grupos
  static List<DeviceGroup> get groups {
    // 1. Obtener todos los IDs de dispositivos disponibles
    final allDeviceIds = MockDevices.devices.map((d) => d.id).toList();

    // 2. Crear grupo "TODOS" (Requerimiento Crítico #4)
    final todosGroup = DeviceGroup(
      id: todosGroupId,
      name: 'TODOS',
      description: 'Todos los dispositivos disponibles',
      deviceIds: allDeviceIds,
      createdAt: DateTime.now(), // Siempre "recién creado" en mock
    );

    // 3. Retornar lista con "TODOS" al principio, seguido de grupos personalizados
    return [
      todosGroup,
      ..._customGroups,
    ];
  }

  /// Grupos personalizados predefinidos
  static final List<DeviceGroup> _customGroups = [
    DeviceGroup(
      id: 'group_1',
      name: 'Acceso Principal',
      description: 'Dispositivos del acceso principal del edificio',
      deviceIds: ['1', '4'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    DeviceGroup(
      id: 'group_2',
      name: 'Estacionamiento',
      description: 'Control de barreras de estacionamiento',
      deviceIds: ['3', '5'],
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    DeviceGroup(
      id: 'group_3',
      name: 'Accesos Secundarios',
      description: 'Puertas y portones secundarios',
      deviceIds: ['2', '6'],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  /// Obtiene un grupo por ID
  static DeviceGroup? getById(String id) {
    try {
      return groups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene grupos que contienen un dispositivo específico
  static List<DeviceGroup> getGroupsForDevice(String deviceId) {
    return groups.where((group) => group.deviceIds.contains(deviceId)).toList();
  }
}
