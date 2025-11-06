import 'package:ciempresas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomMaskedTextWidget extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final ValueChanged<String>? onChanged;

  const CustomMaskedTextWidget({
    super.key,
    required this.controller,
    required this.title,
    this.onChanged,
  });

  @override
  State<CustomMaskedTextWidget> createState() => _CustomMaskedTextWidgetState();
}

class _CustomMaskedTextWidgetState extends State<CustomMaskedTextWidget> {
  late String _maskedText;

  @override
  void initState() {
    super.initState();
    _maskedText = _maskText(widget.controller.text);
    widget.controller.addListener(_updateMaskedText);
  }

  @override
  void didUpdateWidget(CustomMaskedTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updateMaskedText);
      widget.controller.addListener(_updateMaskedText);
    }
    // Forzar actualización cuando cambia el widget
    _updateMaskedText();
  }

  void _updateMaskedText() {
    if (mounted) {
      try {
        final text = widget.controller.text;
        setState(() {
          _maskedText = _maskText(text);
        });
        // Llamar al callback si está definido
        if (widget.onChanged != null) {
          widget.onChanged!(text);
        }
      } catch (e) {
        // Ignorar errores si el controlador ha sido eliminado
        debugPrint('Error al actualizar texto enmascarado: $e');
      }
    }
  }

  String _maskText(String text) => '*' * text.length;

  @override
  void dispose() {
    try {
      widget.controller.removeListener(_updateMaskedText);
    } catch (e) {
      // Ignorar errores si el controlador ya ha sido eliminado
      debugPrint('Error al eliminar listener: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color lineColor;
    try {
      lineColor = widget.controller.text.isNotEmpty
          ? context.theme.appColors.customGreen
          : context.theme.appColors.grey300;
    } catch (e) {
      // Si hay un error al acceder al controlador, usar el color gris
      lineColor = context.theme.appColors.grey300;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_maskedText, style: context.theme.appTextTheme.cardSubtitle),
          const SizedBox(height: 10),
          Container(width: 150, height: 3, color: lineColor),
          const SizedBox(height: 10),
          Text(widget.title, style: context.theme.appTextTheme.cardSubtitle),
        ],
      ),
    );
  }
}
