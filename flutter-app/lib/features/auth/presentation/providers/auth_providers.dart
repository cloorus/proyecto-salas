import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/api_auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_password_reset_code_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/services/api_client.dart';

/// Provider de SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main.dart');
});

/// Provider de Remote Data Source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceMock();
});

/// Provider de Local Data Source
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final sharedPreferences = ref.read(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(sharedPreferences);
});

/// Provider de API Client
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.instance;
});

/// Provider de Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (AppConfig.useRealApi) {
    // Usar implementación real de API
    return ApiAuthRepository(
      apiClient: ref.read(apiClientProvider),
      localDataSource: ref.read(authLocalDataSourceProvider),
    );
  } else {
    // Usar implementación mock
    return AuthRepositoryImpl(
      remoteDataSource: ref.read(authRemoteDataSourceProvider),
      localDataSource: ref.read(authLocalDataSourceProvider),
    );
  }
});

/// Provider de Use Cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});

/// Provider para RegisterUseCase
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});

/// Provider para SendPasswordResetCodeUseCase
final sendPasswordResetCodeUseCaseProvider = Provider<SendPasswordResetCodeUseCase>((ref) {
  return SendPasswordResetCodeUseCase(ref.read(authRepositoryProvider));
});

/// Provider para ResetPasswordUseCase
final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.read(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.read(authRepositoryProvider));
});
