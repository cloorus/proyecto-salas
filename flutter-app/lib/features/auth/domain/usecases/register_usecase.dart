import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Parámetros para el caso de uso de registro
class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? address;
  final String? country;
  final String? language;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.address,
    this.country,
    this.language,
  });
}

/// Caso de uso para registrar un nuevo usuario
/// 
/// Valida que los campos obligatorios no estén vacíos y delega
/// el registro al repositorio. Retorna Either<Failure, User>.
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call(RegisterParams params) async {
    // Validación básica
    if (params.name.isEmpty) {
      return Left(InvalidCredentialsFailure('Nombre vacío'));
    }

    if (params.email.isEmpty) {
      return Left(InvalidCredentialsFailure('Email vacío'));
    }

    if (params.password.isEmpty) {
      return Left(InvalidCredentialsFailure('Password vacío'));
    }

    // Delegar al repositorio
    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      phone: params.phone,
      address: params.address,
      country: params.country,
      language: params.language,
    );
  }
}
