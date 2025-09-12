import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_text_styles.dart';
import 'package:prime_edu/constants/app_dimensions.dart';
import 'classes_tab.dart';
import 'announcements_tab.dart';
import 'calendar_tab.dart';
import 'materials_tab.dart';
import 'profile_tab.dart';
import '../demo/api_demo_screen.dart';
import '../demo/form_demo_screen.dart';
import '../../providers/auth_provider.dart';

/// Tela principal do aplicativo com navegação inferior
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isStudent = authProvider.isStudent;

    // Tabs que são visíveis para todos os usuários
    final List<Widget> allTabs = [
      const DashboardTab(),
      const ClassesTab(),
      const AnnouncementsTab(),
      const CalendarTab(),
      const MaterialsTab(),
      const ProfileTab(),
    ];

    // Adiciona a aba de demos apenas para professores e administradores
    if (!isStudent) {
      allTabs.add(const DemosTab());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: allTabs),
      bottomNavigationBar: _buildBottomNavigationBar(isStudent),
    );
  }

  /// Constrói a barra de navegação inferior
  Widget _buildBottomNavigationBar(bool isStudent) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.overlay,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          child: Row(
            children: [
              _buildNavItem(index: 0, icon: Icons.dashboard, label: 'Início'),
              _buildNavItem(index: 1, icon: Icons.class_, label: 'Turmas'),
              _buildNavItem(
                index: 2,
                icon: Icons.announcement,
                label: 'Avisos',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.calendar_today,
                label: 'Calendário',
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.library_books,
                label: 'Materiais',
              ),
              _buildNavItem(index: 5, icon: Icons.person, label: 'Perfil'),
              if (!isStudent)
                _buildNavItem(index: 6, icon: Icons.science, label: 'Demos'),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói um item de navegação
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(AppDimensions.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconSizeMd,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: AppDimensions.xs),

            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Aba do Dashboard (Início)
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Bom dia,'
        : hour < 18
            ? 'Boa tarde,'
            : 'Boa noite,';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar personalizado
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.surface,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      child: Row(
                        children: [
                          // Avatar do usuário
                          CircleAvatar(
                            radius: AppDimensions.avatarSizeMd / 2,
                            backgroundColor: AppColors.background,
                            child: Icon(
                              Icons.person,
                              size: AppDimensions.iconSizeLg,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(width: AppDimensions.md),

                          // Saudação
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  greeting,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.background,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  user?.name ?? 'Usuário',
                                  style: AppTextStyles.h5.copyWith(
                                    color: AppColors.background,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Ícones de ação
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Note: Search functionality planned for enhanced user experience
                                },
                                icon: const Icon(
                                  Icons.search,
                                  color: AppColors.background,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Note: Notifications system planned for real-time updates
                                },
                                icon: const Icon(
                                  Icons.notifications,
                                  color: AppColors.background,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Conteúdo do dashboard
            SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Resumo rápido
                  _buildQuickSummary(),

                  const SizedBox(height: AppDimensions.xl),

                  // Atividades recentes
                  _buildRecentActivities(),

                  const SizedBox(height: AppDimensions.xl),

                  // Próximos eventos
                  _buildUpcomingEvents(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o resumo rápido
  Widget _buildQuickSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumo Rápido',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: AppDimensions.md),

        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.assignment,
                title: 'Atividades',
                value: '5',
                subtitle: 'Pendentes',
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: AppDimensions.md),

            Expanded(
              child: _buildSummaryCard(
                icon: Icons.grade,
                title: 'Notas',
                value: '8.5',
                subtitle: 'Média',
                color: AppColors.success,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.md),

        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                icon: Icons.event,
                title: 'Eventos',
                value: '3',
                subtitle: 'Esta semana',
                color: AppColors.info,
              ),
            ),

            const SizedBox(width: AppDimensions.md),

            Expanded(
              child: _buildSummaryCard(
                icon: Icons.announcement,
                title: 'Avisos',
                value: '12',
                subtitle: 'Não lidos',
                color: AppColors.warning,
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
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppDimensions.shadowSm,
      ),
      child: Column(
        children: [
          Icon(icon, size: AppDimensions.iconSizeLg, color: color),

          const SizedBox(height: AppDimensions.sm),

          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói as atividades recentes
  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Atividades Recentes',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: AppDimensions.md),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildActivityItem(
              title: 'Tarefa de Matemática',
              subtitle: 'Entrega em 2 dias',
              icon: Icons.assignment,
              color: AppColors.primary,
            );
          },
        ),
      ],
    );
  }

  /// Constrói um item de atividade
  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppDimensions.shadowSm,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(icon, size: AppDimensions.iconSizeMd, color: color),
          ),

          const SizedBox(width: AppDimensions.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  /// Constrói os próximos eventos
  Widget _buildUpcomingEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Próximos Eventos',
          style: AppTextStyles.h4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: AppDimensions.md),

        Container(
          padding: const EdgeInsets.all(AppDimensions.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: AppDimensions.shadowSm,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.event,
                    color: AppColors.primary,
                    size: AppDimensions.iconSizeMd,
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Text(
                      'Prova de História',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Text(
                      'Amanhã',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.md),

              Text(
                'Revisar capítulos 5-8 do livro de História',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Aba de Demonstrations (Demos)
class DemosTab extends StatelessWidget {
  const DemosTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Verifica se o usuário tem permissão para acessar a aba de demos
    if (authProvider.isStudent) {
      // Se for estudante, mostra uma mensagem de acesso negado
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: AppDimensions.lg),
                const Text(
                  'Acesso Restrito',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                const Text(
                  'Esta funcionalidade está disponível apenas para professores e administradores.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
                ElevatedButton(
                  onPressed: () {
                    // Volta para a aba de perfil ou dashboard
                    // We can't directly access the state, so we'll just show a message
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.xl,
                      vertical: AppDimensions.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                  ),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Se for professor ou administrador, mostra as demos normalmente
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Demonstrações',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'API Demo', icon: Icon(Icons.api)),
              Tab(text: 'Formulário', icon: Icon(Icons.edit)),
            ],
          ),
        ),
        body: const TabBarView(children: [ApiDemoScreen(), FormDemoScreen()]),
      ),
    );
  }
}
