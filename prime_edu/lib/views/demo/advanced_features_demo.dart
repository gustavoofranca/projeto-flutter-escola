import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_dimensions.dart';
import 'package:prime_edu/components/atoms/custom_typography.dart';
import 'package:prime_edu/services/notification_service.dart';
import 'package:prime_edu/services/biometric_auth_service.dart';
import 'package:prime_edu/services/deep_link_service.dart';

/// Tela de demonstração dos recursos avançados
/// 
/// Demonstra:
/// - Notificações Push Locais
/// - Autenticação Biométrica
/// - Deep Linking
class AdvancedFeaturesDemo extends StatefulWidget {
  const AdvancedFeaturesDemo({super.key});

  @override
  State<AdvancedFeaturesDemo> createState() => _AdvancedFeaturesDemoState();
}

class _AdvancedFeaturesDemoState extends State<AdvancedFeaturesDemo> {
  final _notificationService = NotificationService();
  final _biometricService = BiometricAuthService();
  final _deepLinkService = DeepLinkService();

  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String _biometricDescription = 'Verificando...';
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Inicializa notificações
    await _notificationService.initialize();
    await _notificationService.requestPermissions();

    // Verifica biometria
    final available = await _biometricService.canCheckBiometrics();
    final enabled = await _biometricService.isBiometricEnabled();
    final description = await _biometricService.getBiometricDescription();

