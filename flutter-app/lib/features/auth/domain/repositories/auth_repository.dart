import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../../../core/errors/failures.dart';

/// Interface del repositorio de autenticación
/// Define el contrato que debe implementar la capa de datos
abstract class AuthRepository {
  /// Realiza login con email y contraseña
  Future<Either<Failure, User>> login(String email, String password);
  
  /// Registra un nuevo usuario
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
    String? country,
    String? language,
  });
  
  /// Envía código de restablecimiento de contraseña al email
  Future<Either<Failure, void>> sendPasswordResetCode(String email);
  
  /// Restablece la contraseña usando el código temporal
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
  
  /// Cierra sesión del usuario actual
  Future<Either<Failure, void>> logout();
  
  /// Obtiene el usuario actual si existe sesión
  Future<Either<Failure, User?>> getCurrentUser();
  
  /// Guarda el estado de "recordarme"
  Future<Either<Failure, void>> saveRememberMe(bool rememberMe);
  
  /// Obtiene el estado de "recordarme"
  Future<Either<Failure, bool>> getRememberMe();
}
