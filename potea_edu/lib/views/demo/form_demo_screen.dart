import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:potea_edu/constants/app_colors.dart';
import 'package:potea_edu/constants/app_dimensions.dart';
import '../../components/atoms/custom_button.dart';
import '../../components/atoms/custom_text_field.dart';
import '../../components/atoms/custom_typography.dart';
import '../../components/molecules/form_field_group.dart';
import '../../components/molecules/section_title.dart';
import '../../providers/auth_provider.dart';

/// Tela de demonstração de formulários com validação
class FormDemoScreen extends StatefulWidget {
  const FormDemoScreen({super.key});

  @override
  State<FormDemoScreen> createState() => _FormDemoScreenState();
}

class _FormDemoScreenState extends State<FormDemoScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _submitController;
  late Animation<double> _submitAnimation;
  
  // Personal info controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Address controllers
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  
  // Other fields
  String? _selectedGender;
  String? _selectedEducation;
  bool _acceptsTerms = false;
  bool _acceptsNewsletter = false;
  
  // Validation errors
  final Map<String, String?> _errors = {};
  
  // Form state
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  @override
  void initState() {
    super.initState();
    
    _submitController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _submitAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _submitController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _submitController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Verifica se o usuário tem permissão para acessar a demo
    if (authProvider.isStudent) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  size: 64,
                  color: AppColors.textSecondary,
                ),
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
                  'Esta funcionalidade de demonstração está disponível apenas para professores e administradores.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.xl,
                      vertical: AppDimensions.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const CustomTypography.h5(
          text: 'Formulário Completo',
          color: AppColors.textPrimary,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Semantics(
            button: true,
            label: 'Limpar formulário',
            hint: 'Toque para limpar todos os campos',
            child: IconButton(
              onPressed: _clearForm,
              icon: const Icon(
                Icons.clear_all,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SectionTitle(
                title: 'Cadastro de Usuário',
                subtitle: 'Preencha todos os campos obrigatórios (*)',
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Personal Information
              FormFieldGroup(
                title: 'Informações Pessoais',
                fields: [
                  FormFieldConfig(
                    label: 'Nome Completo *',
                    hint: 'Digite seu nome completo',
                    type: FormFieldType.text,
                    controller: _nameController,
                    prefixIcon: Icons.person,
                    errorText: _errors['name'],
                    validator: _validateName,
                    onChanged: (value) => _clearFieldError('name'),
                  ),
                  FormFieldConfig(
                    label: 'Email *',
                    hint: 'Digite seu email',
                    type: FormFieldType.text,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    errorText: _errors['email'],
                    validator: _validateEmail,
                    onChanged: (value) => _clearFieldError('email'),
                  ),
                  FormFieldConfig(
                    label: 'Telefone *',
                    hint: '(11) 99999-9999',
                    type: FormFieldType.text,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                    errorText: _errors['phone'],
                    validator: _validatePhone,
                    onChanged: (value) => _clearFieldError('phone'),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _PhoneInputFormatter(),
                    ],
                  ),
                  FormFieldConfig(
                    label: 'Data de Nascimento *',
                    hint: 'DD/MM/AAAA',
                    type: FormFieldType.text,
                    controller: _birthDateController,
                    keyboardType: TextInputType.datetime,
                    prefixIcon: Icons.calendar_today,
                    errorText: _errors['birthDate'],
                    validator: _validateBirthDate,
                    onChanged: (value) => _clearFieldError('birthDate'),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _DateInputFormatter(),
                    ],
                  ),
                ],
                spacing: AppDimensions.lg,
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Gender Selection
              FormFieldGroup(
                title: 'Gênero',
                fields: [
                  FormFieldConfig(
                    label: 'Selecione seu gênero',
                    type: FormFieldType.radio,
                    radioValue: _selectedGender,
                    radioOptions: [
                      RadioOption(label: 'Masculino', value: 'M'),
                      RadioOption(label: 'Feminino', value: 'F'),
                      RadioOption(label: 'Outro', value: 'O'),
                      RadioOption(label: 'Prefiro não informar', value: 'N'),
                    ],
                    onRadioChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Education Level
              FormFieldGroup(
                title: 'Nível de Escolaridade',
                fields: [
                  FormFieldConfig(
                    label: 'Escolaridade *',
                    hint: 'Selecione seu nível de escolaridade',
                    type: FormFieldType.dropdown,
                    prefixIcon: Icons.school,
                    dropdownValue: _selectedEducation,
                    dropdownItems: [
                      DropdownItem(label: 'Ensino Fundamental', value: 'fundamental'),
                      DropdownItem(label: 'Ensino Médio', value: 'medio'),
                      DropdownItem(label: 'Ensino Superior', value: 'superior'),
                      DropdownItem(label: 'Pós-graduação', value: 'pos'),
                      DropdownItem(label: 'Mestrado', value: 'mestrado'),
                      DropdownItem(label: 'Doutorado', value: 'doutorado'),
                    ],
                    onDropdownChanged: (value) {
                      setState(() {
                        _selectedEducation = value;
                        _clearFieldError('education');
                      });
                    },
                    errorText: _errors['education'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecione seu nível de escolaridade';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Security
              FormFieldGroup(
                title: 'Segurança',
                fields: [
                  FormFieldConfig(
                    label: 'Senha *',
                    hint: 'Mínimo 8 caracteres',
                    type: FormFieldType.text,
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock,
                    suffixIcon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    onSuffixIconTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    errorText: _errors['password'],
                    validator: _validatePassword,
                    onChanged: (value) => _clearFieldError('password'),
                  ),
                  FormFieldConfig(
                    label: 'Confirmar Senha *',
                    hint: 'Digite a senha novamente',
                    type: FormFieldType.text,
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    onSuffixIconTap: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    errorText: _errors['confirmPassword'],
                    validator: _validateConfirmPassword,
                    onChanged: (value) => _clearFieldError('confirmPassword'),
                  ),
                ],
                spacing: AppDimensions.lg,
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Address Information
              FormFieldGroup(
                title: 'Endereço',
                fields: [
                  FormFieldConfig(
                    label: 'Rua/Avenida',
                    hint: 'Digite o endereço completo',
                    type: FormFieldType.text,
                    controller: _streetController,
                    prefixIcon: Icons.home,
                    maxLines: 2,
                  ),
                  FormFieldConfig(
                    label: 'Cidade',
                    hint: 'Digite a cidade',
                    type: FormFieldType.text,
                    controller: _cityController,
                    prefixIcon: Icons.location_city,
                  ),
                  FormFieldConfig(
                    label: 'Estado',
                    hint: 'Digite o estado',
                    type: FormFieldType.text,
                    controller: _stateController,
                    prefixIcon: Icons.map,
                  ),
                  FormFieldConfig(
                    label: 'CEP',
                    hint: '00000-000',
                    type: FormFieldType.text,
                    controller: _zipCodeController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.local_post_office,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CepInputFormatter(),
                    ],
                  ),
                ],
                spacing: AppDimensions.lg,
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Preferences
              FormFieldGroup(
                title: 'Preferências',
                fields: [
                  FormFieldConfig(
                    label: 'Aceito os termos de uso *',
                    helperText: 'É necessário aceitar os termos para continuar',
                    type: FormFieldType.checkbox,
                    checkboxValue: _acceptsTerms,
                    onCheckboxChanged: (value) {
                      setState(() {
                        _acceptsTerms = value ?? false;
                        _clearFieldError('terms');
                      });
                    },
                    errorText: _errors['terms'],
                  ),
                  FormFieldConfig(
                    label: 'Desejo receber newsletter',
                    helperText: 'Receba novidades e atualizações por email',
                    type: FormFieldType.checkbox,
                    checkboxValue: _acceptsNewsletter,
                    onCheckboxChanged: (value) {
                      setState(() {
                        _acceptsNewsletter = value ?? false;
                      });
                    },
                  ),
                ],
                spacing: AppDimensions.lg,
              ),
              
              const SizedBox(height: AppDimensions.xl),
              
              // Submit Button
              AnimatedBuilder(
                animation: _submitAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.95 + (0.05 * _submitAnimation.value),
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Cadastrar',
                        onPressed: _isSubmitting ? null : _submitForm,
                        isLoading: _isSubmitting,
                        icon: Icons.check,
                        variant: CustomButtonVariant.primary,
                        size: CustomButtonSize.large,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppDimensions.lg),
              
              // Secondary Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Visualizar Dados',
                  onPressed: _previewData,
                  icon: Icons.preview,
                  variant: CustomButtonVariant.secondary,
                  size: CustomButtonSize.large,
                ),
              ),
              
              const SizedBox(height: AppDimensions.xl),
            ],
          ),
        ),
      ),
    );
  }

  // Validation methods
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value.trim())) {
      return 'Nome deve conter apenas letras';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 11) {
      return 'Telefone deve ter 11 dígitos';
    }
    return null;
  }

  String? _validateBirthDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Data de nascimento é obrigatória';
    }
    
    final parts = value.split('/');
    if (parts.length != 3) {
      return 'Data inválida (use DD/MM/AAAA)';
    }
    
    try {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final date = DateTime(year, month, day);
      final now = DateTime.now();
      
      if (date.isAfter(now)) {
        return 'Data não pode ser futura';
      }
      
      if (now.difference(date).inDays < 365 * 13) {
        return 'Idade mínima: 13 anos';
      }
      
      return null;
    } catch (e) {
      return 'Data inválida';
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 8) {
      return 'Senha deve ter pelo menos 8 caracteres';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Senha deve ter maiúscula, minúscula e número';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != _passwordController.text) {
      return 'Senhas não coincidem';
    }
    return null;
  }

  void _clearFieldError(String field) {
    if (_errors.containsKey(field)) {
      setState(() {
        _errors.remove(field);
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _birthDateController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _streetController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipCodeController.clear();
    
    setState(() {
      _selectedGender = null;
      _selectedEducation = null;
      _acceptsTerms = false;
      _acceptsNewsletter = false;
      _errors.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Formulário limpo'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _previewData() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLg),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return _buildDataPreview(scrollController);
        },
      ),
    );
  }

  Widget _buildDataPreview(ScrollController scrollController) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          const CustomTypography.h5(
            text: 'Pré-visualização dos Dados',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppDimensions.lg),

          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                _buildPreviewSection('Informações Pessoais', [
                  _buildPreviewItem('Nome', _nameController.text),
                  _buildPreviewItem('Email', _emailController.text),
                  _buildPreviewItem('Telefone', _phoneController.text),
                  _buildPreviewItem('Data de Nascimento', _birthDateController.text),
                  _buildPreviewItem('Gênero', _getGenderLabel(_selectedGender)),
                  _buildPreviewItem('Escolaridade', _getEducationLabel(_selectedEducation)),
                ]),
                
                _buildPreviewSection('Endereço', [
                  _buildPreviewItem('Rua', _streetController.text),
                  _buildPreviewItem('Cidade', _cityController.text),
                  _buildPreviewItem('Estado', _stateController.text),
                  _buildPreviewItem('CEP', _zipCodeController.text),
                ]),
                
                _buildPreviewSection('Preferências', [
                  _buildPreviewItem('Aceita termos', _acceptsTerms ? 'Sim' : 'Não'),
                  _buildPreviewItem('Newsletter', _acceptsNewsletter ? 'Sim' : 'Não'),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTypography.h6(
          text: title,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppDimensions.md),
        ...items,
        const SizedBox(height: AppDimensions.lg),
      ],
    );
  }

  Widget _buildPreviewItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: CustomTypography.bodySmall(
              text: '$label:',
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            child: CustomTypography.bodyMedium(
              text: value?.isNotEmpty == true ? value! : 'Não informado',
              color: value?.isNotEmpty == true 
                  ? AppColors.textPrimary 
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getGenderLabel(String? value) {
    switch (value) {
      case 'M': return 'Masculino';
      case 'F': return 'Feminino';
      case 'O': return 'Outro';
      case 'N': return 'Prefiro não informar';
      default: return '';
    }
  }

  String _getEducationLabel(String? value) {
    switch (value) {
      case 'fundamental': return 'Ensino Fundamental';
      case 'medio': return 'Ensino Médio';
      case 'superior': return 'Ensino Superior';
      case 'pos': return 'Pós-graduação';
      case 'mestrado': return 'Mestrado';
      case 'doutorado': return 'Doutorado';
      default: return '';
    }
  }

  Future<void> _submitForm() async {
    // Clear previous errors
    _errors.clear();
    
    // Validate required fields
    bool hasErrors = false;
    
    if (_validateName(_nameController.text) != null) {
      _errors['name'] = _validateName(_nameController.text);
      hasErrors = true;
    }
    
    if (_validateEmail(_emailController.text) != null) {
      _errors['email'] = _validateEmail(_emailController.text);
      hasErrors = true;
    }
    
    if (_validatePhone(_phoneController.text) != null) {
      _errors['phone'] = _validatePhone(_phoneController.text);
      hasErrors = true;
    }
    
    if (_validateBirthDate(_birthDateController.text) != null) {
      _errors['birthDate'] = _validateBirthDate(_birthDateController.text);
      hasErrors = true;
    }
    
    if (_selectedEducation == null) {
      _errors['education'] = 'Selecione seu nível de escolaridade';
      hasErrors = true;
    }
    
    if (_validatePassword(_passwordController.text) != null) {
      _errors['password'] = _validatePassword(_passwordController.text);
      hasErrors = true;
    }
    
    if (_validateConfirmPassword(_confirmPasswordController.text) != null) {
      _errors['confirmPassword'] = _validateConfirmPassword(_confirmPasswordController.text);
      hasErrors = true;
    }
    
    if (!_acceptsTerms) {
      _errors['terms'] = 'É necessário aceitar os termos';
      hasErrors = true;
    }

    if (hasErrors) {
      setState(() {});
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    _submitController.forward().then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        _clearForm();
        _submitController.reset();
      }
    });

    setState(() {
      _isSubmitting = false;
    });
  }
}

