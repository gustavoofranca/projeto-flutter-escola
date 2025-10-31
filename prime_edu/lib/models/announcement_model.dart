import 'package:flutter/material.dart';

/// Modelo para avisos/anúncios de professores para alunos
class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String teacherId;
  final String teacherName;
  final String? classId;
  final String? className;
  final AnnouncementPriority priority;
  final AnnouncementType type;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;
  final bool isActive;
  final List<String> attachmentUrls;
  final Map<String, dynamic>? metadata;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.teacherId,
    required this.teacherName,
    this.classId,
    this.className,
    required this.priority,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.expiresAt,
    this.isActive = true,
    this.attachmentUrls = const [],
    this.metadata,
  });

  /// Cria uma cópia do modelo com campos atualizados
  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
    String? teacherId,
    String? teacherName,
    String? classId,
    String? className,
    AnnouncementPriority? priority,
    AnnouncementType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expiresAt,
    bool? isActive,
    List<String>? attachmentUrls,
    Map<String, dynamic>? metadata,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      priority: priority ?? this.priority,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converte o modelo para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'classId': classId,
      'className': className,
      'priority': priority.name,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'attachmentUrls': attachmentUrls,
      'metadata': metadata,
    };
  }

  /// Cria modelo a partir de Map
  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      teacherId: map['teacherId'],
      teacherName: map['teacherName'],
      classId: map['classId'],
      className: map['className'],
      priority: AnnouncementPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => AnnouncementPriority.medium,
      ),
      type: AnnouncementType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AnnouncementType.geral,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      expiresAt: map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
      isActive: map['isActive'] ?? true,
      attachmentUrls: List<String>.from(map['attachmentUrls'] ?? []),
      metadata: map['metadata'],
    );
  }

  @override
  String toString() {
    return 'AnnouncementModel(id: $id, title: $title, teacherName: $teacherName, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnnouncementModel && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  /// Verifica se o anúncio está expirado
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Verifica se o anúncio é válido (ativo e não expirado)
  bool get isValid {
    return isActive && !isExpired;
  }

  /// Obtém a cor baseada na prioridade
  Color get priorityColor {
    switch (priority) {
      case AnnouncementPriority.low:
        return Colors.green;
      case AnnouncementPriority.medium:
        return Colors.orange;
      case AnnouncementPriority.high:
        return Colors.red;
      case AnnouncementPriority.urgent:
        return Colors.purple;
    }
  }

  /// Obtém o ícone baseado no tipo
  IconData get typeIcon {
    switch (type) {
      case AnnouncementType.geral:
        return Icons.announcement;
      case AnnouncementType.tarefa:
        return Icons.assignment;
      case AnnouncementType.prova:
        return Icons.quiz;
      case AnnouncementType.evento:
        return Icons.event;
      case AnnouncementType.lembrete:
        return Icons.access_time;
      case AnnouncementType.urgente:
        return Icons.priority_high;
    }
  }

  /// Formata o tempo relativo
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m atrás';
    } else {
      return 'agora';
    }
  }
}

/// Prioridade do anúncio
enum AnnouncementPriority {
  low,
  medium,
  high,
  urgent,
}

/// Tipo do anúncio
enum AnnouncementType {
  geral,
  tarefa,
  prova,
  evento,
  lembrete,
  urgente,
}

/// Extensões para facilitar o uso
extension AnnouncementPriorityExtension on AnnouncementPriority {
  String get displayName {
    switch (this) {
      case AnnouncementPriority.low:
        return 'Baixa';
      case AnnouncementPriority.medium:
        return 'Média';
      case AnnouncementPriority.high:
        return 'Alta';
      case AnnouncementPriority.urgent:
        return 'Urgente';
    }
  }
}

extension AnnouncementTypeExtension on AnnouncementType {
  String get displayName {
    switch (this) {
      case AnnouncementType.geral:
        return 'Geral';
      case AnnouncementType.tarefa:
        return 'Tarefa';
      case AnnouncementType.prova:
        return 'Prova';
      case AnnouncementType.evento:
        return 'Evento';
      case AnnouncementType.lembrete:
        return 'Lembrete';
      case AnnouncementType.urgente:
        return 'Urgente';
    }
  }
}