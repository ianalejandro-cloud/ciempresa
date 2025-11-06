import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ciempresas/core/i18n/app_localizations_extension.dart';

class SoftTokenGeneratedModal extends StatefulWidget {
  final VoidCallback? onClose;
  final String? generatedOtp;

  const SoftTokenGeneratedModal({super.key, this.onClose, this.generatedOtp});

  @override
  State<SoftTokenGeneratedModal> createState() =>
      _SoftTokenGeneratedModalState();
}

class _SoftTokenGeneratedModalState extends State<SoftTokenGeneratedModal> {
  late String _generatedToken;
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generateToken();
    _remainingSeconds = 30; // 30 segundos por defecto
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateToken() {
    if (widget.generatedOtp != null && widget.generatedOtp!.isNotEmpty) {
      // Usar el OTP real generado por Verisec
      _generatedToken = widget.generatedOtp!;

      // Si el OTP no tiene formato de espacios y tiene 6+ dígitos, agregar formato
      if (_generatedToken.length >= 6 && !_generatedToken.contains(' ')) {
        if (_generatedToken.length == 6) {
          // Formato: XXX XXX
          _generatedToken =
              '${_generatedToken.substring(0, 3)} ${_generatedToken.substring(3)}';
        } else if (_generatedToken.length >= 8) {
          // Formato: XXXX XXXX
          _generatedToken =
              '${_generatedToken.substring(0, 4)} ${_generatedToken.substring(4, 8)}';
        }
      }
    } else {
      // Generar un token simulado de 8 dígitos (4 + espacio + 4) como fallback
      final random = Random();
      final firstPart = (1000 + random.nextInt(9000)).toString();
      final secondPart = (1000 + random.nextInt(9000)).toString();
      _generatedToken = '$firstPart $secondPart';
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        // Token expirado, cerrar automáticamente
        widget.onClose?.call();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(
      ClipboardData(text: _generatedToken.replaceAll(' ', '')),
    );

    // Mostrar snackbar de confirmación
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('token_copied_to_clipboard')),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Título
            Text(
              context.tr('soft_token'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),

            // Token generado
            Text(
              _generatedToken,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),

            // Icono de copiar
            GestureDetector(
              onTap: _copyToClipboard,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.copy_outlined,
                  size: 24,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Timer
            Text(
              '${context.tr('remaining_time')} ${_formatTime(_remainingSeconds)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Mensaje explicativo
            Text(
              context.tr('token_security_message'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Botón Cerrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => widget.onClose?.call(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  context.tr('close'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Función helper para mostrar el modal del token generado
void showSoftTokenGeneratedModal(BuildContext context, {String? generatedOtp}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: false, // No permitir cerrar tocando fuera
    enableDrag: false, // No permitir cerrar arrastrando
    builder: (context) => SoftTokenGeneratedModal(
      generatedOtp: generatedOtp,
      onClose: () {
        Navigator.of(context).pop();
      },
    ),
  );
}
