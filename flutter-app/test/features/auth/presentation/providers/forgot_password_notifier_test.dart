import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bgnius_vita/core/errors/failures.dart';
import 'package:bgnius_vita/features/auth/domain/usecases/send_password_reset_code_usecase.dart';
import 'package:bgnius_vita/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:bgnius_vita/features/auth/presentation/providers/forgot_password_provider.dart';

@GenerateMocks([SendPasswordResetCodeUseCase, ResetPasswordUseCase])
import 'forgot_password_notifier_test.mocks.dart';

void main() {
  late ForgotPasswordNotifier notifier;
  late MockSendPasswordResetCodeUseCase mockSendCodeUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  setUp(() {
    mockSendCodeUseCase = MockSendPasswordResetCodeUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    notifier = ForgotPasswordNotifier(
      sendCodeUseCase: mockSendCodeUseCase,
      resetPasswordUseCase: mockResetPasswordUseCase,
    );
  });

  group('ForgotPasswordNotifier', () {
    test('initial state should be correct', () {
      expect(notifier.state.isLoading, false);
      expect(notifier.state.codeSent, false);
      expect(notifier.state.timeLeft, 60);
    });

    test('sendCode should update state on success', () async {
      // Arrange
      when(mockSendCodeUseCase(any))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await notifier.sendCode('test@bgnius.com');

      // Assert
      expect(result, true);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.codeSent, true);
    });

    test('sendCode should return false on failure', () async {
      // Arrange
      when(mockSendCodeUseCase(any))
          .thenAnswer((_) async => const Left(ServerFailure('Error')));

      // Act
      final result = await notifier.sendCode('test@bgnius.com');

      // Assert
      expect(result, false);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, 'Error');
    });

    test('resetPassword should update state on success', () async {
      // Arrange
      when(mockResetPasswordUseCase(any))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await notifier.resetPassword(
        email: 'test',
        code: '123',
        newPassword: 'pass',
      );

      // Assert
      expect(result, true);
      expect(notifier.state.isLoading, false);
    });
  });
}
