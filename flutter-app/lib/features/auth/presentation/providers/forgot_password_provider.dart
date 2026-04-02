import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/send_password_reset_code_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'auth_providers.dart';

/// Estado del restablecimiento de contraseña
class ForgotPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool codeSent;
  final int timeLeft;

  const ForgotPasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.codeSent = false,
    this.timeLeft = 60,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? codeSent,
    int? timeLeft,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      codeSent: codeSent ?? this.codeSent,
      timeLeft: timeLeft ?? this.timeLeft,
    );
  }
}

/// Notifier para manejo de restablecimiento de contraseña
class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final SendPasswordResetCodeUseCase sendCodeUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordNotifier({
    required this.sendCodeUseCase,
    required this.resetPasswordUseCase,
  }) : super(const ForgotPasswordState());

  /// Enviar código de restablecimiento
  Future<bool> sendCode(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await sendCodeUseCase(
      SendPasswordResetCodeParams(email: email),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          codeSent: true,
          timeLeft: 60,
        );
        return true;
      },
    );
  }

  /// Restablecer contraseña
  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await resetPasswordUseCase(ResetPasswordParams(
      email: email,
      code: code,
      newPassword: newPassword,
    ));

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  /// Actualizar timer
  void updateTimer(int seconds) {
    state = state.copyWith(timeLeft: seconds);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider para ForgotPasswordNotifier
final forgotPasswordNotifierProvider = StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
  return ForgotPasswordNotifier(
    sendCodeUseCase: ref.read(sendPasswordResetCodeUseCaseProvider),
    resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
  );
});
