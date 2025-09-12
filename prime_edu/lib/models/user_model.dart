/// Modelo de usuário para o aplicativo Potea Edu
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserType userType;
  final String? photoUrl;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? classId; // Para alunos
  final List<String> subjects; // Para professores
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.photoUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.classId,
    this.subjects = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  /// Cria um usuário a partir de um Map (Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${map['userType']}',
        orElse: () => UserType.student,
      ),
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
      dateOfBirth: map['dateOfBirth'] != null 
          ? DateTime.parse(map['dateOfBirth']) 
          : null,
      gender: map['gender'],
      classId: map['classId'],
      subjects: List<String>.from(map['subjects'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  /// Converte o usuário para um Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userType': userType.toString().split('.').last,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'classId': classId,
      'subjects': subjects,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Cria uma cópia do usuário com campos atualizados
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserType? userType,
    String? photoUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? classId,
    List<String>? subjects,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      classId: classId ?? this.classId,
      subjects: subjects ?? this.subjects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Tipos de usuário disponíveis
enum UserType {
  student,   // Aluno
  teacher,   // Professor
  admin,     // Administrador
}

/// Extensão para facilitar o uso dos tipos de usuário
extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.student:
        return 'Aluno';
      case UserType.teacher:
        return 'Professor';
      case UserType.admin:
        return 'Administrador';
    }
  }

  String get shortName {
    switch (this) {
      case UserType.student:
        return 'Aluno';
      case UserType.teacher:
        return 'Prof';
      case UserType.admin:
        return 'Admin';
    }
  }

  bool get isStudent => this == UserType.student;
  bool get isTeacher => this == UserType.teacher;
  bool get isAdmin => this == UserType.admin;
}

