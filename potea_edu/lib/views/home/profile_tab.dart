import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 80,
              color: AppColors.onBackground.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Tela de Perfil',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Funcionalidade em desenvolvimento',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.onBackground.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

