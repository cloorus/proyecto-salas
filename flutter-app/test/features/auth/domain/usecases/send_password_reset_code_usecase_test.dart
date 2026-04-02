import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bgnius_vita/core/errors/failures.dart';
import 'package:bgnius_vita/features/auth/domain/usecases/send_password_reset_code_usecase.dart';

import 'login_usecase_test.mocks.dart';

void main() {
  late SendPasswordResetCodeUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SendPasswordResetCodeUseCase(mockRepository);
  });

  group('SendPasswordResetCodeUseCase', () {
    test('should call repository when email is valid', () async {
      // Arrange
      when(mockRepository.sendPasswordResetCode(any))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(
        const SendPasswordResetCodeParams(email: 'test@bgnius.com'),
      );

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.sendPasswordResetCode('test@bgnius.com'));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when email is empty', () async {
      // Act
      final result = await useCase(
        const SendPasswordResetCodeParams(email: ''),
      );

      // Assert
      expect(result.isLeft(), true);
      verifyNever(mockRepository.sendPasswordResetCode(any));
    });
  });
}
