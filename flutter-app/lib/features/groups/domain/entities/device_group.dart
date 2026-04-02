import 'package:equatable/equatable.dart';

/// Entidad de Grupo de Dispositivos
class DeviceGroup extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<String> deviceIds;
  final DateTime createdAt;

  const DeviceGroup({
    required this.id,
    required this.name,
    this.description,
    required this.deviceIds,
    required this.createdAt,
  });

  int get deviceCount => deviceIds.length;

  @override
  List<Object?> get props => [id, name, description, deviceIds, createdAt];
}
