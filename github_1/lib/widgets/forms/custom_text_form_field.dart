// lib/widgets/forms/custom_text_form_field.dart
import 'package:ciempresas/core/theme/app_text_field_styles.dart';
import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final int? maxLength;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool filled;
  final Color? fillColor;
  final Color? underlineColor;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? errorText;
  final bool showPasswordToggle;
  final bool enabled;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.maxLength, // Por defecto null, no limitar
    this.controller,
    this.validator,
    this.suffixIcon,
    this.filled = true,
    this.fillColor,
    this.underlineColor,
    this.keyboardType,
    this.onChanged,
    this.errorText,
    this.showPasswordToggle = false,
    this.enabled = true,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.showPasswordToggle ? true : widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon = widget.suffixIcon;
    if (widget.showPasswordToggle) {
      suffixIcon = IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return TextFormField(
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      controller: widget.controller,
      obscureText: widget.showPasswordToggle
          ? _obscureText
          : widget.obscureText,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      style: widget.enabled
          ? context
                .theme
                .appTextTheme
                .textFieldInput // Estilo normal cuando está habilitado
          : context
                .theme
                .appTextTheme
                .textFieldDisabledInput, // Estilo gris cuando está deshabilitado
      decoration:
          AppTextFieldStyles.defaultInputDecoration(
            labelText: widget.labelText,
            filled: widget.filled,
            fillColor: widget.fillColor,
            underlineColor: widget.underlineColor,
            suffixIcon: suffixIcon,
            context: context,
          ).copyWith(
            counterText: "", // Oculta el contador de caracteres visual
          ),
      validator: widget.validator,
    );
  }
}
