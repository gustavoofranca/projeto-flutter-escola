import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';
import '../../models/user_model.dart';

/// Tela principal de autenticação com credenciais de demonstração
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            children: [
              const Spacer(),
              
              // Logo e título
              _buildHeader(),
              
              const SizedBox(height: AppDimensions.xxl),
              
              // Texto explicativo
              _buildExplanationText(),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Botões de demo
              _buildDemoButtons(context),
              
              const SizedBox(height: AppDimensions.xl),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o cabeçalho com logo e título
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.school,
            size: 50,
            color: AppColors.background,
          ),
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        // Título
        Text(
          'Potea Edu',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary,
          ),
        ),
        
        const SizedBox(height: AppDimensions.sm),
        
        // Subtítulo
        Text(
          'Sistema de Gestão Educacional',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Constrói o texto explicativo
  Widget _buildExplanationText() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: AppDimensions.iconSizeLg,
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            'Sistema Demonstrativo',
            style: AppTextStyles.h6.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'Este é um sistema educacional fictício para demonstração. Escolha um tipo de usuário abaixo para fazer login automaticamente.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Constrói os botões de demonstração
  Widget _buildDemoButtons(BuildContext context) {
    return Column(
      children: [
        Text(
          'Entrar como:',
          style: AppTextStyles.h6.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        
        // Botão Aluno
        _buildDemoButton(
          context: context,
          title: 'Aluno',
          subtitle: 'João Silva - 3º Ano',
          icon: Icons.school,
          color: AppColors.primary,
          userType: UserType.student,
        ),
        
        const SizedBox(height: AppDimensions.md),
        
        // Botão Professor
        _buildDemoButton(
          context: context,
          title: 'Professor',
          subtitle: 'Prof. Ana Silva - Matemática',
          icon: Icons.person,
          color: AppColors.secondary,
          userType: UserType.teacher,
        ),
        
        const SizedBox(height: AppDimensions.md),
        
        // Botão Administrador
        _buildDemoButton(
          context: context,
          title: 'Administrador',
          subtitle: 'Acesso completo ao sistema',
          icon: Icons.admin_panel_settings,
          color: AppColors.warning,
          userType: UserType.admin,
        ),
      ],
    );
  }

  /// Constrói um botão de demonstração
  Widget _buildDemoButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required UserType userType,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _loginDemo(context, userType),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: AppDimensions.iconSizeLg,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.h6.copyWith(
                            color: AppColors.textPrimary,
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
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconSizeMd,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Faz login com credenciais de demonstração
  Future<void> _loginDemo(BuildContext context, UserType userType) async {
    // Demo implementation - simplified for standalone project
    final userTypeName = userType.toString().split('.').last;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Login demo como $userTypeName realizado com sucesso!',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }
}