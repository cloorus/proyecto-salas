import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_providers.dart';

/// Estado del login screen
class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool rememberMe;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.rememberMe = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? rememberMe,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

/// Notifier para manejar la lógica del login
/// Refactorizado para usar Clean Architecture con UseCase
class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  
  LoginNotifier(this._loginUseCase) : super(const LoginState());

  /// Toggle del checkbox "Recuérdame"
  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  /// Ejecutar login usando Use Case
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final params = LoginParams(email: email, password: password);
    final result = await _loginUseCase(params);
    
    return result.fold(
      (failure) {
        // Error
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) {
        // Éxito
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  /// Limpiar mensaje de error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider del login state (CON DEPENDENCY INJECTION)
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(
    ref.read(loginUseCaseProvider), // ✅ Inyección de dependencia
  );
});
