import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

/// Use Case para obtener el usuario actual
class GetCurrentUserUseCase {
  final AuthRepository repository;
  
  GetCurrentUserUseCase(this.repository);
  
  /// Obtiene el usuario actual si existe sesión
  /// Retorna Either<Failure, User?>
  Future<Either<Failure, User?>> call() async {
    return await repository.getCurrentUser();
  }
}
