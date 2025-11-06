import 'package:dartz/dartz.dart';
import 'package:prime_edu/core/errors/failures.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  // Stream para acompanhar mudanças no estado de autenticação
  Stream<UserEntity?> get authStateChanges;
  
  // Obter usuário atual
  UserEntity? get currentUser;
  
  // Cadastrar com email e senha
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  });
  
  // Entrar com email e senha
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  // Entrar com Google
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  
  // Recuperar senha
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  
  // Atualizar perfil do usuário
  Future<Either<Failure, void>> updateProfile({
    String? displayName,
    String? photoUrl,
  });
  
  // Verificar se o email já está em uso
  Future<Either<Failure, bool>> isEmailInUse(String email);
  
  // Atualizar email
  Future<Either<Failure, void>> updateEmail(String newEmail);
  
  // Atualizar senha
  Future<Either<Failure, void>> updatePassword(String newPassword);
  
  // Enviar verificação de email
  Future<Either<Failure, void>> sendEmailVerification();
  
  // Sair
  Future<Either<Failure, void>> signOut();
  
  // Excluir conta
  Future<void> deleteAccount();
}
