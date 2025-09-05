import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/auth_provider.dart';
import '../../components/atoms/custom_button.dart';
import '../../components/atoms/custom_text_field.dart';
import '../../components/atoms/custom_typography.dart';
import 'signup_screen.dart';
import '../home/home_screen.dart';

/// Tela de login do aplicativo
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simula um delay de login
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Note: Using fictional authentication for demo purposes
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

  void _forgotPassword() {
    // Note: Password recovery feature planned for fictional auth system
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Entrar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.xl),
                
                // Título
                _buildTitle(),
                
                const SizedBox(height: AppDimensions.xxl),
                
                // Formulário
                _buildForm(),
                
                const SizedBox(height: AppDimensions.xl),
                
                // Botão de login
                _buildLoginButton(),
                
                const SizedBox(height: AppDimensions.lg),
                
                // Link para recuperação de senha
                _buildForgotPasswordLink(),
                
                const SizedBox(height: AppDimensions.xxl),
                
                // Divisor
                _buildDivider(),
                
                const SizedBox(height: AppDimensions.lg),
                
                // Botões de autenticação social
                _buildSocialAuthButtons(),
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
          'Entrar na sua conta',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        
        const SizedBox(height: AppDimensions.sm),
        
        Text(
          'Bem-vindo de volta! Entre com suas credenciais para continuar.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  /// Constrói o formulário
  Widget _buildForm() {
    return Column(
      children: [
        // Campo de email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'E-mail',
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'Digite seu e-mail',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite seu e-mail';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Por favor, digite um e-mail válido';
            }
            return null;
          },
        ),
        
        const SizedBox(height: AppDimensions.lg),
        
        // Campo de senha
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Senha',
            prefixIcon: const Icon(Icons.lock_outlined),
            hintText: 'Digite sua senha',
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite sua senha';
            }
            if (value.length < 6) {
              return 'A senha deve ter pelo menos 6 caracteres';
            }
            return null;
          },
        ),
        
        const SizedBox(height: AppDimensions.md),
        
        // Checkbox "Lembrar de mim"
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: AppColors.primary,
            ),
            Text(
              'Lembrar de mim',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Constrói o botão de login
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
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
                'Entrar',
                style: AppTextStyles.buttonMedium,
              ),
      ),
    );
  }

  /// Constrói o link para recuperação de senha
  Widget _buildForgotPasswordLink() {
    return Center(
      child: TextButton(
        onPressed: _forgotPassword,
        child: Text(
          'Esqueceu sua senha?',
          style: AppTextStyles.buttonMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  /// Constrói o divisor
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
          child: Text(
            'ou continue com',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  /// Constrói os botões de autenticação social
  Widget _buildSocialAuthButtons() {
    return Row(
      children: [
        // Botão Google
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Note: Google auth planned for fictional system
              _showComingSoon();
            },
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Google'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
            ),
          ),
        ),
        
        const SizedBox(width: AppDimensions.md),
        
        // Botão Apple
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Note: Apple auth planned for fictional system
              _showComingSoon();
            },
            icon: const Icon(Icons.apple),
            label: const Text('Apple'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
            ),
          ),
        ),
      ],
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

