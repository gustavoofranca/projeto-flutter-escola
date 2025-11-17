import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:prime_edu/features/auth/presentation/providers/auth_view_model_v2.dart';
import 'package:prime_edu/features/auth/presentation/state/auth_state.dart';

// Classes de mock para os casos de uso
class MockSignInWithEmailAndPassword extends Mock
    implements SignInWithEmailAndPassword {}

class MockSignUpWithEmailAndPassword extends Mock
    implements SignUpWithEmailAndPassword {}

// Classes Fake para os parâmetros
class FakeSignInParams extends Fake implements SignInWithEmailAndPasswordParams {
  @override
  final String email = 'test@example.com';
  
  @override
  final String password = 'password123';
  
  FakeSignInParams();
}

class FakeSignUpParams extends Fake implements SignUpWithEmailAndPasswordParams {
  @override
  final String email = 'test@example.com';
  
  @override
  final String password = 'password123';
  
  @override
  final String? name = 'Test User';
  
  FakeSignUpParams();
}

void main() {
  // Configuração dos fallback values para os parâmetros
  setUpAll(() {
    registerFallbackValue(FakeSignInParams());
    registerFallbackValue(FakeSignUpParams());
  });
  
  late AuthViewModelV2 viewModel;
  late MockSignInWithEmailAndPassword mockSignInUseCase;
  late MockSignUpWithEmailAndPassword mockSignUpUseCase;
  
  final tEmail = 'test@example.com';
  final tPassword = 'password123';
  final tUser = UserEntity(
    id: '1',
    email: tEmail,
    name: 'Test User',
    isEmailVerified: true,
  );

  setUp(() {
    mockSignInUseCase = MockSignInWithEmailAndPassword();
    mockSignUpUseCase = MockSignUpWithEmailAndPassword();
    
    viewModel = AuthViewModelV2(
      signInUseCase: mockSignInUseCase,
      signUpUseCase: mockSignUpUseCase,
    );
  });

  group('Estado inicial', () {
    test('deve ter estado inicial correto', () {
      // assert
      expect(viewModel.state, equals(AuthState.initial()));
      expect(viewModel.isLoading, false);
      expect(viewModel.error, isNull);
      expect(viewModel.currentUser, isNull);
      expect(viewModel.isAuthenticated, false);
    });
  });

  group('signIn', () {
    test(
      'deve atualizar estado para loading e depois authenticated quando bem-sucedido',
      () async {
        // arrange
        when(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Right(tUser));

        // act
        final future = viewModel.signIn(tEmail, tPassword);

        // assert - estado intermediário
        expect(viewModel.state.isLoading, true);
        expect(viewModel.state.error, isNull);

        final result = await future;

        // assert - estado final
        expect(result, true);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.isAuthenticated, true);
        expect(viewModel.state.user, tUser);
        expect(viewModel.state.error, isNull);
        
        verify(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).called(1);
      },
    );

    test(
      'deve atualizar estado com erro quando o login falhar',
      () async {
        // arrange
        final tFailure = ServerFailure(message: 'Falha na autenticação');
        when(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signIn(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.isAuthenticated, false);
        expect(viewModel.state.user, isNull);
        expect(viewModel.state.error, isNotNull);
        expect(viewModel.state.error, contains('Falha na autenticação'));
        
        verify(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).called(1);
      },
    );

    test(
      'deve mapear InvalidCredentialsFailure para mensagem amigável',
      () async {
        // arrange
        final tFailure = const InvalidCredentialsFailure();
        when(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signIn(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(
          viewModel.state.error, 
          'Credenciais inválidas. Verifique seu email e senha.'
        );
      },
    );

    test(
      'deve mapear UserNotFoundFailure para mensagem amigável',
      () async {
        // arrange
        final tFailure = const UserNotFoundFailure();
        when(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signIn(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(
          viewModel.state.error,
          'Nenhum usuário encontrado com este email.'
        );
      },
    );

    test(
      'deve mapear WrongPasswordFailure para mensagem amigável',
      () async {
        // arrange
        final tFailure = const WrongPasswordFailure();
        when(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signIn(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.state.error, 'Senha incorreta. Tente novamente.');
      },
    );

    test(
      'deve capturar erros inesperados',
      () async {
        // arrange
        when(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenThrow(Exception('Erro inesperado'));

        // act
        final result = await viewModel.signIn(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.state.error, contains('Erro inesperado'));
      },
    );
  });

  group('signUp', () {
    test(
      'deve atualizar estado para loading e depois authenticated quando bem-sucedido',
      () async {
        // arrange
        final tName = 'Test User';
        when(() => mockSignUpUseCase(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Right(tUser));

        // act
        final future = viewModel.signUp(tEmail, tPassword, name: tName);

        // assert - estado intermediário
        expect(viewModel.state.isLoading, true);
        expect(viewModel.state.error, isNull);

        final result = await future;

        // assert - estado final
        expect(result, true);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.isAuthenticated, true);
        expect(viewModel.state.user, tUser);
        expect(viewModel.state.error, isNull);
        
        verify(() => mockSignUpUseCase(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).called(1);
      },
    );

    test(
      'deve atualizar estado com erro quando o cadastro falhar',
      () async {
        // arrange
        final tFailure = ServerFailure(message: 'Falha no cadastro');
        when(() => mockSignUpUseCase(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signUp(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.isAuthenticated, false);
        expect(viewModel.state.user, isNull);
        expect(viewModel.state.error, isNotNull);
      },
    );

    test(
      'deve mapear EmailAlreadyInUseFailure para mensagem amigável',
      () async {
        // arrange
        final tFailure = const EmailAlreadyInUseFailure();
        when(() => mockSignUpUseCase(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signUp(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(
          viewModel.state.error, 
          'Este email já está em uso. Tente fazer login ou use outro email.'
        );
      },
    );

    test(
      'deve mapear InvalidEmailFailure para mensagem amigável',
      () async {
        // arrange
        final tFailure = const InvalidEmailFailure();
        when(() => mockSignUpUseCase(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signUp(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.state.error, 'O email fornecido é inválido.');
      },
    );

    test(
      'deve mapear WeakPasswordFailure para mensagem amigável',
      () async {
        // arrange
        final tWeakPassword = '123';
        final tFailure = const WeakPasswordFailure();
        when(() => mockSignUpUseCase(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signUp(tEmail, tWeakPassword);

        // assert
        expect(result, false);
        expect(
          viewModel.state.error,
          'A senha fornecida é muito fraca. Tente uma senha mais forte.'
        );
      },
    );
  });

  group('signOut', () {
    test(
      'deve resetar o estado para inicial',
      () async {
        // arrange - primeiro faz login
        when(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Right(tUser));
        
        await viewModel.signIn(tEmail, tPassword);
        
        // Garante que o usuário está autenticado
        expect(viewModel.state.isAuthenticated, true);
        expect(viewModel.state.user, isNotNull);
        
        // act
        viewModel.signOut();
        
        // assert
        expect(viewModel.state, equals(AuthState.initial()));
        expect(viewModel.state.isAuthenticated, false);
        expect(viewModel.state.user, isNull);
        expect(viewModel.state.error, isNull);
      },
    );
  });

  group('clearError', () {
    test(
      'deve limpar a mensagem de erro mantendo outros estados',
      () async {
        // arrange - cria um erro
        final tFailure = ServerFailure(message: 'Algum erro');
        when(() => mockSignInUseCase(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));
        
        await viewModel.signIn(tEmail, tPassword);
        
        // Garante que há erro
        expect(viewModel.state.error, isNotNull);
        
        // act
        viewModel.clearError();
        
        // assert
        expect(viewModel.state.error, isNull);
        expect(viewModel.state.isLoading, false);
      },
    );
  });

  group('setError', () {
    test(
      'deve definir uma mensagem de erro',
      () {
        // arrange
        final errorMessage = 'Erro customizado';
        
        // act
        viewModel.setError(errorMessage);
        
        // assert
        expect(viewModel.state.error, errorMessage);
      },
    );
  });

  group('currentUser setter', () {
    test(
      'deve atualizar o usuário e estado de autenticação',
      () {
        // act
        viewModel.currentUser = tUser;
        
        // assert
        expect(viewModel.state.user, tUser);
        expect(viewModel.state.isAuthenticated, true);
      },
    );

    test(
      'deve limpar autenticação quando usuário for null',
      () {
        // arrange - primeiro define um usuário
        viewModel.currentUser = tUser;
        expect(viewModel.state.isAuthenticated, true);
        
        // act
        viewModel.currentUser = null;
        
        // assert
        expect(viewModel.state.user, isNull);
        expect(viewModel.state.isAuthenticated, false);
      },
    );
  });

  group('Getters de conveniência', () {
    test('isLoading deve retornar o valor correto do estado', () {
      expect(viewModel.isLoading, viewModel.state.isLoading);
    });

    test('error deve retornar o valor correto do estado', () {
      expect(viewModel.error, viewModel.state.error);
    });

    test('currentUser deve retornar o valor correto do estado', () {
      expect(viewModel.currentUser, viewModel.state.user);
    });

    test('isAuthenticated deve retornar o valor correto do estado', () {
      expect(viewModel.isAuthenticated, viewModel.state.isAuthenticated);
    });
  });
}
