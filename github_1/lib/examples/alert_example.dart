import 'package:ciempresas/core/constants/app_constant_enum.dart';
import 'package:flutter/material.dart';
import 'package:ciempresas/widgets/custom_alert_dialog.dart';

class AlertExampleScreen extends StatelessWidget {
  const AlertExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejemplos de Alertas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showSuccessAlert(context),
              child: const Text('Alerta de Éxito'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showErrorAlert(context),
              child: const Text('Alerta de Error'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showWarningAlert(context),
              child: const Text('Alerta de Advertencia'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showInfoAlert(context),
              child: const Text('Alerta de Información'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessAlert(BuildContext context) {
    showCustomAlert(
      context: context,
      type: AlertType.success,
      title: 'Operación Exitosa',
      message: 'La operación se ha completado correctamente.',
      onButtonPressed: () {
        Navigator.of(context).pop();
        // Aquí puedes ejecutar acciones adicionales después de cerrar la alerta
        debugPrint('Alerta de éxito cerrada');
      },
    );
  }

  void _showErrorAlert(BuildContext context) {
    showCustomAlert(
      context: context,
      type: AlertType.error,
      title: 'Error',
      message: 'Ha ocurrido un error al procesar la solicitud.',
      buttonText: 'Entendido',
      onButtonPressed: () {
        Navigator.of(context).pop();
        debugPrint('Alerta de error cerrada');
      },
    );
  }

  void _showWarningAlert(BuildContext context) {
    showCustomAlert(
      context: context,
      type: AlertType.warning,
      title: 'Advertencia',
      message: 'Esta acción podría tener consecuencias importantes.',
      buttonText: 'Continuar',
      onButtonPressed: () {
        Navigator.of(context).pop();
        debugPrint('Alerta de advertencia cerrada');
      },
    );
  }

  void _showInfoAlert(BuildContext context) {
    showCustomAlert(
      context: context,
      type: AlertType.info,
      title: 'Información',
      message: 'Aquí tienes información importante sobre esta función.',
      onButtonPressed: () {
        Navigator.of(context).pop();
        debugPrint('Alerta de información cerrada');
      },
    );
  }
}
