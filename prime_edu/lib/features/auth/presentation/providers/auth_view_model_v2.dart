import 'package:flutter/foundation.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:prime_edu/features/auth/domain/usecases/sign_up_with_email_and_password.dart';
import 'package:prime_edu/features/auth/presentation/state/auth_state.dart';

/// ViewModel aprimorado para autenticação usando estado imutável
/// 
/// Implementa o padrão MVVM com Clean Architecture:
/// - Estado imutável (AuthState com Freezed)
/// - Separação de responsabilidades
/// - Testabilidade aprimorada
/// - Melhor rastreamento de mudanças de estado
class AuthViewModelV2 extends ChangeNotifier {
  final SignInWithEmailAndPassword _signInUseCase;
  final SignUpWithEmailAndPassword _signUpUseCase;
  
  // Estado privado imutável
  AuthState _state = AuthState.initial();
  
  // Getter público para o estado
  AuthState get state => _state;
  
  // Getters de conveniência (mantém compatibilidade com código existente)
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  UserEntity? get currentUser => _state.user;
  bool get isAuthenticated => _state.isAuthenticated;
  
  AuthViewModelV2({
    required SignInWithEmailAndPassword signInUseCase,
    required SignUpWithEmailAndPassword signUpUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase;
  
  /// Atualiza o estado de forma imutável
  void _updateState(AuthState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
      
      // Log para debug (pode ser removido em produção)
      if (kDebugMode) {
        debugPrint('[AuthViewModel] State updated: ${newState.toString()}');
      }
    }
  }
  
  /// Realiza login com email e senha
  /// 
  /// Retorna [true] se o login foi bem-sucedido, [false] caso contrário.
  Future<bool> signIn(String email, String password) async {
    // Inicia loading
    _updateState(_state.copyWith(
      isLoading: true,
      error: null,
    ));
    
    try {
      final result = await _signInUseCase(
        SignInWithEmailAndPasswordParams(
          email: email,
          password: password,
        ),
      );
      
      return result.fold(
        (failure) {
          // Atualiza estado com erro
          _updateState(_state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
            isAuthenticated: false,
          ));
          return false;
        },
        (user) {
          // Atualiza estado com sucesso
          _updateState(_state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            error: null,
          ));
          return true;
        },
      );
    } catch (e) {
      // Captura erros inesperados
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Erro inesperado: ${e.toString()}',
        isAuthenticated: false,
      ));
      return false;
    }
  }
  
  /// Realiza cadastro com email e senha
  /// 
  /// Retorna [true] se o cadastro foi bem-sucedido, [false] caso contrário.
  Future<bool> signUp(String email, String password, {String? name}) async {
    // Inicia loading
    _updateState(_state.copyWith(
      isLoading: true,
      error: null,
    ));
    
    try {
      final result = await _signUpUseCase(
        SignUpWithEmailAndPasswordParams(
          email: email,
          password: password,
          name: name,
        ),
      );
      
      return result.fold(
        (failure) {
          // Atualiza estado com erro
          _updateState(_state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
            isAuthenticated: false,
          ));
          return false;
        },
        (user) {
          // Atualiza estado com sucesso
          _updateState(_state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            error: null,
          ));
          return true;
        },
      );
    } catch (e) {
      // Captura erros inesperados
      _updateState(_state.copyWith(
        isLoading: false,
        error: 'Erro inesperado: ${e.toString()}',
        isAuthenticated: false,
      ));
      return false;
    }
  }
  
  /// Realiza logout do usuário
  void signOut() {
    _updateState(AuthState.initial());
  }
  
  /// Define uma mensagem de erro manualmente
  void setError(String message) {
    _updateState(_state.copyWith(error: message));
  }
  
  /// Limpa a mensagem de erro
  void clearError() {
    _updateState(_state.copyWith(error: null));
  }
  
  /// Define o usuário atual (útil para testes)
  set currentUser(UserEntity? user) {
    _updateState(_state.copyWith(
      user: user,
      isAuthenticated: user != null,
    ));
  }
  
  /// Mapeia falhas para mensagens amigáveis ao usuário
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
  
  @override
  void dispose() {
    if (kDebugMode) {
      debugPrint('[AuthViewModel] Disposed');
    }
    super.dispose();
  }
}
