import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/app_text_styles.dart';

/// Campo de entrada personalizado com animações e acessibilidade
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.onChanged,
    this.validator,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with TickerProviderStateMixin {
  late AnimationController _focusController;
  late AnimationController _errorController;
  late Animation<double> _labelAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<double> _errorAnimation;

  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _errorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _labelAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeOut,
    ));

    _borderColorAnimation = ColorTween(
      begin: AppColors.borderColor,
      end: AppColors.primary,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeOut,
    ));

    _errorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _errorController,
      curve: Curves.elasticOut,
    ));

    _focusNode.addListener(_onFocusChange);
    
    if (widget.controller != null) {
      _hasText = widget.controller!.text.isNotEmpty;
      widget.controller!.addListener(_onTextChange);
    }

    if (widget.errorText != null) {
      _errorController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.errorText != null && oldWidget.errorText == null) {
      _errorController.forward();
    } else if (widget.errorText == null && oldWidget.errorText != null) {
      _errorController.reverse();
    }

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onTextChange);
      if (widget.controller != null) {
        _hasText = widget.controller!.text.isNotEmpty;
        widget.controller!.addListener(_onTextChange);
      }
    }
  }

  @override
  void dispose() {
    _focusController.dispose();
    _errorController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller?.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_focusNode.hasFocus || _hasText) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  void _onTextChange() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
      
      if (_hasText || _isFocused) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: widget.label,
      hint: widget.hint,
      enabled: widget.enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_labelAnimation, _borderColorAnimation]),
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  children: [
                    // Text field
                    TextFormField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      keyboardType: widget.keyboardType,
                      obscureText: widget.obscureText,
                      enabled: widget.enabled,
                      maxLines: widget.maxLines,
                      maxLength: widget.maxLength,
                      inputFormatters: widget.inputFormatters,
                      validator: widget.validator,
                      onChanged: widget.onChanged,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: widget.enabled 
                            ? AppColors.textPrimary 
                            : AppColors.textSecondary,
                      ),
                      decoration: InputDecoration(
                        hintText: _isFocused || _hasText ? widget.hint : null,
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: widget.prefixIcon != null
                            ? Icon(
                                widget.prefixIcon,
                                color: _isFocused 
                                    ? AppColors.primary 
                                    : AppColors.textSecondary,
                                size: AppDimensions.iconSizeMd,
                              )
                            : null,
                        suffixIcon: widget.suffixIcon != null
                            ? GestureDetector(
                                onTap: widget.onSuffixIconTap,
                                child: Icon(
                                  widget.suffixIcon,
                                  color: _isFocused 
                                      ? AppColors.primary 
                                      : AppColors.textSecondary,
                                  size: AppDimensions.iconSizeMd,
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          borderSide: BorderSide(
                            color: AppColors.borderColor,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          borderSide: BorderSide(
                            color: widget.errorText != null 
                                ? AppColors.error 
                                : AppColors.borderColor,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          borderSide: BorderSide(
                            color: widget.errorText != null 
                                ? AppColors.error 
                                : AppColors.primary,
                            width: 2.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          borderSide: BorderSide(
                            color: AppColors.error,
                            width: 1.5,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          borderSide: BorderSide(
                            color: AppColors.error,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.lg,
                          vertical: AppDimensions.md,
                        ),
                        counterText: '',
                      ),
                    ),
                    
                    // Floating label
                    Positioned(
                      left: widget.prefixIcon != null ? 48 : AppDimensions.lg,
                      top: 0,
                      child: AnimatedBuilder(
                        animation: _labelAnimation,
                        builder: (context, child) {
                          final labelScale = 0.75 + (0.25 * (1 - _labelAnimation.value));
                          final labelY = 16 + (-8 * _labelAnimation.value);
                          
                          return Transform.translate(
                            offset: Offset(0, labelY),
                            child: Transform.scale(
                              scale: labelScale,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                color: _labelAnimation.value > 0.5 
                                    ? AppColors.background 
                                    : Colors.transparent,
                                child: Text(
                                  widget.label,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: widget.errorText != null
                                        ? AppColors.error
                                        : _isFocused
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                    fontWeight: _isFocused || _hasText 
                                        ? FontWeight.w600 
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Helper and error text
          AnimatedBuilder(
            animation: _errorAnimation,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: (widget.errorText != null || widget.helperText != null) 
                    ? 20 : 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppDimensions.lg,
                    top: AppDimensions.xs,
                  ),
                  child: widget.errorText != null
                      ? Transform.translate(
                          offset: Offset(
                            10 * (1 - _errorAnimation.value) * 
                            (_errorAnimation.value < 0.5 ? -1 : 1), 
                            0
                          ),
                          child: Text(
                            widget.errorText!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : widget.helperText != null
                          ? Text(
                              widget.helperText!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            )
                          : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}