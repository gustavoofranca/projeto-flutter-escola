import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';

/// Tab de Turmas - Gerenciamento de classes e matérias
class ClassesTab extends StatelessWidget {
  const ClassesTab({super.key});

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
              
              // Lista de turmas
              _buildClassesList(),
              
              const SizedBox(height: AppDimensions.lg),
              
              // Matérias em destaque
              _buildFeaturedSubjects(),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o cabeçalho da tela de turmas
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minhas Turmas',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          'Gerencie suas turmas e acompanhe o progresso',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Constrói a lista de turmas
  Widget _buildClassesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Turmas Ativas',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        _buildClassCard(
          name: '3º Ano A',
          teacher: 'Prof. Maria Santos',
          students: 28,
          subjects: ['Matemática', 'Português', 'História'],
          progress: 0.75,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildClassCard(
          name: '2º Ano B',
          teacher: 'Prof. Carlos Oliveira',
          students: 25,
          subjects: ['Ciências', 'Geografia', 'Inglês'],
          progress: 0.60,
          color: AppColors.secondary,
        ),
        const SizedBox(height: AppDimensions.sm),
        _buildClassCard(
          name: '1º Ano C',
          teacher: 'Prof. Ana Costa',
          students: 30,
          subjects: ['Arte', 'Educação Física', 'Filosofia'],
          progress: 0.45,
          color: AppColors.accent,
        ),
      ],
    );
  }

  /// Constrói um card de turma
  Widget _buildClassCard({
    required String name,
    required String teacher,
    required int students,
    required List<String> subjects,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: AppDimensions.iconSizeSm,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Icon(
                Icons.person,
                color: AppColors.textSecondary,
                size: AppDimensions.iconSizeSm,
              ),
              const SizedBox(width: AppDimensions.xs),
              Text(
                teacher,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.group,
                color: AppColors.textSecondary,
                size: AppDimensions.iconSizeSm,
              ),
              const SizedBox(width: AppDimensions.xs),
              Text(
                '$students alunos',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Wrap(
            spacing: AppDimensions.xs,
            runSpacing: AppDimensions.xs,
            children: subjects.map((subject) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: AppDimensions.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Text(
                  subject,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progresso',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.xs),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Constrói matérias em destaque
  Widget _buildFeaturedSubjects() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Matérias em Destaque',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        Row(
          children: [
            Expanded(
              child: _buildSubjectCard(
                name: 'Matemática',
                icon: Icons.calculate,
                color: AppColors.primary,
                grade: '8.5',
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: _buildSubjectCard(
                name: 'História',
                icon: Icons.history_edu,
                color: AppColors.secondary,
                grade: '9.0',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        Row(
          children: [
            Expanded(
              child: _buildSubjectCard(
                name: 'Português',
                icon: Icons.book,
                color: AppColors.accent,
                grade: '7.8',
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: _buildSubjectCard(
                name: 'Ciências',
                icon: Icons.science,
                color: AppColors.primary,
                grade: '8.2',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói um card de matéria
  Widget _buildSubjectCard({
    required String name,
    required IconData icon,
    required Color color,
    required String grade,
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
            name,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.xs),
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
              'Nota: $grade',
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
}
