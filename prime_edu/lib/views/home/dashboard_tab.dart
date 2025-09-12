import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../components/atoms/custom_typography.dart';
import '../profile/edit_profile_screen.dart';

/// Tab do Dashboard - Visão geral do aplicativo
class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _userStats;
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate API call
      setState(() {
        _userStats = _userService.getUserStats(user);
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    
    await _loadDashboardData();
    
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    
    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CustomTypography.h6(
            text: 'Usuário não encontrado',
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            _buildDashboardHeader(user),

            // Content
            SliverPadding(
              padding: AppDimensions.screenPadding,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (_isLoading)
                    const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else ...[
                    const SizedBox(height: 20),

                    // Quick Summary Cards
                    _buildQuickSummaryCards(user),

                    const SizedBox(height: 24),

                    // Recent Activities
                    _buildSectionTitle('Atividades Recentes'),
                    const SizedBox(height: 12),
                    _buildRecentActivities(user),

                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildSectionTitle('Ações Rápidas'),
                    const SizedBox(height: 12),
                    _buildQuickActions(user),

                    const SizedBox(height: 24),

                    // Upcoming Events
                    _buildSectionTitle('Próximos Eventos'),
                    const SizedBox(height: 12),
                    _buildUpcomingEvents(),

                    const SizedBox(height: 20),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardHeader(user) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: AppDimensions.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTypography.bodyMedium(
                              text: _getGreeting(),
                              color: AppColors.background.withValues(alpha: 0.9),
                            ),
                            const SizedBox(height: 4),
                            CustomTypography.h4(
                              text: user.name,
                              color: AppColors.background,
                            ),
                            const SizedBox(height: 4),
                            CustomTypography.bodyMedium(
                              text: '${user.userType.displayName} • Prime Edu',
                              color: AppColors.background.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.background.withValues(alpha: 0.2),
                          child: Icon(
                            _getUserIcon(user.userType),
                            size: 30,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            if (_isRefreshing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: AppColors.primary),
          onPressed: () {
            _showNotifications(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.primary),
          onPressed: () {
            _showSearch(context);
          },
        ),
      ],
    );
  }

  Widget _buildQuickSummaryCards(user) {
    if (_userStats == null) return const SizedBox();
    
    final stats = _userStats!;
    
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            user.userType == UserType.student ? 'Matérias' : 'Turmas',
            user.userType == UserType.student 
                ? '${stats['totalClasses']}' 
                : '${stats['totalClasses']}',
            Icons.book,
            AppColors.primary,
            onTap: () => _navigateToClasses(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            user.userType == UserType.student ? 'Atividades' : 'Alunos',
            user.userType == UserType.student 
                ? '${stats['pendingAssignments']}' 
                : '${stats['totalStudents']}',
            user.userType == UserType.student ? Icons.assignment : Icons.people,
            user.userType == UserType.student && stats['pendingAssignments'] > 0 
                ? AppColors.warning 
                : AppColors.secondary,
            onTap: () => _navigateToAssignments(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            user.userType == UserType.student ? 'Média' : 'Avisos',
            user.userType == UserType.student 
                ? '${stats['averageGrade']}' 
                : '${stats['totalAnnouncements']}',
            user.userType == UserType.student ? Icons.grade : Icons.announcement,
            AppColors.success,
            onTap: () => user.userType == UserType.student 
                ? _showGradeDetails(context) 
                : _navigateToAnnouncements(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            CustomTypography.h5(
              text: value,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: 4),
            CustomTypography.caption(
              text: title,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return CustomTypography.h5(
      text: title,
      color: AppColors.textPrimary,
    );
  }

  Widget _buildRecentActivities(user) {
    final activities = user.userType == UserType.student ? [
      {'title': 'Matemática - Exercícios 5-10', 'subject': 'Matemática', 'due': 'Hoje', 'type': 'homework'},
      {'title': 'História - Resumo Capítulo 3', 'subject': 'História', 'due': 'Amanhã', 'type': 'assignment'},
      {'title': 'Física - Relatório Laboratório', 'subject': 'Física', 'due': '23/08', 'type': 'lab'},
    ] : [
      {'title': 'Aviso publicado para 3º A', 'subject': 'Matemática', 'due': 'Hoje', 'type': 'announcement'},
      {'title': 'Notas lançadas - Prova 1', 'subject': 'Física', 'due': 'Ontem', 'type': 'grade'},
      {'title': 'Atividade criada', 'subject': 'Matemática', 'due': '2 dias', 'type': 'homework'},
    ];

    return Column(
      children: activities.map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getActivityColor(activity['type']!),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTypography.bodyMedium(
                      text: activity['title']!,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        CustomTypography.bodySmall(
                          text: activity['subject']!,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 12),
                        CustomTypography.bodySmall(
                          text: activity['due']!,
                          color: _getActivityColor(activity['type']!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(user) {
    List<Map<String, dynamic>> actions = [];
    
    if (user.userType == UserType.student) {
      actions = [
        {
          'title': 'Ver Notas',
          'icon': Icons.grade,
          'color': AppColors.success,
          'onTap': () => _showGradeDetails(context),
        },
        {
          'title': 'Atividades',
          'icon': Icons.assignment,
          'color': AppColors.warning,
          'onTap': () => _navigateToAssignments(context),
        },
      ];
    } else if (user.userType == UserType.teacher) {
      actions = [
        {
          'title': 'Criar Aviso',
          'icon': Icons.announcement,
          'color': AppColors.primary,
          'onTap': () => _createAnnouncement(context),
        },
        {
          'title': 'Lançar Notas',
          'icon': Icons.grade,
          'color': AppColors.success,
          'onTap': () => _launchGrades(context),
        },
      ];
    } else {
      actions = [
        {
          'title': 'Relatórios',
          'icon': Icons.analytics,
          'color': AppColors.info,
          'onTap': () => _viewReports(context),
        },
        {
          'title': 'Usuários',
          'icon': Icons.people,
          'color': AppColors.secondary,
          'onTap': () => _manageUsers(context),
        },
      ];
    }

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: action['onTap'],
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: action['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(
                    color: action['color'].withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      action['icon'],
                      color: action['color'],
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    CustomTypography.bodySmall(
                      text: action['title'],
                      color: action['color'],
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
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
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.borderColor),
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
                    CustomTypography.bodyMedium(
                      text: event['title']!,
                      color: AppColors.textPrimary,
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
                          child: CustomTypography.caption(
                            text: event['type']!,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        CustomTypography.caption(
                          text: event['date']!,
                          color: AppColors.textSecondary,
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

  // Helper methods
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bom dia!';
    } else if (hour < 18) {
      return 'Boa tarde!';
    } else {
      return 'Boa noite!';
    }
  }

  IconData _getUserIcon(userType) {
    switch (userType) {
      case UserType.student:
        return Icons.school;
      case UserType.teacher:
        return Icons.person;
      case UserType.admin:
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'homework':
        return AppColors.warning;
      case 'assignment':
        return AppColors.info;
      case 'lab':
        return AppColors.success;
      case 'announcement':
        return AppColors.primary;
      case 'grade':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
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

  // Navigation and action methods
  void _navigateToClasses(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navegando para Turmas...'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _navigateToAssignments(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navegando para Atividades...'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _navigateToAnnouncements(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navegando para Avisos...'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showGradeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const CustomTypography.h6(
          text: 'Minhas Notas',
          color: AppColors.textPrimary,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGradeItem('Matemática', 8.5, AppColors.success),
            _buildGradeItem('Português', 7.8, AppColors.warning),
            _buildGradeItem('Física', 9.2, AppColors.success),
            _buildGradeItem('Química', 8.0, AppColors.success),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CustomTypography.bodyMedium(
              text: 'Fechar',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeItem(String subject, double grade, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTypography.bodyMedium(
            text: subject,
            color: AppColors.textPrimary,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomTypography.bodySmall(
              text: grade.toString(),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const CustomTypography.h6(
          text: 'Notificações',
          color: AppColors.textPrimary,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.announcement, color: AppColors.warning),
              title: const CustomTypography.bodyMedium(
                text: 'Novo aviso de Matemática',
                color: AppColors.textPrimary,
              ),
              subtitle: const CustomTypography.bodySmall(
                text: 'Há 2 horas',
                color: AppColors.textSecondary,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.assignment, color: AppColors.info),
              title: const CustomTypography.bodyMedium(
                text: 'Atividade de Física pendente',
                color: AppColors.textPrimary,
              ),
              subtitle: const CustomTypography.bodySmall(
                text: 'Entrega amanhã',
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CustomTypography.bodyMedium(
              text: 'Fechar',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showSearch(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Busca em desenvolvimento!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _createAnnouncement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Criar aviso em desenvolvimento!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _launchGrades(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lançamento de notas em desenvolvimento!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _viewReports(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Relatórios em desenvolvimento!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _manageUsers(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gerenciamento de usuários em desenvolvimento!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}