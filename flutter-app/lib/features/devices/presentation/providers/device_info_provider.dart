import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/device.dart';
import '../../domain/entities/device_info.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/api_device_repository.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../data/repositories/api_device_repository.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/mock_devices.dart';

/// Provider para API Client (compartido con auth)
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.instance;
});

/// Provider del repositorio de dispositivos original (para DeviceInfo)
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  return DeviceRepositoryImpl();
});

/// Provider del repositorio API de dispositivos (para operaciones CRUD)
final apiDeviceRepositoryProvider = Provider<ApiDeviceRepository>((ref) {
  return ApiDeviceRepositoryImpl(
    apiClient: ref.read(apiClientProvider),
  );
});

/// Provider para obtener lista de dispositivos
final devicesListProvider = FutureProvider<List<Device>>((ref) async {
  if (AppConfig.useRealApi) {
    final repository = ref.watch(apiDeviceRepositoryProvider);
    final result = await repository.getDevices();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (devices) => devices,
    );
  } else {
    // Usar datos mock
    final deviceRepository = ref.watch(deviceRepositoryProvider);
    // Como el repositorio original no tiene getDevices, usar mock directo
    throw Exception("No se pudieron cargar dispositivos");
  }
});

/// Provider para obtener información detallada de un dispositivo
final deviceInfoProvider = FutureProvider.family<DeviceInfo, String>((ref, id) async {
  if (AppConfig.useRealApi) {
    final repository = ref.watch(apiDeviceRepositoryProvider);
    final result = await repository.getDeviceInfo(id);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (deviceInfo) => deviceInfo,
    );
  } else {
    // Usar implementación original
    final repository = ref.watch(deviceRepositoryProvider);
    return repository.getDeviceInfo(id);
  }
});

/// Provider para enviar comandos a dispositivos
final deviceCommandProvider = Provider<Future<void> Function(String id, String action)>((ref) {
  return (String id, String action) async {
    if (AppConfig.useRealApi) {
      final repository = ref.watch(apiDeviceRepositoryProvider);
      final result = await repository.sendCommand(id, action);
      result.fold(
        (failure) => throw Exception(failure.message),
        (_) => null,
      );
    } else {
      // Simular comando en mock
      await Future.delayed(const Duration(seconds: 1));
    }
  };
});
