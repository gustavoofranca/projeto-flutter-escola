import 'package:flutter/material.dart';
import 'package:prime_edu/constants/app_colors.dart';
import 'package:prime_edu/constants/app_dimensions.dart';
import 'package:prime_edu/constants/app_text_styles.dart';

/// Botão personalizado com microinterações e acessibilidade
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final CustomButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    if (widget.isLoading) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(CustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _shimmerController.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _shimmerController.stop();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (_canInteract) {
      _scaleController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_canInteract) {
      _scaleController.reverse();
    }
  }

  void _onTapCancel() {
    if (_canInteract) {
      _scaleController.reverse();
    }
  }

  bool get _canInteract => widget.isEnabled && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final dimensions = _getDimensions();

    return Semantics(
      button: true,
      enabled: _canInteract,
      label: widget.text,
      hint: widget.isLoading ? 'Carregando' : 'Toque para executar ação',
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              onTap: _canInteract ? widget.onPressed : null,
              child: Container(
                height: dimensions.height,
                decoration: BoxDecoration(
                  gradient: widget.isLoading
                      ? null
                      : LinearGradient(
                          colors: [colors.primary, colors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  color: widget.isLoading ? colors.disabled : null,
                  borderRadius: BorderRadius.circular(dimensions.borderRadius),
                  boxShadow: _canInteract
                      ? [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(dimensions.borderRadius),
                  child: Stack(
                    children: [
                      // Shimmer effect for loading
                      if (widget.isLoading)
                        AnimatedBuilder(
                          animation: _shimmerAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withValues(alpha: 0.2),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                  begin: Alignment(_shimmerAnimation.value, 0),
                                  end: Alignment(
                                    _shimmerAnimation.value + 0.5,
                                    0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      // Button content
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: dimensions.horizontalPadding,
                          vertical: dimensions.verticalPadding,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null && !widget.isLoading) ...[
                              Icon(
                                widget.icon,
                                size: dimensions.iconSize,
                                color: colors.text,
                              ),
                              SizedBox(width: dimensions.iconSpacing),
                            ],

                            if (widget.isLoading)
                              SizedBox(
                                width: dimensions.iconSize,
                                height: dimensions.iconSize,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colors.text,
                                  ),
                                ),
                              )
                            else
                              Text(
                                widget.text,
                                style: dimensions.textStyle.copyWith(
                                  color: colors.text,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _ButtonColors _getColors() {
    switch (widget.variant) {
      case CustomButtonVariant.primary:
        return _ButtonColors(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          text: AppColors.background,
          disabled: AppColors.textSecondary,
        );
      case CustomButtonVariant.secondary:
        return _ButtonColors(
          primary: AppColors.surface,
          secondary: AppColors.surface,
          text: AppColors.primary,
          disabled: AppColors.textSecondary,
        );
      case CustomButtonVariant.outlined:
        return _ButtonColors(
          primary: Colors.transparent,
          secondary: Colors.transparent,
          text: AppColors.primary,
          disabled: AppColors.textSecondary,
        );
    }
  }

  _ButtonDimensions _getDimensions() {
    switch (widget.size) {
      case CustomButtonSize.small:
        return _ButtonDimensions(
          height: 36,
          horizontalPadding: AppDimensions.md,
          verticalPadding: AppDimensions.sm,
          borderRadius: AppDimensions.radiusSm,
          iconSize: AppDimensions.iconSizeSm,
          iconSpacing: AppDimensions.xs,
          textStyle: AppTextStyles.caption,
        );
      case CustomButtonSize.medium:
        return _ButtonDimensions(
          height: 48,
          horizontalPadding: AppDimensions.lg,
          verticalPadding: AppDimensions.md,
          borderRadius: AppDimensions.radiusMd,
          iconSize: AppDimensions.iconSizeMd,
          iconSpacing: AppDimensions.sm,
          textStyle: AppTextStyles.button,
        );
      case CustomButtonSize.large:
        return _ButtonDimensions(
          height: 56,
          horizontalPadding: AppDimensions.xl,
          verticalPadding: AppDimensions.md,
          borderRadius: AppDimensions.radiusLg,
          iconSize: AppDimensions.iconSizeLg,
          iconSpacing: AppDimensions.md,
          textStyle: AppTextStyles.buttonLarge,
        );
    }
  }
}

enum CustomButtonVariant { primary, secondary, outlined }

enum CustomButtonSize { small, medium, large }

class _ButtonColors {
  final Color primary;
  final Color secondary;
  final Color text;
  final Color disabled;

  _ButtonColors({
    required this.primary,
    required this.secondary,
    required this.text,
    required this.disabled,
  });
}

class _ButtonDimensions {
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double iconSize;
  final double iconSpacing;
  final TextStyle textStyle;

  _ButtonDimensions({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.iconSize,
    required this.iconSpacing,
    required this.textStyle,
  });
}
