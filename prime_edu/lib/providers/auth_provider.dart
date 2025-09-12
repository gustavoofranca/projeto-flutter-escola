import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Provider para gerenciar estado de autenticação
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;
  
  // Verificações de tipo de usuário
  bool get isStudent => _currentUser?.userType == UserType.student;
  bool get isTeacher => _currentUser?.userType == UserType.teacher;
  bool get isAdmin => _currentUser?.userType == UserType.admin;

  /// Inicializa o provider verificando se há usuário logado
  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      
      if (isLoggedIn) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          _setUser(user);
          _isLoggedIn = true;
        }
      }
    } catch (e) {
      _setError('Erro ao inicializar: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Realiza login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.login(email, password);
      
      if (result.isSuccess && result.user != null) {
        _setUser(result.user!);
        _isLoggedIn = true;
        return true;
      } else {
        _setError(result.error ?? 'Erro desconhecido no login');
        return false;
      }
    } catch (e) {
      _setError('Erro de conexão: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Realiza logout
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _authService.logout();
      _clearUser();
      _isLoggedIn = false;
    } catch (e) {
      _setError('Erro ao fazer logout: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Registra novo usuário
  Future<bool> register(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.register(userData);
      
      if (result.isSuccess && result.user != null) {
        _setUser(result.user!);
        _isLoggedIn = true;
        return true;
      } else {
        _setError(result.error ?? 'Erro desconhecido no registro');
        return false;
      }
    } catch (e) {
      _setError('Erro de conexão: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Atualiza dados do usuário
  Future<bool> updateUser(UserModel updatedUser) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.updateUser(updatedUser);
      
      if (result.isSuccess && result.user != null) {
        _setUser(result.user!);
        return true;
      } else {
        _setError(result.error ?? 'Erro ao atualizar usuário');
        return false;
      }
    } catch (e) {
      _setError('Erro de conexão: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Recupera senha
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.resetPassword(email);
      
      if (!success) {
        _setError('Email não encontrado');
      }
      
      return success;
    } catch (e) {
      _setError('Erro de conexão: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Obtém credenciais demo
  Map<String, dynamic> getDemoCredentials(UserType userType) {
    return AuthService.getDemoCredentials(userType);
  }

  /// Login demo com usuário específico
  void loginWithUser(UserModel user) {
    _setUser(user);
    _isLoggedIn = true;
  }

  // Métodos privados
  void _setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void _clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

}