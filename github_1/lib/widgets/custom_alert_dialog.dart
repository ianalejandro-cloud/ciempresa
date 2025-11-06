import 'package:ciempresas/core/constants/app_constant_enum.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final AlertType type;
  final String title;
  final String message;
  final String buttonText;
  final Function() onButtonPressed;

  const CustomAlertDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.buttonText = 'Aceptar',
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _getIcon(),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            message,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIcon() {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case AlertType.success:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case AlertType.error:
        iconData = Icons.error;
        iconColor = Colors.red;
        break;
      case AlertType.warning:
        iconData = Icons.warning;
        iconColor = Colors.orange;
        break;
      case AlertType.info:
        iconData = Icons.info;
        iconColor = Colors.blue;
        break;
    }

    return Icon(iconData, color: iconColor, size: 30);
  }
}

// Función de ayuda para mostrar el diálogo fácilmente desde cualquier parte de la app
Future<void> showCustomAlert({
  required BuildContext context,
  required AlertType type,
  required String title,
  required String message,
  String buttonText = 'Aceptar',
  required Function() onButtonPressed,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => CustomAlertDialog(
      type: type,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    ),
  );
}
