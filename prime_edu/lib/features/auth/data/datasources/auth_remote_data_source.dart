import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';

/// Contrato para a fonte de dados remota de autenticação
/// Data Sources devem lançar exceções em caso de erro, não retornar Either
abstract class AuthRemoteDataSource {
  /// Stream que emite o usuário atual quando o estado de autenticação muda
  Stream<UserEntity?> get authStateChanges;
  
  /// Retorna o usuário atualmente autenticado
  UserEntity? get currentUser;
  
  /// Faz login com email e senha
  /// Lança [ServerException], [InvalidCredentialsException], [UserNotFoundException], etc.
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  /// Cria uma nova conta com email e senha
  /// Lança [EmailAlreadyInUseException], [WeakPasswordException], [InvalidEmailException], etc.
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  });
  
  /// Faz login com o Google
  /// Lança [ServerException] em caso de erro
  Future<UserEntity> signInWithGoogle();
  
  /// Envia um email de redefinição de senha
  /// Lança [ServerException] em caso de erro
  Future<void> sendPasswordResetEmail(String email);
  
  /// Atualiza o perfil do usuário
  /// Lança [ServerException] em caso de erro
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  });
  
  /// Verifica se um email já está em uso
  /// Lança [InvalidEmailException], [ServerException] em caso de erro
  Future<bool> isEmailInUse(String email);
  
  /// Atualiza o email do usuário
  /// Lança [ServerException] em caso de erro
  Future<void> updateEmail(String newEmail);
  
  /// Atualiza a senha do usuário
  /// Lança [ServerException] em caso de erro
  Future<void> updatePassword(String newPassword);
  
  /// Envia um email de verificação
  /// Lança [ServerException] em caso de erro
  Future<void> sendEmailVerification();
  
  /// Faz logout do usuário atual
  /// Lança [ServerException] em caso de erro
  Future<void> signOut();
  
  /// Exclui a conta do usuário atual
  /// Lança [ServerException] em caso de erro
  Future<void> deleteAccount();
}
