import 'package:dartz/dartz.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/repositories/auth_repository.dart';
import 'package:prime_edu/features/auth/domain/usecases/usecase.dart';

class SignUpWithEmailAndPasswordParams {
  final String email;
  final String password;
  final String? name;

  SignUpWithEmailAndPasswordParams({
    required this.email,
    required this.password,
    this.name,
  });
}

class SignUpWithEmailAndPassword implements UseCase<UserEntity, SignUpWithEmailAndPasswordParams> {
  final AuthRepository repository;

  const SignUpWithEmailAndPassword(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpWithEmailAndPasswordParams params) async {
    return await repository.signUpWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}
