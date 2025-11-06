import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// Un servicio para obtener información de la red del dispositivo.
class NetworkInfoService {
  final _networkInfo = NetworkInfo();

  /// Recupera la dirección IP del WiFi del dispositivo.
  ///
  /// Devuelve la dirección IP como un String.
  /// Retorna '10.0.2.2' para el emulador de Android como fallback.
  /// Retorna null si ocurre un error o no se puede obtener la IP.
  Future<String?> getIpAddress() async {
    try {
      return await _networkInfo.getWifiIP() ?? '10.0.2.2';
    } catch (e) {
      debugPrint('Error al obtener la dirección IP: $e');
      return '10.0.2.2'; // Fallback en caso de error
    }
  }
}
