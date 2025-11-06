import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/repositories/auth_repository.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_in_with_email_and_password.dart';

// Mock para AuthRepository
class MockAuthRepository extends Mock implements AuthRepository {}

// Classe Fake para os parâmetros
class FakeSignInParams extends Fake implements SignInWithEmailAndPasswordParams {
  @override
  final String email = 'test@example.com';

  @override
  final String password = 'password123';

  FakeSignInParams();
}
void main() {
  late SignInWithEmailAndPassword usecase;
  late MockAuthRepository mockAuthRepository;
  late UserEntity tUser;
  final tEmail = 'test@example.com';
  final tPassword = 'password123';

  setUpAll(() {
    // Registra os fallback values para os parâmetros
    registerFallbackValue(FakeSignInParams());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignInWithEmailAndPassword(mockAuthRepository);
    tUser = UserEntity(
      id: '1',
      email: tEmail,
      name: 'Test User',
      isEmailVerified: true,
    );
  });

  test(
    'deve fazer login com email e senha fornecidos',
    () async {
      // arrange
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => Right(tUser));

      // act
      final result = await usecase(
        SignInWithEmailAndPasswordParams(
          email: tEmail,
          password: tPassword,
        ),
      );

      // assert
      expect(result, Right(tUser));
      verify(() => mockAuthRepository.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'deve retornar ServerFailure quando o login falhar',
    () async {
      // arrange
      final tFailure = ServerFailure(message: 'Falha na autenticação');
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(
        SignInWithEmailAndPasswordParams(
          email: tEmail,
          password: tPassword,
        ),
      );

      // assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test(
    'deve retornar InvalidCredentialsFailure quando as credenciais forem inválidas',
    () async {
      // arrange
      final tFailure = InvalidCredentialsFailure('Credenciais inválidas');
      when(() => mockAuthRepository.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(
        SignInWithEmailAndPasswordParams(
          email: tEmail,
          password: tPassword,
        ),
      );

      // assert
      expect(result, Left(tFailure));
      verify(() => mockAuthRepository.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
