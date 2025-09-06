import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:potea_edu/constants/app_colors.dart';
import 'package:potea_edu/constants/app_text_styles.dart';
import 'package:potea_edu/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../providers/announcement_provider.dart';
import '../../models/announcement_model.dart';
import '../../models/user_model.dart';
import '../../components/atoms/custom_typography.dart';
import '../announcements/create_announcement_screen.dart';

/// Aba de Avisos - Sistema de comunicação dos professores para alunos
class AnnouncementsTab extends StatefulWidget {
  const AnnouncementsTab({super.key});

  @override
  State<AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<AnnouncementsTab> {
  final String _searchQuery = '';
  AnnouncementType? _filterType;
  AnnouncementPriority? _filterPriority;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnnouncementProvider>().loadAnnouncements();
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(user),
            
            // Search and Filters
            _buildSearchAndFilters(),
            
            // Content
            Expanded(
              child: _buildContent(user),
            ),
          ],
        ),
      ),
      // Floating Action Button for Teachers
      floatingActionButton: user.userType == UserType.teacher 
          ? FloatingActionButton(
              onPressed: () => _createAnnouncement(context),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildHeader(user) {
    final announcementProvider = context.watch<AnnouncementProvider>();
    final unreadCount = announcementProvider.getUnreadCount(user);
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Avisos',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: AppDimensions.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm,
                          vertical: AppDimensions.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                        ),
                        child: CustomTypography.caption(
                          text: unreadCount.toString(),
                          color: AppColors.background,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDimensions.xs),
                Text(
                  user.userType == UserType.teacher 
                      ? 'Gerencie seus avisos' 
                      : 'Comunicados importantes dos professores',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => _showFilters(context),
                icon: Icon(
                  Icons.filter_list,
                  color: (_filterType != null || _filterPriority != null) 
                      ? AppColors.primary 
                      : AppColors.textSecondary,
                ),
                tooltip: 'Filtros',
              ),
              IconButton(
                onPressed: () => context.read<AnnouncementProvider>().refresh(),
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.primary,
                ),
                tooltip: 'Atualizar',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                // Note: _searchQuery is final, so we can't modify it
                // This is a placeholder for search functionality
              },
              decoration: InputDecoration(
                hintText: 'Buscar avisos...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: AppDimensions.sm,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          IconButton(
            onPressed: () => _showFilters(context),
            icon: Icon(
              Icons.tune,
              color: (_filterType != null || _filterPriority != null)
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
            tooltip: 'Filtros avançados',
          ),
        ],
      ),
    );
  }

  Widget _buildContent(user) {
    return Consumer<AnnouncementProvider>(
      builder: (context, announcementProvider, child) {
        if (announcementProvider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: AppDimensions.md),
                CustomTypography.bodyMedium(
                  text: 'Carregando avisos...',
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          );
        }

        if (announcementProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppDimensions.md),
                CustomTypography.bodyLarge(
                  text: 'Erro ao carregar avisos',
                  color: AppColors.error,
                ),
                const SizedBox(height: AppDimensions.sm),
                CustomTypography.bodyMedium(
                  text: announcementProvider.error!,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppDimensions.lg),
                ElevatedButton(
                  onPressed: () => announcementProvider.refresh(),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        var announcements = announcementProvider.getAnnouncementsForUser(user);
        
        // Apply filters
        if (_filterType != null) {
          announcements = announcementProvider.filterByType(announcements, _filterType!);
        }
        if (_filterPriority != null) {
          announcements = announcementProvider.filterByPriority(announcements, _filterPriority!);
        }
        
        // Apply search
        if (_searchQuery.isNotEmpty) {
          announcements = announcementProvider.searchAnnouncements(announcements, _searchQuery);
        }

        if (announcements.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.announcement_outlined,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppDimensions.md),
                CustomTypography.h6(
                  text: 'Nenhum aviso encontrado',
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppDimensions.sm),
                CustomTypography.bodyMedium(
                  text: 'Tente ajustar os filtros ou aguarde novos avisos',
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => announcementProvider.refresh(),
          color: AppColors.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.lg),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              return _buildAnnouncementCard(announcements[index], user);
            },
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementCard(AnnouncementModel announcement, user) {
    return GestureDetector(
      onTap: () => _showAnnouncementDetails(context, announcement, user),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border(
            left: BorderSide(
              color: _getPriorityColor(announcement.priority),
              width: 4,
            ),
          ),
          boxShadow: AppDimensions.shadowSm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do aviso
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.xs),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(announcement.priority).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Icon(
                      _getPriorityIcon(announcement.priority),
                      size: AppDimensions.iconSizeSm,
                      color: _getPriorityColor(announcement.priority),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.title,
                          style: AppTextStyles.h6.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Por ${announcement.teacherName} • ${announcement.className ?? "Turma"}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(announcement.priority).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Text(
                      _getPriorityText(announcement.priority),
                      style: AppTextStyles.caption.copyWith(
                        color: _getPriorityColor(announcement.priority),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.md),
              
              // Conteúdo do aviso (preview)
              Text(
                announcement.content.length > 150 
                    ? '${announcement.content.substring(0, 150)}...'
                    : announcement.content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: AppDimensions.md),
              
              // Footer com data e ações
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: AppDimensions.iconSizeSm,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppDimensions.xs),
                      Text(
                        announcement.timeAgo,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (announcement.attachmentUrls.isNotEmpty) ...[
                        const SizedBox(width: AppDimensions.md),
                        const Icon(
                          Icons.attach_file,
                          size: AppDimensions.iconSizeSm,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppDimensions.xs),
                        const Text(
                          'Anexos',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (user.userType == UserType.teacher && announcement.teacherId == user.id)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.info),
                          onPressed: () => _editAnnouncement(context, announcement),
                          tooltip: 'Editar',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.error),
                          onPressed: () => _deleteAnnouncement(context, announcement),
                          tooltip: 'Excluir',
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.urgent:
        return AppColors.error;
      case AnnouncementPriority.high:
        return AppColors.warning;
      case AnnouncementPriority.medium:
        return AppColors.info;
      case AnnouncementPriority.low:
        return AppColors.success;
    }
  }

  IconData _getPriorityIcon(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.urgent:
        return Icons.warning;
      case AnnouncementPriority.high:
        return Icons.priority_high;
      case AnnouncementPriority.medium:
        return Icons.info;
      case AnnouncementPriority.low:
        return Icons.check_circle;
    }
  }

  String _getPriorityText(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.urgent:
        return 'URGENTE';
      case AnnouncementPriority.high:
        return 'ALTA';
      case AnnouncementPriority.medium:
        return 'MÉDIA';
      case AnnouncementPriority.low:
        return 'BAIXA';
    }
  }

  // Action methods
  void _createAnnouncement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAnnouncementScreen(),
      ),
    );
  }

  void _editAnnouncement(BuildContext context, AnnouncementModel announcement) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAnnouncementScreen(
          editingAnnouncement: announcement,
        ),
      ),
    );
  }

  void _deleteAnnouncement(BuildContext context, AnnouncementModel announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const CustomTypography.h6(
          text: 'Excluir Aviso',
          color: AppColors.textPrimary,
        ),
        content: const CustomTypography.bodyMedium(
          text: 'Tem certeza que deseja excluir este aviso? Esta ação não pode ser desfeita.',
          color: AppColors.textSecondary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CustomTypography.bodyMedium(
              text: 'Cancelar',
              color: AppColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              navigator.pop();
              final success = await context.read<AnnouncementProvider>().deleteAnnouncement(announcement.id);
              if (success && mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Aviso excluído com sucesso!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const CustomTypography.bodyMedium(
              text: 'Excluir',
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDetails(BuildContext context, AnnouncementModel announcement, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: CustomTypography.h6(
          text: announcement.title,
          color: AppColors.textPrimary,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(announcement.priority).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: CustomTypography.caption(
                      text: _getPriorityText(announcement.priority),
                      color: _getPriorityColor(announcement.priority),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: CustomTypography.caption(
                      text: announcement.type.displayName,
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              CustomTypography.bodyMedium(
                text: announcement.content,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppDimensions.md),
              CustomTypography.bodySmall(
                text: 'Por ${announcement.teacherName}',
                color: AppColors.textSecondary,
              ),
              CustomTypography.bodySmall(
                text: 'Publicado ${announcement.timeAgo}',
                color: AppColors.textSecondary,
              ),
              if (announcement.expiresAt != null)
                CustomTypography.bodySmall(
                  text: 'Expira em ${_formatDate(announcement.expiresAt!)}',
                  color: AppColors.warning,
                ),
            ],
          ),
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

  void _showFilters(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const CustomTypography.h6(
          text: 'Filtros',
          color: AppColors.textPrimary,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<AnnouncementType?>(
              value: _filterType,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<AnnouncementType?>(
                  value: null,
                  child: Text('Todos os tipos'),
                ),
                ...AnnouncementType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }),
              ],
              onChanged: (type) {
                setState(() {
                  _filterType = type;
                });
              },
            ),
            const SizedBox(height: AppDimensions.md),
            DropdownButtonFormField<AnnouncementPriority?>(
              value: _filterPriority,
              decoration: const InputDecoration(
                labelText: 'Prioridade',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<AnnouncementPriority?>(
                  value: null,
                  child: Text('Todas as prioridades'),
                ),
                ...AnnouncementPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.displayName),
                  );
                }),
              ],
              onChanged: (priority) {
                setState(() {
                  _filterPriority = priority;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _filterType = null;
                _filterPriority = null;
              });
              Navigator.of(context).pop();
            },
            child: const CustomTypography.bodyMedium(
              text: 'Limpar',
              color: AppColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CustomTypography.bodyMedium(
              text: 'Aplicar',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}