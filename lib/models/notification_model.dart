/// Modelo de notificação para o aplicativo Potea Edu
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String senderId;
  final List<String> recipientIds;
  final String? targetId; // ID da turma, matéria, atividade, etc.
  final DateTime createdAt;
  final DateTime? readAt;
  final bool isRead;
  final NotificationPriority priority;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.senderId,
    required this.recipientIds,
    this.targetId,
    required this.createdAt,
    this.readAt,
    this.isRead = false,
    this.priority = NotificationPriority.normal,
    this.data,
    this.imageUrl,
    this.actionUrl,
  });

  /// Cria uma notificação a partir de um Map (Firestore)
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${map['type']}',
        orElse: () => NotificationType.general,
      ),
      senderId: map['senderId'] ?? '',
      recipientIds: List<String>.from(map['recipientIds'] ?? []),
      targetId: map['targetId'],
      createdAt: DateTime.parse(map['createdAt']),
      readAt: map['readAt'] != null ? DateTime.parse(map['readAt']) : null,
      isRead: map['isRead'] ?? false,
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString() == 'NotificationPriority.${map['priority']}',
        orElse: () => NotificationPriority.normal,
      ),
      data: map['data'],
      imageUrl: map['imageUrl'],
      actionUrl: map['actionUrl'],
    );
  }

  /// Converte a notificação para um Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'senderId': senderId,
      'recipientIds': recipientIds,
      'targetId': targetId,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'isRead': isRead,
      'priority': priority.toString().split('.').last,
      'data': data,
      'imageUrl': imageUrl,
      'actionUrl': actionUrl,
    };
  }

  /// Cria uma cópia da notificação com campos atualizados
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    String? senderId,
    List<String>? recipientIds,
    String? targetId,
    DateTime? createdAt,
    DateTime? readAt,
    bool? isRead,
    NotificationPriority? priority,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      recipientIds: recipientIds ?? this.recipientIds,
      targetId: targetId ?? this.targetId,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      isRead: isRead ?? this.isRead,
      priority: priority ?? this.priority,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }

  /// Marca a notificação como lida
  NotificationModel markAsRead() {
    return copyWith(
      isRead: true,
      readAt: DateTime.now(),
    );
  }

  /// Verifica se a notificação é recente (últimas 24h)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  /// Retorna o tempo relativo da notificação
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
      return 'Agora';
    }
  }

  /// Verifica se a notificação tem imagem
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Verifica se a notificação tem ação
  bool get hasAction => actionUrl != null && actionUrl!.isNotEmpty;

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Tipos de notificação disponíveis
enum NotificationType {
  general,        // Geral
  activity,       // Atividade
  grade,          // Nota
  announcement,   // Anúncio
  reminder,       // Lembrete
  event,          // Evento
  message,        // Mensagem
  system,         // Sistema
}

/// Prioridade da notificação
enum NotificationPriority {
  low,            // Baixa
  normal,         // Normal
  high,           // Alta
  urgent,         // Urgente
}

/// Extensões para facilitar o uso dos enums
extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.general:
        return 'Geral';
      case NotificationType.activity:
        return 'Atividade';
      case NotificationType.grade:
        return 'Nota';
      case NotificationType.announcement:
        return 'Anúncio';
      case NotificationType.reminder:
        return 'Lembrete';
      case NotificationType.event:
        return 'Evento';
      case NotificationType.message:
        return 'Mensagem';
      case NotificationType.system:
        return 'Sistema';
    }
  }




}

extension NotificationPriorityExtension on NotificationPriority {
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Baixa';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.high:
        return 'Alta';
      case NotificationPriority.urgent:
        return 'Urgente';
    }
  }




}

/// Modelo de evento para o calendário
class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String createdBy;
  final List<String> attendees;
  final String? location;
  final EventType type;
  final bool isAllDay;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    this.attendees = const [],
    this.location,
    required this.type,
    this.isAllDay = false,
    this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria um evento a partir de um Map (Firestore)
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      createdBy: map['createdBy'] ?? '',
      attendees: List<String>.from(map['attendees'] ?? []),
      location: map['location'],
      type: EventType.values.firstWhere(
        (e) => e.toString() == 'EventType.${map['type']}',
        orElse: () => EventType.general,
      ),
      isAllDay: map['isAllDay'] ?? false,
      color: map['color'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  /// Converte o evento para um Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdBy': createdBy,
      'attendees': attendees,
      'location': location,
      'type': type.toString().split('.').last,
      'isAllDay': isAllDay,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Verifica se o evento está acontecendo agora
  bool get isHappeningNow {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Verifica se o evento já passou
  bool get isPast => DateTime.now().isAfter(endDate);

  /// Verifica se o evento está no futuro
  bool get isFuture => DateTime.now().isBefore(startDate);

  /// Retorna a duração do evento
  Duration get duration => endDate.difference(startDate);

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, startDate: $startDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Tipos de evento disponíveis
enum EventType {
  general,        // Geral
  exam,           // Prova
  assignment,     // Tarefa
  meeting,        // Reunião
  holiday,        // Feriado
  activity,       // Atividade
  presentation,   // Apresentação
  other,          // Outro
}

/// Extensão para facilitar o uso do tipo de evento
extension EventTypeExtension on EventType {
  String get displayName {
    switch (this) {
      case EventType.general:
        return 'Geral';
      case EventType.exam:
        return 'Prova';
      case EventType.assignment:
        return 'Tarefa';
      case EventType.meeting:
        return 'Reunião';
      case EventType.holiday:
        return 'Feriado';
      case EventType.activity:
        return 'Atividade';
      case EventType.presentation:
        return 'Apresentação';
      case EventType.other:
        return 'Outro';
    }
  }

  // Removido Flutter-specific IconData e Color getters
}

