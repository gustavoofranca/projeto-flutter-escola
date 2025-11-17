import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço de autenticação biométrica
/// 
/// Gerencia autenticação usando:
/// - Impressão digital (Touch ID / Fingerprint)
/// - Reconhecimento facial (Face ID)
/// - Outros métodos biométricos disponíveis no dispositivo
class BiometricAuthService {
  static final BiometricAuthService _instance = BiometricAuthService._internal();
  factory BiometricAuthService() => _instance;
  BiometricAuthService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _lastAuthTimeKey = 'last_auth_time';

  /// Verifica se o dispositivo suporta biometria
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[BiometricAuth] Erro ao verificar suporte: $e');
      }
      return false;
    }
  }

  /// Verifica se há biometria disponível no dispositivo
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[BiometricAuth] Erro ao verificar dispositivo: $e');
      }
      return false;
    }
  }

  /// Lista os tipos de biometria disponíveis
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[BiometricAuth] Erro ao listar biometrias: $e');
      }
      return [];
    }
  }

  /// Obtém descrição dos tipos de biometria disponíveis
  Future<String> getBiometricDescription() async {
    final biometrics = await getAvailableBiometrics();
    
    if (biometrics.isEmpty) {
      return 'Nenhuma biometria disponível';
    }

    final List<String> descriptions = [];
    
    if (biometrics.contains(BiometricType.face)) {
      descriptions.add('Reconhecimento Facial');
    }
    if (biometrics.contains(BiometricType.fingerprint)) {
      descriptions.add('Impressão Digital');
    }
    if (biometrics.contains(BiometricType.iris)) {
      descriptions.add('Íris');
    }
    if (biometrics.contains(BiometricType.strong)) {
      descriptions.add('Biometria Forte');
    }
    if (biometrics.contains(BiometricType.weak)) {
      descriptions.add('Biometria Fraca');
    }

    return descriptions.join(', ');
  }

  /// Autentica o usuário usando biometria
  Future<BiometricAuthResult> authenticate({
    String localizedReason = 'Por favor, autentique-se para continuar',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      // Verifica suporte
      final canCheck = await canCheckBiometrics();
      final isSupported = await isDeviceSupported();

      if (!canCheck || !isSupported) {
        return BiometricAuthResult(
          success: false,
          errorMessage: 'Biometria não disponível neste dispositivo',
          errorType: BiometricErrorType.notAvailable,
        );
      }

      // Tenta autenticar
      final authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        await _saveLastAuthTime();
        
        if (kDebugMode) {
          debugPrint('[BiometricAuth] Autenticação bem-sucedida');
        }

        return BiometricAuthResult(
          success: true,
          biometricType: (await getAvailableBiometrics()).firstOrNull,
        );
      } else {
        return BiometricAuthResult(
          success: false,
          errorMessage: 'Autenticação cancelada ou falhou',
          errorType: BiometricErrorType.authenticationFailed,
        );
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('[BiometricAuth] Erro na autenticação: ${e.code} - ${e.message}');
      }

      return BiometricAuthResult(
        success: false,
        errorMessage: _getErrorMessage(e.code),
        errorType: _getErrorType(e.code),
      );
    }
  }

  /// Verifica se a biometria está habilitada nas preferências
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  /// Habilita ou desabilita a biometria
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
    
    if (kDebugMode) {
      debugPrint('[BiometricAuth] Biometria ${enabled ? 'habilitada' : 'desabilitada'}');
    }
  }

  /// Salva o timestamp da última autenticação
  Future<void> _saveLastAuthTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastAuthTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Obtém o tempo desde a última autenticação
  Future<Duration?> getTimeSinceLastAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAuthTime = prefs.getInt(_lastAuthTimeKey);
    
    if (lastAuthTime == null) return null;
    
    final lastAuth = DateTime.fromMillisecondsSinceEpoch(lastAuthTime);
    return DateTime.now().difference(lastAuth);
  }

  /// Verifica se precisa re-autenticar (após X minutos)
  Future<bool> needsReAuthentication({Duration timeout = const Duration(minutes: 5)}) async {
    final timeSince = await getTimeSinceLastAuth();
    
    if (timeSince == null) return true;
    
    return timeSince > timeout;
  }

  /// Converte código de erro em mensagem amigável
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'NotAvailable':
        return 'Biometria não disponível neste dispositivo';
      case 'NotEnrolled':
        return 'Nenhuma biometria cadastrada. Configure nas configurações do dispositivo';
      case 'PasscodeNotSet':
        return 'Senha do dispositivo não configurada';
      case 'LockedOut':
        return 'Muitas tentativas. Tente novamente mais tarde';
      case 'PermanentlyLockedOut':
        return 'Biometria bloqueada permanentemente';
      case 'BiometricOnlyNotSupported':
        return 'Apenas biometria não é suportada';
      default:
        return 'Erro na autenticação biométrica';
    }
  }

  /// Converte código de erro em tipo de erro
  BiometricErrorType _getErrorType(String errorCode) {
    switch (errorCode) {
      case 'NotAvailable':
      case 'BiometricOnlyNotSupported':
        return BiometricErrorType.notAvailable;
      case 'NotEnrolled':
        return BiometricErrorType.notEnrolled;
      case 'PasscodeNotSet':
        return BiometricErrorType.passcodeNotSet;
      case 'LockedOut':
      case 'PermanentlyLockedOut':
        return BiometricErrorType.lockedOut;
      default:
        return BiometricErrorType.authenticationFailed;
    }
  }

  /// Cancela autenticação em andamento
  Future<void> stopAuthentication() async {
    await _localAuth.stopAuthentication();
  }
}

/// Resultado da autenticação biométrica
class BiometricAuthResult {
  final bool success;
  final String? errorMessage;
  final BiometricErrorType? errorType;
  final BiometricType? biometricType;

  BiometricAuthResult({
    required this.success,
    this.errorMessage,
    this.errorType,
    this.biometricType,
  });

  @override
  String toString() {
    return 'BiometricAuthResult(success: $success, errorMessage: $errorMessage, '
        'errorType: $errorType, biometricType: $biometricType)';
  }
}

/// Tipos de erro de autenticação biométrica
enum BiometricErrorType {
  notAvailable,
  notEnrolled,
  passcodeNotSet,
  lockedOut,
  authenticationFailed,
}
