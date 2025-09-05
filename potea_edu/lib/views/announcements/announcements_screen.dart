import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/molecules/info_card.dart';
import '../../models/announcement_model.dart';
import '../../services/announcement_service.dart';
import '../../providers/auth_provider.dart';

/// Tela de avisos/anúncios
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen>
    with TickerProviderStateMixin {
  final AnnouncementService _announcementService = AnnouncementService();
  late TabController _tabController;
  
  List<AnnouncementModel> _allAnnouncements = [];
  List<AnnouncementModel> _urgentAnnouncements = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAnnouncements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = context.read<AuthProvider>().currentUser;
      
      final [allAnnouncements, urgentAnnouncements] = await Future.wait([
        _announcementService.getAnnouncements(user: user),
        _announcementService.getUrgentAnnouncements(user: user),
      ]);

      setState(() {
        _allAnnouncements = allAnnouncements;
        _urgentAnnouncements = urgentAnnouncements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar avisos: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const CustomTypography.h5(
          text: 'Avisos',
          color: AppColors.textPrimary,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadAnnouncements,
            tooltip: 'Atualizar',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(
              icon: const Icon(Icons.announcement),
              text: 'Todos',
              iconMargin: const EdgeInsets.only(bottom: 4),
            ),
            Tab(
              icon: Stack(
                children: [
                  const Icon(Icons.priority_high),
                  if (_urgentAnnouncements.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${_urgentAnnouncements.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              text: 'Urgentes',
              iconMargin: const EdgeInsets.only(bottom: 4),
            ),
            const Tab(
              icon: Icon(Icons.filter_list),
              text: 'Filtros',
              iconMargin: EdgeInsets.only(bottom: 4),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllAnnouncementsTab(),
          _buildUrgentAnnouncementsTab(),
          _buildFiltersTab(),
        ],
      ),
    );
  }

  Widget _buildAllAnnouncementsTab() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_allAnnouncements.isEmpty) {
      return _buildEmptyState('Nenhum aviso encontrado');
    }

    return RefreshIndicator(
      onRefresh: _loadAnnouncements,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.lg),
        itemCount: _allAnnouncements.length,
        itemBuilder: (context, index) {
          return _buildAnnouncementCard(_allAnnouncements[index]);
        },
      ),
    );
  }

  Widget _buildUrgentAnnouncementsTab() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_urgentAnnouncements.isEmpty) {
      return _buildEmptyState('Nenhum aviso urgente');
    }

    return RefreshIndicator(
      onRefresh: _loadAnnouncements,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.lg),
        itemCount: _urgentAnnouncements.length,
        itemBuilder: (context, index) {
          return _buildAnnouncementCard(_urgentAnnouncements[index]);
        },
      ),
    );
  }

  Widget _buildFiltersTab() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTypography.h6(
            text: 'Filtrar por Tipo',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.md),
          
          _buildFilterButton(
            'Geral',
            Icons.announcement,
            () => _filterByType(AnnouncementType.general),
          ),
          _buildFilterButton(
            'Tarefas',
            Icons.assignment,
            () => _filterByType(AnnouncementType.homework),
          ),
          _buildFilterButton(
            'Provas',
            Icons.quiz,
            () => _filterByType(AnnouncementType.exam),
          ),
          _buildFilterButton(
            'Eventos',
            Icons.event,
            () => _filterByType(AnnouncementType.event),
          ),
          _buildFilterButton(
            'Lembretes',
            Icons.access_time,
            () => _filterByType(AnnouncementType.reminder),
          ),
          
          const SizedBox(height: AppDimensions.xl),
          
          const CustomTypography.h6(
            text: 'Filtrar por Prioridade',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.md),
          
          _buildFilterButton(
            'Baixa',
            Icons.keyboard_arrow_down,
            () => _filterByPriority(AnnouncementPriority.low),
          ),
          _buildFilterButton(
            'Média',
            Icons.remove,
            () => _filterByPriority(AnnouncementPriority.medium),
          ),
          _buildFilterButton(
            'Alta',
            Icons.keyboard_arrow_up,
            () => _filterByPriority(AnnouncementPriority.high),
          ),
          _buildFilterButton(
            'Urgente',
            Icons.priority_high,
            () => _filterByPriority(AnnouncementPriority.urgent),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: InfoCard(
        title: text,
        icon: icon,
        iconColor: AppColors.primary,
        onTap: onPressed,
        showShadow: false,
        showBorder: true,
      ),
    );
  }

  Widget _buildAnnouncementCard(AnnouncementModel announcement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border(
            left: BorderSide(
              width: 4,
              color: announcement.priorityColor,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.overlay,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    announcement.typeIcon,
                    color: announcement.priorityColor,
                    size: AppDimensions.iconSizeMd,
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: CustomTypography.h6(
                      text: announcement.title,
                      color: AppColors.textPrimary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.sm,
                      vertical: AppDimensions.xs,
                    ),
                    decoration: BoxDecoration(
                      color: announcement.priorityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: CustomTypography.caption(
                      text: announcement.priority.displayName,
                      color: announcement.priorityColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.md),
              
              // Content
              CustomTypography.bodyMedium(
                text: announcement.content,
                color: AppColors.textPrimary,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: AppDimensions.md),
              
              // Footer
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: AppDimensions.iconSizeSm,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Expanded(
                    child: CustomTypography.caption(
                      text: announcement.teacherName,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  CustomTypography.caption(
                    text: announcement.timeAgo,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              
              if (announcement.className != null) ...[
                const SizedBox(height: AppDimensions.xs),
                Row(
                  children: [
                    Icon(
                      Icons.class_,
                      size: AppDimensions.iconSizeSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.xs),
                    CustomTypography.caption(
                      text: announcement.className!,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: AppDimensions.lg),
          CustomTypography.bodyMedium(
            text: 'Carregando avisos...',
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: AppDimensions.lg),
          CustomTypography.h6(
            text: 'Erro ao carregar avisos',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.sm),
          CustomTypography.bodyMedium(
            text: _error ?? 'Erro desconhecido',
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.lg),
          ElevatedButton.icon(
            onPressed: _loadAnnouncements,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.announcement_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppDimensions.lg),
          CustomTypography.h6(
            text: message,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.sm),
          const CustomTypography.bodyMedium(
            text: 'Puxe para baixo para atualizar',
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Future<void> _filterByType(AnnouncementType type) async {
    setState(() => _isLoading = true);
    
    try {
      final user = context.read<AuthProvider>().currentUser;
      final filtered = await _announcementService.getAnnouncements(
        user: user,
        type: type,
      );
      
      setState(() {
        _allAnnouncements = filtered;
        _isLoading = false;
      });
      
      _tabController.animateTo(0); // Volta para a aba "Todos"
    } catch (e) {
      setState(() {
        _error = 'Erro ao filtrar: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _filterByPriority(AnnouncementPriority priority) async {
    setState(() => _isLoading = true);
    
    try {
      final user = context.read<AuthProvider>().currentUser;
      final filtered = await _announcementService.getAnnouncements(
        user: user,
        priority: priority,
      );
      
      setState(() {
        _allAnnouncements = filtered;
        _isLoading = false;
      });
      
      _tabController.animateTo(0); // Volta para a aba "Todos"
    } catch (e) {
      setState(() {
        _error = 'Erro ao filtrar: $e';
        _isLoading = false;
      });
    }
  }
}