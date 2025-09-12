import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_text_styles.dart';
import 'package:prime_edu/constants/app_dimensions.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: SingleChildScrollView(
            // Wrap in SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and title
                _buildHeader(),

                const SizedBox(height: AppDimensions.xxl),

                // Welcome message
                _buildWelcomeMessage(),

                const SizedBox(height: AppDimensions.xl),

                // Demo login buttons
                _buildDemoLoginButtons(context),

                const SizedBox(height: AppDimensions.xl),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(30),
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
            size: 60,
            color: AppColors.background,
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        Text(
          'Prime Edu',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          'Sistema de Gestão Educacional',
          style: AppTextStyles.h6.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    return Column(
      children: [
        Text(
          'Bem-vindo!',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          'Escolha um perfil para acessar o sistema:',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDemoLoginButtons(BuildContext context) {
    return Column(
      children: [
        // Student login
        _buildLoginButton(
          context: context,
          title: 'Entrar como Aluno',
          subtitle: 'João Silva - 3º Ano A',
          icon: Icons.school,
          color: AppColors.primary,
          userType: UserType.student,
        ),

        const SizedBox(height: AppDimensions.lg),

        // Teacher login
        _buildLoginButton(
          context: context,
          title: 'Entrar como Professor',
          subtitle: 'Prof. Ana Costa - Matemática',
          icon: Icons.person,
          color: AppColors.secondary,
          userType: UserType.teacher,
        ),

        const SizedBox(height: AppDimensions.lg),

        // Admin login
        _buildLoginButton(
          context: context,
          title: 'Entrar como Administrador',
          subtitle: 'Dr. Roberto Admin - Sistema',
          icon: Icons.admin_panel_settings,
          color: AppColors.warning,
          userType: UserType.admin,
        ),
      ],
    );
  }

  Widget _buildLoginButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required UserType userType,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleDemoLogin(context, userType),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          padding: const EdgeInsets.all(AppDimensions.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
          elevation: 0,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(icon, color: color, size: AppDimensions.iconSizeLg),
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: AppDimensions.iconSizeMd,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(color: AppColors.divider),
        const SizedBox(height: AppDimensions.md),
        Text(
          'Versão de Demonstração',
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          '© 2024 Prime Education - Todos os direitos reservados',
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _handleDemoLogin(BuildContext context, UserType userType) {
    final authProvider = context.read<AuthProvider>();

    // Demo users data
    final demoUsers = {
      UserType.student: UserModel(
        id: 'student_001',
        name: 'João Silva',
        email: 'joao.silva@prime.edu',
        userType: UserType.student,
        phoneNumber: '(11) 99999-0001',
        classId: '3A_2024',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      ),
      UserType.teacher: UserModel(
        id: 'teacher_001',
        name: 'Prof. Ana Costa',
        email: 'ana.costa@prime.edu',
        userType: UserType.teacher,
        phoneNumber: '(11) 99999-1001',
        subjects: ['Matemática', 'Física'],
        createdAt: DateTime.now().subtract(const Duration(days: 1000)),
        updatedAt: DateTime.now(),
      ),
      UserType.admin: UserModel(
        id: 'admin_001',
        name: 'Dr. Roberto Admin',
        email: 'admin@prime.edu',
        userType: UserType.admin,
        phoneNumber: '(11) 99999-9001',
        createdAt: DateTime.now().subtract(const Duration(days: 2000)),
        updatedAt: DateTime.now(),
      ),
    };

    final user = demoUsers[userType];
    if (user != null) {
      authProvider.loginWithUser(user);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login realizado com sucesso como ${user.userType.displayName}!',
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
