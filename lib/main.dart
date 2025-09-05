import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';
import 'constants/app_text_styles.dart';
import 'constants/app_dimensions.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: PoteaEduApp(),
    ),
  );
}

/// Aplicativo principal Potea Edu
class PoteaEduApp extends StatelessWidget {
  const PoteaEduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Potea Edu',
      debugShowCheckedModeBanner: false,
      theme: _buildDarkTheme(),
      home: const SplashScreen(),
    );
  }

  /// Constrói o tema escuro do aplicativo
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Cores primárias
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: Color(0xFF66FFB3),
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.background,
        onSecondary: AppColors.background,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),
      
      // Tipografia
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        headlineLarge: AppTextStyles.h4,
        headlineMedium: AppTextStyles.h5,
        headlineSmall: AppTextStyles.h6,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.buttonLarge,
        labelMedium: AppTextStyles.buttonMedium,
        labelSmall: AppTextStyles.buttonSmall,
      ),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h5,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppDimensions.iconSizeMd,
        ),
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppColors.background,
      
      // Card
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.overlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      
      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
          textStyle: AppTextStyles.buttonMedium,
          minimumSize: const Size(0, AppDimensions.buttonHeightMd),
        ),
      ),
      
      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
          textStyle: AppTextStyles.buttonMedium,
          minimumSize: const Size(0, AppDimensions.buttonHeightMd),
        ),
      ),
      
      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          textStyle: AppTextStyles.buttonMedium,
        ),
      ),
      
      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
      
      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
      ),
      
      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 6,
        shape: CircleBorder(),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: AppDimensions.md,
      ),
      
      // Icon
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppDimensions.iconSizeMd,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedColor: AppColors.primary,
        labelStyle: AppTextStyles.bodySmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
      ),
      
      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.sm,
        ),
        titleTextStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        leadingAndTrailingTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        titleTextStyle: AppTextStyles.h5,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),
      
      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        contentTextStyle: AppTextStyles.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // ProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceLight,
        circularTrackColor: AppColors.surfaceLight,
      ),
      
      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.5);
          }
          return AppColors.surfaceLight;
        }),
      ),
      
      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.background),
        side: const BorderSide(color: AppColors.border, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
      ),
      
      // Radio
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
      ),
    );
  }
}

