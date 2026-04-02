import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/api_client.dart';

/// Implementación del repositorio de autenticación usando la API real de Vita
class ApiAuthRepository implements AuthRepository {
  final ApiClient _apiClient;
  final AuthLocalDataSource _localDataSource;
  
  ApiAuthRepository({
    required ApiClient apiClient,
    required AuthLocalDataSource localDataSource,
  }) : _apiClient = apiClient,
       _localDataSource = localDataSource;
  
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Guardar tokens en ApiClient
        await _apiClient.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        
        // Obtener perfil del usuario
        final userResponse = await _apiClient.get('/users/me');
        
        if (userResponse.statusCode == 200) {
          final userModel = UserModel.fromJson(userResponse.data);
          
          // Guardar localmente
          await _localDataSource.saveUser(userModel);
          await _localDataSource.saveToken(data['access_token']);
          
          return Right(userModel.toEntity());
        } else {
          return Left(ServerFailure('Error obteniendo perfil de usuario'));
        }
      } else {
        return Left(InvalidCredentialsFailure('Credenciales inválidas'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 422) {
        return Left(InvalidCredentialsFailure('Credenciales inválidas'));
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure('Error de conexión'));
      } else {
        return Left(ServerFailure('Error del servidor'));
      }
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
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
      final response = await _apiClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'full_name': name,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
          if (country != null) 'country': country,
          if (language != null) 'language': language,
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        // Guardar tokens en ApiClient
        await _apiClient.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        
        // Obtener perfil del usuario
        final userResponse = await _apiClient.get('/users/me');
        
        if (userResponse.statusCode == 200) {
          final userModel = UserModel.fromJson(userResponse.data);
          
          // Guardar localmente
          await _localDataSource.saveUser(userModel);
          await _localDataSource.saveToken(data['access_token']);
          
          return Right(userModel.toEntity());
        } else {
          return Left(ServerFailure('Error obteniendo perfil de usuario'));
        }
      } else {
        return Left(ServerFailure('Error al registrar usuario'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409 || e.response?.statusCode == 422) {
        final message = e.response?.data['detail'] ?? 'El email ya está registrado';
        return Left(ServerFailure(message));
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure('Error de conexión'));
      } else {
        return Left(ServerFailure('Error del servidor'));
      }
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> sendPasswordResetCode(String email) async {
    try {
      final response = await _apiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
      
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Error enviando código de restablecimiento'));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure('Error de conexión'));
      } else {
        return Left(ServerFailure('Error del servidor'));
      }
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/reset-password',
        data: {
          'email': email,
          'code': code,
          'new_password': newPassword,
        },
      );
      
      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure('Error restableciendo contraseña'));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422 || e.response?.statusCode == 400) {
        final message = e.response?.data['detail'] ?? 'Código inválido o expirado';
        return Left(InvalidCredentialsFailure(message));
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout ||
                 e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure('Error de conexión'));
      } else {
        return Left(ServerFailure('Error del servidor'));
      }
    } catch (e) {
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Intentar hacer logout en el servidor (opcional, puede fallar si no hay conexión)
      try {
        await _apiClient.post('/auth/logout');
      } catch (e) {
        // Ignorar errores de logout del servidor, limpiar localmente de todos modos
      }
      
      // Limpiar tokens y datos locales
      await _apiClient.clearTokens();
      await _localDataSource.deleteToken();
      await _localDataSource.deleteUser();
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al cerrar sesión'));
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Primero intentar obtener desde caché local
      final userModel = await _localDataSource.getUser();
      if (userModel != null && _apiClient.hasValidToken) {
        // Si hay usuario en caché y token válido, intentar sincronizar con servidor
        try {
          final response = await _apiClient.get('/users/me');
          if (response.statusCode == 200) {
            final updatedUserModel = UserModel.fromJson(response.data);
            await _localDataSource.saveUser(updatedUserModel);
            return Right(updatedUserModel.toEntity());
          }
        } catch (e) {
          // Si falla la sincronización, usar datos locales
        }
        
        return Right(userModel.toEntity());
      }
      
      // Si no hay usuario en caché pero hay token, obtener del servidor
      if (_apiClient.hasValidToken) {
        try {
          final response = await _apiClient.get('/users/me');
          if (response.statusCode == 200) {
            final userModel = UserModel.fromJson(response.data);
            await _localDataSource.saveUser(userModel);
            return Right(userModel.toEntity());
          }
        } catch (e) {
          // Token posiblemente inválido
          await _apiClient.clearTokens();
          await _localDataSource.deleteToken();
          await _localDataSource.deleteUser();
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error obteniendo usuario actual'));
    }
  }
  
  @override
  Future<Either<Failure, void>> saveRememberMe(bool rememberMe) async {
    try {
      await _localDataSource.saveRememberMe(rememberMe);
      return const Right(null);
    } on Exception {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, bool>> getRememberMe() async {
    try {
      final value = await _localDataSource.getRememberMe();
      return Right(value);
    } on Exception {
      return Left(CacheFailure());
    }
  }
}