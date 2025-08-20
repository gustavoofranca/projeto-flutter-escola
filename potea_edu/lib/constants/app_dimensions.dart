import 'package:flutter/material.dart';

/// Dimensões e espaçamentos do aplicativo Potea
class AppDimensions {
  // Espaçamentos base
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
  
  // Margens e padding
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  
  // Margens horizontais
  static const EdgeInsets paddingHXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHXl = EdgeInsets.symmetric(horizontal: xl);
  
  // Margens verticais
  static const EdgeInsets paddingVXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVXl = EdgeInsets.symmetric(vertical: xl);
  
  // Margens específicas
  static const EdgeInsets paddingTop = EdgeInsets.only(top: md);
  static const EdgeInsets paddingBottom = EdgeInsets.only(bottom: md);
  static const EdgeInsets paddingLeft = EdgeInsets.only(left: md);
  static const EdgeInsets paddingRight = EdgeInsets.only(right: md);
  
  // Padding da tela
  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  
  // Bordas arredondadas
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusXxl = 32.0;
  
  // Bordas específicas para componentes
  static const double buttonRadius = 12.0;
  static const double inputRadius = 12.0;
  static const double cardRadius = 16.0;
  
  // Sombras
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  
  // Alturas de botões
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  
  // Larguras de botões
  static const double buttonWidthSm = 120.0;
  static const double buttonWidthMd = 160.0;
  static const double buttonWidthLg = 200.0;
  
  // Padding de botões
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  
  // Alturas de campos de texto
  static const double textFieldHeight = 56.0;
  static const double textFieldHeightSm = 48.0;
  
  // Padding de campos de texto
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  
  // Tamanhos de ícones
  static const double iconSizeXs = 16.0;
  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;
  
  // Tamanhos de avatar
  static const double avatarSizeXs = 32.0;
  static const double avatarSizeSm = 40.0;
  static const double avatarSizeMd = 56.0;
  static const double avatarSizeLg = 80.0;
  static const double avatarSizeXl = 120.0;
  
  // Elevações
  static const double buttonElevation = 2.0;
  static const double cardElevation = 4.0;
  static const double appBarElevation = 0.0;
  static const double bottomNavElevation = 8.0;
  static const double drawerElevation = 16.0;
  
  // Breakpoints para responsividade
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
}

