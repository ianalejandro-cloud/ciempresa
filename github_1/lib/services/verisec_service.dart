import 'package:flutter/services.dart';

class VerisecService {
  static const MethodChannel _channel = MethodChannel('com.cibanco.superapp/channel');
  
  static bool _isProvisioned = false;
  static String _tokenSerial = '';
  
  static bool get isProvisioned => _isProvisioned;
  static String get tokenSerial => _tokenSerial;

  /// PASO 1: Realizar afiliación
  static Future<String> performAffiliation(String clientCode) async {
    try {
      final String result = await _channel.invokeMethod('performAffiliation', clientCode);
      if (result.isNotEmpty && !result.startsWith('ERROR')) {
        return result;
      } else {
        throw VerisecException('Error en afiliación: $result');
      }
    } on PlatformException catch (e) {
      throw VerisecException('Error de plataforma: ${e.message}');
    }
  }

  /// PASO 2: Realizar login
  static Future<String> performLogin(String nip) async {
    try {
      if (nip.isEmpty || nip.length < 4) {
        throw VerisecException('NIP debe tener al menos 4 dígitos');
      }
      
      final String result = await _channel.invokeMethod('performLogin', nip);
      if (result.isNotEmpty && !result.startsWith('ERROR')) {
        _isProvisioned = true;
        _tokenSerial = result;
        return result;
      } else {
        throw VerisecException('Error en login: $result');
      }
    } on PlatformException catch (e) {
      throw VerisecException('Error de plataforma: ${e.message}');
    }
  }

  /// PASO 3: Generar OTP
  static Future<String> generateOTP(String nip) async {
    try {
      if (!_isProvisioned) {
        throw VerisecException('Usuario no está aprovisionado');
      }
      
      final String result = await _channel.invokeMethod('generateOTP', nip);
      if (result.isNotEmpty && !result.startsWith('ERROR')) {
        return result;
      } else {
        throw VerisecException('Error generando OTP: $result');
      }
    } on PlatformException catch (e) {
      throw VerisecException('Error de plataforma: ${e.message}');
    }
  }
  
  static void clearState() {
    _isProvisioned = false;
    _tokenSerial = '';
  }
}

class VerisecException implements Exception {
  final String message;
  VerisecException(this.message);
  
  @override
  String toString() => 'VerisecException: $message';
}
