import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Estado imutável para autenticação
/// 
/// Usa Freezed para gerar código boilerplate automaticamente:
/// - copyWith() para atualizações imutáveis
/// - Equality (==) e hashCode
/// - toString() para debug
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    /// Indica se uma operação está em andamento
    @Default(false) bool isLoading,
    
    /// Usuário atualmente autenticado
    UserEntity? user,
    
    /// Mensagem de erro, se houver
    String? error,
    
    /// Indica se o usuário está autenticado
    @Default(false) bool isAuthenticated,
  }) = _AuthState;
  
  /// Estado inicial (não autenticado, sem loading, sem erro)
  factory AuthState.initial() => const AuthState();
  
  /// Estado de loading
  factory AuthState.loading() => const AuthState(isLoading: true);
  
  /// Estado autenticado com sucesso
  factory AuthState.authenticated(UserEntity user) => AuthState(
    isAuthenticated: true,
    user: user,
  );
  
  /// Estado com erro
  factory AuthState.error(String message) => AuthState(error: message);
}
