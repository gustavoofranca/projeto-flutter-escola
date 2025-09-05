import '../models/user_model.dart';

/// Service para gerenciar dados do usuário
class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Mock database with users
  final List<UserModel> _users = [
    UserModel(
      id: 'student_001',
      name: 'João Silva',
      email: 'joao.silva@potea.edu',
      userType: UserType.student,
      phoneNumber: '(11) 99999-0001',
      classId: '3A_2024',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
    ),
    UserModel(
      id: 'student_002',
      name: 'Maria Santos',
      email: 'maria.santos@potea.edu',
      userType: UserType.student,
      phoneNumber: '(11) 99999-0002',
      classId: '3A_2024',
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
      updatedAt: DateTime.now(),
    ),
    UserModel(
      id: 'teacher_001',
      name: 'Prof. Ana Costa',
      email: 'ana.costa@potea.edu',
      userType: UserType.teacher,
      phoneNumber: '(11) 99999-1001',
      subjects: ['Matemática', 'Física'],
      createdAt: DateTime.now().subtract(const Duration(days: 1000)),
      updatedAt: DateTime.now(),
    ),
    UserModel(
      id: 'teacher_002',
      name: 'Prof. Carlos Oliveira',
      email: 'carlos.oliveira@potea.edu',
      userType: UserType.teacher,
      phoneNumber: '(11) 99999-1002',
      subjects: ['História', 'Geografia'],
      createdAt: DateTime.now().subtract(const Duration(days: 800)),
      updatedAt: DateTime.now(),
    ),
    UserModel(
      id: 'admin_001',
      name: 'Dr. Roberto Admin',
      email: 'admin@potea.edu',
      userType: UserType.admin,
      phoneNumber: '(11) 99999-9001',
      createdAt: DateTime.now().subtract(const Duration(days: 2000)),
      updatedAt: DateTime.now(),
    ),
  ];

  /// Get user by ID
  UserModel? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get user by email
  UserModel? getUserByEmail(String email) {
    try {
      return _users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  /// Get all students
  List<UserModel> getStudents() {
    return _users.where((user) => user.userType == UserType.student).toList();
  }

  /// Get all teachers
  List<UserModel> getTeachers() {
    return _users.where((user) => user.userType == UserType.teacher).toList();
  }

  /// Get students by class
  List<UserModel> getStudentsByClass(String classId) {
    return _users
        .where((user) => 
            user.userType == UserType.student && 
            user.classId == classId)
        .toList();
  }

  /// Update user profile
  Future<bool> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API delay
    
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex == -1) return false;

    try {
      final currentUser = _users[userIndex];
      final updatedUser = currentUser.copyWith(
        name: updates['name'] ?? currentUser.name,
        email: updates['email'] ?? currentUser.email,
        phoneNumber: updates['phoneNumber'] ?? currentUser.phoneNumber,
        updatedAt: DateTime.now(),
      );
      
      _users[userIndex] = updatedUser;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get user statistics
  Map<String, dynamic> getUserStats(UserModel user) {
    switch (user.userType) {
      case UserType.student:
        return {
          'totalClasses': 8,
          'completedAssignments': 24,
          'pendingAssignments': 3,
          'averageGrade': 8.5,
          'attendance': 95.2,
          'totalTests': 12,
          'passedTests': 11,
        };

      case UserType.teacher:
        return {
          'totalClasses': 3,
          'totalStudents': _users.where((u) => u.userType == UserType.student).length,
          'totalSubjects': user.subjects.length,
          'totalAnnouncements': 15,
          'averageClassGrade': 7.8,
          'activeAssignments': 5,
        };

      case UserType.admin:
        return {
          'totalStudents': _users.where((u) => u.userType == UserType.student).length,
          'totalTeachers': _users.where((u) => u.userType == UserType.teacher).length,
          'totalClasses': 12,
          'systemUptime': '99.8%',
          'activeUsers': _users.where((u) => u.isActive).length,
          'totalAnnouncements': 45,
        };
    }
  }

  /// Change user password
  Future<bool> changePassword(String userId, String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate API delay
    
    // Mock validation - in real app, you'd verify the old password
    if (oldPassword.length < 6 || newPassword.length < 6) {
      return false;
    }
    
    // In real app, you'd hash and store the new password
    return true;
  }

  /// Upload user avatar
  Future<String?> uploadAvatar(String userId, String imagePath) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate upload delay
    
    // Mock upload - return a fake URL
    return 'https://example.com/avatars/$userId.jpg';
  }

  /// Get user activity log
  List<Map<String, dynamic>> getUserActivity(String userId) {
    final activities = [
      {
        'action': 'Login',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'details': 'Logged in from mobile app',
        'ip': '192.168.1.100',
      },
      {
        'action': 'Profile Update',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'details': 'Updated phone number',
        'ip': '192.168.1.100',
      },
      {
        'action': 'Password Change',
        'timestamp': DateTime.now().subtract(const Duration(days: 7)),
        'details': 'Password changed successfully',
        'ip': '192.168.1.100',
      },
      {
        'action': 'Login',
        'timestamp': DateTime.now().subtract(const Duration(days: 7, hours: 3)),
        'details': 'Logged in from web browser',
        'ip': '192.168.1.101',
      },
      {
        'action': 'Profile View',
        'timestamp': DateTime.now().subtract(const Duration(days: 10)),
        'details': 'Viewed profile page',
        'ip': '192.168.1.100',
      },
    ];

    return activities;
  }
}