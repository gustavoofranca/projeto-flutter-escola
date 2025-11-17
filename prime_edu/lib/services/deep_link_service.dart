import 'package:flutter/foundation.dart';

/// Serviço de Deep Linking
/// 
/// Gerencia navegação via URLs profundas:
/// - primeedu://announcement/123 - Abre aviso específico
/// - primeedu://class/456 - Abre aula específica
/// - primeedu://profile - Abre perfil do usuário
/// - primeedu://materials/book/789 - Abre livro específico
/// 
/// Suporta também URLs web:
/// - https://primeedu.com/announcement/123
/// - https://primeedu.com/class/456
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  /// Callback para navegação
  Function(DeepLinkData)? _navigationCallback;

  /// Define o callback de navegação
  void setNavigationCallback(Function(DeepLinkData) callback) {
    _navigationCallback = callback;
  }

  /// Processa um deep link
  Future<void> handleDeepLink(String url) async {
    try {
      final linkData = parseDeepLink(url);
      
      if (linkData != null) {
        if (kDebugMode) {
          debugPrint('[DeepLink] Processando: ${linkData.type} - ${linkData.id}');
        }

        _navigationCallback?.call(linkData);
      } else {
        if (kDebugMode) {
          debugPrint('[DeepLink] URL inválida: $url');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[DeepLink] Erro ao processar: $e');
      }
    }
  }

  /// Faz parsing de um deep link
  DeepLinkData? parseDeepLink(String url) {
    try {
      final uri = Uri.parse(url);
      
      // Suporta esquemas: primeedu:// e https://primeedu.com
      if (uri.scheme != 'primeedu' && 
          !(uri.scheme == 'https' && uri.host == 'primeedu.com')) {
        return null;
      }

      final pathSegments = uri.pathSegments;
      
      if (pathSegments.isEmpty) {
        return null;
      }

      final type = pathSegments[0];
      final id = pathSegments.length > 1 ? pathSegments[1] : null;
      final params = uri.queryParameters;

      return DeepLinkData(
        type: _parseDeepLinkType(type),
        id: id,
        parameters: params,
        rawUrl: url,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[DeepLink] Erro no parsing: $e');
      }
      return null;
    }
  }

  /// Converte string em tipo de deep link
  DeepLinkType _parseDeepLinkType(String type) {
    switch (type.toLowerCase()) {
      case 'announcement':
      case 'aviso':
        return DeepLinkType.announcement;
      case 'class':
      case 'aula':
        return DeepLinkType.classRoom;
      case 'profile':
      case 'perfil':
        return DeepLinkType.profile;
      case 'materials':
      case 'materiais':
        return DeepLinkType.materials;
      case 'book':
      case 'livro':
        return DeepLinkType.book;
      case 'calendar':
      case 'calendario':
        return DeepLinkType.calendar;
      case 'messages':
      case 'mensagens':
        return DeepLinkType.messages;
      default:
        return DeepLinkType.unknown;
    }
  }

  /// Gera um deep link para compartilhamento
  String generateDeepLink({
    required DeepLinkType type,
    String? id,
    Map<String, String>? parameters,
  }) {
    final buffer = StringBuffer('primeedu://');
    
    // Adiciona tipo
    buffer.write(_deepLinkTypeToString(type));
    
    // Adiciona ID se houver
    if (id != null) {
      buffer.write('/$id');
    }
    
    // Adiciona parâmetros se houver
    if (parameters != null && parameters.isNotEmpty) {
      buffer.write('?');
      final params = parameters.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      buffer.write(params);
    }
    
    return buffer.toString();
  }

  /// Converte tipo de deep link em string
  String _deepLinkTypeToString(DeepLinkType type) {
    switch (type) {
      case DeepLinkType.announcement:
        return 'announcement';
      case DeepLinkType.classRoom:
        return 'class';
      case DeepLinkType.profile:
        return 'profile';
      case DeepLinkType.materials:
        return 'materials';
      case DeepLinkType.book:
        return 'book';
      case DeepLinkType.calendar:
        return 'calendar';
      case DeepLinkType.messages:
        return 'messages';
      case DeepLinkType.unknown:
        return 'unknown';
    }
  }

  /// Gera URL web para compartilhamento
  String generateWebLink({
    required DeepLinkType type,
    String? id,
    Map<String, String>? parameters,
  }) {
    final buffer = StringBuffer('https://primeedu.com/');
    
    buffer.write(_deepLinkTypeToString(type));
    
    if (id != null) {
      buffer.write('/$id');
    }
    
    if (parameters != null && parameters.isNotEmpty) {
      buffer.write('?');
      final params = parameters.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      buffer.write(params);
    }
    
    return buffer.toString();
  }

  /// Exemplos de deep links
  static const Map<String, String> examples = {
    'Aviso específico': 'primeedu://announcement/abc123',
    'Aula específica': 'primeedu://class/mat101',
    'Perfil do usuário': 'primeedu://profile',
    'Materiais educacionais': 'primeedu://materials',
    'Livro específico': 'primeedu://materials/book/xyz789',
    'Calendário': 'primeedu://calendar',
    'Mensagens': 'primeedu://messages',
    'Web - Aviso': 'https://primeedu.com/announcement/abc123',
    'Web - Aula': 'https://primeedu.com/class/mat101',
  };
}

/// Dados de um deep link processado
class DeepLinkData {
  final DeepLinkType type;
  final String? id;
  final Map<String, String> parameters;
  final String rawUrl;

  DeepLinkData({
    required this.type,
    this.id,
    this.parameters = const {},
    required this.rawUrl,
  });

  @override
  String toString() {
    return 'DeepLinkData(type: $type, id: $id, parameters: $parameters)';
  }
}

/// Tipos de deep link suportados
enum DeepLinkType {
  announcement,  // Avisos/Anúncios
  classRoom,     // Aulas
  profile,       // Perfil
  materials,     // Materiais
  book,          // Livro específico
  calendar,      // Calendário
  messages,      // Mensagens
  unknown,       // Desconhecido
}
