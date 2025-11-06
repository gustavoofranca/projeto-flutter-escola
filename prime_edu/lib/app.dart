import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_dimensions.dart';
import 'package:prime_edu/features/auth/presentation/pages/modern_login_page.dart';
import 'package:prime_edu/features/auth/presentation/providers/auth_view_model.dart';
import 'package:prime_edu/providers/auth_provider.dart';
import 'package:prime_edu/providers/announcement_provider.dart';
import 'package:prime_edu/providers/calendar_provider.dart';
import 'package:prime_edu/providers/book_download_provider.dart';
import 'package:prime_edu/views/home/home_screen.dart';
import 'package:prime_edu/core/injection_container.dart' as di;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.sl<AuthViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AnnouncementProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CalendarProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookDownloadProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Prime Edu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            background: AppColors.background,
            error: AppColors.error,
            onPrimary: AppColors.onPrimary,
            onSecondary: AppColors.onSecondary,
            onSurface: AppColors.onSurface,
            onBackground: AppColors.onBackground,
            onError: Colors.white,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: AppDimensions.appBarElevation,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surfaceLight.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
              borderSide: BorderSide(
                color: AppColors.border.withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppDimensions.md,
              horizontal: AppDimensions.md,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.md,
                horizontal: AppDimensions.lg,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
              ),
              elevation: AppDimensions.buttonElevation,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.md,
                horizontal: AppDimensions.lg,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
              ),
              side: BorderSide(
                color: AppColors.border.withOpacity(0.3),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.sm,
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: AppColors.surface,
            elevation: AppDimensions.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            ),
          ),
        ),
        home: const ModernLoginPage(),
        routes: {
          ModernLoginPage.routeName: (context) => const ModernLoginPage(),
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const ModernLoginPage(),
        },
      ),
    );
  }
}
