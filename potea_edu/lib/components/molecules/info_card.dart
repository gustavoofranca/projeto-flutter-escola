import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../atoms/custom_typography.dart';

/// Card de informação com animações e microinterações
class InfoCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showBorder;
  final bool showShadow;
  final EdgeInsetsGeometry? padding;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.trailing,
    this.showBorder = false,
    this.showShadow = true,
    this.padding,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tapController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: widget.showShadow ? 2.0 : 0.0,
      end: widget.showShadow ? 8.0 : 0.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _tapController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _tapController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _tapController.reverse();
    }
  }

  void _onHoverChange(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered && widget.onTap != null) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: widget.onTap != null,
      label: widget.title,
      hint: widget.onTap != null ? 'Toque para mais informações' : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([_elevationAnimation, _scaleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: MouseRegion(
              onEnter: (_) => _onHoverChange(true),
              onExit: (_) => _onHoverChange(false),
              child: GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: widget.showBorder
                        ? Border.all(
                            color: _isHovered 
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : AppColors.borderColor,
                            width: 1.5,
                          )
                        : null,
                    boxShadow: widget.showShadow
                        ? [
                            BoxShadow(
                              color: AppColors.overlay,
                              blurRadius: _elevationAnimation.value,
                              offset: Offset(0, _elevationAnimation.value / 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: widget.padding ?? const EdgeInsets.all(AppDimensions.lg),
                    child: Row(
                      children: [
                        // Icon
                        if (widget.icon != null) ...[
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(AppDimensions.md),
                            decoration: BoxDecoration(
                              color: (widget.iconColor ?? AppColors.primary)
                                  .withValues(alpha: _isHovered ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                            ),
                            child: Icon(
                              widget.icon,
                              size: AppDimensions.iconSizeLg,
                              color: widget.iconColor ?? AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.md),
                        ],
                        
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTypography.h6(
                                text: widget.title,
                                color: AppColors.textPrimary,
                              ),
                              
                              if (widget.subtitle != null) ...[
                                const SizedBox(height: AppDimensions.xs),
                                CustomTypography.bodySmall(
                                  text: widget.subtitle!,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                              
                              if (widget.description != null) ...[
                                const SizedBox(height: AppDimensions.sm),
                                CustomTypography.bodyMedium(
                                  text: widget.description!,
                                  color: AppColors.textPrimary,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        
                        // Trailing
                        if (widget.trailing != null) ...[
                          const SizedBox(width: AppDimensions.md),
                          widget.trailing!,
                        ] else if (widget.onTap != null) ...[
                          const SizedBox(width: AppDimensions.md),
                          AnimatedRotation(
                            turns: _isHovered ? 0.125 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: AppDimensions.iconSizeMd,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Card estatístico com animação de crescimento
class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool animateValue;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.animateValue = true,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));

    if (widget.animateValue) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.title}: ${widget.value}',
      hint: widget.subtitle,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.lg),
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.overlay,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomTypography.bodySmall(
                            text: widget.title,
                            color: AppColors.textSecondary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          widget.icon,
                          size: AppDimensions.iconSizeMd,
                          color: widget.iconColor ?? AppColors.primary,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppDimensions.md),
                    
                    CustomTypography.h4(
                      text: widget.value,
                      color: AppColors.textPrimary,
                    ),
                    
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: AppDimensions.xs),
                      CustomTypography.caption(
                        text: widget.subtitle!,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}