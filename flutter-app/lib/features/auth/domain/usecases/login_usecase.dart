import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

/// Parámetros para el login
class LoginParams {
  final String email;
  final String password;
  
  const LoginParams({
    required this.email,
    required this.password,
  });
}

/// Use Case para realizar login
class LoginUseCase {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  /// Ejecuta el login
  /// Retorna Either<Failure, User>
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Validaciones de negocio adicionales pueden ir aquí
    if (params.email.isEmpty) {
      return Left(InvalidCredentialsFailure('Email vacío'));
    }
    
    if (params.password.isEmpty) {
      return Left(InvalidCredentialsFailure('Contraseña vacía'));
    }
    
    // Delegar al repository
    return await repository.login(params.email, params.password);
  }
}
