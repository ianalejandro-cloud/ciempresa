import 'package:flutter/foundation.dart';

/// Configuración centralizada para las APIs
class ApiConfig {
  final String baseUrl;
  final String authServiceUrl;
  final String managementServiceUrl;
  final String clientServiceUrl;
  final Duration timeout;
  final bool isDev;
  
  const ApiConfig({
    required this.baseUrl,
    required this.authServiceUrl,
    required this.managementServiceUrl,
    required this.clientServiceUrl,
    this.timeout = const Duration(minutes: 2),
    this.isDev = false,
  });
  
  /// Crea una configuración basada en variables de entorno
  factory ApiConfig.fromEnvironment() {
    return ApiConfig(
      baseUrl: const String.fromEnvironment(
        'BASE_URL',
        defaultValue: 'https://apiqa.cibanco.com',
      ),
      authServiceUrl: const String.fromEnvironment(
        'BASE_URL_AUTH',
        defaultValue: 'https://cibc-mcnet-authenticate-238857314839.us-central1.run.app',
      ),
      managementServiceUrl: const String.fromEnvironment(
        'BASE_URL_MANAGEMENT',
        defaultValue: 'https://cibc-mcnet-user-management-238857314839.us-central1.run.app',
      ),
      clientServiceUrl: const String.fromEnvironment(
        'BASE_URL_CLIENT',
        defaultValue: 'http://10.1.9.119:7839',
      ),
      isDev: false,
    );
  }
  
  /// Crea una configuración para desarrollo local
  factory ApiConfig.dev() {
    return ApiConfig(
      baseUrl: 'http://10.0.2.2:8000',
      authServiceUrl: 'http://10.0.2.2:8001',
      managementServiceUrl: 'http://10.0.2.2:8002',
      clientServiceUrl: 'http://10.0.2.2:8003',
      isDev: true,
    );
  }
  
  /// Imprime la configuración actual (útil para depuración)
  void printConfig() {
    debugPrint('API Config:');
    debugPrint('- Base URL: $baseUrl');
    debugPrint('- Auth Service URL: $authServiceUrl');
    debugPrint('- Management Service URL: $managementServiceUrl');
    debugPrint('- Client Service URL: $clientServiceUrl');
    debugPrint('- Timeout: ${timeout.inSeconds}s');
    debugPrint('- Dev Mode: $isDev');
  }
}