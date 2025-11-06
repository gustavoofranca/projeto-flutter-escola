import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:prime_edu/features/auth/presentation/providers/auth_view_model.dart';

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
  
  late AuthViewModel viewModel;
  late MockSignInWithEmailAndPassword mockSignInWithEmailAndPassword;
  late MockSignUpWithEmailAndPassword mockSignUpWithEmailAndPassword;
  
  final tEmail = 'test@example.com';
  final tPassword = 'password123';
  final tUser = UserEntity(
    id: '1',
    email: tEmail,
    name: 'Test User',
    isEmailVerified: true,
  );

  setUp(() {
    mockSignInWithEmailAndPassword = MockSignInWithEmailAndPassword();
    mockSignUpWithEmailAndPassword = MockSignUpWithEmailAndPassword();
    
    viewModel = AuthViewModel(
      signInWithEmailAndPassword: mockSignInWithEmailAndPassword,
      signUpWithEmailAndPassword: mockSignUpWithEmailAndPassword,
    );
    
    // Configuração padrão para evitar erros de mock não configurado
    when(() => mockSignInWithEmailAndPassword(
          any(),
        )).thenAnswer((_) async => Right(tUser));
    
    when(() => mockSignUpWithEmailAndPassword(
          any(),
        )).thenAnswer((_) async => Right(tUser));
  });

  group('signIn', () {
    test(
      'deve atualizar o estado corretamente quando o login for bem-sucedido',
      () async {
        // arrange
        when(() => mockSignInWithEmailAndPassword(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Right(tUser));

        // act
        final result = await viewModel.signIn(tEmail, tPassword);

        // assert
        expect(result, true);
        expect(viewModel.currentUser, tUser);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, isNull);
        
        verify(() => mockSignInWithEmailAndPassword(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).called(1);
      },
    );

    test(
      'deve atualizar o estado com erro quando o login falhar',
      () async {
        // arrange
        final tFailure = ServerFailure(message: 'Falha na autenticação');
        when(() => mockSignInWithEmailAndPassword(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signIn(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.currentUser, isNull);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, tFailure.message);
        
        verify(() => mockSignInWithEmailAndPassword(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).called(1);
      },
    );

    test(
      'deve retornar mensagem de erro para credenciais inválidas',
      () async {
        // arrange
        final tFailure = const InvalidCredentialsFailure();
        when(() => mockSignInWithEmailAndPassword(
              any(that: isA<SignInWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signIn(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.currentUser, isNull);
        expect(viewModel.isLoading, false);
        expect(
          viewModel.error, 
          'Credenciais inválidas. Verifique seu email e senha.'
        );
      },
    );
  });

  group('signUp', () {
    test(
      'deve atualizar o estado corretamente quando o cadastro for bem-sucedido',
      () async {
        // arrange
        final tName = 'Test User';
        when(() => mockSignUpWithEmailAndPassword(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Right(tUser));

        // act
        final result = await viewModel.signUp(tEmail, tPassword, name: tName);

        // assert
        expect(result, true);
        expect(viewModel.currentUser, tUser);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, isNull);
        
        verify(() => mockSignUpWithEmailAndPassword(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).called(1);
      },
    );

    test(
      'deve atualizar o estado com erro quando o cadastro falhar',
      () async {
        // arrange
        final tFailure = ServerFailure(message: 'Falha no cadastro');
        when(() => mockSignUpWithEmailAndPassword(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signUp(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.currentUser, isNull);
        expect(viewModel.error, tFailure.message);
      },
    );

    test(
      'deve retornar mensagem de erro quando o email já estiver em uso',
      () async {
        // arrange
        final tFailure = const EmailAlreadyInUseFailure();
        when(() => mockSignUpWithEmailAndPassword(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signUp(tEmail, tPassword);

        // assert
        expect(result, false);
        expect(viewModel.currentUser, isNull);
        expect(
          viewModel.error, 
          'Este email já está em uso. Tente fazer login ou use outro email.'
        );
      },
    );

    test(
      'deve retornar mensagem de erro quando a senha for fraca',
      () async {
        // arrange
        final tWeakPassword = '123';
        final tFailure = const WeakPasswordFailure();
        when(() => mockSignUpWithEmailAndPassword(
              any(that: isA<SignUpWithEmailAndPasswordParams>()),
            )).thenAnswer((_) async => Left(tFailure));

        // act
        final result = await viewModel.signUp(tEmail, tWeakPassword);

        // assert
        expect(result, false);
        expect(viewModel.currentUser, isNull);
        expect(
          viewModel.error,
          'A senha fornecida é muito fraca. Tente uma senha mais forte.'
        );
      },
    );
  });

  group('signOut', () {
    test(
      'deve limpar o usuário atual e erros',
      () {
        // arrange
        viewModel = AuthViewModel(
          signInWithEmailAndPassword: mockSignInWithEmailAndPassword,
          signUpWithEmailAndPassword: mockSignUpWithEmailAndPassword,
        );
        
        // Define um usuário atual e um erro
        viewModel.currentUser = tUser;
        viewModel.setError('Algum erro');
        
        // Garante que o usuário e o erro estão definidos
        expect(viewModel.currentUser, isNotNull);
        expect(viewModel.error, isNotNull);
        
        // act
        viewModel.signOut();
        
        // assert
        expect(viewModel.currentUser, isNull);
        expect(viewModel.error, isNull);
      },
    );
  });

  test('clearError deve limpar a mensagem de erro', () {
    // arrange
    viewModel.setError('Algum erro');
    
    // act
    viewModel.clearError();
    
    // assert
    expect(viewModel.error, isNull);
  });

  test('signOut deve limpar o usuário atual', () {
    // arrange
    viewModel.currentUser = tUser;
    
    // Garante que o usuário está definido
    expect(viewModel.currentUser, isNotNull);
    
    // act
    viewModel.signOut();
    
    // assert
    expect(viewModel.currentUser, isNull);
  });
}
