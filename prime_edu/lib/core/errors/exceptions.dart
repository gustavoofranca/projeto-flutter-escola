class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class InvalidCredentialsException extends ServerException {
  const InvalidCredentialsException(String message) : super(message);
  
  @override
  String toString() => 'InvalidCredentialsException: $message';
}

class EmailAlreadyInUseException extends ServerException {
  const EmailAlreadyInUseException(String message) : super(message);
  
  @override
  String toString() => 'EmailAlreadyInUseException: $message';
}

class InvalidEmailException extends ServerException {
  const InvalidEmailException(String message) : super(message);
  
  @override
  String toString() => 'InvalidEmailException: $message';
}

class WeakPasswordException extends ServerException {
  const WeakPasswordException(String message) : super(message);
  
  @override
  String toString() => 'WeakPasswordException: $message';
}

class UserNotFoundException extends ServerException {
  const UserNotFoundException(String message) : super(message);
  
  @override
  String toString() => 'UserNotFoundException: $message';
}

class WrongPasswordException extends ServerException {
  const WrongPasswordException(String message) : super(message);
  
  @override
  String toString() => 'WrongPasswordException: $message';
}