// Input formatters
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length <= 11) {
      String formatted = '';
      
      if (digits.isNotEmpty) {
        formatted += '(';
        if (digits.length >= 2) {
          formatted += '${digits.substring(0, 2)}) ';
          if (digits.length >= 7) {
            formatted += '${digits.substring(2, 7)}-';
            if (digits.length >= 11) {
              formatted += digits.substring(7, 11);
            } else {
              formatted += digits.substring(7);
            }
          } else {
            formatted += digits.substring(2);
          }
        } else {
          formatted += digits;
        }
      }
      
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    
    return oldValue;
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length <= 8) {
      String formatted = '';
      
      if (digits.length >= 2) {
        formatted += '${digits.substring(0, 2)}/';
        if (digits.length >= 4) {
          formatted += '${digits.substring(2, 4)}/';
          if (digits.length >= 8) {
            formatted += digits.substring(4, 8);
          } else {
            formatted += digits.substring(4);
          }
        } else {
          formatted += digits.substring(2);
        }
      } else {
        formatted = digits;
      }
      
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    
    return oldValue;
  }
}

class _CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length <= 8) {
      String formatted = '';
      
      if (digits.length >= 5) {
        formatted = '${digits.substring(0, 5)}-${digits.substring(5)}';
      } else {
        formatted = digits;
      }
      
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    
    return oldValue;
  }
}