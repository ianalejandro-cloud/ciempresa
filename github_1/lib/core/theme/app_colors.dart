import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  // Singleton instance
  static final AppColors _instance = AppColors._internal();
  
  // Factory constructor to return the same instance
  factory AppColors() => _instance;
  
  // Private constructor
  AppColors._internal();
  
  @override
  ThemeExtension<AppColors> copyWith() {
    return this;
  }
  
  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    return this;
  }
  // Colores primarios
  final Color primary = const Color(0xFF00A859); // Verde principal
  final Color primaryLight = const Color(0xFFE8F5E9); // Verde claro para fondos
  
  // Colores de acento
  final Color accentPink = const Color(0xFFE91E63); // Rosa/Magenta para íconos y elementos destacados
  final Color accentBlue = const Color(0xFF2196F3); // Azul para enlaces
  
  // Escala de grises
  final Color background = const Color(0xFFF5F5F5); // Fondo general
  final Color cardBackground = const Color(0xFFFFFFFF); // Fondo de tarjetas
  final Color inputBackground = const Color(0xFFEEEEEE); // Fondo de campos de entrada
  final Color textPrimary = const Color(0xFF212121); // Texto principal
  final Color textSecondary = const Color(0xFF757575); // Texto secundario
  final Color textHint = const Color(0xFF9E9E9E); // Placeholder
  final Color divider = const Color(0xFFE0E0E0); // Divisores y bordes
  
  // Botones
  final Color buttonPrimary = const Color(0xFF000000); // Botón principal
  final Color buttonText = const Color(0xFFFFFFFF); // Texto en botón
  final Color buttonDisabled = const Color(0xFFE0E0E0); // Botón deshabilitado
  final Color buttonDisabledText = const Color(0xFF9E9E9E); // Texto en botón deshabilitado
  
  // Estados
  final Color success = const Color(0xFF4CAF50); // Éxito
  final Color error = const Color(0xFFF44336); // Error
  final Color warning = const Color(0xFFFFC107); // Advertencia
  final Color info = const Color(0xFF2196F3); // Información
  
  // Barra de progreso
  final Color progressBackground = const Color(0xFFE0E0E0); // Fondo de la barra de progreso
  final Color progressFill = const Color(0xFF00A859); // Relleno de la barra de progreso
  
  // Sombras
  static const BoxShadow cardShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    blurRadius: 4,
    offset: Offset(0, 2),
  );
}
