/// Modelo de turma para o aplicativo Potea Edu
class ClassModel {
  final String id;
  final String name;
  final String description;
  final String teacherId;
  final List<String> studentIds;
  final List<String> subjectIds;
  final int maxStudents;
  final String academicYear;
  final String semester;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const ClassModel({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherId,
    this.studentIds = const [],
    this.subjectIds = const [],
    this.maxStudents = 40,
    required this.academicYear,
    required this.semester,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  /// Cria uma turma a partir de um Map (Firestore)
  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      teacherId: map['teacherId'] ?? '',
      studentIds: List<String>.from(map['studentIds'] ?? []),
      subjectIds: List<String>.from(map['subjectIds'] ?? []),
      maxStudents: map['maxStudents'] ?? 40,
      academicYear: map['academicYear'] ?? '',
      semester: map['semester'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  /// Converte a turma para um Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'teacherId': teacherId,
      'studentIds': studentIds,
      'subjectIds': subjectIds,
      'maxStudents': maxStudents,
      'academicYear': academicYear,
      'semester': semester,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Cria uma cópia da turma com campos atualizados
  ClassModel copyWith({
    String? id,
    String? name,
    String? description,
    String? teacherId,
    List<String>? studentIds,
    List<String>? subjectIds,
    int? maxStudents,
    String? academicYear,
    String? semester,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      teacherId: teacherId ?? this.teacherId,
      studentIds: studentIds ?? this.studentIds,
      subjectIds: subjectIds ?? this.subjectIds,
      maxStudents: maxStudents ?? this.maxStudents,
      academicYear: academicYear ?? this.academicYear,
      semester: semester ?? this.semester,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Verifica se a turma está cheia
  bool get isFull => studentIds.length >= maxStudents;

  /// Retorna o número de vagas disponíveis
  int get availableSlots => maxStudents - studentIds.length;

  /// Verifica se a turma está ativa no período atual
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Retorna o status da turma
  String get status {
    if (!isActive) return 'Inativa';
    if (isCurrentlyActive) return 'Ativa';
    if (DateTime.now().isBefore(startDate)) return 'Pendente';
    return 'Encerrada';
  }

  @override
  String toString() {
    return 'ClassModel(id: $id, name: $name, teacherId: $teacherId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClassModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Modelo de matéria/disciplina
class SubjectModel {
  final String id;
  final String name;
  final String description;
  final String classId;
  final String teacherId;
  final int credits;
  final String code;
  final List<String> topics;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.classId,
    required this.teacherId,
    this.credits = 0,
    required this.code,
    this.topics = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  /// Cria uma matéria a partir de um Map (Firestore)
  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      classId: map['classId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      credits: map['credits'] ?? 0,
      code: map['code'] ?? '',
      topics: List<String>.from(map['topics'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  /// Converte a matéria para um Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'classId': classId,
      'teacherId': teacherId,
      'credits': credits,
      'code': code,
      'topics': topics,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return 'SubjectModel(id: $id, name: $name, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubjectModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

