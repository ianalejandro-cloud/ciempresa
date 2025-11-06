// lib/widgets/buttons/secondary_button.dart
import 'package:ciempresas/core/theme/app_button_styles.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final double borderRadius;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    this.text = 'Cancelar',
    this.backgroundColor = const Color(0xFFF8F9FA),
    this.textColor = const Color(0xFF101010),
    this.borderColor = const Color(0xFF101010),
    this.width,
    this.height,
    this.padding,
    this.elevation = 0,
    this.borderRadius = 49.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppButtonStyles.secondaryButton(context: context),
        child: Text("Cancelar"),
      ),
    );
  }
}
