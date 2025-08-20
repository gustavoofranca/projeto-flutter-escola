/// Modelo de nota para o aplicativo Potea Edu
class GradeModel {
  final String id;
  final String studentId;
  final String subjectId;
  final String activityId;
  final String classId;
  final double score;
  final int maxScore;
  final String? comments;
  final String gradedBy;
  final DateTime gradedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final GradeStatus status;

  const GradeModel({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.activityId,
    required this.classId,
    required this.score,
    required this.maxScore,
    this.comments,
    required this.gradedBy,
    required this.gradedAt,
    required this.createdAt,
    required this.updatedAt,
    this.status = GradeStatus.graded,
  });

  /// Cria uma nota a partir de um Map (Firestore)
  factory GradeModel.fromMap(Map<String, dynamic> map) {
    return GradeModel(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      subjectId: map['subjectId'] ?? '',
      activityId: map['activityId'] ?? '',
      classId: map['classId'] ?? '',
      score: (map['score'] ?? 0.0).toDouble(),
      maxScore: map['maxScore'] ?? 100,
      comments: map['comments'],
      gradedBy: map['gradedBy'] ?? '',
      gradedAt: DateTime.parse(map['gradedAt']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      status: GradeStatus.values.firstWhere(
        (e) => e.toString() == 'GradeStatus.${map['status']}',
        orElse: () => GradeStatus.graded,
      ),
    );
  }

  /// Converte a nota para um Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'subjectId': subjectId,
      'activityId': activityId,
      'classId': classId,
      'score': score,
      'maxScore': maxScore,
      'comments': comments,
      'gradedBy': gradedBy,
      'gradedAt': gradedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  /// Cria uma cópia da nota com campos atualizados
  GradeModel copyWith({
    String? id,
    String? studentId,
    String? subjectId,
    String? activityId,
    String? classId,
    double? score,
    int? maxScore,
    String? comments,
    String? gradedBy,
    DateTime? gradedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    GradeStatus? status,
  }) {
    return GradeModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      subjectId: subjectId ?? this.subjectId,
      activityId: activityId ?? this.activityId,
      classId: classId ?? this.classId,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      comments: comments ?? this.comments,
      gradedBy: gradedBy ?? this.gradedBy,
      gradedAt: gradedAt ?? this.gradedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  /// Calcula a porcentagem da nota
  double get percentage => (score / maxScore) * 100;

  /// Retorna a nota em formato de letra (A, B, C, D, F)
  String get letterGrade {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }

  /// Verifica se a nota é aprovatória (>= 60%)
  bool get isPassing => percentage >= 60;

  /// Retorna a cor da nota baseada na porcentagem
  Color get gradeColor {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.lightGreen;
    if (percentage >= 70) return Colors.yellow;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  String toString() {
    return 'GradeModel(id: $id, studentId: $studentId, score: $score/$maxScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GradeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Status da nota
enum GradeStatus {
  pending,    // Pendente
  graded,     // Avaliada
  reviewed,   // Revisada
  disputed,   // Contestada
}

/// Extensão para facilitar o uso do status da nota
extension GradeStatusExtension on GradeStatus {
  String get displayName {
    switch (this) {
      case GradeStatus.pending:
        return 'Pendente';
      case GradeStatus.graded:
        return 'Avaliada';
      case GradeStatus.reviewed:
        return 'Revisada';
      case GradeStatus.disputed:
        return 'Contestada';
    }
  }

  Color get color {
    switch (this) {
      case GradeStatus.pending:
        return Colors.orange;
      case GradeStatus.graded:
        return Colors.green;
      case GradeStatus.reviewed:
        return Colors.blue;
      case GradeStatus.disputed:
        return Colors.red;
    }
  }
}

/// Modelo para estatísticas de notas
class GradeStatistics {
  final double averageScore;
  final double highestScore;
  final double lowestScore;
  final int totalGrades;
  final int passingGrades;
  final int failingGrades;
  final Map<String, int> gradeDistribution;

  const GradeStatistics({
    required this.averageScore,
    required this.highestScore,
    required this.lowestScore,
    required this.totalGrades,
    required this.passingGrades,
    required this.failingGrades,
    required this.gradeDistribution,
  });

  /// Calcula a taxa de aprovação
  double get passRate => totalGrades > 0 ? (passingGrades / totalGrades) * 100 : 0;

  /// Calcula a taxa de reprovação
  double get failRate => totalGrades > 0 ? (failingGrades / totalGrades) * 100 : 0;

  /// Retorna o status geral baseado na média
  String get overallStatus {
    if (averageScore >= 90) return 'Excelente';
    if (averageScore >= 80) return 'Bom';
    if (averageScore >= 70) return 'Regular';
    if (averageScore >= 60) return 'Abaixo da Média';
    return 'Precisa Melhorar';
  }

  /// Retorna a cor do status geral
  Color get overallStatusColor {
    if (averageScore >= 90) return Colors.green;
    if (averageScore >= 80) return Colors.lightGreen;
    if (averageScore >= 70) return Colors.yellow;
    if (averageScore >= 60) return Colors.orange;
    return Colors.red;
  }
}

