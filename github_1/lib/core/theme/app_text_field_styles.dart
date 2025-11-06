import 'package:flutter/material.dart';
import 'package:ciempresas/core/theme/app_theme.dart';

class AppTextFieldStyles {
  // Default colors
  static const Color defaultFillColor = Color(0xFFEDEFF1);
  static const Color defaultUnderlineColor = Color(0xFF95C60F);

  // Default input decoration
  static InputDecoration defaultInputDecoration({
    required String labelText,
    bool filled = true,
    Color? fillColor,
    Color? underlineColor,
    Widget? suffixIcon,
    Color? textColor,
    BuildContext? context,
  }) {
    final borderColor = underlineColor ?? Colors.grey;
    final focusedBorderColor = underlineColor ?? defaultUnderlineColor;

    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: fillColor ?? defaultFillColor,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
      ),
      suffixIcon: suffixIcon,
      // Aplicar el color personalizado a todos los estados del borde
      border: UnderlineInputBorder(borderSide: BorderSide(color: borderColor)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
      ),
      labelStyle: context != null
          ? context.theme.appTextTheme.textFieldInput
          : const TextStyle(color: Colors.black, fontSize: 16),
      floatingLabelStyle: context != null
          ? context.theme.appTextTheme.textFieldInput.copyWith(
              fontSize: 14,
              color: Colors.grey,
            )
          : const TextStyle(color: Colors.grey, fontSize: 14),
      // Asegurando que el alto sea consistente

      // Estilo cuando hay un error
      errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
    );
  }

  // Error style for validation
  static InputDecoration errorInputDecoration({
    required String errorText,
    bool filled = true,
    Color? fillColor,
  }) {
    return InputDecoration(
      errorText: errorText,
      filled: filled,
      fillColor: fillColor ?? defaultFillColor,
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      // Mismo padding que el estilo normal
      contentPadding: const EdgeInsets.only(top: 15, bottom: 15),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
      // Mantener consistencia con el estilo normal
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 16),
      floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 16),
      isDense: true,
    );
  }
}
