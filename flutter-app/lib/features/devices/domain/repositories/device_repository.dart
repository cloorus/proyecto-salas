import '../entities/device_info.dart';

abstract class DeviceRepository {
  Future<DeviceInfo> getDeviceInfo(String id);
  Future<void> updateDevice(DeviceInfo device);
  Future<void> createDevice(Map<String, dynamic> deviceData);
}