    if (mounted) {
      setState(() {
        _biometricAvailable = available;
        _biometricEnabled = enabled;
        _biometricDescription = description;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const CustomTypography.h6(
          text: 'Recursos Avançados',
          color: AppColors.textPrimary,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        children: [
          _buildSectionTitle('📢 Notificações Push Locais'),
          _buildNotificationsSection(),
          
          const SizedBox(height: AppDimensions.xl),
          
          _buildSectionTitle('🔐 Autenticação Biométrica'),
          _buildBiometricSection(),
          
          const SizedBox(height: AppDimensions.xl),
          
          _buildSectionTitle('🔗 Deep Linking'),
          _buildDeepLinkSection(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: CustomTypography.h5(
        text: title,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTypography.bodyMedium(
              text: 'Sistema de notificações locais implementado com:',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.sm),
            _buildFeatureItem('✅ Notificações imediatas'),
            _buildFeatureItem('✅ Notificações agendadas'),
            _buildFeatureItem('✅ Suporte a Android e iOS'),
            _buildFeatureItem('✅ Canais personalizados'),
            
            const SizedBox(height: AppDimensions.md),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppDimensions.md),
            
            const CustomTypography.bodyLarge(
              text: 'Testar Notificações:',
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppDimensions.sm),
            
            _buildNotificationButton(
              'Novo Aviso',
              Icons.announcement,
              () => _sendAnnouncementNotification(),
            ),
            const SizedBox(height: AppDimensions.sm),
            _buildNotificationButton(
              'Lembrete de Aula',
              Icons.school,
              () => _sendClassReminder(),
            ),
            const SizedBox(height: AppDimensions.sm),
            _buildNotificationButton(
              'Prazo de Atividade',
              Icons.assignment,
              () => _sendDeadlineNotification(),
            ),
            const SizedBox(height: AppDimensions.sm),
            _buildNotificationButton(
              'Nova Mensagem',
              Icons.message,
              () => _sendMessageNotification(),
            ),
            
            if (_notificationCount > 0) ...[
              const SizedBox(height: AppDimensions.md),
              Container(
                padding: const EdgeInsets.all(AppDimensions.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomTypography.bodySmall(
                  text: '$_notificationCount notificações enviadas nesta sessão',
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricSection() {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTypography.bodyMedium(
              text: 'Autenticação biométrica implementada com:',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.sm),
            _buildFeatureItem('✅ Touch ID / Impressão Digital'),
            _buildFeatureItem('✅ Face ID / Reconhecimento Facial'),
            _buildFeatureItem('✅ Verificação de disponibilidade'),
            _buildFeatureItem('✅ Tratamento de erros'),
            
            const SizedBox(height: AppDimensions.md),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppDimensions.md),
            
            _buildInfoRow('Status:', _biometricAvailable ? 'Disponível' : 'Não disponível'),
            _buildInfoRow('Tipo:', _biometricDescription),
            _buildInfoRow('Habilitado:', _biometricEnabled ? 'Sim' : 'Não'),
            
            const SizedBox(height: AppDimensions.md),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _biometricAvailable ? _testBiometric : null,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Testar Autenticação'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.sm),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _biometricAvailable ? _toggleBiometric : null,
                icon: Icon(_biometricEnabled ? Icons.toggle_on : Icons.toggle_off),
                label: Text(_biometricEnabled ? 'Desabilitar' : 'Habilitar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeepLinkSection() {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomTypography.bodyMedium(
              text: 'Deep linking implementado com:',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppDimensions.sm),
            _buildFeatureItem('✅ URLs customizadas (primeedu://)'),
            _buildFeatureItem('✅ URLs web (https://primeedu.com)'),
            _buildFeatureItem('✅ Navegação para telas específicas'),
            _buildFeatureItem('✅ Compartilhamento de conteúdo'),
            
            const SizedBox(height: AppDimensions.md),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppDimensions.md),
            
            const CustomTypography.bodyLarge(
              text: 'Exemplos de Deep Links:',
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: AppDimensions.sm),
            
            ...DeepLinkService.examples.entries.map((entry) {
              return _buildDeepLinkExample(entry.key, entry.value);
            }),
            
            const SizedBox(height: AppDimensions.md),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateAndCopyDeepLink,
                icon: const Icon(Icons.link),
                label: const Text('Gerar e Copiar Link'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: CustomTypography.bodySmall(
        text: text,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CustomTypography.bodyMedium(
            text: label,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: CustomTypography.bodySmall(
              text: value,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
        ),
      ),
    );
  }

  Widget _buildDeepLinkExample(String label, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => _copyToClipboard(url),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.sm),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTypography.caption(
                      text: label,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 2),
                    CustomTypography.bodySmall(
                      text: url,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.copy, size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  // Notification handlers
  Future<void> _sendAnnouncementNotification() async {
    await _notificationService.notifyNewAnnouncement(
      title: 'Prova de Matemática na próxima semana',
      author: 'Prof. Silva',
    );
    setState(() => _notificationCount++);
    _showSnackBar('Notificação de aviso enviada!');
  }

  Future<void> _sendClassReminder() async {
    await _notificationService.notifyClassReminder(
      className: 'Matemática Avançada',
      classTime: DateTime.now().add(const Duration(minutes: 15)),
    );
    setState(() => _notificationCount++);
    _showSnackBar('Lembrete de aula agendado para daqui 15 minutos!');
  }

  Future<void> _sendDeadlineNotification() async {
    await _notificationService.notifyActivityDeadline(
      activityName: 'Trabalho de História',
      deadline: DateTime.now().add(const Duration(hours: 24)),
    );
    setState(() => _notificationCount++);
    _showSnackBar('Notificação de prazo agendada para daqui 24 horas!');
  }

  Future<void> _sendMessageNotification() async {
    await _notificationService.notifyNewMessage(
      sender: 'Prof. João',
      message: 'Não esqueça de revisar o capítulo 5!',
    );
    setState(() => _notificationCount++);
    _showSnackBar('Notificação de mensagem enviada!');
  }

  // Biometric handlers
  Future<void> _testBiometric() async {
    final result = await _biometricService.authenticate(
      localizedReason: 'Autentique-se para testar o recurso',
    );

    if (result.success) {
      _showSnackBar('✅ Autenticação bem-sucedida!', isSuccess: true);
    } else {
      _showSnackBar('❌ ${result.errorMessage}', isSuccess: false);
    }
  }

  Future<void> _toggleBiometric() async {
    final newValue = !_biometricEnabled;
    await _biometricService.setBiometricEnabled(newValue);
    setState(() => _biometricEnabled = newValue);
    _showSnackBar(
      newValue ? 'Biometria habilitada' : 'Biometria desabilitada',
      isSuccess: true,
    );
  }

  // Deep link handlers
  void _generateAndCopyDeepLink() {
    final link = _deepLinkService.generateDeepLink(
      type: DeepLinkType.announcement,
      id: 'demo_${DateTime.now().millisecondsSinceEpoch}',
      parameters: {'source': 'demo'},
    );
    _copyToClipboard(link);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('Link copiado: $text', isSuccess: true);
  }

  void _showSnackBar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
