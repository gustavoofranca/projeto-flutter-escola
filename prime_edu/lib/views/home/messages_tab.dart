import 'package:flutter/material.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_text_styles.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mensagens'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 80,
              color: AppColors.onBackground.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Tela de Mensagens',
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
