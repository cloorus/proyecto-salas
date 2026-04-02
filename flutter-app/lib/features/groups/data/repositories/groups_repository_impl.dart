import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/device_group.dart';
import '../../domain/repositories/groups_repository.dart';
// Mock groups removed - using API
import '../../../devices/domain/entities/device.dart';
import '../../../devices/data/models/mock_devices.dart';

/// Error message constants for localization mapping
class GroupsErrorMessages {
  static const String groupNotFound = 'GROUP_NOT_FOUND';
  static const String cannotAddToAllGroup = 'CANNOT_ADD_TO_ALL_GROUP';
  static const String deviceAlreadyInGroup = 'DEVICE_ALREADY_IN_GROUP';
  static const String cannotRemoveFromAllGroup = 'CANNOT_REMOVE_FROM_ALL_GROUP';
  static const String deviceNotInGroup = 'DEVICE_NOT_IN_GROUP';
  static const String nameCannotBeEmpty = 'NAME_CANNOT_BE_EMPTY';
  static const String groupNameAlreadyExists = 'GROUP_NAME_ALREADY_EXISTS';
  static const String cannotModifyAllGroup = 'CANNOT_MODIFY_ALL_GROUP';
  static const String cannotDeleteAllGroup = 'CANNOT_DELETE_ALL_GROUP';
}

class GroupsRepositoryImpl implements GroupsRepository {
  // Simular base de datos en memoria para persistencia durante la sesión
  static List<DeviceGroup>? _inMemoryGroups;

  GroupsRepositoryImpl() {
    _inMemoryGroups ??= [];
  }

  @override
  Future<Either<Failure, List<DeviceGroup>>> getGroups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(_inMemoryGroups!);
  }

  @override
  Future<Either<Failure, List<Device>>> getDevices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right([]);
  }

  @override
  Future<Either<Failure, DeviceGroup>> addDeviceToGroup(
      String groupId, String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final groupIndex = _inMemoryGroups!.indexWhere((g) => g.id == groupId);
      if (groupIndex == -1)
        return Left(ServerFailure(GroupsErrorMessages.groupNotFound));

      final group = _inMemoryGroups![groupIndex];

      if (group.id == 'group_todos') {
        // TODOS group ID usually 'group_todos'
        return Left(ServerFailure(GroupsErrorMessages.cannotAddToAllGroup));
      }

      if (group.deviceIds.contains(deviceId)) {
        return Left(ServerFailure(GroupsErrorMessages.deviceAlreadyInGroup));
      }

      final updatedDeviceIds = List<String>.from(group.deviceIds)
        ..add(deviceId);
      final updatedGroup = DeviceGroup(
        id: group.id,
        name: group.name,
        description: group.description,
        deviceIds: updatedDeviceIds,
        createdAt: group.createdAt,
      );

      _inMemoryGroups![groupIndex] = updatedGroup;
      return Right(updatedGroup);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeviceGroup>> removeDeviceFromGroup(
      String groupId, String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final groupIndex = _inMemoryGroups!.indexWhere((g) => g.id == groupId);
      if (groupIndex == -1)
        return Left(ServerFailure(GroupsErrorMessages.groupNotFound));

      final group = _inMemoryGroups![groupIndex];

      if (group.id == 'group_todos') {
        return Left(ServerFailure(GroupsErrorMessages.cannotRemoveFromAllGroup));
      }

      if (!group.deviceIds.contains(deviceId)) {
        return Left(ServerFailure(GroupsErrorMessages.deviceNotInGroup));
      }

      final updatedDeviceIds = List<String>.from(group.deviceIds)
        ..remove(deviceId);
      final updatedGroup = DeviceGroup(
        id: group.id,
        name: group.name,
        description: group.description,
        deviceIds: updatedDeviceIds,
        createdAt: group.createdAt,
      );

      _inMemoryGroups![groupIndex] = updatedGroup;
      return Right(updatedGroup);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeviceGroup>> createGroup(
      String name, String description) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      if (name.trim().isEmpty) {
        return Left(ServerFailure(GroupsErrorMessages.nameCannotBeEmpty));
      }

      if (_inMemoryGroups!
          .any((g) => g.name.toLowerCase() == name.trim().toLowerCase())) {
        return Left(ServerFailure(GroupsErrorMessages.groupNameAlreadyExists));
      }

      final newGroup = DeviceGroup(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        description: description,
        deviceIds: [],
        createdAt: DateTime.now(),
      );

      _inMemoryGroups!.add(newGroup);
      return Right(newGroup);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeviceGroup>> updateGroup(
      String groupId, String name, String description) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      if (groupId == 'group_todos') {
        return Left(ServerFailure(GroupsErrorMessages.cannotModifyAllGroup));
      }

      final groupIndex = _inMemoryGroups!.indexWhere((g) => g.id == groupId);
      if (groupIndex == -1)
        return Left(ServerFailure(GroupsErrorMessages.groupNotFound));

      if (name.trim().isEmpty) {
        return Left(ServerFailure(GroupsErrorMessages.nameCannotBeEmpty));
      }

      // Check uniqueness excluding current group
      if (_inMemoryGroups!.any((g) =>
          g.id != groupId &&
          g.name.toLowerCase() == name.trim().toLowerCase())) {
        return Left(ServerFailure(GroupsErrorMessages.groupNameAlreadyExists));
      }

      final currentGroup = _inMemoryGroups![groupIndex];
      final updatedGroup = DeviceGroup(
        id: currentGroup.id,
        name: name.trim(),
        description: description,
        deviceIds: currentGroup.deviceIds,
        createdAt: currentGroup.createdAt,
      );

      _inMemoryGroups![groupIndex] = updatedGroup;
      return Right(updatedGroup);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      if (groupId == 'group_todos') {
        return Left(ServerFailure(GroupsErrorMessages.cannotDeleteAllGroup));
      }

      final groupIndex = _inMemoryGroups!.indexWhere((g) => g.id == groupId);
      if (groupIndex == -1)
        return Left(ServerFailure(GroupsErrorMessages.groupNotFound));

      _inMemoryGroups!.removeAt(groupIndex);

      // Devices should technically be moved to TODOS but if they are already there (as they are in Mock), we don't need to do anything explicitly.
      // Logic: "Devices not deleted, only group".

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
