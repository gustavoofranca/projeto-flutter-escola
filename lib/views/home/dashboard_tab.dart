import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';

/// Tab do Dashboard - Visão geral do aplicativo
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Resumo de atividades
              _buildActivitiesSummary(),
              
              const SizedBox(height: AppDimensions.lg),
              
              // Próximas atividades
              _buildUpcomingActivities(),
              
              const SizedBox(height: AppDimensions.lg),
              
              // Estatísticas rápidas
              _buildQuickStats(),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o cabeçalho do dashboard
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo de volta!',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          'João Silva',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          'Aluno • Turma 3º Ano A',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Constrói o resumo de atividades
  Widget _buildActivitiesSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo de Hoje',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.assignment,
                title: 'Atividades',
                value: '3',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.message,
                title: 'Mensagens',
                value: '5',
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.event,
                title: 'Eventos',
                value: '2',
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói um card de resumo
  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppDimensions.iconSizeLg,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Constrói as próximas atividades
  Widget _buildUpcomingActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Próximas Atividades',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        _buildActivityItem(
          title: 'Matemática - Exercícios',
          subtitle: 'Entrega até 15:00',
          time: '14:30',
          color: AppColors.primary,
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildActivityItem(
          title: 'História - Pesquisa',
          subtitle: 'Apresentação em grupo',
          time: '16:00',
          color: AppColors.secondary,
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildActivityItem(
          title: 'Educação Física',
          subtitle: 'Aula prática',
          time: '17:30',
          color: AppColors.accent,
        ),
      ],
    );
  }

  /// Constrói um item de atividade
  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.sm,
              vertical: AppDimensions.xs,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Text(
              time,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói estatísticas rápidas
  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estatísticas da Semana',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Container(
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '85%',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      'Presença',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: AppColors.divider,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '7.8',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      'Média Geral',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
