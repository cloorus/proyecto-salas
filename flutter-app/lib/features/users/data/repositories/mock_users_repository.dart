import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/users_repository.dart';
import '../models/mock_users.dart';

class MockUsersRepository implements UsersRepository {
  @override
  Future<Either<Failure, List<AppUser>>> getUsers() async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 500));
      
      final users = MockUsers.getAll();
      return Right(users);
    } catch (e) {
      return Left(ServerFailure('Error al obtener usuarios'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> getUserById(String id) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 300));
      
      final user = MockUsers.getById(id);
      if (user == null) {
        return Left(ServerFailure('Usuario no encontrado'));
      }
      
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Error al obtener usuario'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> updateUserRole(
    String userId,
    String deviceId,
    UserRole role,
  ) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      // En una implementación real, aquí se actualizaría la relación
      // usuario-dispositivo-rol en el backend
      final updatedUser = MockUsers.updateUserRole(userId, role);
      
      return Right(updatedUser);
    } catch (e) {
      return Left(ServerFailure('Error al actualizar rol del usuario'));
    }
  }

  @override
  Future<Either<Failure, List<AppUser>>> getDeviceUsers(String deviceId) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 400));
      
      final users = MockUsers.getByDeviceId(deviceId);
      return Right(users);
    } catch (e) {
      return Left(ServerFailure('Error al obtener usuarios del dispositivo'));
    }
  }
}