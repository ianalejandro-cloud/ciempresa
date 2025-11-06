import '../auth/token_manager.dart';
import '../config/api_config.dart';
import '../http/http_client.dart';
import '../http/http_package_client.dart';
import 'api_client.dart';
import 'auth_api_client.dart';
import 'client_api_client.dart';
import 'user_api_client.dart';

/// Fábrica para crear instancias de clientes API
class ApiClientFactory {
  /// Crea un cliente API base
  static ApiClient createApiClient({
    HttpClient? httpClient,
    TokenManager? tokenManager,
    ApiConfig? config,
  }) {
    final client = httpClient ?? HttpPackageClient();
    final manager = tokenManager ?? TokenManager();
    final apiConfig = config ?? ApiConfig.fromEnvironment();
    
    return ApiClient(
      httpClient: client,
      tokenManager: manager,
      config: apiConfig,
    );
  }
  
  /// Crea un cliente API para autenticación
  static AuthApiClient createAuthApiClient({
    HttpClient? httpClient,
    TokenManager? tokenManager,
    ApiConfig? config,
  }) {
    final client = httpClient ?? HttpPackageClient();
    final manager = tokenManager ?? TokenManager();
    final apiConfig = config ?? ApiConfig.fromEnvironment();
    
    return AuthApiClient(
      httpClient: client,
      tokenManager: manager,
      config: apiConfig,
    );
  }
  
  /// Crea un cliente API para gestión de usuarios
  static UserApiClient createUserApiClient({
    HttpClient? httpClient,
    TokenManager? tokenManager,
    ApiConfig? config,
  }) {
    final client = httpClient ?? HttpPackageClient();
    final manager = tokenManager ?? TokenManager();
    final apiConfig = config ?? ApiConfig.fromEnvironment();
    
    return UserApiClient(
      httpClient: client,
      tokenManager: manager,
      config: apiConfig,
    );
  }
  
  /// Crea un cliente API para datos de cliente
  static ClientApiClient createClientApiClient({
    HttpClient? httpClient,
    TokenManager? tokenManager,
    ApiConfig? config,
  }) {
    final client = httpClient ?? HttpPackageClient();
    final manager = tokenManager ?? TokenManager();
    final apiConfig = config ?? ApiConfig.fromEnvironment();
    
    return ClientApiClient(
      httpClient: client,
      tokenManager: manager,
      config: apiConfig,
    );
  }
}