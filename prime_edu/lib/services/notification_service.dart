import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Serviço de notificações locais
/// 
/// Gerencia notificações push locais para:
/// - Lembretes de aulas
/// - Novos avisos/anúncios
/// - Prazos de atividades
/// - Mensagens importantes
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Verifica se a plataforma suporta notificações
  bool get isPlatformSupported {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Verifica se a plataforma é suportada
    if (!isPlatformSupported) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Plataforma não suportada (apenas Android/iOS)');
      }
      _isInitialized = false;
      return;
    }

    try {
      // Inicializa timezone
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

      // Configurações para Android
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configurações para iOS
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Configurações gerais
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Inicializa o plugin
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('[NotificationService] Serviço inicializado com sucesso');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Erro ao inicializar: $e');
      }
      _isInitialized = false;
    }
  }

  /// Callback quando uma notificação é tocada
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      debugPrint('[NotificationService] Notificação tocada: ${response.payload}');
    }
    // Aqui você pode navegar para telas específicas baseado no payload
  }

  /// Solicita permissões de notificação (iOS)
  Future<bool> requestPermissions() async {
    if (!_isInitialized) await initialize();

    final result = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return result ?? true; // Android não precisa de permissão explícita
  }

  /// Mostra uma notificação imediata
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    if (!isPlatformSupported) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Notificações não suportadas nesta plataforma');
      }
      return;
    }

    if (!_isInitialized) await initialize();
    if (!_isInitialized) return;

    try {
      const androidDetails = AndroidNotificationDetails(
        'prime_edu_channel',
        'Prime Edu Notifications',
        channelDescription: 'Notificações do aplicativo Prime Edu',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );

      if (kDebugMode) {
        debugPrint('[NotificationService] Notificação enviada: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Erro ao enviar notificação: $e');
      }
    }
  }

  /// Agenda uma notificação para o futuro
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    try {
      const androidDetails = AndroidNotificationDetails(
        'prime_edu_scheduled',
        'Prime Edu Scheduled',
        channelDescription: 'Notificações agendadas do Prime Edu',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      if (kDebugMode) {
        debugPrint('[NotificationService] Notificação agendada: $title para $scheduledDate');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationService] Erro ao agendar notificação: $e');
      }
    }
  }

  /// Notificação de novo aviso
  Future<void> notifyNewAnnouncement({
    required String title,
    required String author,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: '📢 Novo Aviso',
      body: '$title - Por $author',
      payload: 'announcement',
    );
  }

  /// Notificação de lembrete de aula
  Future<void> notifyClassReminder({
    required String className,
    required DateTime classTime,
  }) async {
    await scheduleNotification(
      id: className.hashCode,
      title: '📚 Lembrete de Aula',
      body: '$className às ${classTime.hour}:${classTime.minute.toString().padLeft(2, '0')}',
      scheduledDate: classTime.subtract(const Duration(minutes: 15)),
      payload: 'class_reminder',
    );
  }

  /// Notificação de prazo de atividade
  Future<void> notifyActivityDeadline({
    required String activityName,
    required DateTime deadline,
  }) async {
    await scheduleNotification(
      id: activityName.hashCode,
      title: '⏰ Prazo Próximo',
      body: '$activityName vence em breve!',
      scheduledDate: deadline.subtract(const Duration(hours: 24)),
      payload: 'activity_deadline',
    );
  }

  /// Notificação de mensagem
  Future<void> notifyNewMessage({
    required String sender,
    required String message,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: '💬 Nova Mensagem de $sender',
      body: message,
      payload: 'message',
    );
  }

  /// Cancela uma notificação específica
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancela todas as notificações
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Lista todas as notificações pendentes
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}

/// Prioridade da notificação
enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}
