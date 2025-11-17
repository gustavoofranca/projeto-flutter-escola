import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/core/errors/exceptions.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prime_edu/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tEmail = 'test@example.com';
  final tPassword = 'password123';
  final tUser = UserEntity(
    id: '1',
    email: tEmail,
    name: 'Test User',
    isEmailVerified: true,
  );

  group('signInWithEmailAndPassword', () {
    test(
      'deve retornar UserEntity quando o login for bem-sucedido',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => tUser);

        // act
        final result = await repository.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result, equals(Right(tUser)));
        verify(() => mockRemoteDataSource.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).called(1);
      },
    );

    test(
      'deve retornar ServerFailure quando ServerException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(ServerException(message: 'Erro no servidor'));

        // act
        final result = await repository.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result, equals(Left(ServerFailure(message: 'Erro no servidor'))));
        verify(() => mockRemoteDataSource.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            )).called(1);
      },
    );

    test(
      'deve retornar InvalidCredentialsFailure quando InvalidCredentialsException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(InvalidCredentialsException());

        // act
        final result = await repository.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(
          result,
          equals(Left(InvalidCredentialsFailure('Credenciais inválidas'))),
        );
      },
    );

    test(
      'deve retornar UserNotFoundFailure quando UserNotFoundException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(UserNotFoundException());

        // act
        final result = await repository.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(
          result,
          equals(Left(UserNotFoundFailure('Usuário não encontrado'))),
        );
      },
    );

    test(
      'deve retornar WrongPasswordFailure quando WrongPasswordException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(WrongPasswordException());

        // act
        final result = await repository.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result, equals(Left(WrongPasswordFailure('Senha incorreta'))));
      },
    );
  });

  group('signUpWithEmailAndPassword', () {
    test(
      'deve retornar UserEntity quando o cadastro for bem-sucedido',
      () async {
        // arrange
        final tName = 'Test User';
        when(() => mockRemoteDataSource.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenAnswer((_) async => tUser);

        // act
        final result = await repository.signUpWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
          name: tName,
        );

        // assert
        expect(result, equals(Right(tUser)));
        verify(() => mockRemoteDataSource.signUpWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
              name: tName,
            )).called(1);
      },
    );

    test(
      'deve retornar EmailAlreadyInUseFailure quando EmailAlreadyInUseException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenThrow(EmailAlreadyInUseException());

        // act
        final result = await repository.signUpWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(
          result,
          equals(Left(EmailAlreadyInUseFailure('Email já está em uso'))),
        );
      },
    );

    test(
      'deve retornar InvalidEmailFailure quando InvalidEmailException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenThrow(InvalidEmailException());

        // act
        final result = await repository.signUpWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result, equals(Left(InvalidEmailFailure('Email inválido'))));
      },
    );

    test(
      'deve retornar WeakPasswordFailure quando WeakPasswordException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signUpWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
              name: any(named: 'name'),
            )).thenThrow(WeakPasswordException());

        // act
        final result = await repository.signUpWithEmailAndPassword(
          email: tEmail,
          password: 'weak',
        );

        // assert
        expect(result, equals(Left(WeakPasswordFailure('Senha muito fraca'))));
      },
    );
  });

  group('signInWithGoogle', () {
    test(
      'deve retornar UserEntity quando o login com Google for bem-sucedido',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signInWithGoogle())
            .thenAnswer((_) async => tUser);

        // act
        final result = await repository.signInWithGoogle();

        // assert
        expect(result, equals(Right(tUser)));
        verify(() => mockRemoteDataSource.signInWithGoogle()).called(1);
      },
    );

    test(
      'deve retornar ServerFailure quando ServerException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signInWithGoogle())
            .thenThrow(ServerException(message: 'Erro no servidor'));

        // act
        final result = await repository.signInWithGoogle();

        // assert
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Deveria retornar Left'),
        );
      },
    );
  });

  group('sendPasswordResetEmail', () {
    test(
      'deve retornar Right(null) quando o email de recuperação for enviado com sucesso',
      () async {
        // arrange
        when(() => mockRemoteDataSource.sendPasswordResetEmail(any()))
            .thenAnswer((_) async => Future.value());

        // act
        final result = await repository.sendPasswordResetEmail(tEmail);

        // assert
        expect(result, equals(const Right(null)));
        verify(() => mockRemoteDataSource.sendPasswordResetEmail(tEmail))
            .called(1);
      },
    );

    test(
      'deve retornar ServerFailure quando ServerException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.sendPasswordResetEmail(any()))
            .thenThrow(ServerException(message: 'Erro ao enviar email'));

        // act
        final result = await repository.sendPasswordResetEmail(tEmail);

        // assert
        expect(result, isA<Left>());
      },
    );
  });

  group('signOut', () {
    test(
      'deve retornar Right(null) quando o logout for bem-sucedido',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signOut())
            .thenAnswer((_) async => Future.value());

        // act
        final result = await repository.signOut();

        // assert
        expect(result, equals(const Right(null)));
        verify(() => mockRemoteDataSource.signOut()).called(1);
      },
    );

    test(
      'deve retornar ServerFailure quando ServerException for lançada',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signOut())
            .thenThrow(ServerException(message: 'Erro ao fazer logout'));

        // act
        final result = await repository.signOut();

        // assert
        expect(result, isA<Left>());
      },
    );
  });

  group('currentUser', () {
    test(
      'deve retornar o usuário atual do data source',
      () {
        // arrange
        when(() => mockRemoteDataSource.currentUser).thenReturn(tUser);

        // act
        final result = repository.currentUser;

        // assert
        expect(result, equals(tUser));
        verify(() => mockRemoteDataSource.currentUser).called(1);
      },
    );

    test(
      'deve retornar null quando não houver usuário logado',
      () {
        // arrange
        when(() => mockRemoteDataSource.currentUser).thenReturn(null);

        // act
        final result = repository.currentUser;

        // assert
        expect(result, isNull);
      },
    );
  });
}
