import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

// Import no necesario ya que usamos Theme.of(context)
// import 'app_theme.dart'; // Eliminamos este import ya que no es necesario

/// Clase para centralizar los estilos de los botones primarios
class AppButtonStyles {
  static ButtonStyle elevatedButton({
    required BuildContext context,
    FontWeight fontWeight = FontWeight.normal,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 24,
    ),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(30)),
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: context.theme.appColors.primary,
      foregroundColor: context.theme.appColors.background,
      padding: padding,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
    );
  }

  static ButtonStyle secondaryButton({
    required BuildContext context,
    FontWeight fontWeight = FontWeight.normal,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 32,
    ),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(30)),
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ElevatedButton.styleFrom(
      backgroundColor: context.theme.appColors.secondary,
      foregroundColor: context.theme.appColors.primary,
      padding: padding,
      side: BorderSide(color: colors.primary, width: 1.0),
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      elevation: 0,
    );
  }
}
