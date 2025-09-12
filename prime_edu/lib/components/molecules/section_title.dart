import 'package:flutter/material.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_dimensions.dart';
import '../atoms/custom_typography.dart';

/// Widget para títulos de seção
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment alignment;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.padding,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          CustomTypography.h5(text: title, color: AppColors.textPrimary),
          if (subtitle != null) ...[
            const SizedBox(height: AppDimensions.xs),
            CustomTypography.bodyMedium(
              text: subtitle!,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}
