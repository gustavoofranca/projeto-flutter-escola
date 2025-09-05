import 'package:flutter/material.dart';

/// Cores do aplicativo Potea baseadas no design da imagem
class AppColors {
  // Cores principais
  static const Color primary = Color(0xFF00FF7F); // Verde neon
  static const Color primaryDark = Color(0xFF00CC66);
  static const Color primaryLight = Color(0xFF66FFB3);
  static const Color secondary = Color(0xFF00E676); // Verde secundário
  
  // Tema escuro com fundo #2a3030
  static const Color background = Color(0xFF2A3030); // Azul-acinzentado escuro
  static const Color surface = Color(0xFF373E3E); // Superfície ligeiramente mais clara
  static const Color surfaceLight = Color(0xFF454D4D); // Superfície mais clara
  static const Color surfaceVariant = Color(0xFF545D5D); // Variante da superfície
  
  // Texto
  static const Color textPrimary = Color(0xFFFFFFFF); // Branco
  static const Color textSecondary = Color(0xFFBFC5C5); // Cinza claro com tom azulado
  static const Color textTertiary = Color(0xFF9DA3A3); // Cinza médio com tom azulado
  
  // Cores do tema Material 3
  static const Color onPrimary = Color(0xFF000000); // Texto sobre primary
  static const Color onSecondary = Color(0xFF000000); // Texto sobre secondary
  static const Color onSurface = Color(0xFFFFFFFF); // Texto sobre surface
  static const Color onBackground = Color(0xFFFFFFFF); // Texto sobre background
  
  // Estados
  static const Color success = Color(0xFF00FF7F);
  static const Color error = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFA502);
  static const Color info = Color(0xFF3742FA);
  
  // Bordas e divisores
  static const Color border = Color(0xFF545D5D);
  static const Color borderColor = Color(0xFF545D5D); // Alias for border
  static const Color divider = Color(0xFF454D4D);
  
  // Overlays
  static const Color overlay = Color(0x992A3030); // Overlay com a cor de fundo
  static const Color overlayLight = Color(0x4D2A3030); // Overlay mais claro
  
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