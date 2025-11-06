import 'package:dartz/dartz.dart';
import 'package:prime_edu/core/errors/exceptions.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges;
  }

  @override
  UserEntity? get currentUser => remoteDataSource.currentUser;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Se chegou aqui, o login foi bem-sucedido
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on InvalidCredentialsException {
      return Left(InvalidCredentialsFailure('Credenciais inválidas'));
    } on UserNotFoundException {
      return Left(UserNotFoundFailure('Usuário não encontrado'));
    } on WrongPasswordException {
      return Left(WrongPasswordFailure('Senha incorreta'));
    } on EmailAlreadyInUseException {
      return Left(EmailAlreadyInUseFailure('Email já está em uso'));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      // Se chegou aqui, o cadastro foi bem-sucedido
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on EmailAlreadyInUseException {
      return Left(EmailAlreadyInUseFailure('Email já está em uso'));
    } on InvalidEmailException {
      return Left(InvalidEmailFailure('Email inválido'));
    } on WeakPasswordException {
      return Left(WeakPasswordFailure('Senha muito fraca'));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      await remoteDataSource.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado'));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailInUse(String email) async {
    try {
      final isInUse = await remoteDataSource.isEmailInUse(email);
      return Right(isInUse);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on InvalidEmailException {
      return Left(InvalidEmailFailure('Email inválido'));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmail(String newEmail) async {
    try {
      await remoteDataSource.updateEmail(newEmail);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(String newPassword) async {
    try {
      await remoteDataSource.updatePassword(newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado'));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocorreu um erro inesperado'));
    }
  }

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount();
  }
}
