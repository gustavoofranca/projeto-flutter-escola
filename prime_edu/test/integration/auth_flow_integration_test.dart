import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/repositories/auth_repository.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:prime_edu/features/auth/presentation/providers/auth_view_model_v2.dart';
import 'package:dartz/dartz.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

/// Testes de integração para o fluxo completo de autenticação
/// 
/// Estes testes verificam a integração entre:
/// - ViewModel
/// - Use Cases
/// - Repository (mockado)
void main() {
  late MockAuthRepository mockRepository;
  late SignInWithEmailAndPassword signInUseCase;
  late SignUpWithEmailAndPassword signUpUseCase;
  late AuthViewModelV2 viewModel;

  setUp(() {
    mockRepository = MockAuthRepository();
    signInUseCase = SignInWithEmailAndPassword(mockRepository);
    signUpUseCase = SignUpWithEmailAndPassword(mockRepository);
    viewModel = AuthViewModelV2(
      signInUseCase: signInUseCase,
      signUpUseCase: signUpUseCase,
    );
  });

  final tEmail = 'test@example.com';
  final tPassword = 'password123';
  final tUser = UserEntity(
    id: '1',
    email: tEmail,
    name: 'Test User',
    isEmailVerified: true,
  );

  group('Fluxo de Login Completo', () {
    test(
      'deve completar o fluxo de login com sucesso do início ao fim',
      () async {
        // arrange
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUser));

        // Verifica estado inicial
        expect(viewModel.isAuthenticated, false);
        expect(viewModel.currentUser, isNull);

        // act - Executa login
        final result = await viewModel.signIn(tEmail, tPassword);

        // assert - Verifica resultado
        expect(result, true);
        expect(viewModel.isAuthenticated, true);
        expect(viewModel.currentUser, tUser);
        expect(viewModel.error, isNull);
        expect(viewModel.isLoading, false);

        // Verifica que o repository foi chamado corretamente
        verify(() => mockRepository.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).called(1);
      },
    );

    test(
      'deve lidar com erro de credenciais inválidas no fluxo completo',
      () async {
        // arrange
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left(InvalidCredentialsFailure()));

        // act
        final result = await viewModel.signIn(tEmail, 'wrong_password');

        // assert
        expect(result, false);
        expect(viewModel.isAuthenticated, false);
        expect(viewModel.currentUser, isNull);
        expect(viewModel.error, isNotNull);
        expect(
          viewModel.error,
          contains('Credenciais inválidas'),
        );
      },
    );

    test(
      'deve permitir logout após login bem-sucedido',
      () async {
        // arrange - Primeiro faz login
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUser));

        await viewModel.signIn(tEmail, tPassword);
        expect(viewModel.isAuthenticated, true);

        // act - Faz logout
        viewModel.signOut();

        // assert
        expect(viewModel.isAuthenticated, false);
        expect(viewModel.currentUser, isNull);
        expect(viewModel.error, isNull);
      },
    );
  });

  group('Fluxo de Cadastro Completo', () {
    test(
      'deve completar o fluxo de cadastro com sucesso do início ao fim',
      () async {
        // arrange
        final tName = 'New User';
        when(() => mockRepository.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => Right(tUser));

        // Verifica estado inicial
        expect(viewModel.isAuthenticated, false);
        expect(viewModel.currentUser, isNull);

        // act - Executa cadastro
        final result = await viewModel.signUp(tEmail, tPassword, name: tName);

        // assert - Verifica resultado
        expect(result, true);
        expect(viewModel.isAuthenticated, true);
        expect(viewModel.currentUser, tUser);
        expect(viewModel.error, isNull);
        expect(viewModel.isLoading, false);

        // Verifica que o repository foi chamado corretamente
        verify(() => mockRepository.signUpWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
              name: tName,
            )).called(1);
      },
    );

    test(
      'deve lidar com erro de email já em uso no fluxo completo',
      () async {
        // arrange
        when(() => mockRepository.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => const Left(EmailAlreadyInUseFailure()));

        // act
        final result = await viewModel.signUp(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.isAuthenticated, false);
        expect(viewModel.currentUser, isNull);
        expect(viewModel.error, isNotNull);
        expect(
          viewModel.error,
          contains('já está em uso'),
        );
      },
    );

    test(
      'deve lidar com erro de senha fraca no fluxo completo',
      () async {
        // arrange
        when(() => mockRepository.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => const Left(WeakPasswordFailure()));

        // act
        final result = await viewModel.signUp(tEmail, '123');

        // assert
        expect(result, false);
        expect(viewModel.isAuthenticated, false);
        expect(viewModel.error, contains('fraca'));
      },
    );
  });

  group('Fluxo de Recuperação de Erro', () {
    test(
      'deve limpar erro após falha de login',
      () async {
        // arrange - Simula falha de login
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left(InvalidCredentialsFailure()));

        await viewModel.signIn(tEmail, 'wrong_password');
        expect(viewModel.error, isNotNull);

        // act - Limpa erro
        viewModel.clearError();

        // assert
        expect(viewModel.error, isNull);
        expect(viewModel.isAuthenticated, false); // Estado de auth não muda
      },
    );

    test(
      'deve permitir nova tentativa de login após falha',
      () async {
        // arrange - Primeira tentativa falha
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left(InvalidCredentialsFailure()));

        final firstResult = await viewModel.signIn(tEmail, 'wrong_password');
        expect(firstResult, false);
        expect(viewModel.error, isNotNull);

        // arrange - Segunda tentativa com sucesso
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUser));

        // act - Segunda tentativa
        final secondResult = await viewModel.signIn(tEmail, tPassword);

        // assert
        expect(secondResult, true);
        expect(viewModel.isAuthenticated, true);
        expect(viewModel.currentUser, tUser);
        expect(viewModel.error, isNull);
      },
    );
  });

  group('Fluxo de Estados Múltiplos', () {
    test(
      'deve gerenciar transições de estado corretamente',
      () async {
        // arrange
        final states = <bool>[];
        
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async {
          // Simula delay para capturar estado de loading
          await Future.delayed(const Duration(milliseconds: 100));
          return Right(tUser);
        });

        // act & assert - Captura estados durante o processo
        final future = viewModel.signIn(tEmail, tPassword);
        
        // Estado inicial de loading
        states.add(viewModel.isLoading);
        expect(viewModel.isLoading, true);
        expect(viewModel.isAuthenticated, false);

        await future;

        // Estado final
        states.add(viewModel.isLoading);
        expect(viewModel.isLoading, false);
        expect(viewModel.isAuthenticated, true);
        
        // Verifica que passou por loading
        expect(states, [true, false]);
      },
    );
  });

  group('Fluxo de Validação de Dados', () {
    test(
      'deve manter consistência de dados através do fluxo',
      () async {
        // arrange
        when(() => mockRepository.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(tUser));

        // act
        await viewModel.signIn(tEmail, tPassword);

        // assert - Verifica consistência dos dados
        expect(viewModel.currentUser?.email, tEmail);
        expect(viewModel.currentUser?.id, tUser.id);
        expect(viewModel.currentUser?.name, tUser.name);
        expect(viewModel.isAuthenticated, true);
      },
    );
  });
}
