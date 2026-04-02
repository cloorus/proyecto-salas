import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

/// Use Case para realizar logout
class LogoutUseCase {
  final AuthRepository repository;
  
  LogoutUseCase(this.repository);
  
  /// Ejecuta el logout
  /// Retorna Either<Failure, void>
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
