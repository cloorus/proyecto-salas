import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/api_client.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/users_repository.dart';

class ApiUsersRepository implements UsersRepository {
  @override
  Future<Either<Failure, List<AppUser>>> getUsers() async {
    try {
      final response = await ApiClient.instance.get('/users');
      final List data = response.data is List ? response.data : (response.data['data'] ?? []);
      return Right(data.map((json) => _userFromJson(json)).toList());
    } catch (e) {
      return Left(ServerFailure('Error cargando usuarios: $e'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> getUserById(String id) async {
    try {
      final response = await ApiClient.instance.get('/users/$id');
      return Right(_userFromJson(response.data));
    } catch (e) {
      return Left(ServerFailure('Error cargando usuario: $e'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> updateUserRole(String userId, String deviceId, UserRole role) async {
    try {
      final response = await ApiClient.instance.put(
        '/users/$userId/devices/$deviceId/roles',
        data: {'role': role.name},
      );
      return Right(_userFromJson(response.data));
    } catch (e) {
      return Left(ServerFailure('Error actualizando rol: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AppUser>>> getDeviceUsers(String deviceId) async {
    try {
      final response = await ApiClient.instance.get('/devices/$deviceId/users');
      final List data = response.data is List ? response.data : (response.data['users'] ?? []);
      return Right(data.map((json) => _userFromJson(json)).toList());
    } catch (e) {
      return Left(ServerFailure('Error cargando usuarios del dispositivo: $e'));
    }
  }

  AppUser _userFromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] ?? json['user_id'] ?? '').toString(),
      name: json['full_name'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      country: json['country'],
      profilePhoto: json['profile_photo_url'],
      role: _parseRole(json['role'] ?? json['permission_level']),
      createdAt: json['created_at'] != null
          ? (DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  UserRole _parseRole(dynamic role) {
    switch (role?.toString().toLowerCase()) {
      case 'admin': return UserRole.admin;
      case 'owner': return UserRole.owner;
      case 'guest': return UserRole.guest;
      default: return UserRole.user;
    }
  }
}
