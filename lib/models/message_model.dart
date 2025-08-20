import 'package:flutter/material.dart';

/// Modelo de mensagem para o chat interno do aplicativo Potea Edu
class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? attachmentUrl;
  final String? attachmentName;
  final MessageStatus status;
  final String? replyToId;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.attachmentUrl,
    this.attachmentName,
    this.status = MessageStatus.sent,
    this.replyToId,
  });

  /// Cria uma mensagem a partir de um Map (Firestore)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${map['type']}',
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'] ?? false,
      attachmentUrl: map['attachmentUrl'],
      attachmentName: map['attachmentName'],
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == 'MessageStatus.${map['status']}',
        orElse: () => MessageStatus.sent,
      ),
      replyToId: map['replyToId'],
    );
  }

  /// Converte a mensagem para um Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'attachmentUrl': attachmentUrl,
      'attachmentName': attachmentName,
      'status': status.toString().split('.').last,
      'replyToId': replyToId,
    };
  }

  /// Cria uma cópia da mensagem com campos atualizados
  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isRead,
    String? attachmentUrl,
    String? attachmentName,
    MessageStatus? status,
    String? replyToId,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentName: attachmentName ?? this.attachmentName,
      status: status ?? this.status,
      replyToId: replyToId ?? this.replyToId,
    );
  }

  /// Verifica se a mensagem é recente (últimas 24h)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inHours < 24;
  }

  /// Retorna o tempo relativo da mensagem
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

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

  /// Verifica se a mensagem tem anexo
  bool get hasAttachment => attachmentUrl != null && attachmentUrl!.isNotEmpty;

  @override
  String toString() {
    return 'MessageModel(id: $id, senderId: $senderId, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Tipos de mensagem disponíveis
enum MessageType {
  text,         // Texto simples
  image,        // Imagem
  document,     // Documento
  audio,        // Áudio
  video,        // Vídeo
  location,     // Localização
  contact,      // Contato
  system,       // Mensagem do sistema
}

/// Status da mensagem
enum MessageStatus {
  sending,      // Enviando
  sent,         // Enviada
  delivered,    // Entregue
  read,         // Lida
  failed,       // Falhou
}

/// Extensões para facilitar o uso dos enums
extension MessageTypeExtension on MessageType {
  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'Texto';
      case MessageType.image:
        return 'Imagem';
      case MessageType.document:
        return 'Documento';
      case MessageType.audio:
        return 'Áudio';
      case MessageType.video:
        return 'Vídeo';
      case MessageType.location:
        return 'Localização';
      case MessageType.contact:
        return 'Contato';
      case MessageType.system:
        return 'Sistema';
    }
  }

  IconData get icon {
    switch (this) {
      case MessageType.text:
        return Icons.text_fields;
      case MessageType.image:
        return Icons.image;
      case MessageType.document:
        return Icons.description;
      case MessageType.audio:
        return Icons.audiotrack;
      case MessageType.video:
        return Icons.videocam;
      case MessageType.location:
        return Icons.location_on;
      case MessageType.contact:
        return Icons.contact_phone;
      case MessageType.system:
        return Icons.info;
    }
  }
}

extension MessageStatusExtension on MessageStatus {
  String get displayName {
    switch (this) {
      case MessageStatus.sending:
        return 'Enviando...';
      case MessageStatus.sent:
        return 'Enviada';
      case MessageStatus.delivered:
        return 'Entregue';
      case MessageStatus.read:
        return 'Lida';
      case MessageStatus.failed:
        return 'Falhou';
    }
  }

  Color get color {
    switch (this) {
      case MessageStatus.sending:
        return Colors.orange;
      case MessageStatus.sent:
        return Colors.grey;
      case MessageStatus.delivered:
        return Colors.blue;
      case MessageStatus.read:
        return Colors.green;
      case MessageStatus.failed:
        return Colors.red;
    }
  }
}

/// Modelo de conversa para organizar mensagens
class ConversationModel {
  final String id;
  final List<String> participantIds;
  final String lastMessageId;
  final String lastMessageContent;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isGroupChat;
  final String? groupName;
  final String? groupAvatar;

  const ConversationModel({
    required this.id,
    required this.participantIds,
    required this.lastMessageId,
    required this.lastMessageContent,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isGroupChat = false,
    this.groupName,
    this.groupAvatar,
  });

  /// Cria uma conversa a partir de um Map (Firestore)
  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      id: map['id'] ?? '',
      participantIds: List<String>.from(map['participantIds'] ?? []),
      lastMessageId: map['lastMessageId'] ?? '',
      lastMessageContent: map['lastMessageContent'] ?? '',
      lastMessageTime: DateTime.parse(map['lastMessageTime']),
      unreadCount: map['unreadCount'] ?? 0,
      isGroupChat: map['isGroupChat'] ?? false,
      groupName: map['groupName'],
      groupAvatar: map['groupAvatar'],
    );
  }

  /// Converte a conversa para um Map (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantIds': participantIds,
      'lastMessageId': lastMessageId,
      'lastMessageContent': lastMessageContent,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
      'isGroupChat': isGroupChat,
      'groupName': groupName,
      'groupAvatar': groupAvatar,
    };
  }

  /// Verifica se a conversa tem mensagens não lidas
  bool get hasUnreadMessages => unreadCount > 0;

  /// Retorna o tempo relativo da última mensagem
  String get lastMessageTimeAgo {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

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
}

