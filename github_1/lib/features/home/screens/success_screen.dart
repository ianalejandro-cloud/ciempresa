import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:ciempresas/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

/// Pantalla de éxito reutilizable que muestra un mensaje de confirmación
/// con un ícono de check verde y un botón personalizable.
///
/// Puede ser utilizada en cualquier flujo donde se necesite mostrar
/// una confirmación de éxito al usuario.
class SuccessScreen extends StatelessWidget {
  /// El mensaje de éxito a mostrar
  final String successMessage;

  /// La función a ejecutar cuando se presiona el botón
  final VoidCallback onFinishPressed;

  /// El texto del botón (por defecto "Finalizar")
  final String buttonText;

  const SuccessScreen({
    super.key,
    required this.successMessage,
    required this.onFinishPressed,
    this.buttonText = 'Finalizar',
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // Espaciado superior
                SizedBox(height: screenHeight * 0.15),

                // Ícono de éxito
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF9BCE3E), // Verde claro del diseño
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 60),
                ),

                // Espaciado
                SizedBox(height: screenHeight * 0.08),

                // Mensaje de éxito
                Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth > 600 ? 500 : screenWidth * 0.9,
                  ),
                  child: Text(
                    successMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.theme.appColors.onBackground,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),

                // Spacer que empuja el botón hacia abajo
                const Spacer(),

                // Botón Finalizar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: PrimaryButton(
                    text: buttonText,
                    onPressed: onFinishPressed,
                  ),
                ),

                // Espaciado inferior
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
