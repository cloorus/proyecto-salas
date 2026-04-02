import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../../../../core/errors/failures.dart';

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // Llamar API
      final response = await remoteDataSource.login(email, password);
      
      // Extraer datos
      final userModel = UserModel.fromJson(response['user']);
      final token = response['token'] as String;
      
      // Guardar localmente
      await localDataSource.saveToken(token);
      await localDataSource.saveUser(userModel);
      
      // Retornar usuario como Entity
      return Right(userModel.toEntity());
    } on Exception catch (e) {
      if (e.toString().contains('Credenciales')) {
        return Left(InvalidCredentialsFailure());
      }
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
    String? country,
    String? language,
  }) async {
    try {
      // Llamar API
      final response = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        country: country,
        language: language,
      );
      
      // Extraer datos
      final userModel = UserModel.fromJson(response['user']);
      final token = response['token'] as String;
      
      // Guardar localmente
      await localDataSource.saveToken(token);
      await localDataSource.saveUser(userModel);
      
      // Retornar usuario como Entity
      return Right(userModel.toEntity());
    } on Exception catch (e) {
      if (e.toString().contains('existe')) {
        return Left(ServerFailure(e.toString()));
      }
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> sendPasswordResetCode(String email) async {
    try {
      await remoteDataSource.sendPasswordResetCode(email);
      return const Right(null);
    } on Exception {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      return const Right(null);
    } on Exception catch (e) {
      if (e.toString().contains('inválido') || e.toString().contains('expirado')) {
        return Left(InvalidCredentialsFailure(e.toString()));
      }
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Llamar API
      await remoteDataSource.logout();
      
      // Limpiar local
      await localDataSource.deleteToken();
      await localDataSource.deleteUser();
      
      return const Right(null);
    } on Exception {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getUser();
      return Right(userModel?.toEntity());
    } on Exception {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> saveRememberMe(bool rememberMe) async {
    try {
      await localDataSource.saveRememberMe(rememberMe);
      return const Right(null);
    } on Exception {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, bool>> getRememberMe() async {
    try {
      final value = await localDataSource.getRememberMe();
      return Right(value);
    } on Exception {
      return Left(CacheFailure());
    }
  }
}
