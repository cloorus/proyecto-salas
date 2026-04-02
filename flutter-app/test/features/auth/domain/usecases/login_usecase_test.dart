import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bgnius_vita/core/errors/failures.dart';
import 'package:bgnius_vita/features/auth/domain/entities/user.dart';
import 'package:bgnius_vita/features/auth/domain/repositories/auth_repository.dart';
import 'package:bgnius_vita/features/auth/domain/usecases/login_usecase.dart';

// Esta anotación generará el mock
@GenerateMocks([AuthRepository])
import 'login_usecase_test.mocks.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  final testUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@bgnius.com',
    createdAt: DateTime(2024, 1, 1),
  );

  group('LoginUseCase', () {
    test('should return User when login succeeds', () async {
      // Arrange
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(
        const LoginParams(email: 'test@bgnius.com', password: 'pass123'),
      );

      // Assert
      expect(result, Right(testUser));
      verify(mockRepository.login('test@bgnius.com', 'pass123'));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return InvalidCredentialsFailure when repository returns failure', () async {
      // Arrange
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => const Left(InvalidCredentialsFailure()));

      // Act
      final result = await useCase(
        const LoginParams(email: 'wrong@email.com', password: 'wrong'),
      );

      // Assert
      expect(result, const Left(InvalidCredentialsFailure()));
      verify(mockRepository.login('wrong@email.com', 'wrong'));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return InvalidCredentialsFailure when email is empty', () async {
      // Act
      final result = await useCase(
        const LoginParams(email: '', password: 'pass123'),
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (_) => fail('Should return failure'),
      );
      verifyNever(mockRepository.login(any, any));
    });

    test('should return InvalidCredentialsFailure when password is empty', () async {
      // Act
      final result = await useCase(
        const LoginParams(email: 'test@bgnius.com', password: ''),
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (_) => fail('Should return failure'),
      );
      verifyNever(mockRepository.login(any, any));
    });
  });
}
