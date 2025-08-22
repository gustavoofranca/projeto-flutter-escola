import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class ClassesTab extends StatelessWidget {
  const ClassesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Turmas'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.class_,
              size: 80,
              color: AppColors.onBackground.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Tela de Turmas',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.onBackground.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Funcionalidade em desenvolvimento',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.onBackground.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

