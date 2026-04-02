import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class MockSettingsRepository implements SettingsRepository {
  // Mock data que coincide con lo que se muestra en la pantalla
  UserProfile _currentProfile = const UserProfile(
    name: 'Carlos Mena',
    email: 'carlos@bgnius.com',
    phone: '+506 8888-8888',
    address: 'San José, Costa Rica',
    country: 'Costa Rica',
    language: 'Español',
  );

  AppSettings _currentSettings = const AppSettings(
    darkMode: false,
    fontSize: 1.0, // Normal
    highContrast: false,
    reducedMotion: false,
    biometricsEnabled: false,
    environment: Environment.production,
    serverUrl: 'https://api.bgnius.com',
  );

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 300));
      
      return Right(_currentProfile);
    } catch (e) {
      return Left(ServerFailure('Error al obtener perfil'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(seconds: 1));
      
      _currentProfile = profile;
      return Right(_currentProfile);
    } catch (e) {
      return Left(ServerFailure('Error al actualizar perfil'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Validaciones básicas
      if (currentPassword.isEmpty || newPassword.isEmpty) {
        return Left(ServerFailure('Las contraseñas no pueden estar vacías'));
      }
      
      if (newPassword.length < 6) {
        return Left(ServerFailure('La nueva contraseña debe tener al menos 6 caracteres'));
      }
      
      // En una implementación real, aquí se verificaría la contraseña actual
      // y se actualizaría en el backend
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al cambiar contraseña'));
    }
  }

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 200));
      
      return Right(_currentSettings);
    } catch (e) {
      return Left(ServerFailure('Error al obtener configuraciones'));
    }
  }

  @override
  Future<Either<Failure, AppSettings>> updateSettings(AppSettings settings) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 500));
      
      _currentSettings = settings;
      return Right(_currentSettings);
    } catch (e) {
      return Left(ServerFailure('Error al actualizar configuraciones'));
    }
  }
}