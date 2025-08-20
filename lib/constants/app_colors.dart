import 'package:flutter/material.dart';

/// Cores do aplicativo Potea baseadas no design da imagem
class AppColors {
  // Cores principais
  static const Color primary = Color(0xFF00FF7F); // Verde neon
  static const Color primaryDark = Color(0xFF00CC66);
  static const Color primaryLight = Color(0xFF66FFB3);
  
  // Tema escuro
  static const Color background = Color(0xFF000000); // Preto
  static const Color surface = Color(0xFF121212); // Cinza muito escuro
  static const Color surfaceLight = Color(0xFF1E1E1E); // Cinza escuro
  static const Color surfaceVariant = Color(0xFF2D2D2D); // Cinza médio
  
  // Texto
  static const Color textPrimary = Color(0xFFFFFFFF); // Branco
  static const Color textSecondary = Color(0xFFB3B3B3); // Cinza claro
  static const Color textTertiary = Color(0xFF808080); // Cinza médio
  
  // Estados
  static const Color success = Color(0xFF00FF7F);
  static const Color error = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFA502);
  static const Color info = Color(0xFF3742FA);
  
  // Bordas e divisores
  static const Color border = Color(0xFF404040);
  static const Color divider = Color(0xFF2D2D2D);
  
  // Overlays
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

