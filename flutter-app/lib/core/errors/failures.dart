import 'package:equatable/equatable.dart';

/// Clase base para todos los errores de la aplicación
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Error del servidor
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error del servidor']);
}

/// Credenciales inválidas
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([super.message = 'Credenciales inválidas']);
}

/// Error de red
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Error de conexión']);
}

/// Error de caché
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error al guardar datos']);
}
