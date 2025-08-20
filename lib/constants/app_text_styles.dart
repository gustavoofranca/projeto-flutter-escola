import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilos de texto do aplicativo Potea
class AppTextStyles {
  // Fonte base
  static TextStyle get _baseText => GoogleFonts.inter(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
  );
  
  // Títulos
  static TextStyle get h1 => _baseText.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  
  static TextStyle get h2 => _baseText.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );
  
  static TextStyle get h3 => _baseText.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );
  
  static TextStyle get h4 => _baseText.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  
  static TextStyle get h5 => _baseText.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  
  static TextStyle get h6 => _baseText.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
  );
  
  // Corpo do texto
  static TextStyle get bodyLarge => _baseText.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
  
  static TextStyle get bodyMedium => _baseText.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );
  
  static TextStyle get bodySmall => _baseText.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );
  
  // Botões
  static TextStyle get buttonLarge => _baseText.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  static TextStyle get buttonMedium => _baseText.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
  );
  
  static TextStyle get buttonSmall => _baseText.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );
  
  // Caption e overline
  static TextStyle get caption => _baseText.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );
  
  static TextStyle get overline => _baseText.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );
  
  // Texto secundário
  static TextStyle get bodySecondary => bodyMedium.copyWith(
    color: AppColors.textSecondary,
  );
  
  static TextStyle get bodyTertiary => bodySmall.copyWith(
    color: AppColors.textTertiary,
  );
  
  // Texto primário (verde)
  static TextStyle get bodyPrimary => bodyMedium.copyWith(
    color: AppColors.primary,
    fontWeight: FontWeight.w500,
  );
}

