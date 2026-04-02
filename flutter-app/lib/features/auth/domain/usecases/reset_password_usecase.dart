import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Parámetros para restablecer contraseña
class ResetPasswordParams {
  final String email;
  final String code;
  final String newPassword;

  const ResetPasswordParams({
    required this.email,
    required this.code,
    required this.newPassword,
  });
}

/// Caso de uso para restablecer contraseña
/// 
/// Valida el email, código y nueva contraseña, luego delega al repositorio.
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    if (params.email.isEmpty) {
      return Left(InvalidCredentialsFailure('Email vacío'));
    }

    if (params.code.isEmpty) {
      return Left(InvalidCredentialsFailure('Código vacío'));
    }

    if (params.newPassword.isEmpty) {
      return Left(InvalidCredentialsFailure('Password vacío'));
    }

    return await repository.resetPassword(
      email: params.email,
      code: params.code,
      newPassword: params.newPassword,
    );
  }
}
