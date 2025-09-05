import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/auth/auth_screen.dart';
import 'views/home/home_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/book_download_provider.dart';

void main() {
  runApp(const PoteaEduApp());
}

class PoteaEduApp extends StatelessWidget {
  const PoteaEduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (context) => BookDownloadProvider()),
      ],
      child: MaterialApp(
        title: 'Potea Edu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00FF7F), // Verde neon
            secondary: Color(0xFF00E676),
            surface: Color(0xFF121212),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF7F),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: const AppInitializer(),
      ),
    );
  }
}

/// Widget que decide qual tela mostrar baseado no estado de autenticação
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    // Inicializa o provider de autenticação
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().initialize();
      context.read<AnnouncementProvider>().loadAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Mostra splash enquanto carrega
        if (authProvider.isLoading) {
          return const SplashScreen();
        }

        // Se estiver logado, vai para a tela principal
        if (authProvider.isLoggedIn) {
          return const HomeScreen();
        }

        // Se não estiver logado, vai para autenticação
        return const AuthScreen();
      },
    );
  }
}

// Tela de Splash
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF00FF7F),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FF7F).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.school,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Potea Edu',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00FF7F),
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Educação do Futuro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              color: Color(0xFF00FF7F),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}