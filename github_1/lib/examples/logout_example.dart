import 'package:ciempresas/core/restFull/rest_manager.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:flutter/material.dart';

/// Ejemplo de uso del método logout de RestManager
class LogoutExample {
  final RestManager _restManager = RestManager();

  /// Función de logout con manejo completo de respuesta
  Future<void> logout() async {
    debugPrint('🔄 Iniciando proceso de logout...');

    try {
      final result = await _restManager.logout();

      switch (result) {
        case Success(value: final data):
          debugPrint('✅ Logout exitoso');
          debugPrint('📄 Respuesta del servidor: $data');

          // Limpiar tokens locales después del logout exitoso
          await _restManager.clearTokens();

          // Aquí puedes agregar lógica adicional como:
          // - Navegar a pantalla de login
          // - Limpiar datos del usuario
          // - Mostrar mensaje de confirmación

          break;

        case Failure(exception: final error):
          debugPrint('❌ Error en logout');
          debugPrint('📄 Error: $error');

          // Manejar error de logout
          // Aún así podrías limpiar tokens locales si es necesario

          break;
      }
    } catch (e) {
      debugPrint('🚨 Excepción durante logout: $e');

      // Manejar excepción inesperada
      // Considerar limpiar tokens locales como fallback
    }
  }

  /// Función simplificada de logout
  Future<bool> simpleLogout() async {
    final result = await _restManager.logout();

    switch (result) {
      case Success():
        await _restManager.clearTokens();
        return true;
      case Failure():
        return false;
    }
  }
}
