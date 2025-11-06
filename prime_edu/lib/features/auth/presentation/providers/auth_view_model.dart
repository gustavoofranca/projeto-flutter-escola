import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_up_with_email_and_password.dart';

class AuthViewModel with ChangeNotifier {
  final SignInWithEmailAndPassword signInWithEmailAndPassword;
  final SignUpWithEmailAndPassword signUpWithEmailAndPassword;
  
  bool _isLoading = false;
  String? _error;
  UserEntity? _currentUser;
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  UserEntity? get currentUser => _currentUser;
  
  // Setters para testes
  set currentUser(UserEntity? user) {
    _currentUser = user;
    notifyListeners();
  }
  
  AuthViewModel({
    required this.signInWithEmailAndPassword,
    required this.signUpWithEmailAndPassword,
  });
  
  // Método para login com email e senha
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await signInWithEmailAndPassword(
      SignInWithEmailAndPasswordParams(
        email: email,
        password: password,
      ),
    );
    
    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
  
  // Método para cadastro com email e senha
  Future<bool> signUp(String email, String password, {String? name}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    final result = await signUpWithEmailAndPassword(
      SignUpWithEmailAndPasswordParams(
        email: email,
        password: password,
        name: name,
      ),
    );
    
    return result.fold(
      (failure) {
        _error = _mapFailureToMessage(failure);
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }
  
  // Método para sair
  void signOut() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }
  
  // Definir mensagem de erro
  void setError(String message) {
    _error = message;
    notifyListeners();
  }
  
  // Limpar erros
  void clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Mapeia falhas para mensagens amigáveis
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is InvalidCredentialsFailure) {
      return 'Credenciais inválidas. Verifique seu email e senha.';
    } else if (failure is EmailAlreadyInUseFailure) {
      return 'Este email já está em uso. Tente fazer login ou use outro email.';
    } else if (failure is InvalidEmailFailure) {
      return 'O email fornecido é inválido.';
    } else if (failure is WeakPasswordFailure) {
      return 'A senha fornecida é muito fraca. Tente uma senha mais forte.';
    } else if (failure is UserNotFoundFailure) {
      return 'Nenhum usuário encontrado com este email.';
    } else if (failure is WrongPasswordFailure) {
      return 'Senha incorreta. Tente novamente.';
    } else {
      return 'Ocorreu um erro inesperado. Tente novamente mais tarde.';
    }
  }
}
