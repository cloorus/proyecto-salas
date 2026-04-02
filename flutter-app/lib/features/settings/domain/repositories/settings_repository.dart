import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  /// Obtiene el perfil del usuario actual
  Future<Either<Failure, UserProfile>> getProfile();
  
  /// Actualiza el perfil del usuario
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile);
  
  /// Cambia la contraseña del usuario
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  
  /// Obtiene las configuraciones de la aplicación
  Future<Either<Failure, AppSettings>> getSettings();
  
  /// Actualiza las configuraciones de la aplicación
  Future<Either<Failure, AppSettings>> updateSettings(AppSettings settings);
}