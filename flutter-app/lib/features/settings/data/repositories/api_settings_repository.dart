import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/api_client.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class ApiSettingsRepository implements SettingsRepository {
  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final response = await ApiClient.instance.get('/users/me');
      final data = response.data;
      return Right(UserProfile(
        name: data['full_name'] ?? data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'],
        address: data['address'],
        country: data['country'],
        language: data['language'] ?? 'es',
        profilePhotoUrl: data['profile_photo_url'],
      ));
    } catch (e) {
      return Left(ServerFailure('Error cargando perfil: $e'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile) async {
    try {
      final response = await ApiClient.instance.put('/users/me', data: {
        'full_name': profile.name,
        'phone': profile.phone,
        'address': profile.address,
        'country': profile.country,
        'language': profile.language,
      });
      final data = response.data;
      return Right(UserProfile(
        name: data['full_name'] ?? data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'],
        address: data['address'],
        country: data['country'],
        language: data['language'] ?? 'es',
        profilePhotoUrl: data['profile_photo_url'],
      ));
    } catch (e) {
      return Left(ServerFailure('Error actualizando perfil: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await ApiClient.instance.post('/auth/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error cambiando contrasena: $e'));
    }
  }

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    // Settings are local-only (dark mode, font size, etc.)
    return const Right(AppSettings());
  }

  @override
  Future<Either<Failure, AppSettings>> updateSettings(AppSettings settings) async {
    // Settings are local-only
    return Right(settings);
  }
}
