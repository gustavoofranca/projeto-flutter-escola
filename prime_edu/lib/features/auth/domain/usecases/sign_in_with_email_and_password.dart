import 'package:dartz/dartz.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/repositories/auth_repository.dart';
import 'package:prime_edu/features/auth/domain/usecases/usecase.dart';

class SignInWithEmailAndPasswordParams {
  final String email;
  final String password;

  const SignInWithEmailAndPasswordParams({
    required this.email,
    required this.password,
  });
}

class SignInWithEmailAndPassword implements UseCase<UserEntity, SignInWithEmailAndPasswordParams> {
  final AuthRepository repository;

  const SignInWithEmailAndPassword(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInWithEmailAndPasswordParams params) async {
    return await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}
