import 'package:equatable/equatable.dart';

/// Entidade de domínio para Anúncios
/// 
/// Representa um anúncio no domínio da aplicação.
/// Esta é a representação pura de negócio, sem dependências de frameworks.
class AnnouncementEntity extends Equatable {
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

  const AnnouncementEntity({
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

  /// Verifica se o anúncio está expirado
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Verifica se o anúncio é válido (ativo e não expirado)
  bool get isValid => isActive && !isExpired;

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        teacherId,
        teacherName,
        classId,
        className,
        priority,
        type,
        createdAt,
        updatedAt,
        expiresAt,
        isActive,
        attachmentUrls,
        metadata,
      ];
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
