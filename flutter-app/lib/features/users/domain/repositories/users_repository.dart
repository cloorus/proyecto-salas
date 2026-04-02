import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/app_user.dart';

abstract class UsersRepository {
  /// Obtiene la lista de todos los usuarios
  Future<Either<Failure, List<AppUser>>> getUsers();
  
  /// Obtiene un usuario por su ID
  Future<Either<Failure, AppUser>> getUserById(String id);
  
  /// Actualiza el rol de un usuario para un dispositivo específico
  Future<Either<Failure, AppUser>> updateUserRole(
    String userId, 
    String deviceId, 
    UserRole role
  );
  
  /// Obtiene los usuarios asociados a un dispositivo específico
  Future<Either<Failure, List<AppUser>>> getDeviceUsers(String deviceId);
}