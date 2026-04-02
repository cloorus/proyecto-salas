import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Entidad de Dispositivo
class Device extends Equatable {
  final String id;
  final String name;
  final String model;
  final String serialNumber;
  final DeviceType type;
  final DeviceStatus status;
  final bool isOnline;
  final String? location;
  final String? description;
  final DateTime createdAt;
  final DateTime? lastConnection;
  /// URL o path de la imagen del dispositivo (null = imagen por defecto)
  final String? imageUrl;
  /// Indica si este dispositivo es el principal (borde de color especial)
  final bool isPrimary;

  const Device({
    required this.id,
    required this.name,
    required this.model,
    required this.serialNumber,
    required this.type,
    this.status = DeviceStatus.ready,
    this.isOnline = false,
    this.location,
    this.description,
    required this.createdAt,
    this.lastConnection,
    this.imageUrl,
    this.isPrimary = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        model,
        serialNumber,
        type,
        status,
        isOnline,
        location,
        description,
        createdAt,
        lastConnection,
        imageUrl,
        isPrimary,
      ];
}

/// Tipos de dispositivo
enum DeviceType {
  gate,      // Portón
  barrier,   // Barrera
  door,      // Puerta
  other,     // Otro
}

extension DeviceTypeExtension on DeviceType {
  String get displayName {
    switch (this) {
      case DeviceType.gate:
        return 'Portón';
      case DeviceType.barrier:
        return 'Barrera';
      case DeviceType.door:
        return 'Puerta';
      case DeviceType.other:
        return 'Otro';
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceType.gate:
        return Icons.garage_outlined;
      case DeviceType.barrier:
        return Icons.traffic_outlined;
      case DeviceType.door:
        return Icons.door_front_door_outlined;
      case DeviceType.other:
        return Icons.device_unknown_outlined;
    }
  }
}

/// Estados del dispositivo
enum DeviceStatus {
  ready,       // Listo
  opening,     // Abriendo
  closing,     // Cerrando
  paused,      // Pausado
  error,       // Error
  maintenance, // Mantenimiento
}

extension DeviceStatusExtension on DeviceStatus {
  String get displayName {
    switch (this) {
      case DeviceStatus.ready:
        return 'Listo';
      case DeviceStatus.opening:
        return 'Abriendo';
      case DeviceStatus.closing:
        return 'Cerrando';
      case DeviceStatus.paused:
        return 'Pausado';
      case DeviceStatus.error:
        return 'Error';
      case DeviceStatus.maintenance:
        return 'Mantenimiento';
    }
  }

  Color get color {
    switch (this) {
      case DeviceStatus.ready:
        return AppColors.success;
      case DeviceStatus.opening:
      case DeviceStatus.closing:
        return AppColors.info;
      case DeviceStatus.paused:
        return AppColors.textSecondary;
      case DeviceStatus.error:
        return AppColors.error;
      case DeviceStatus.maintenance:
        return AppColors.warning;
    }
  }
}
