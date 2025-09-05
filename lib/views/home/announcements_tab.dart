import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';
import '../../models/user_model.dart';
import '../../models/notification_model.dart';

/// Aba de Avisos - Sistema de comunicação unidirecional dos professores
class AnnouncementsTab extends StatelessWidget {
  const AnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Lista de avisos
            Expanded(
              child: _buildAnnouncementsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Note: Announcement creation planned for teacher role in demo system
          _showCreateAnnouncement(context);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        tooltip: 'Criar Aviso',
        child: const Icon(Icons.announcement),
      ),
    );
  }

  /// Constrói o cabeçalho da tela de avisos
  Widget _buildHeader() {
    return Container(
      padding: AppDimensions.screenPadding,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Avisos',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Comunicados importantes dos professores',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a lista de avisos
  Widget _buildAnnouncementsList() {
    // Lista mock de avisos
    final announcements = [
      AnnouncementModel(
        id: '1',
        title: 'Prova de Matemática',
        content: 'A prova será realizada na próxima segunda-feira às 14h. Estudem os capítulos 5 e 6 do livro. Não esqueçam de trazer calculadora e material de escrita.',
        author: 'Prof. Silva',
        authorType: UserType.teacher,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        priority: NotificationPriority.high,
        category: 'Acadêmico',
      ),
      AnnouncementModel(
        id: '2',
        title: 'Reunião de Pais e Mestres',
        content: 'Reunião marcada para sexta-feira às 19h no auditório principal. Serão discutidos o desempenho da turma e projetos futuros.',
        author: 'Coordenação Pedagógica',
        authorType: UserType.teacher,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        priority: NotificationPriority.normal,
        category: 'Administrativo',
      ),
      AnnouncementModel(
        id: '3',
        title: 'Atividade de História',
        content: 'Entrega do trabalho sobre Revolução Industrial até quinta-feira às 23h59. O trabalho deve ter no mínimo 5 páginas e incluir bibliografia.',
        author: 'Prof. Santos',
        authorType: UserType.teacher,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        priority: NotificationPriority.normal,
        category: 'Acadêmico',
      ),
      AnnouncementModel(
        id: '4',
        title: 'Cancelamento de Aula',
        content: 'A aula de Educação Física de amanhã foi cancelada devido ao mau tempo. A reposição será agendada para a próxima semana.',
        author: 'Prof. Oliveira',
        authorType: UserType.teacher,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        priority: NotificationPriority.urgent,
        category: 'Acadêmico',
      ),
      AnnouncementModel(
        id: '5',
        title: 'Feira de Ciências',
        content: 'A Feira de Ciências será realizada no dia 15 de dezembro. Todos os projetos devem ser inscritos até o dia 10. Maiores informações na coordenação.',
        author: 'Prof. Costa',
        authorType: UserType.teacher,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        priority: NotificationPriority.low,
        category: 'Evento',
      ),
    ];

    if (announcements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.announcement_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum aviso disponível',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Os professores postarão avisos aqui',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: AppDimensions.screenPadding,
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return _buildAnnouncementCard(announcement);
      },
    );
  }

  /// Constrói um card de aviso
  Widget _buildAnnouncementCard(AnnouncementModel announcement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do aviso
            Row(
              children: [
                Icon(
                  Icons.announcement,
                  color: _getPriorityColor(announcement.priority),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    announcement.title,
                    style: AppTextStyles.h6.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(announcement.priority).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getPriorityText(announcement.priority),
                    style: TextStyle(
                      color: _getPriorityColor(announcement.priority),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Categoria
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                announcement.category,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Conteúdo do aviso
            Text(
              announcement.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Rodapé com autor e tempo
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  announcement.author,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  _getTimeAgo(announcement.createdAt),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Retorna a cor baseada na prioridade
  Color _getPriorityColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return AppColors.success;
      case NotificationPriority.normal:
        return AppColors.info;
      case NotificationPriority.high:
        return AppColors.warning;
      case NotificationPriority.urgent:
        return AppColors.error;
    }
  }

  /// Retorna o texto da prioridade
  String _getPriorityText(NotificationPriority priority) {
    switch (priority) {
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

  /// Retorna o tempo relativo
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

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

  /// Mostra modal de criação de aviso
  void _showCreateAnnouncement(BuildContext context) {
    // Note: Announcement creation modal planned for demo system
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de criação de avisos em desenvolvimento!'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Modelo para avisos
class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String author;
  final UserType authorType;
  final DateTime createdAt;
  final NotificationPriority priority;
  final String category;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.authorType,
    required this.createdAt,
    required this.priority,
    required this.category,
  });
}
