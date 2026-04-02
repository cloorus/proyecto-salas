import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bgnius_vita/core/errors/failures.dart';
import 'package:bgnius_vita/features/auth/domain/entities/user.dart';
import 'package:bgnius_vita/features/auth/domain/usecases/login_usecase.dart';
import 'package:bgnius_vita/features/auth/presentation/providers/login_provider.dart';

// Esta anotación generará el mock
@GenerateMocks([LoginUseCase])
import 'login_notifier_test.mocks.dart';

void main() {
  late LoginNotifier notifier;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    notifier = LoginNotifier(mockLoginUseCase);
  });

  final testUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@bgnius.com',
    createdAt: DateTime(2024, 1, 1),
  );

  group('LoginNotifier', () {
    test('initial state should be correct', () {
      // Assert
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, null);
      expect(notifier.state.rememberMe, false);
    });

    test('toggleRememberMe should toggle the rememberMe state', () {
      // Assert initial state
      expect(notifier.state.rememberMe, false);

      // Act
      notifier.toggleRememberMe();

      // Assert
      expect(notifier.state.rememberMe, true);

      // Act again
      notifier.toggleRememberMe();

      // Assert
      expect(notifier.state.rememberMe, false);
    });

    test('login should return true on success', () async {
      // Arrange
      when(mockLoginUseCase.call(any))
          .thenAnswer((_) async => Right(testUser));

      // Act
      final result = await notifier.login('test@bgnius.com', 'pass123');

      // Assert
      expect(result, true);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, null);
    });

    test('login should return false and set error message on failure', () async {
      // Arrange
      const failure = InvalidCredentialsFailure('Credenciales inválidas');
      when(mockLoginUseCase.call(any))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await notifier.login('wrong@email.com', 'wrong');

      // Assert
      expect(result, false);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, 'Credenciales inválidas');
    });

    test('login should call use case with correct params', () async {
      // Arrange
      when(mockLoginUseCase.call(any))
          .thenAnswer((_) async => Right(testUser));

      // Act
      await notifier.login('test@bgnius.com', 'pass123');

      // Assert - Use argThat matcher to verify params
      verify(mockLoginUseCase.call(
        argThat(isA<LoginParams>()
            .having((p) => p.email, 'email', 'test@bgnius.com')
            .having((p) => p.password, 'password', 'pass123')),
      )).called(1);
    });

    test('clearError should clear error message', () async {
      // Arrange - trigger an error first by failing login
      const failure = InvalidCredentialsFailure('Some error');
      when(mockLoginUseCase.call(any))
          .thenAnswer((_) async => const Left(failure));

      await notifier.login('wrong@email.com', 'wrong');
      
      // Verify error is set
      expect(notifier.state.errorMessage, 'Some error');

      // Act
      notifier.clearError();

      // Assert
      expect(notifier.state.errorMessage, null);
    });
  });
}
