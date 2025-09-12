import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_dimensions.dart';
import '../../providers/announcement_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/announcement_model.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/atoms/custom_button.dart';
import '../../components/atoms/custom_text_field.dart';
import '../../components/molecules/section_title.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  final AnnouncementModel? editingAnnouncement;

  const CreateAnnouncementScreen({super.key, this.editingAnnouncement});

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  AnnouncementType _selectedType = AnnouncementType.general;
  AnnouncementPriority _selectedPriority = AnnouncementPriority.medium;
  String? _selectedClass;
  DateTime? _expiresAt;
  bool _isLoading = false;

  final List<String> _availableClasses = [
    'Todas as turmas',
    '3º Ano A',
    '3º Ano B',
    '2º Ano A',
    '2º Ano B',
    '1º Ano A',
    '1º Ano B',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editingAnnouncement != null) {
      _loadExistingData();
    }
    _selectedClass = _availableClasses.first;
  }

  void _loadExistingData() {
    final announcement = widget.editingAnnouncement!;
    _titleController.text = announcement.title;
    _contentController.text = announcement.content;
    _selectedType = announcement.type;
    _selectedPriority = announcement.priority;
    _selectedClass = announcement.className ?? _availableClasses.first;
    _expiresAt = announcement.expiresAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editingAnnouncement != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: CustomTypography.h6(
          text: isEditing ? 'Editar Aviso' : 'Criar Aviso',
          color: AppColors.textPrimary,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: _showDeleteConfirmation,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              const SectionTitle(
                title: 'Informações Básicas',
                subtitle: 'Preencha os dados do aviso',
              ),

              const SizedBox(height: AppDimensions.lg),

              _buildBasicInfoForm(),

              const SizedBox(height: AppDimensions.xl),

              // Configuration Section
              const SectionTitle(
                title: 'Configurações',
                subtitle: 'Defina prioridade e destinatários',
              ),

              const SizedBox(height: AppDimensions.lg),

              _buildConfigurationForm(),

              const SizedBox(height: AppDimensions.xl),

              // Action Buttons
              _buildActionButtons(isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoForm() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _titleController,
            label: 'Título do Aviso',
            hint: 'Ex: Prova de Matemática',
            prefixIcon: Icons.title,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Título é obrigatório';
              }
              if (value.trim().length < 5) {
                return 'Título deve ter pelo menos 5 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.lg),

          CustomTextField(
            controller: _contentController,
            label: 'Conteúdo do Aviso',
            hint: 'Descreva os detalhes do aviso...',
            prefixIcon: Icons.description,
            maxLines: 6,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Conteúdo é obrigatório';
              }
              if (value.trim().length < 10) {
                return 'Conteúdo deve ter pelo menos 10 caracteres';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationForm() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Selection
          const CustomTypography.h6(
            text: 'Tipo de Aviso',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.sm),
          DropdownButtonFormField<AnnouncementType>(
            value: _selectedType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            items: AnnouncementType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Icon(_getTypeIcon(type), color: AppColors.primary),
                    const SizedBox(width: AppDimensions.sm),
                    Text(type.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (type) {
              setState(() {
                _selectedType = type!;
              });
            },
          ),

          const SizedBox(height: AppDimensions.lg),

          // Priority Selection
          const CustomTypography.h6(
            text: 'Prioridade',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.sm),
          DropdownButtonFormField<AnnouncementPriority>(
            value: _selectedPriority,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            items: AnnouncementPriority.values.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(priority.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (priority) {
              setState(() {
                _selectedPriority = priority!;
              });
            },
          ),

          const SizedBox(height: AppDimensions.lg),

          // Class Selection
          const CustomTypography.h6(
            text: 'Destinatários',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.sm),
          DropdownButtonFormField<String>(
            value: _selectedClass,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
            ),
            items: _availableClasses.map((className) {
              return DropdownMenuItem(
                value: className,
                child: Row(
                  children: [
                    Icon(
                      className == 'Todas as turmas'
                          ? Icons.public
                          : Icons.group,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(className),
                  ],
                ),
              );
            }).toList(),
            onChanged: (className) {
              setState(() {
                _selectedClass = className;
              });
            },
          ),

          const SizedBox(height: AppDimensions.lg),

          // Expiration Date
          ListTile(
            leading: const Icon(Icons.event, color: AppColors.primary),
            title: const CustomTypography.bodyMedium(
              text: 'Data de Expiração (Opcional)',
              color: AppColors.textPrimary,
            ),
            subtitle: CustomTypography.bodySmall(
              text: _expiresAt != null
                  ? 'Expira em ${_formatDate(_expiresAt!)}'
                  : 'Nenhuma data definida',
              color: AppColors.textSecondary,
            ),
            trailing: IconButton(
              icon: Icon(
                _expiresAt != null ? Icons.clear : Icons.add,
                color: AppColors.primary,
              ),
              onPressed: _expiresAt != null
                  ? _clearExpirationDate
                  : _selectExpirationDate,
            ),
            onTap: _selectExpirationDate,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isEditing) {
    return Column(
      children: [
        CustomButton(
          text: isEditing ? 'Atualizar Aviso' : 'Publicar Aviso',
          onPressed: _isLoading ? null : _saveAnnouncement,
          icon: isEditing ? Icons.update : Icons.publish,
          size: CustomButtonSize.large,
          isLoading: _isLoading,
        ),

        const SizedBox(height: AppDimensions.md),

        CustomButton(
          text: 'Cancelar',
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          variant: CustomButtonVariant.outlined,
          size: CustomButtonSize.large,
        ),
      ],
    );
  }

  IconData _getTypeIcon(AnnouncementType type) {
    switch (type) {
      case AnnouncementType.general:
        return Icons.announcement;
      case AnnouncementType.homework:
        return Icons.assignment;
      case AnnouncementType.exam:
        return Icons.quiz;
      case AnnouncementType.event:
        return Icons.event;
      case AnnouncementType.reminder:
        return Icons.access_time;
      case AnnouncementType.urgent:
        return Icons.priority_high;
    }
  }

  Color _getPriorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.low:
        return AppColors.success;
      case AnnouncementPriority.medium:
        return AppColors.info;
      case AnnouncementPriority.high:
        return AppColors.warning;
      case AnnouncementPriority.urgent:
        return AppColors.error;
    }
  }

  Future<void> _selectExpirationDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expiresAt ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _expiresAt = date;
      });
    }
  }

  void _clearExpirationDate() {
    setState(() {
      _expiresAt = null;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _saveAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = context.read<AuthProvider>().currentUser!;
      final announcementProvider = context.read<AnnouncementProvider>();

      final announcement = AnnouncementModel(
        id:
            widget.editingAnnouncement?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        teacherId: user.id,
        teacherName: user.name,
        classId: _selectedClass == 'Todas as turmas' ? null : _selectedClass,
        className: _selectedClass,
        priority: _selectedPriority,
        type: _selectedType,
        createdAt: widget.editingAnnouncement?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        expiresAt: _expiresAt,
      );

      bool success;
      if (widget.editingAnnouncement != null) {
        success = await announcementProvider.updateAnnouncement(announcement);
      } else {
        success = await announcementProvider.createAnnouncement(announcement);
      }

      if (success && mounted) {
        final navigator = Navigator.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              widget.editingAnnouncement != null
                  ? 'Aviso atualizado com sucesso!'
                  : 'Aviso publicado com sucesso!',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        navigator.pop();
      } else {
        throw Exception('Falha ao salvar aviso');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const CustomTypography.h6(
          text: 'Excluir Aviso',
          color: AppColors.textPrimary,
        ),
        content: const CustomTypography.bodyMedium(
          text:
              'Tem certeza que deseja excluir este aviso? Esta ação não pode ser desfeita.',
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
            onPressed: _deleteAnnouncement,
            child: const CustomTypography.bodyMedium(
              text: 'Excluir',
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAnnouncement() async {
    Navigator.of(context).pop(); // Close dialog

    setState(() {
      _isLoading = true;
    });

    try {
      final announcementProvider = context.read<AnnouncementProvider>();
      final success = await announcementProvider.deleteAnnouncement(
        widget.editingAnnouncement!.id,
      );

      if (success && mounted) {
        final navigator = Navigator.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Aviso excluído com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
        navigator.pop();
      } else {
        throw Exception('Falha ao excluir aviso');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
