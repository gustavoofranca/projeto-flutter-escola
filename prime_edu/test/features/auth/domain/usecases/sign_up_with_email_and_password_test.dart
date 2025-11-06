import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/repositories/auth_repository.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_up_with_email_and_password.dart';

// Mock para AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}
void main() {
  late SignUpWithEmailAndPassword usecase;
  late MockAuthRepository mockAuthRepository;
  late UserEntity tUser;
  final tEmail = 'test@example.com';
  final tPassword = 'password123';
  final tName = 'Test User';

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignUpWithEmailAndPassword(mockAuthRepository);
    tUser = UserEntity(
      id: '1',
      email: tEmail,
      name: tName,
      isEmailVerified: false,
    );
  });

  test(
    'deve criar uma nova conta com email e senha fornecidos',
    () async {
      // arrange
      when(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
            name: tName,
          )).thenAnswer((_) async => Right(tUser));

      // act
      final result = await usecase(
        SignUpWithEmailAndPasswordParams(
          email: tEmail,
          password: tPassword,
          name: tName,
        ),
      );

      // assert
      expect(result, Right(tUser));
      verify(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
            name: tName,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'deve retornar ServerFailure quando o cadastro falhar',
    () async {
      // arrange
      final tFailure = ServerFailure(message: 'Falha no cadastro');
      when(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
            name: tName,
          )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(
        SignUpWithEmailAndPasswordParams(
          email: tEmail,
          password: tPassword,
          name: tName,
        ),
      );

      // assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
            name: tName,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'deve retornar EmailAlreadyInUseFailure quando o email já estiver em uso',
    () async {
      // arrange
      final tFailure = EmailAlreadyInUseFailure('Email já está em uso');
      when(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
            name: tName,
          )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(
        SignUpWithEmailAndPasswordParams(
          email: tEmail,
          password: tPassword,
          name: tName,
        ),
      );

      // assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
            name: tName,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'deve retornar InvalidEmailFailure quando o email for inválido',
    () async {
      // arrange
      final tFailure = InvalidEmailFailure('Email inválido');
      when(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: 'email-invalido',
            password: tPassword,
            name: tName,
          )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(
        SignUpWithEmailAndPasswordParams(
          email: 'email-invalido',
          password: tPassword,
          name: tName,
        ),
      );

      // assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: 'email-invalido',
            password: tPassword,
            name: tName,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'deve retornar WeakPasswordFailure quando a senha for fraca',
    () async {
      // arrange
      final tWeakPassword = '123';
      final tFailure = WeakPasswordFailure('Senha muito fraca');
      when(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tWeakPassword,
            name: tName,
          )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(
        SignUpWithEmailAndPasswordParams(
          email: tEmail,
          password: tWeakPassword,
          name: tName,
        ),
      );

      // assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.signUpWithEmailAndPassword(
            email: tEmail,
            password: tWeakPassword,
            name: tName,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
