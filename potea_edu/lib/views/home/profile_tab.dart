import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:potea_edu/constants/app_colors.dart';
import 'package:potea_edu/constants/app_text_styles.dart';
import 'package:potea_edu/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/atoms/custom_button.dart';
import '../../components/molecules/info_card.dart';
import '../../components/molecules/section_title.dart';
import '../profile/edit_profile_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final UserService _userService = UserService();
  Map<String, dynamic>? _userStats;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadUserStats();
  }

  Future<void> _loadUserStats() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
      setState(() {
        _userStats = _userService.getUserStats(user);
        _isLoadingStats = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        
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
          body: CustomScrollView(
            slivers: [
              _buildProfileHeader(user),
              
              SliverPadding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildUserInfo(user),
                    
                    const SizedBox(height: AppDimensions.xl),
                    
                    _buildAcademicInfo(user),
                    
                    const SizedBox(height: AppDimensions.xl),
                    
                    _buildSettingsSection(),
                    
                    const SizedBox(height: AppDimensions.xl),
                    
                    _buildAppInfo(),
                    
                    const SizedBox(height: AppDimensions.xl),
                    
                    _buildLogoutButton(authProvider),
                    
                    const SizedBox(height: AppDimensions.xxl),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.surface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.background,
                    child: Icon(
                      _getUserIcon(user.userType),
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.md),
                  
                  CustomTypography.h5(
                    text: user.name,
                    color: AppColors.background,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppDimensions.xs),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: CustomTypography.bodyMedium(
                      text: user.userType.displayName,
                      color: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Informações Pessoais',
          subtitle: 'Seus dados cadastrais',
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        _buildInfoCard([
          _buildInfoItem(
            icon: Icons.email,
            label: 'Email',
            value: user.email,
          ),
          _buildInfoItem(
            icon: Icons.badge,
            label: user.userType == UserType.student 
                ? 'Matrícula' 
                : user.userType == UserType.teacher 
                    ? 'Registro' 
                    : 'ID',
            value: _getUserId(user),
          ),
          if (user.phoneNumber?.isNotEmpty == true)
            _buildInfoItem(
              icon: Icons.phone,
              label: 'Telefone',
              value: user.phoneNumber!,
            ),
        ]),
      ],
    );
  }

  Widget _buildAcademicInfo(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Informações Acadêmicas',
          subtitle: 'Dados relacionados aos estudos/ensino',
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        if (user.userType == UserType.student)
          _buildStudentAcademicInfo(user)
        else if (user.userType == UserType.teacher)
          _buildTeacherAcademicInfo(user)
        else
          _buildAdminAcademicInfo(),
      ],
    );
  }

  Widget _buildStudentAcademicInfo(UserModel user) {
    if (_isLoadingStats) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final stats = _userStats!;
    return _buildInfoCard([
      _buildInfoItem(
        icon: Icons.class_,
        label: 'Turma',
        value: '3º Ano A',
      ),
      _buildInfoItem(
        icon: Icons.school,
        label: 'Matérias',
        value: '${stats['totalClasses']} matérias',
      ),
      _buildInfoItem(
        icon: Icons.trending_up,
        label: 'Média Geral',
        value: stats['averageGrade'].toString(),
        valueColor: AppColors.success,
      ),
      _buildInfoItem(
        icon: Icons.assignment,
        label: 'Atividades Pendentes',
        value: '${stats['pendingAssignments']} atividades',
        valueColor: stats['pendingAssignments'] > 0 ? AppColors.warning : AppColors.success,
      ),
      _buildInfoItem(
        icon: Icons.check_circle,
        label: 'Frequência',
        value: '${stats['attendance']}%',
        valueColor: AppColors.info,
      ),
    ]);
  }

  Widget _buildTeacherAcademicInfo(UserModel user) {
    if (_isLoadingStats) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final stats = _userStats!;
    return _buildInfoCard([
      _buildInfoItem(
        icon: Icons.subject,
        label: 'Disciplinas',
        value: user.subjects.join(', '),
      ),
      _buildInfoItem(
        icon: Icons.groups,
        label: 'Turmas Ativas',
        value: '${stats['totalClasses']} turmas',
      ),
      _buildInfoItem(
        icon: Icons.people,
        label: 'Total de Alunos',
        value: '${stats['totalStudents']} alunos',
      ),
      _buildInfoItem(
        icon: Icons.announcement,
        label: 'Avisos Publicados',
        value: '${stats['totalAnnouncements']} avisos',
      ),
      _buildInfoItem(
        icon: Icons.assignment,
        label: 'Atividades Ativas',
        value: '${stats['activeAssignments']} atividades',
      ),
    ]);
  }

  Widget _buildAdminAcademicInfo() {
    if (_isLoadingStats) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final stats = _userStats!;
    return _buildInfoCard([
      _buildInfoItem(
        icon: Icons.school,
        label: 'Total de Alunos',
        value: '${stats['totalStudents']} alunos',
      ),
      _buildInfoItem(
        icon: Icons.person,
        label: 'Total de Professores',
        value: '${stats['totalTeachers']} professores',
      ),
      _buildInfoItem(
        icon: Icons.class_,
        label: 'Total de Turmas',
        value: '${stats['totalClasses']} turmas',
      ),
      _buildInfoItem(
        icon: Icons.analytics,
        label: 'Sistema Ativo',
        value: stats['systemUptime'],
        valueColor: AppColors.success,
      ),
      _buildInfoItem(
        icon: Icons.admin_panel_settings,
        label: 'Usuários Ativos',
        value: '${stats['activeUsers']} usuários',
        valueColor: AppColors.info,
      ),
    ]);
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Configurações',
          subtitle: 'Personalize sua experiência',
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        _buildMenuCard([
          _buildMenuItem(
            icon: Icons.edit,
            title: 'Editar Perfil',
            subtitle: 'Alterar informações pessoais',
            onTap: () {
              _showComingSoon(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.security,
            title: 'Segurança',
            subtitle: 'Alterar senha e configurações de segurança',
            onTap: () {
              _showSecurityDialog(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.notifications,
            title: 'Notificações',
            subtitle: 'Configurar alertas e lembretes',
            onTap: () {
              _showNotificationSettings(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.dark_mode,
            title: 'Aparência',
            subtitle: 'Tema e configurações visuais',
            onTap: () {
              _showComingSoon(context);
            },
          ),
        ]),
      ],
    );
  }

  Widget _buildAppInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Sobre o App',
          subtitle: 'Informações e suporte',
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        _buildMenuCard([
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Central de Ajuda',
            subtitle: 'FAQ e tutoriais',
            onTap: () {
              _showComingSoon(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.feedback,
            title: 'Enviar Feedback',
            subtitle: 'Compartilhe sua opinião',
            onTap: () {
              _showComingSoon(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'Sobre o Potea Edu',
            subtitle: 'Versão 1.0.0 • Sistema Educacional',
            onTap: () {
              _showAboutDialog(context);
            },
          ),
          _buildMenuItem(
            icon: Icons.privacy_tip,
            title: 'Política de Privacidade',
            subtitle: 'Como protegemos seus dados',
            onTap: () {
              _showComingSoon(context);
            },
          ),
        ]),
      ],
    );
  }

  Widget _buildLogoutButton(AuthProvider authProvider) {
    return CustomButton(
      text: 'Sair da Conta',
      onPressed: () {
        _showLogoutDialog(context, authProvider);
      },
      icon: Icons.logout,
      variant: CustomButtonVariant.outlined,
      size: CustomButtonSize.large,
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          
          return Column(
            children: [
              child,
              if (index < children.length - 1)
                const Divider(
                  color: AppColors.divider,
                  height: 1,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          
          return Column(
            children: [
              child,
              if (index < children.length - 1)
                const Divider(
                  color: AppColors.divider,
                  height: 1,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
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
          
          const SizedBox(width: AppDimensions.md),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTypography.bodySmall(
                  text: label,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppDimensions.xs),
                CustomTypography.bodyMedium(
                  text: value,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: AppColors.textSecondary,
                  size: AppDimensions.iconSizeMd,
                ),
              ),
              
              const SizedBox(width: AppDimensions.md),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTypography.bodyMedium(
                      text: title,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    CustomTypography.bodySmall(
                      text: subtitle,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: AppDimensions.iconSizeSm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getUserIcon(UserType userType) {
    switch (userType) {
      case UserType.student:
        return Icons.school;
      case UserType.teacher:
        return Icons.person;
      case UserType.admin:
        return Icons.admin_panel_settings;
    }
  }

  String _getUserId(UserModel user) {
    switch (user.userType) {
      case UserType.student:
        return 'ALU001';
      case UserType.teacher:
        return 'PROF001';
      case UserType.admin:
        return 'ADM001';
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Funcionalidade em desenvolvimento!',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.background,
          ),
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: Row(
          children: [
            Icon(
              Icons.school,
              color: AppColors.primary,
              size: AppDimensions.iconSizeLg,
            ),
            const SizedBox(width: AppDimensions.md),
            CustomTypography.h6(
              text: 'Potea Edu',
              color: AppColors.textPrimary,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTypography.bodyMedium(
              text: 'Sistema de Gestão Educacional',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.md),
            CustomTypography.bodyMedium(
              text: 'Versão: 1.0.0',
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppDimensions.sm),
            CustomTypography.bodyMedium(
              text: 'Desenvolvido com Flutter',
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppDimensions.sm),
            CustomTypography.bodyMedium(
              text: '© 2024 Potea Education',
              color: AppColors.textSecondary,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: CustomTypography.bodyMedium(
              text: 'Fechar',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: CustomTypography.h6(
          text: 'Confirmar Saída',
          color: AppColors.textPrimary,
        ),
        content: CustomTypography.bodyMedium(
          text: 'Tem certeza que deseja sair da sua conta?',
          color: AppColors.textSecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: CustomTypography.bodyMedium(
              text: 'Cancelar',
              color: AppColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              authProvider.logout();
            },
            child: CustomTypography.bodyMedium(
              text: 'Sair',
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: CustomTypography.h6(
          text: 'Configurações de Segurança',
          color: AppColors.textPrimary,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock, color: AppColors.primary),
              title: const CustomTypography.bodyMedium(
                text: 'Alterar Senha',
                color: AppColors.textPrimary,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _navigateToChangePassword(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: AppColors.primary),
              title: const CustomTypography.bodyMedium(
                text: 'Histórico de Login',
                color: AppColors.textPrimary,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showLoginHistory(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: AppColors.primary),
              title: const CustomTypography.bodyMedium(
                text: 'Autenticação em Duas Etapas',
                color: AppColors.textPrimary,
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showComingSoon(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: CustomTypography.h6(
          text: 'Configurações de Notificação',
          color: AppColors.textPrimary,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const CustomTypography.bodyMedium(
                text: 'Avisos de Professores',
                color: AppColors.textPrimary,
              ),
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
            SwitchListTile(
              title: const CustomTypography.bodyMedium(
                text: 'Lembretes de Atividades',
                color: AppColors.textPrimary,
              ),
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
            SwitchListTile(
              title: const CustomTypography.bodyMedium(
                text: 'Eventos do Calendário',
                color: AppColors.textPrimary,
              ),
              value: false,
              onChanged: (value) {},
              activeColor: AppColors.primary,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: CustomTypography.bodyMedium(
              text: 'Fechar',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
    );
  }

  void _showLoginHistory(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      final activities = _userService.getUserActivity(user.id);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          title: CustomTypography.h6(
            text: 'Histórico de Atividades',
            color: AppColors.textPrimary,
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ListTile(
                  leading: Icon(
                    _getActivityIcon(activity['action']),
                    color: AppColors.primary,
                  ),
                  title: CustomTypography.bodyMedium(
                    text: activity['action'],
                    color: AppColors.textPrimary,
                  ),
                  subtitle: CustomTypography.bodySmall(
                    text: '${activity['details']}\n${_formatDateTime(activity['timestamp'])}',
                    color: AppColors.textSecondary,
                  ),
                  trailing: CustomTypography.bodySmall(
                    text: activity['ip'],
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: CustomTypography.bodyMedium(
                text: 'Fechar',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }
  }

  IconData _getActivityIcon(String action) {
    switch (action.toLowerCase()) {
      case 'login':
        return Icons.login;
      case 'logout':
        return Icons.logout;
      case 'profile update':
        return Icons.edit;
      case 'password change':
        return Icons.lock;
      default:
        return Icons.history;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} às ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

