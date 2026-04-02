import 'package:dartz/dartz.dart';
import '../entities/device.dart';
import '../entities/device_info.dart';
import '../../../../core/errors/failures.dart';

/// Repositorio extendido para operaciones con dispositivos via API
abstract class ApiDeviceRepository {
  /// Obtiene la lista de dispositivos del usuario
  Future<Either<Failure, List<Device>>> getDevices();
  
  /// Obtiene información detallada de un dispositivo
  Future<Either<Failure, DeviceInfo>> getDeviceInfo(String id);
  
  /// Crea un nuevo dispositivo
  Future<Either<Failure, Device>> createDevice(Map<String, dynamic> deviceData);
  
  /// Actualiza un dispositivo existente
  Future<Either<Failure, Device>> updateDevice(String id, Map<String, dynamic> deviceData);
  
  /// Elimina un dispositivo
  Future<Either<Failure, void>> deleteDevice(String id);
  
  /// Sube foto del dispositivo
  Future<Either<Failure, void>> uploadDevicePhoto(String id, dynamic imageFile);

  /// Envía comando a un dispositivo (open|close|pause|pedestrian)
  Future<Either<Failure, void>> sendCommand(String id, String action);
}