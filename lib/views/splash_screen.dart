import 'package:flutter/material.dart';
// Import removido - não utilizado
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_dimensions.dart';
import 'onboarding/onboarding_screen.dart';

/// Tela de splash screen animada do aplicativo Potea Edu
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // Anima o logo
    await _logoController.forward();
    
    // Anima o texto
    await _textController.forward();
    
    // Inicia o progresso
    await _progressController.forward();
    
    // Aguarda um pouco e navega para o onboarding
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              
              // Logo animado
              _buildLogo(),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Texto do app
              _buildAppText(),
              
              const SizedBox(height: AppDimensions.xxl),
              
              // Indicador de progresso
              _buildProgressIndicator(),
              
              const SizedBox(height: AppDimensions.xl),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o logo animado
  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: Curves.elasticOut.transform(_logoController.value),
          child: Container(
            width: 120,
            height: 120,
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
              size: 60,
              color: AppColors.background,
            ),
          ),
        );
      },
    );
  }

  /// Constrói o texto do aplicativo
  Widget _buildAppText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _textController.value)),
          child: Opacity(
            opacity: _textController.value,
            child: Column(
              children: [
                Text(
                  'Potea',
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Edu',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                Text(
                  'Educação Inteligente',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Constrói o indicador de progresso
  Widget _buildProgressIndicator() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _progressController.value,
                backgroundColor: AppColors.surfaceLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: AppDimensions.md),
            Text(
              'Carregando...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}

