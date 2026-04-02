import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bgnius_vita/core/errors/failures.dart';
import 'package:bgnius_vita/features/auth/domain/entities/user.dart';
import 'package:bgnius_vita/features/auth/domain/usecases/register_usecase.dart';

// Importamos el mock ya generado
import 'login_usecase_test.mocks.dart';

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  final testUser = User(
    id: '1',
    name: 'Test User',
    email: 'test@bgnius.com',
    createdAt: DateTime(2024, 1, 1),
  );

  group('RegisterUseCase', () {
    test('should return User when registration succeeds', () async {
      // Arrange
      when(mockRepository.register(
        name: anyNamed('name'),
        email: anyNamed('email'),
        password: anyNamed('password'),
        phone: anyNamed('phone'),
        address: anyNamed('address'),
        country: anyNamed('country'),
        language: anyNamed('language'),
      )).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await useCase(
        const RegisterParams(
          name: 'Test User',
          email: 'test@bgnius.com',
          password: 'pass123',
        ),
      );

      // Assert
      expect(result, Right(testUser));
      verify(mockRepository.register(
        name: 'Test User',
        email: 'test@bgnius.com',
        password: 'pass123',
        phone: null,
        address: null,
        country: null,
        language: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.register(
        name: anyNamed('name'),
        email: anyNamed('email'),
        password: anyNamed('password'),
        phone: anyNamed('phone'),
        address: anyNamed('address'),
        country: anyNamed('country'),
        language: anyNamed('language'),
      )).thenAnswer((_) async => const Left(ServerFailure()));

      // Act
      final result = await useCase(
        const RegisterParams(
          name: 'Test User',
          email: 'test@bgnius.com',
          password: 'pass123',
        ),
      );

      // Assert
      expect(result, const Left(ServerFailure()));
    });

    test('should return invalid credentials failure when validation fails (empty name)', () async {
      // Act
      final result = await useCase(
        const RegisterParams(name: '', email: 'test@email.com', password: 'pass'),
      );

      // Assert
      expect(result.isLeft(), true);
      verifyNever(mockRepository.register(
        name: anyNamed('name'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });
  });
}
