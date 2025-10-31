import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../components/atoms/custom_button.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/molecules/section_title.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phoneNumber ?? '';
    }

    // Add listeners to detect changes
    _nameController.addListener(_onDataChanged);
    _emailController.addListener(_onDataChanged);
    _phoneController.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    setState(() {
      _hasChanges = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const CustomTypography.h6(
          text: 'Editar Perfil',
          color: AppColors.textPrimary,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            if (_hasChanges) {
              _showDiscardChangesDialog();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveChanges,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const CustomTypography.bodyMedium(
                      text: 'Salvar',
                      color: AppColors.primary,
                    ),
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
              // Profile Picture Section
              _buildProfilePictureSection(user),

              const SizedBox(height: AppDimensions.xl),

              // Personal Information Section
              const SectionTitle(
                title: 'Informações Pessoais',
                subtitle: 'Atualize seus dados básicos',
              ),

              const SizedBox(height: AppDimensions.lg),

              _buildPersonalInfoForm(),

              const SizedBox(height: AppDimensions.xl),

              // Account Information Section
              _buildAccountInfoSection(),

              const SizedBox(height: AppDimensions.xl),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(user) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.surface,
                child: Icon(
                  _getUserIcon(user?.userType),
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _changeProfilePicture,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.background,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          CustomTypography.bodyMedium(
            text: 'Alterar foto do perfil',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoForm() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nome Completo',
              prefixIcon: const Icon(Icons.person, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nome é obrigatório';
              }
              if (value.trim().length < 3) {
                return 'Nome deve ter pelo menos 3 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.lg),

          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email é obrigatório';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Email inválido';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.lg),

          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Telefone',
              prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection() {
    final user = context.read<AuthProvider>().currentUser;

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
          const CustomTypography.h6(
            text: 'Informações da Conta',
            color: AppColors.textPrimary,
          ),

          const SizedBox(height: AppDimensions.lg),

          _buildReadOnlyField(
            label: 'Tipo de Usuário',
            value: user?.userType.displayName ?? 'N/A',
            icon: Icons.badge,
          ),

          const SizedBox(height: AppDimensions.md),

          _buildReadOnlyField(
            label: 'ID do Usuário',
            value: user?.id ?? 'N/A',
            icon: Icons.fingerprint,
          ),

          const SizedBox(height: AppDimensions.md),

          _buildReadOnlyField(
            label: 'Membro desde',
            value: user != null
                ? '${user.createdAt.day.toString().padLeft(2, '0')}/${user.createdAt.month.toString().padLeft(2, '0')}/${user.createdAt.year}'
                : 'N/A',
            icon: Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTypography.bodySmall(
                text: label,
                color: AppColors.textSecondary,
              ),
              CustomTypography.bodyMedium(
                text: value,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomButton(
          text: 'Alterar Senha',
          onPressed: _changePassword,
          icon: Icons.lock,
          variant: CustomButtonVariant.outlined,
          size: CustomButtonSize.large,
        ),

        const SizedBox(height: AppDimensions.md),

        CustomButton(
          text: 'Histórico de Atividades',
          onPressed: _viewActivityLog,
          icon: Icons.history,
          variant: CustomButtonVariant.outlined,
          size: CustomButtonSize.large,
        ),
      ],
    );
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

  void _changeProfilePicture() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Seleção de foto em desenvolvimento!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _changePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  void _viewActivityLog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ActivityLogScreen()),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;
      if (user != null) {
        final updatedUser = user.copyWith(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          updatedAt: DateTime.now(),
        );

        final success = await authProvider.updateUser(updatedUser);

        if (success && mounted) {
          final navigator = Navigator.of(context);
          final scaffoldMessenger = ScaffoldMessenger.of(context);

          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: AppColors.success,
            ),
          );

          setState(() {
            _hasChanges = false;
          });

          navigator.pop();
        } else {
          throw Exception('Falha ao atualizar perfil');
        }
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

  void _showDiscardChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const CustomTypography.h6(
          text: 'Descartar Alterações?',
          color: AppColors.textPrimary,
        ),
        content: const CustomTypography.bodyMedium(
          text: 'Você tem alterações não salvas. Deseja descartá-las?',
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
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const CustomTypography.bodyMedium(
              text: 'Descartar',
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder screens for navigation
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Alterar Senha'),
        backgroundColor: AppColors.surface,
      ),
      body: const Center(
        child: CustomTypography.h6(
          text: 'Tela de Alteração de Senha\n(Em desenvolvimento)',
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Histórico de Atividades'),
        backgroundColor: AppColors.surface,
      ),
      body: const Center(
        child: CustomTypography.h6(
          text: 'Histórico de Atividades\n(Em desenvolvimento)',
          color: AppColors.textSecondary,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
