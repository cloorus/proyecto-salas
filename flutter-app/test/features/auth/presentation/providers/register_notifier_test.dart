import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bgnius_vita/core/errors/failures.dart';
import 'package:bgnius_vita/features/auth/domain/entities/user.dart';
import 'package:bgnius_vita/features/auth/domain/usecases/register_usecase.dart';
import 'package:bgnius_vita/features/auth/presentation/providers/register_provider.dart';

@GenerateMocks([RegisterUseCase])
import 'register_notifier_test.mocks.dart';

void main() {
  late RegisterNotifier notifier;
  late MockRegisterUseCase mockRegisterUseCase;

  setUp(() {
    mockRegisterUseCase = MockRegisterUseCase();
    notifier = RegisterNotifier(mockRegisterUseCase);
  });

  final testUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@bgnius.com',
    createdAt: DateTime(2024, 1, 1),
  );

  group('RegisterNotifier', () {
    test('initial state should be correct', () {
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, null);
      expect(notifier.state.acceptTerms, false);
    });

    test('toggleAcceptTerms should toggle state', () {
      expect(notifier.state.acceptTerms, false);
      notifier.toggleAcceptTerms();
      expect(notifier.state.acceptTerms, true);
    });

    test('register should return true on success', () async {
      // Arrange
      when(mockRegisterUseCase(any))
          .thenAnswer((_) async => Right(testUser));

      // Act
      final result = await notifier.register(
        name: 'Test',
        email: 'test@email.com',
        password: 'pass',
      );

      // Assert
      expect(result, true);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, null);
    });

    test('register should return false on failure', () async {
      // Arrange
      when(mockRegisterUseCase(any))
          .thenAnswer((_) async => const Left(ServerFailure('Error')));

      // Act
      final result = await notifier.register(
        name: 'Test',
        email: 'test@email.com',
        password: 'pass',
      );

      // Assert
      expect(result, false);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, 'Error');
    });
  });
}
