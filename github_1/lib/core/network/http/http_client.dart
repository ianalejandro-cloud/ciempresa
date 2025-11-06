import '../../restFull/result.dart';

/// Interfaz base para clientes HTTP
abstract class HttpClient {
  /// Realiza una petición GET
  Future<Result<dynamic, Exception>> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  });

  /// Realiza una petición POST
  Future<Result<dynamic, Exception>> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    String contentType = 'application/json',
  });

  /// Realiza una petición PUT
  Future<Result<dynamic, Exception>> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });

  /// Realiza una petición DELETE
  Future<Result<dynamic, Exception>> delete(
    String url, {
    Map<String, String>? headers,
  });

  /// Realiza una petición PATCH
  Future<Result<dynamic, Exception>> patch(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  });
}