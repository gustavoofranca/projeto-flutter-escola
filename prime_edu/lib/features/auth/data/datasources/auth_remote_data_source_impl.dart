import 'dart:async';
import 'package:prime_edu/core/errors/exceptions.dart';
import 'package:prime_edu/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prime_edu/features/auth/data/models/user_model.dart';
import 'package:prime_edu/features/auth/domain/entities/user_entity.dart';

/// Implementação de exemplo da fonte de dados remota de autenticação
/// Esta é uma implementação simulada que pode ser substituída por uma implementação real
/// que se conecta a um serviço como Firebase Auth, Supabase, etc.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Simula um usuário em memória para fins de demonstração
  UserEntity? _currentUser;
  final StreamController<UserEntity?> _authStateController = 
      StreamController<UserEntity?>.broadcast();

  @override
  Stream<UserEntity?> get authStateChanges => _authStateController.stream;

  @override
  UserEntity? get currentUser => _currentUser;

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Simula uma chamada de rede
      await Future.delayed(const Duration(seconds: 1));
      
      // Validações
      if (email.isEmpty) {
        throw const InvalidEmailException('Email não pode estar vazio');
      }
      
      if (!email.contains('@')) {
        throw const InvalidEmailException('Email inválido');
      }
      
      if (password.isEmpty) {
        throw const InvalidCredentialsException('Senha não pode estar vazia');
      }
      
      if (password.length < 6) {
        throw const WeakPasswordException('A senha deve ter pelo menos 6 caracteres');
      }
      
      // Simula um usuário autenticado
      _currentUser = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: email.split('@').first,
        isEmailVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _authStateController.add(_currentUser);
      return _currentUser!;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // Simula uma chamada de rede
      await Future.delayed(const Duration(seconds: 1));
      
      // Validações
      if (email.isEmpty) {
        throw const InvalidEmailException('Email não pode estar vazio');
      }
      
      if (!email.contains('@')) {
        throw const InvalidEmailException('Email inválido');
      }
      
      if (password.isEmpty) {
        throw const InvalidCredentialsException('Senha não pode estar vazia');
      }
      
      if (password.length < 6) {
        throw const WeakPasswordException('A senha deve ter pelo menos 6 caracteres');
      }
      
      // Verifica se o email já está em uso (simulação)
      if (email == 'existente@teste.com') {
        throw const EmailAlreadyInUseException('Email já está em uso');
      }
      
      // Simula a criação de um novo usuário
      _currentUser = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name ?? email.split('@').first,
        isEmailVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _authStateController.add(_currentUser);
      return _currentUser!;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      // Implementação simulada do login com Google
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = UserModel(
        id: 'google-user-${DateTime.now().millisecondsSinceEpoch}',
        email: 'user${DateTime.now().millisecondsSinceEpoch}@example.com',
        name: 'Google User',
        isEmailVerified: true,
        photoUrl: 'https://via.placeholder.com/150',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _authStateController.add(_currentUser);
      return _currentUser!;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Simula uma chamada de rede
      await Future.delayed(const Duration(seconds: 1));
      
      if (email.isEmpty) {
        throw const InvalidEmailException('Email é obrigatório');
      }
      
      if (!email.contains('@')) {
        throw const InvalidEmailException('Email inválido');
      }
      
      // Em um ambiente real, isso enviaria um email de redefinição de senha
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      if (_currentUser == null) {
        throw const ServerException('Nenhum usuário autenticado');
      }
      
      // Simula uma atualização de perfil
      await Future.delayed(const Duration(milliseconds: 500));
      
      _currentUser = (_currentUser as UserModel).copyWith(
        name: displayName ?? _currentUser!.name,
        photoUrl: photoUrl ?? _currentUser!.photoUrl,
      );
      
      _authStateController.add(_currentUser);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isEmailInUse(String email) async {
    try {
      // Validação de email
      if (email.isEmpty) {
        throw const InvalidEmailException('Email não pode estar vazio');
      }
      
      if (!email.contains('@')) {
        throw const InvalidEmailException('Email inválido');
      }
      
      // Simula uma verificação de email em uso
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Em um ambiente real, isso verificaria no banco de dados
      // Para fins de demonstração, considera que o email 'existente@teste.com' já está em uso
      final isInUse = email == 'existente@teste.com';
      return isInUse;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    try {
      if (_currentUser == null) {
        throw const ServerException('Nenhum usuário autenticado');
      }
      
      if (newEmail.isEmpty) {
        throw const InvalidEmailException('Novo email é obrigatório');
      }
      
      if (!newEmail.contains('@')) {
        throw const InvalidEmailException('Email inválido');
      }
      
      // Verifica se o novo email já está em uso
      final emailInUse = await isEmailInUse(newEmail);
      
      if (emailInUse) {
        throw const EmailAlreadyInUseException('Email já está em uso');
      }
      
      // Simula uma atualização de email
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = (_currentUser as UserModel).copyWith(
        email: newEmail,
        isEmailVerified: false, // O email precisa ser verificado novamente
      );
      
      _authStateController.add(_currentUser);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      // Simula uma chamada de rede
      await Future.delayed(const Duration(seconds: 1));
      
      if (_currentUser == null) {
        throw const ServerException('Nenhum usuário autenticado');
      }
      
      if (newPassword.isEmpty) {
        throw const ServerException('Nova senha é obrigatória');
      }
      
      // Em um ambiente real, a senha seria atualizada no servidor
      _currentUser = (_currentUser as UserModel).copyWith(
        updatedAt: DateTime.now(),
      );
      
      _authStateController.add(_currentUser);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      if (_currentUser == null) {
        throw const ServerException('Nenhum usuário autenticado');
      }
      
      // Simula o envio de um email de verificação
      await Future.delayed(const Duration(seconds: 1));
      
      // Em um ambiente real, isso enviaria um email de verificação
      _currentUser = (_currentUser as UserModel).copyWith(
        isEmailVerified: true, // Simula que o email foi verificado
        updatedAt: DateTime.now(),
      );
      
      _authStateController.add(_currentUser);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Simula um logout
      await Future.delayed(const Duration(milliseconds: 300));
      
      _currentUser = null;
      _authStateController.add(null);
    } catch (e) {
      throw ServerException('Falha ao fazer logout');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      if (_currentUser == null) {
        throw const ServerException('Nenhum usuário autenticado');
      }
      
      // Simula a exclusão da conta
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = null;
      _authStateController.add(null);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  // Método para limpar recursos
  void dispose() {
    _authStateController.close();
  }
}
