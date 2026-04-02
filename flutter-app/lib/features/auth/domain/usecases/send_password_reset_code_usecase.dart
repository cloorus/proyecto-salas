import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Parámetros para enviar código de restablecimiento
class SendPasswordResetCodeParams {
  final String email;

  const SendPasswordResetCodeParams({required this.email});
}

/// Caso de uso para enviar código de restablecimiento de contraseña
/// 
/// Valida el email y delega al repositorio para enviar el código temporal.
class SendPasswordResetCodeUseCase {
  final AuthRepository repository;

  SendPasswordResetCodeUseCase(this.repository);

  Future<Either<Failure, void>> call(SendPasswordResetCodeParams params) async {
    if (params.email.isEmpty) {
      return Left(InvalidCredentialsFailure('Email vacío'));
    }

    return await repository.sendPasswordResetCode(params.email);
  }
}
