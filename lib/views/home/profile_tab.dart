import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';

/// Tab de Perfil - Configurações e informações do usuário
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

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
              // Header do perfil
              _buildProfileHeader(),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Estatísticas do usuário
              _buildUserStats(),
              
              const SizedBox(height: AppDimensions.lg),
              
              // Menu de opções
              _buildMenuOptions(),
              
              const SizedBox(height: AppDimensions.lg),
              
              // Informações acadêmicas
              _buildAcademicInfo(),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o cabeçalho do perfil
  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                'JS',
                style: AppTextStyles.h1.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: AppDimensions.lg),
          
          // Nome e informações
          Text(
            'João Silva',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          
          const SizedBox(height: AppDimensions.sm),
          
          Text(
            'joao.silva@email.com',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: AppDimensions.sm),
          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Text(
              'Aluno • 3º Ano A',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói as estatísticas do usuário
  Widget _buildUserStats() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.school,
              value: '85%',
              label: 'Presença',
              color: AppColors.primary,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.assignment,
              value: '24',
              label: 'Atividades',
              color: AppColors.secondary,
            ),
          ),
          Container(
            width: 1,
            height: 60,
            color: AppColors.divider,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.grade,
              value: '7.8',
              label: 'Média',
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói um item de estatística
  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
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
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Constrói o menu de opções
  Widget _buildMenuOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configurações',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Editar Perfil',
          subtitle: 'Alterar informações pessoais',
          onTap: () {
            // TODO: Implementar edição de perfil
          },
        ),
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notificações',
          subtitle: 'Configurar alertas e lembretes',
          onTap: () {
            // TODO: Implementar configurações de notificação
          },
        ),
        _buildMenuItem(
          icon: Icons.security,
          title: 'Privacidade',
          subtitle: 'Configurações de segurança',
          onTap: () {
            // TODO: Implementar configurações de privacidade
          },
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Ajuda e Suporte',
          subtitle: 'Central de ajuda e contato',
          onTap: () {
            // TODO: Implementar tela de ajuda
          },
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'Sobre o App',
          subtitle: 'Versão e informações',
          onTap: () {
            // TODO: Implementar tela sobre
          },
        ),
      ],
    );
  }

  /// Constrói um item do menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.md),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: AppDimensions.iconSizeMd,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textSecondary,
          size: AppDimensions.iconSizeSm,
        ),
        onTap: onTap,
      ),
    );
  }

  /// Constrói informações acadêmicas
  Widget _buildAcademicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações Acadêmicas',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        _buildAcademicCard(
          title: 'Matrícula',
          value: '2023001',
          icon: Icons.badge,
        ),
        _buildAcademicCard(
          title: 'Turma',
          value: '3º Ano A',
          icon: Icons.class_,
        ),
        _buildAcademicCard(
          title: 'Período',
          value: '2023/2024',
          icon: Icons.calendar_today,
        ),
        _buildAcademicCard(
          title: 'Status',
          value: 'Ativo',
          icon: Icons.check_circle,
          isStatus: true,
        ),
      ],
    );
  }

  /// Constrói um card de informação acadêmica
  Widget _buildAcademicCard({
    required String title,
    required String value,
    required IconData icon,
    bool isStatus = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isStatus 
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(
              icon,
              color: isStatus 
                  ? AppColors.success
                  : AppColors.secondary,
              size: AppDimensions.iconSizeMd,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
