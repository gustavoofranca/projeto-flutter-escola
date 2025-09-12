import 'package:flutter/material.dart';
import 'package:prime_edu/constants/app_text_styles.dart';

/// Componente de tipografia personalizada com acessibilidade
class CustomTypography extends StatelessWidget {
  final String text;
  final CustomTypographyVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isSelectable;
  final String? semanticsLabel;
  final String? semanticsHint;

  const CustomTypography({
    super.key,
    required this.text,
    this.variant = CustomTypographyVariant.bodyMedium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  });

  // Factory constructors for different variants
  const CustomTypography.h1({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.h1;

  const CustomTypography.h2({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.h2;

  const CustomTypography.h3({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.h3;

  const CustomTypography.h4({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.h4;

  const CustomTypography.h5({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.h5;

  const CustomTypography.h6({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.h6;

  const CustomTypography.bodyLarge({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.bodyLarge;

  const CustomTypography.bodyMedium({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.bodyMedium;

  const CustomTypography.bodySmall({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.bodySmall;

  const CustomTypography.caption({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.caption;

  const CustomTypography.overline({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isSelectable = false,
    this.semanticsLabel,
    this.semanticsHint,
  }) : variant = CustomTypographyVariant.overline;

  @override
  Widget build(BuildContext context) {
    final textStyle = _getTextStyle().copyWith(color: color);

    final Widget textWidget = isSelectable
        ? SelectableText(
            text,
            style: textStyle,
            textAlign: textAlign,
            maxLines: maxLines,
          )
        : Text(
            text,
            style: textStyle,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );

    return Semantics(
      label: semanticsLabel ?? text,
      hint: semanticsHint,
      readOnly: true,
      child: textWidget,
    );
  }

  TextStyle _getTextStyle() {
    switch (variant) {
      case CustomTypographyVariant.h1:
        return AppTextStyles.h1;
      case CustomTypographyVariant.h2:
        return AppTextStyles.h2;
      case CustomTypographyVariant.h3:
        return AppTextStyles.h3;
      case CustomTypographyVariant.h4:
        return AppTextStyles.h4;
      case CustomTypographyVariant.h5:
        return AppTextStyles.h5;
      case CustomTypographyVariant.h6:
        return AppTextStyles.h6;
      case CustomTypographyVariant.bodyLarge:
        return AppTextStyles.bodyLarge;
      case CustomTypographyVariant.bodyMedium:
        return AppTextStyles.bodyMedium;
      case CustomTypographyVariant.bodySmall:
        return AppTextStyles.bodySmall;
      case CustomTypographyVariant.caption:
        return AppTextStyles.caption;
      case CustomTypographyVariant.overline:
        return AppTextStyles.overline;
      case CustomTypographyVariant.button:
        return AppTextStyles.button;
    }
  }
}

enum CustomTypographyVariant {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  bodyLarge,
  bodyMedium,
  bodySmall,
  caption,
  overline,
  button,
}
