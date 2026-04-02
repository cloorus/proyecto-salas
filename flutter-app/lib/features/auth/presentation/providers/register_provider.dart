
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_providers.dart'; // Import for registerUseCaseProvider

/// Estado del registro
class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final bool acceptTerms;

  const RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.acceptTerms = false,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? acceptTerms,
    bool clearError = false,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      acceptTerms: acceptTerms ?? this.acceptTerms,
    );
  }
}

/// Notifier para manejo del registro
class RegisterNotifier extends StateNotifier<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterNotifier(this.registerUseCase) : super(const RegisterState());

  /// Toggle accept terms checkbox
  void toggleAcceptTerms() {
    state = state.copyWith(acceptTerms: !state.acceptTerms);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Register user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
    String? country,
    String? language,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await registerUseCase(RegisterParams(
      name: name,
      email: email,
      password: password,
      phone: phone,
      address: address,
      country: country,
      language: language,
    ));

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }
}

/// Provider del Register Notifier
final registerNotifierProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(
    ref.read(registerUseCaseProvider),
  );
});
