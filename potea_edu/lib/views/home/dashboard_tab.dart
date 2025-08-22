import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Custom App Bar
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.surface,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: AppDimensions.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bem-vindo de volta!',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'João Silva',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aluno • 3º Ano do Ensino Médio',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Content
        SliverPadding(
          padding: AppDimensions.screenPadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),

              // Quick Summary Cards
              _buildQuickSummaryCards(),

              const SizedBox(height: 24),

              // Recent Activities
              _buildSectionTitle('Atividades Recentes'),
              const SizedBox(height: 12),
              _buildRecentActivities(),

              const SizedBox(height: 24),

              // Upcoming Events
              _buildSectionTitle('Próximos Eventos'),
              const SizedBox(height: 12),
              _buildUpcomingEvents(),

              const SizedBox(height: 20),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Matérias',
            '8',
            Icons.book,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Atividades',
            '12',
            Icons.assignment,
            AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Notas',
            '9.2',
            Icons.grade,
            AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h4.copyWith(
        color: AppColors.onBackground,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRecentActivities() {
    final activities = [
      {'title': 'Matemática - Exercícios 5-10', 'subject': 'Matemática', 'due': 'Hoje'},
      {'title': 'História - Resumo Capítulo 3', 'subject': 'História', 'due': 'Amanhã'},
      {'title': 'Física - Relatório Laboratório', 'subject': 'Física', 'due': '23/08'},
    ];

    return Column(
      children: activities.map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title']!,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          activity['subject']!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Entrega: ${activity['due']}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.onSurface.withValues(alpha: 0.4),
                size: 16,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUpcomingEvents() {
    final events = [
      {'title': 'Prova de Matemática', 'date': '25/08', 'type': 'Prova'},
      {'title': 'Entrega Trabalho História', 'date': '28/08', 'type': 'Trabalho'},
      {'title': 'Reunião de Pais', 'date': '30/08', 'type': 'Reunião'},
    ];

    return Column(
      children: events.map((event) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getEventIcon(event['type']!),
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title']!,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            event['type']!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          event['date']!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'Prova':
        return Icons.quiz;
      case 'Trabalho':
        return Icons.assignment;
      case 'Reunião':
        return Icons.meeting_room;
      default:
        return Icons.event;
    }
  }
}

