import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/device_group.dart';
import '../../../devices/domain/entities/device.dart';

abstract class GroupsRepository {
  Future<Either<Failure, List<DeviceGroup>>> getGroups();
  Future<Either<Failure, List<Device>>> getDevices();
  Future<Either<Failure, DeviceGroup>> addDeviceToGroup(
      String groupId, String deviceId);
  Future<Either<Failure, DeviceGroup>> removeDeviceFromGroup(
      String groupId, String deviceId);
  Future<Either<Failure, DeviceGroup>> createGroup(
      String name, String description);
  Future<Either<Failure, DeviceGroup>> updateGroup(
      String groupId, String name, String description);
  Future<Either<Failure, void>> deleteGroup(String groupId);
}
