import 'package:flutter/material.dart';
// Removido flutter_animate - usando animações nativas
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

/// Tela principal de autenticação
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
              
              // Botões de autenticação social
              _buildSocialAuthButtons(),
              
              const SizedBox(height: AppDimensions.lg),
              
              // Divisor
              _buildDivider(),
              
              const SizedBox(height: AppDimensions.lg),
              
              // Botão de login com senha
              _buildPasswordAuthButton(),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Link para cadastro
              _buildSignupLink(),
              
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
          child: Icon(
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
            fontWeight: FontWeight.w800,
          ),
        ),
        
        const SizedBox(height: AppDimensions.sm),
        
        // Subtítulo
        Text(
          'Entre na sua conta',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Constrói os botões de autenticação social
  Widget _buildSocialAuthButtons() {
    return Column(
      children: [
        // Botão Google
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          text: 'Continuar com Google',
          onPressed: () {
            // TODO: Implementar autenticação Google
            _showComingSoon();
          },
        ),
        
        const SizedBox(height: AppDimensions.md),
        
        // Botão Apple
        _buildSocialButton(
          icon: Icons.apple,
          text: 'Continuar com Apple',
          onPressed: () {
            // TODO: Implementar autenticação Apple
            _showComingSoon();
          },
        ),
      ],
    );
  }

  /// Constrói um botão de autenticação social
  Widget _buildSocialButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: AppDimensions.iconSizeMd),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }

  /// Constrói o divisor
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Text(
            'ou',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  /// Constrói o botão de login com senha
  Widget _buildPasswordAuthButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        },
        child: Text(
          'Entrar com senha',
          style: AppTextStyles.buttonMedium,
        ),
      ),
    );
  }

  /// Constrói o link para cadastro
  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SignupScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          },
          child: Text(
            'Cadastre-se',
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Mostra mensagem de "em breve"
  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Funcionalidade em desenvolvimento!',
          style: AppTextStyles.bodyMedium,
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

