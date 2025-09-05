import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/app_text_styles.dart';
import '../atoms/custom_text_field.dart';
import '../atoms/custom_typography.dart';

/// Grupo de campos de formulário com validação integrada
class FormFieldGroup extends StatefulWidget {
  final String? title;
  final List<FormFieldConfig> fields;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final bool showDividers;

  const FormFieldGroup({
    super.key,
    this.title,
    required this.fields,
    this.padding,
    this.spacing = AppDimensions.md,
    this.showDividers = false,
  });

  @override
  State<FormFieldGroup> createState() => _FormFieldGroupState();
}

class _FormFieldGroupState extends State<FormFieldGroup> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: widget.title != null ? 'Grupo de campos: ${widget.title}' : 'Grupo de campos',
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(AppDimensions.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null) ...[
              CustomTypography.h6(
                text: widget.title!,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppDimensions.lg),
            ],
            
            ...widget.fields.asMap().entries.map((entry) {
              final index = entry.key;
              final field = entry.value;
              final isLast = index == widget.fields.length - 1;
              
              return Column(
                children: [
                  _buildFormField(field),
                  if (!isLast) ...[
                    SizedBox(height: widget.spacing),
                    if (widget.showDividers)
                      Divider(
                        color: AppColors.borderColor,
                        height: widget.spacing,
                      ),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(FormFieldConfig config) {
    switch (config.type) {
      case FormFieldType.text:
        return CustomTextField(
          label: config.label,
          hint: config.hint,
          helperText: config.helperText,
          errorText: config.errorText,
          controller: config.controller,
          keyboardType: config.keyboardType ?? TextInputType.text,
          obscureText: config.obscureText ?? false,
          enabled: config.enabled ?? true,
          maxLines: config.maxLines,
          maxLength: config.maxLength,
          prefixIcon: config.prefixIcon,
          suffixIcon: config.suffixIcon,
          onSuffixIconTap: config.onSuffixIconTap,
          onChanged: config.onChanged,
          validator: config.validator,
          inputFormatters: config.inputFormatters,
        );
      
      case FormFieldType.dropdown:
        return _buildDropdownField(config);
      
      case FormFieldType.checkbox:
        return _buildCheckboxField(config);
      
      case FormFieldType.radio:
        return _buildRadioField(config);
    }
  }

  Widget _buildDropdownField(FormFieldConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTypography.bodyMedium(
          text: config.label,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppDimensions.sm),
        
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: config.errorText != null 
                  ? AppColors.error 
                  : AppColors.borderColor,
              width: 1.5,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: config.dropdownValue,
            hint: config.hint != null 
                ? Text(config.hint!, style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ))
                : null,
            items: config.dropdownItems?.map((item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Text(
                  item.label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
            onChanged: config.enabled == false ? null : config.onDropdownChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
                vertical: AppDimensions.md,
              ),
              prefixIcon: config.prefixIcon != null
                  ? Icon(
                      config.prefixIcon,
                      color: AppColors.textSecondary,
                      size: AppDimensions.iconSizeMd,
                    )
                  : null,
            ),
            validator: config.validator,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            dropdownColor: AppColors.surface,
            iconEnabledColor: AppColors.textSecondary,
            iconDisabledColor: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
        
        if (config.errorText != null) ...[
          const SizedBox(height: AppDimensions.xs),
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.lg),
            child: CustomTypography.caption(
              text: config.errorText!,
              color: AppColors.error,
            ),
          ),
        ],
        
        if (config.helperText != null && config.errorText == null) ...[
          const SizedBox(height: AppDimensions.xs),
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.lg),
            child: CustomTypography.caption(
              text: config.helperText!,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCheckboxField(FormFieldConfig config) {
    return Semantics(
      button: true,
      checked: config.checkboxValue,
      label: config.label,
      hint: 'Toque para marcar ou desmarcar',
      child: InkWell(
        onTap: config.enabled == false ? null : () {
          config.onCheckboxChanged?.call(!(config.checkboxValue ?? false));
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: config.checkboxValue ?? false,
                  onChanged: config.enabled == false ? null : config.onCheckboxChanged,
                  activeColor: AppColors.primary,
                  checkColor: AppColors.background,
                  side: BorderSide(
                    color: config.errorText != null 
                        ? AppColors.error 
                        : AppColors.borderColor,
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTypography.bodyMedium(
                      text: config.label,
                      color: AppColors.textPrimary,
                    ),
                    
                    if (config.helperText != null) ...[
                      const SizedBox(height: AppDimensions.xs),
                      CustomTypography.caption(
                        text: config.helperText!,
                        color: AppColors.textSecondary,
                      ),
                    ],
                    
                    if (config.errorText != null) ...[
                      const SizedBox(height: AppDimensions.xs),
                      CustomTypography.caption(
                        text: config.errorText!,
                        color: AppColors.error,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioField(FormFieldConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTypography.bodyMedium(
          text: config.label,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppDimensions.sm),
        
        ...?config.radioOptions?.map((option) {
          return Semantics(
            button: true,
            selected: config.radioValue == option.value,
            label: option.label,
            hint: 'Toque para selecionar esta opção',
            child: InkWell(
              onTap: config.enabled == false ? null : () {
                config.onRadioChanged?.call(option.value);
              },
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
                child: Row(
                  children: [
                    Radio<String>(
                      value: option.value,
                      groupValue: config.radioValue,
                      onChanged: config.enabled == false ? null : config.onRadioChanged,
                      activeColor: AppColors.primary,
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    
                    Expanded(
                      child: CustomTypography.bodyMedium(
                        text: option.label,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        
        if (config.errorText != null) ...[
          const SizedBox(height: AppDimensions.xs),
          CustomTypography.caption(
            text: config.errorText!,
            color: AppColors.error,
          ),
        ],
        
        if (config.helperText != null && config.errorText == null) ...[
          const SizedBox(height: AppDimensions.xs),
          CustomTypography.caption(
            text: config.helperText!,
            color: AppColors.textSecondary,
          ),
        ],
      ],
    );
  }
}

/// Configuração de campo de formulário
class FormFieldConfig {
  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final FormFieldType type;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? enabled;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  
  // Dropdown specific
  final String? dropdownValue;
  final List<DropdownItem>? dropdownItems;
  final ValueChanged<String?>? onDropdownChanged;
  
  // Checkbox specific
  final bool? checkboxValue;
  final ValueChanged<bool?>? onCheckboxChanged;
  
  // Radio specific
  final String? radioValue;
  final List<RadioOption>? radioOptions;
  final ValueChanged<String?>? onRadioChanged;

  FormFieldConfig({
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    required this.type,
    this.controller,
    this.keyboardType,
    this.obscureText,
    this.enabled,
    this.maxLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.dropdownValue,
    this.dropdownItems,
    this.onDropdownChanged,
    this.checkboxValue,
    this.onCheckboxChanged,
    this.radioValue,
    this.radioOptions,
    this.onRadioChanged,
  });
}

enum FormFieldType { text, dropdown, checkbox, radio }

class DropdownItem {
  final String label;
  final String value;

  DropdownItem({required this.label, required this.value});
}

class RadioOption {
  final String label;
  final String value;

  RadioOption({required this.label, required this.value});
}