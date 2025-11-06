import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Falhas de autenticação
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([String message = 'Credenciais inválidas']) : super(message);
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure([String message = 'Email já está em uso']) : super(message);
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure([String message = 'Email inválido']) : super(message);
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure([String message = 'Senha muito fraca']) : super(message);
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure([String message = 'Usuário não encontrado']) : super(message);
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure([String message = 'Senha incorreta']) : super(message);
}

// Falhas de servidor
class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message);
}

// Falhas de rede
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

// Falhas de cache
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message);
}
// Adicione mais tipos de falhas conforme necessário
