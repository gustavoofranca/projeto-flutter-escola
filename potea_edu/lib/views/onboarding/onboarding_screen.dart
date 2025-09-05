import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';
import '../auth/auth_screen.dart';

/// Tela de onboarding para novos usuários
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bem-vindo ao Potea Edu',
      description: 'A plataforma educacional mais inteligente e intuitiva para alunos e professores.',
      image: Icons.school,
      color: AppColors.primary,
    ),
    OnboardingPage(
      title: 'Aprendizado Personalizado',
      description: 'Receba conteúdo adaptado ao seu ritmo de aprendizado e estilo de estudo.',
      image: Icons.psychology,
      color: AppColors.primaryLight,
    ),
    OnboardingPage(
      title: 'Comunicação Eficiente',
      description: 'Mantenha-se conectado com professores e colegas através do chat integrado.',
      image: Icons.chat_bubble,
      color: AppColors.primary,
    ),
    OnboardingPage(
      title: 'Organização Total',
      description: 'Gerencie suas atividades, notas e calendário escolar em um só lugar.',
      image: Icons.calendar_today,
      color: AppColors.primaryLight,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToAuth();
    }
  }

  void _goToAuth() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthScreen(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Indicadores de página
            _buildPageIndicators(),
            
            // Conteúdo das páginas
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            
            // Botões de navegação
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  /// Constrói os indicadores de página
  Widget _buildPageIndicators() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _pages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
            width: _currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: _currentPage == index
                  ? AppColors.primary
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói uma página individual
  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagem/ícone
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
            ),
            child: Icon(
              page.image,
              size: 100,
              color: page.color,
            ),
          ),
          
          const SizedBox(height: AppDimensions.xxl),
          
          // Título
          Text(
            page.title,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppDimensions.lg),
          
          // Descrição
          Text(
            page.description,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Constrói os botões de navegação
  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.xl),
      child: Row(
        children: [
          // Botão pular (apenas na primeira página)
          if (_currentPage == 0)
            Expanded(
              child: TextButton(
                onPressed: _goToAuth,
                child: Text(
                  'Pular',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),
          
          // Botão próximo/começar
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(
                _currentPage == _pages.length - 1 ? 'Começar' : 'Próximo',
                style: AppTextStyles.buttonMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modelo para uma página de onboarding
class OnboardingPage {
  final String title;
  final String description;
  final IconData image;
  final Color color;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}

