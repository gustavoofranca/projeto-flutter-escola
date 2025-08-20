/// Modelo de atividade para o aplicativo Potea Edu
class ActivityModel {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final String subjectId;
  final String classId;
  final String createdBy;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> attachments;
  final List<String> assignedStudentIds;
  final ActivityStatus status;
  final int maxScore;
  final String instructions;
  final bool isGroupActivity;

  const ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.subjectId,
    required this.classId,
    required this.createdBy,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.attachments = const [],
    this.assignedStudentIds = const [],
    this.status = ActivityStatus.pending,
    this.maxScore = 100,
    this.instructions = '',
    this.isGroupActivity = false,
  });

  /// Cria uma atividade a partir de um Map (Firestore)
  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: ActivityType.values.firstWhere(
        (e) => e.toString() == 'ActivityType.${map['type']}',
        orElse: () => ActivityType.assignment,
      ),
      subjectId: map['subjectId'] ?? '',
      classId: map['classId'] ?? '',
      createdBy: map['createdBy'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      attachments: List<String>.from(map['attachments'] ?? []),
      assignedStudentIds: List<String>.from(map['assignedStudentIds'] ?? []),
      status: ActivityStatus.values.firstWhere(
        (e) => e.toString() == 'ActivityStatus.${map['status']}',
        orElse: () => ActivityStatus.pending,
      ),
      maxScore: map['maxScore'] ?? 100,
      instructions: map['instructions'] ?? '',
      isGroupActivity: map['isGroupActivity'] ?? false,
    );
  }

  /// Converte a atividade para um Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'subjectId': subjectId,
      'classId': classId,
      'createdBy': createdBy,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'attachments': attachments,
      'assignedStudentIds': assignedStudentIds,
      'status': status.toString().split('.').last,
      'maxScore': maxScore,
      'instructions': instructions,
      'isGroupActivity': isGroupActivity,
    };
  }

  /// Cria uma cópia da atividade com campos atualizados
  ActivityModel copyWith({
    String? id,
    String? title,
    String? description,
    ActivityType? type,
    String? subjectId,
    String? classId,
    String? createdBy,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? attachments,
    List<String>? assignedStudentIds,
    ActivityStatus? status,
    int? maxScore,
    String? instructions,
    bool? isGroupActivity,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      subjectId: subjectId ?? this.subjectId,
      classId: classId ?? this.classId,
      createdBy: createdBy ?? this.createdBy,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachments: attachments ?? this.attachments,
      assignedStudentIds: assignedStudentIds ?? this.assignedStudentIds,
      status: status ?? this.status,
      maxScore: maxScore ?? this.maxScore,
      instructions: instructions ?? this.instructions,
      isGroupActivity: isGroupActivity ?? this.isGroupActivity,
    );
  }

  /// Verifica se a atividade está atrasada
  bool get isOverdue => DateTime.now().isAfter(dueDate) && status != ActivityStatus.completed;

  /// Retorna o tempo restante para entrega
  Duration get timeRemaining => dueDate.difference(DateTime.now());

  /// Verifica se a atividade está próxima do prazo (24h)
  bool get isDueSoon => timeRemaining.inHours <= 24 && timeRemaining.isNegative == false;

  @override
  String toString() {
    return 'ActivityModel(id: $id, title: $title, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Tipos de atividade disponíveis
enum ActivityType {
  assignment,    // Tarefa
  exam,          // Prova
  project,       // Projeto
  presentation,  // Apresentação
  quiz,          // Questionário
  homework,      // Dever de casa
  lab,           // Laboratório
  other,         // Outro
}

/// Status da atividade
enum ActivityStatus {
  pending,       // Pendente
  inProgress,    // Em andamento
  submitted,     // Entregue
  graded,        // Avaliada
  completed,     // Concluída
  cancelled,     // Cancelada
}

/// Extensões para facilitar o uso dos enums
extension ActivityTypeExtension on ActivityType {
  String get displayName {
    switch (this) {
      case ActivityType.assignment:
        return 'Tarefa';
      case ActivityType.exam:
        return 'Prova';
      case ActivityType.project:
        return 'Projeto';
      case ActivityType.presentation:
        return 'Apresentação';
      case ActivityType.quiz:
        return 'Questionário';
      case ActivityType.homework:
        return 'Dever de Casa';
      case ActivityType.lab:
        return 'Laboratório';
      case ActivityType.other:
        return 'Outro';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityType.assignment:
        return Icons.assignment;
      case ActivityType.exam:
        return Icons.quiz;
      case ActivityType.project:
        return Icons.work;
      case ActivityType.presentation:
        return Icons.present_to_all;
      case ActivityType.quiz:
        return Icons.question_answer;
      case ActivityType.homework:
        return Icons.home_work;
      case ActivityType.lab:
        return Icons.science;
      case ActivityType.other:
        return Icons.more_horiz;
    }
  }
}

extension ActivityStatusExtension on ActivityStatus {
  String get displayName {
    switch (this) {
      case ActivityStatus.pending:
        return 'Pendente';
      case ActivityStatus.inProgress:
        return 'Em Andamento';
      case ActivityStatus.submitted:
        return 'Entregue';
      case ActivityStatus.graded:
        return 'Avaliada';
      case ActivityStatus.completed:
        return 'Concluída';
      case ActivityStatus.cancelled:
        return 'Cancelada';
    }
  }

  Color get color {
    switch (this) {
      case ActivityStatus.pending:
        return Colors.orange;
      case ActivityStatus.inProgress:
        return Colors.blue;
      case ActivityStatus.submitted:
        return Colors.purple;
      case ActivityStatus.graded:
        return Colors.green;
      case ActivityStatus.completed:
        return Colors.green;
      case ActivityStatus.cancelled:
        return Colors.red;
    }
  }
}

