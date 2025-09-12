import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Serviço de autenticação fictício para demonstração
class AuthService {
  static const String _keyUserId = 'user_id';
  static const String _keyUserType = 'user_type';
  static const String _keyIsLoggedIn = 'is_logged_in';
  
  // Usuários fictícios para demonstração
  static final Map<String, Map<String, dynamic>> _users = {
    'joao@aluno.com': {
      'id': '1',
      'password': '123456',
      'name': 'João Silva',
      'email': 'joao@aluno.com',
      'userType': 'student',
      'studentId': 'ALU001',
      'classId': '3A',
      'grade': '3º Ano',
      'avatar': null,
      'phone': '(11) 99999-9999',
      'birthDate': '2005-03-15',
      'address': 'São Paulo, SP',
    },
    'maria@aluna.com': {
      'id': '2',
      'password': '123456',
      'name': 'Maria Santos',
      'email': 'maria@aluna.com',
      'userType': 'student',
      'studentId': 'ALU002',
      'classId': '3B',
      'grade': '3º Ano',
      'avatar': null,
      'phone': '(11) 98888-8888',
      'birthDate': '2005-07-22',
      'address': 'São Paulo, SP',
    },
    'prof.silva@escola.com': {
      'id': '3',
      'password': '123456',
      'name': 'Prof. Ana Silva',
      'email': 'prof.silva@escola.com',
      'userType': 'teacher',
      'teacherId': 'PROF001',
      'subjects': ['Matemática', 'Física'],
      'classes': ['3A', '3B', '2A'],
      'avatar': null,
      'phone': '(11) 97777-7777',
      'department': 'Exatas',
    },
    'prof.santos@escola.com': {
      'id': '4',
      'password': '123456',
      'name': 'Prof. Carlos Santos',
      'email': 'prof.santos@escola.com',
      'userType': 'teacher',
      'teacherId': 'PROF002',
      'subjects': ['História', 'Geografia'],
      'classes': ['3A', '3C'],
      'avatar': null,
      'phone': '(11) 96666-6666',
      'department': 'Humanas',
    },
    'admin@escola.com': {
      'id': '5',
      'password': 'admin123',
      'name': 'Administrador',
      'email': 'admin@escola.com',
      'userType': 'admin',
      'avatar': null,
      'phone': '(11) 95555-5555',
      'department': 'Administração',
    },
  };

  /// Realiza login fictício
  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula delay da rede

    final user = _users[email.toLowerCase()];
    
    if (user == null) {
      return AuthResult.error('Email não encontrado');
    }
    
    if (user['password'] != password) {
      return AuthResult.error('Senha incorreta');
    }

    // Salva dados do login
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, user['id']);
    await prefs.setString(_keyUserType, user['userType']);
    await prefs.setBool(_keyIsLoggedIn, true);

    final userModel = UserModel.fromMap(user);
    return AuthResult.success(userModel);
  }

  /// Realiza logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserType);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  /// Verifica se usuário está logado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Obtém usuário atual
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_keyUserId);
    
    if (userId == null) return null;

    // Busca usuário pelo ID
    for (final userData in _users.values) {
      if (userData['id'] == userId) {
        return UserModel.fromMap(userData);
      }
    }
    
    return null;
  }

  /// Registra novo usuário (funcionalidade limitada)
  Future<AuthResult> register(Map<String, dynamic> userData) async {
    await Future.delayed(const Duration(seconds: 2)); // Simula delay da rede

    final email = userData['email']?.toLowerCase();
    
    if (_users.containsKey(email)) {
      return AuthResult.error('Email já cadastrado');
    }

    // Em um app real, isso seria salvo no banco de dados
    final newUserId = (DateTime.now().millisecondsSinceEpoch).toString();
    userData['id'] = newUserId;
    userData['userType'] = 'student'; // Default para aluno
    
    _users[email] = userData;

    final userModel = UserModel.fromMap(userData);
    return AuthResult.success(userModel);
  }

  /// Recupera senha (funcionalidade fictícia)
  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simula verificação se email existe
    return _users.containsKey(email.toLowerCase());
  }

  /// Atualiza dados do usuário
  Future<AuthResult> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Atualiza no "banco de dados" fictício
    final userData = user.toMap();
    _users[user.email] = userData;

    return AuthResult.success(user);
  }

  /// Lista todos os usuários (apenas para admin)
  Future<List<UserModel>> getAllUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _users.values
        .map((userData) => UserModel.fromMap(userData))
        .toList();
  }

  /// Lista usuários por tipo
  Future<List<UserModel>> getUsersByType(UserType type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _users.values
        .where((userData) => userData['userType'] == type.name)
        .map((userData) => UserModel.fromMap(userData))
        .toList();
  }

  /// Obtém dados fictícios para demo
  static Map<String, dynamic> getDemoCredentials(UserType userType) {
    switch (userType) {
      case UserType.student:
        return {
          'email': 'joao@aluno.com',
          'password': '123456',
          'name': 'João Silva (Aluno)',
        };
      case UserType.teacher:
        return {
          'email': 'prof.silva@escola.com',
          'password': '123456',
          'name': 'Prof. Ana Silva (Professor)',
        };
      case UserType.admin:
        return {
          'email': 'admin@escola.com',
          'password': 'admin123',
          'name': 'Administrador',
        };
    }
  }
}

/// Resultado da operação de autenticação
class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? error;

  AuthResult._(this.isSuccess, this.user, this.error);

  factory AuthResult.success(UserModel user) {
    return AuthResult._(true, user, null);
  }

  factory AuthResult.error(String error) {
    return AuthResult._(false, null, error);
  }
}