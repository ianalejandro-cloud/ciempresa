import 'package:ciempresas/custom_code/actions/generar_otp_con_nip.dart';
import 'package:flutter/material.dart';

enum OtpGenerationState { idle, loading, success, error }

class OtpGenerationProvider extends ChangeNotifier {
  OtpGenerationState _state = OtpGenerationState.idle;
  OtpGenerationState get state => _state;

  String _generatedOtp = '';
  String get generatedOtp => _generatedOtp;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  DateTime? _lastOtpGenerationTime;
  DateTime? get lastOtpGenerationTime => _lastOtpGenerationTime;

  bool get isLoading => _state == OtpGenerationState.loading;
  bool get hasError => _state == OtpGenerationState.error;
  bool get hasSuccess => _state == OtpGenerationState.success;

  /// Genera un OTP usando el NIP proporcionado
  Future<void> generateOtp(String nip) async {
    // Validar formato del NIP
    if (!_validateNip(nip)) {
      return;
    }

    _state = OtpGenerationState.loading;
    _errorMessage = '';
    _generatedOtp = '';
    notifyListeners();

    try {
      debugPrint('🔄 [OtpProvider] Generando OTP con NIP: $nip');

      // Llamar a la función de generación de OTP
      final String otpResult = await generarOtpConNip(nip);

      debugPrint('📄 [OtpProvider] Respuesta de generarOtpConNip: $otpResult');

      if (otpResult.isNotEmpty && !otpResult.startsWith('ERROR')) {
        debugPrint('✅ [OtpProvider] OTP generado exitosamente: $otpResult');

        _generatedOtp = otpResult;
        _lastOtpGenerationTime = DateTime.now();
        _state = OtpGenerationState.success;
      } else {
        debugPrint('❌ [OtpProvider] Error al generar OTP: $otpResult');

        _state = OtpGenerationState.error;
        _errorMessage = otpResult.startsWith('ERROR')
            ? 'Error en el servicio Verisec'
            : 'No se pudo generar el OTP. Inténtalo de nuevo.';
      }
    } catch (e) {
      debugPrint('🚨 [OtpProvider] Excepción al generar OTP: $e');

      _state = OtpGenerationState.error;
      _errorMessage =
          'Error de conexión. Verifica tu red e inténtalo de nuevo.';
    }

    notifyListeners();
  }

  /// Valida el formato del NIP
  bool _validateNip(String nip) {
    // Validar longitud
    if (nip.length != 6) {
      _state = OtpGenerationState.error;
      _errorMessage = 'El NIP debe tener 6 dígitos';
      notifyListeners();
      return false;
    }

    // Validar que solo contenga números
    if (!RegExp(r'^\d{6}$').hasMatch(nip)) {
      _state = OtpGenerationState.error;
      _errorMessage = 'El NIP debe contener solo números';
      notifyListeners();
      return false;
    }

    return true;
  }

  /// Limpia el estado de error
  void clearError() {
    if (_state == OtpGenerationState.error) {
      _state = OtpGenerationState.idle;
      _errorMessage = '';
      notifyListeners();
    }
  }

  /// Limpia todos los datos
  void clearData() {
    _state = OtpGenerationState.idle;
    _generatedOtp = '';
    _errorMessage = '';
    notifyListeners();
  }

  /// Obtiene el tiempo restante para poder generar otro OTP (en segundos)
  int get secondsUntilNextOtp {
    if (_lastOtpGenerationTime == null) return 0;

    final elapsed = DateTime.now().difference(_lastOtpGenerationTime!);
    final remaining = 30 - elapsed.inSeconds;

    return remaining > 0 ? remaining : 0;
  }

  /// Verifica si se puede generar otro OTP
  bool get canGenerateOtp {
    return secondsUntilNextOtp == 0;
  }
}
