import 'package:prime_edu/features/announcements/domain/entities/announcement_entity.dart';

/// Model de dados para Anúncios
/// 
/// Estende a entidade de domínio e adiciona funcionalidades de serialização.
/// Responsável por converter entre JSON e objetos Dart.
class AnnouncementModel extends AnnouncementEntity {
  const AnnouncementModel({
    required super.id,
    required super.title,
    required super.content,
    required super.teacherId,
    required super.teacherName,
    super.classId,
    super.className,
    required super.priority,
    required super.type,
    required super.createdAt,
    super.updatedAt,
    super.expiresAt,
    super.isActive,
    super.attachmentUrls,
    super.metadata,
  });

  /// Cria um model a partir de uma entidade
  factory AnnouncementModel.fromEntity(AnnouncementEntity entity) {
    return AnnouncementModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      teacherId: entity.teacherId,
      teacherName: entity.teacherName,
      classId: entity.classId,
      className: entity.className,
      priority: entity.priority,
      type: entity.type,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      expiresAt: entity.expiresAt,
      isActive: entity.isActive,
      attachmentUrls: entity.attachmentUrls,
      metadata: entity.metadata,
    );
  }

  /// Converte o model para Map (JSON)
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

  /// Cria model a partir de Map (JSON)
  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      teacherId: map['teacherId'] as String,
      teacherName: map['teacherName'] as String,
      classId: map['classId'] as String?,
      className: map['className'] as String?,
      priority: AnnouncementPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => AnnouncementPriority.medium,
      ),
      type: AnnouncementType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AnnouncementType.geral,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      expiresAt: map['expiresAt'] != null
          ? DateTime.parse(map['expiresAt'] as String)
          : null,
      isActive: map['isActive'] as bool? ?? true,
      attachmentUrls: List<String>.from(map['attachmentUrls'] ?? []),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Cria uma cópia do model com campos atualizados
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
}
