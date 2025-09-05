import 'package:flutter/material.dart';
// Removido flutter_animate - usando animações nativas
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';
import '../../models/user_model.dart';
import '../home/home_screen.dart';

/// Tela de configuração de perfil para novos usuários
class SetupProfileScreen extends StatefulWidget {
  final UserType userType;

  const SetupProfileScreen({
    super.key,
    required this.userType,
  });

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;

  final List<String> _genderOptions = ['Masculino', 'Feminino', 'Outro', 'Prefiro não informar'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simula um delay de configuração
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Note: Profile data saving planned for demo system
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
      (route) => false,
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 anos atrás
      firstDate: DateTime.now().subtract(const Duration(days: 36500)), // 100 anos atrás
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.background,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Configurar Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.lg),
                
                // Título
                _buildTitle(),
                
                const SizedBox(height: AppDimensions.xxl),
                
                // Foto de perfil
                _buildProfilePhoto(),
                
                const SizedBox(height: AppDimensions.xl),
                
                // Formulário
                _buildForm(),
                
                const SizedBox(height: AppDimensions.xl),
                
                // Botão de conclusão
                _buildCompleteButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói o título da tela
  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configure seu perfil',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        
        const SizedBox(height: AppDimensions.sm),
        
        Text(
          'Complete suas informações para personalizar sua experiência.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Constrói a foto de perfil
  Widget _buildProfilePhoto() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Note: Photo selection feature planned for demo system
              _showPhotoPicker();
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
                border: Border.all(
                  color: AppColors.primary,
                  width: 3,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: AppDimensions.iconSizeXl,
                color: AppColors.primary,
              ),
            ),
          ),
          
          const SizedBox(height: AppDimensions.md),
          
          Text(
            'Toque para adicionar foto',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o formulário
  Widget _buildForm() {
    return Column(
      children: [
        // Campo de nome completo
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nome Completo',
            prefixIcon: Icon(Icons.person_outline),
            hintText: 'Digite seu nome completo',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite seu nome';
            }
            if (value.trim().split(' ').length < 2) {
              return 'Digite seu nome completo';
            }
            return null;
          },
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        // Campo de data de nascimento
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? 'Data de Nascimento: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Data de Nascimento',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _selectedDate != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        // Campo de telefone
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Telefone',
            prefixIcon: Icon(Icons.phone_outlined),
            hintText: 'Digite seu telefone',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite seu telefone';
            }
            if (value.length < 10) {
              return 'Digite um telefone válido';
            }
            return null;
          },
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        // Campo de gênero
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: const InputDecoration(
            labelText: 'Gênero',
            prefixIcon: Icon(Icons.person_outline),
            hintText: 'Selecione seu gênero',
          ),
          items: _genderOptions.map((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecione seu gênero';
            }
            return null;
          },
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        // Informações do tipo de usuário
        Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.userType.isStudent ? Icons.school : Icons.person,
                color: AppColors.primary,
                size: AppDimensions.iconSizeMd,
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo de Usuário',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.userType.displayName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Constrói o botão de conclusão
  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _completeSetup,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.background),
                ),
              )
            : Text(
                'Concluir Configuração',
                style: AppTextStyles.buttonMedium,
              ),
      ),
    );
  }

  /// Mostra o seletor de foto
  void _showPhotoPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selecionar Foto',
                style: AppTextStyles.h5.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: AppDimensions.lg),
              
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  // Note: Camera capture planned for demo system
                  _showComingSoon();
                },
              ),
              
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  // Note: Gallery selection planned for demo system
                  _showComingSoon();
                },
              ),
            ],
          ),
        );
      },
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

