import 'package:ciempresas/core/constants/app_constant_enum.dart';
import 'package:flutter/material.dart';
import 'package:ciempresas/widgets/custom_confirm_dialog.dart';

class ConfirmDialogExampleScreen extends StatelessWidget {
  const ConfirmDialogExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejemplos de Diálogos de Confirmación')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showSuccessConfirm(context),
              child: const Text('Confirmación de Éxito'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showErrorConfirm(context),
              child: const Text('Confirmación de Error'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showWarningConfirm(context),
              child: const Text('Confirmación de Advertencia'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showInfoConfirm(context),
              child: const Text('Confirmación de Información'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessConfirm(BuildContext context) {
    showConfirmDialog(
      context: context,
      type: AlertType.success,
      title: 'Operación Exitosa',
      message: '¿Deseas continuar con la siguiente operación?',
      onCancelPressed: () {
        Navigator.of(context).pop();
        debugPrint('Operación cancelada');
      },
      onConfirmPressed: () {
        Navigator.of(context).pop();
        debugPrint('Operación confirmada');
        // Aquí puedes ejecutar acciones adicionales después de confirmar
      },
    );
  }

  void _showErrorConfirm(BuildContext context) {
    showConfirmDialog(
      context: context,
      type: AlertType.error,
      title: 'Error',
      message: '¿Deseas intentar nuevamente?',
      cancelButtonText: 'No',
      confirmButtonText: 'Sí',
      onCancelPressed: () {
        Navigator.of(context).pop();
        debugPrint('No se reintentará');
      },
      onConfirmPressed: () {
        Navigator.of(context).pop();
        debugPrint('Se reintentará la operación');
      },
    );
  }

  void _showWarningConfirm(BuildContext context) {
    showConfirmDialog(
      context: context,
      type: AlertType.warning,
      title: 'Advertencia',
      message: 'Esta acción no se puede deshacer. ¿Estás seguro de continuar?',
      cancelButtonText: 'Volver',
      confirmButtonText: 'Continuar',
      onCancelPressed: () {
        Navigator.of(context).pop();
        debugPrint('Acción cancelada');
      },
      onConfirmPressed: () {
        Navigator.of(context).pop();
        debugPrint('Acción confirmada');
      },
    );
  }

  void _showInfoConfirm(BuildContext context) {
    showConfirmDialog(
      context: context,
      type: AlertType.info,
      title: 'Información',
      message: '¿Deseas recibir notificaciones sobre este tema?',
      cancelButtonText: 'No, gracias',
      confirmButtonText: 'Sí, por favor',
      onCancelPressed: () {
        Navigator.of(context).pop();
        debugPrint('Notificaciones rechazadas');
      },
      onConfirmPressed: () {
        Navigator.of(context).pop();
        debugPrint('Notificaciones aceptadas');
      },
    );
  }
}
