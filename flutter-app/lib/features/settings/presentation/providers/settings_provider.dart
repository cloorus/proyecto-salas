import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../data/repositories/api_settings_repository.dart';

/// Provider del repositorio de configuraciones
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return ApiSettingsRepository();
});

/// Provider para obtener el perfil del usuario
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repository = ref.read(settingsRepositoryProvider);
  final result = await repository.getProfile();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (profile) => profile,
  );
});

/// Provider para obtener las configuraciones de la aplicación
final appSettingsProvider = FutureProvider<AppSettings>((ref) async {
  final repository = ref.read(settingsRepositoryProvider);
  final result = await repository.getSettings();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (settings) => settings,
  );
});

/// StateNotifier para manejar el estado del perfil de usuario
class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  UserProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  final SettingsRepository _repository;

  Future<void> _loadProfile() async {
    final result = await _repository.getProfile();
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (profile) => AsyncValue.data(profile),
    );
  }

  Future<void> updateProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    
    final result = await _repository.updateProfile(profile);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (profile) => AsyncValue.data(profile),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    
    result.fold(
      (failure) => throw Exception(failure.message),
      (_) {}, // Password changed successfully
    );
  }

  void refresh() {
    _loadProfile();
  }
}

/// StateNotifier para manejar el estado de las configuraciones de la aplicación
class AppSettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  AppSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  final SettingsRepository _repository;

  Future<void> _loadSettings() async {
    final result = await _repository.getSettings();
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (settings) => AsyncValue.data(settings),
    );
  }

  Future<void> updateSettings(AppSettings settings) async {
    state = const AsyncValue.loading();
    
    final result = await _repository.updateSettings(settings);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (settings) => AsyncValue.data(settings),
    );
  }

  Future<void> toggleDarkMode() async {
    final currentState = state;
    if (currentState is AsyncData) {
      final currentSettings = currentState.value;
      await updateSettings(currentSettings.copyWith(darkMode: !currentSettings.darkMode));
    }
  }

  Future<void> updateFontSize(double fontSize) async {
    final currentState = state;
    if (currentState is AsyncData) {
      final currentSettings = currentState.value;
      await updateSettings(currentSettings.copyWith(fontSize: fontSize));
    }
  }

  Future<void> toggleHighContrast() async {
    final currentState = state;
    if (currentState is AsyncData) {
      final currentSettings = currentState.value;
      await updateSettings(currentSettings.copyWith(highContrast: !currentSettings.highContrast));
    }
  }

  Future<void> toggleReducedMotion() async {
    final currentState = state;
    if (currentState is AsyncData) {
      final currentSettings = currentState.value;
      await updateSettings(currentSettings.copyWith(reducedMotion: !currentSettings.reducedMotion));
    }
  }

  Future<void> toggleBiometrics() async {
    final currentState = state;
    if (currentState is AsyncData) {
      final currentSettings = currentState.value;
      await updateSettings(currentSettings.copyWith(biometricsEnabled: !currentSettings.biometricsEnabled));
    }
  }

  Future<void> updateEnvironment(Environment environment) async {
    final currentState = state;
    if (currentState is AsyncData) {
      final currentSettings = currentState.value;
      await updateSettings(currentSettings.copyWith(
        environment: environment,
        serverUrl: environment.defaultServerUrl,
      ));
    }
  }

  Future<void> updateServerUrl(String serverUrl) async {
    final currentState = state;
    if (currentState is AsyncData) {
      final currentSettings = currentState.value;
      await updateSettings(currentSettings.copyWith(serverUrl: serverUrl));
    }
  }

  void refresh() {
    _loadSettings();
  }
}

/// Provider del StateNotifier para el perfil de usuario
final userProfileNotifierProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile>>((ref) {
  final repository = ref.read(settingsRepositoryProvider);
  return UserProfileNotifier(repository);
});

/// Provider del StateNotifier para las configuraciones de la aplicación
final appSettingsNotifierProvider = StateNotifierProvider<AppSettingsNotifier, AsyncValue<AppSettings>>((ref) {
  final repository = ref.read(settingsRepositoryProvider);
  return AppSettingsNotifier(repository);
});