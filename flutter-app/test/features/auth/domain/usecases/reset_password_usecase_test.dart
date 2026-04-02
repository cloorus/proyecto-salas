import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bgnius_vita/core/errors/failures.dart';
import 'package:bgnius_vita/features/auth/domain/usecases/reset_password_usecase.dart';

import 'login_usecase_test.mocks.dart';

void main() {
  late ResetPasswordUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ResetPasswordUseCase(mockRepository);
  });

  group('ResetPasswordUseCase', () {
    test('should call repository when params are valid', () async {
      // Arrange
      when(mockRepository.resetPassword(
        email: anyNamed('email'),
        code: anyNamed('code'),
        newPassword: anyNamed('newPassword'),
      )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(
        const ResetPasswordParams(
          email: 'test@bgnius.com',
          code: '123456',
          newPassword: 'newpass',
        ),
      );

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.resetPassword(
        email: 'test@bgnius.com',
        code: '123456',
        newPassword: 'newpass',
      ));
    });

    test('should return failure when password is empty', () async {
      // Act
      final result = await useCase(
        const ResetPasswordParams(
          email: 'test@bgnius.com',
          code: '123456',
          newPassword: '',
        ),
      );

      // Assert
      expect(result.isLeft(), true);
      verifyNever(mockRepository.resetPassword(
        email: anyNamed('email'),
        code: anyNamed('code'),
        newPassword: anyNamed('newPassword'),
      ));
    });
  });
}
