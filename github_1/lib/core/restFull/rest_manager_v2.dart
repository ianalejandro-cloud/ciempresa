import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../network/api/api_client_factory.dart';
import '../network/api/auth_api_client.dart';
import '../network/api/client_api_client.dart';
import '../network/api/user_api_client.dart';
import '../network/config/api_config.dart';
import 'api_endpoints.dart';
import 'result.dart';

/// Versión actualizada de RestManager que utiliza la nueva arquitectura
/// pero mantiene la compatibilidad con el código existente
class RestManagerV2 {
  // === Singleton ===
  static final RestManagerV2 _instance = RestManagerV2._internal();
  factory RestManagerV2() => _instance;
  RestManagerV2._internal() {
    _initializeClients();
  }

  // === Clientes API ===
  late final AuthApiClient _authClient;
  late final UserApiClient _userClient;
  late final ClientApiClient _clientClient;

  // === Configuración ===
  final ApiConfig _config = ApiConfig.fromEnvironment();

  void _initializeClients() {
    _authClient = ApiClientFactory.createAuthApiClient(config: _config);
    _userClient = ApiClientFactory.createUserApiClient(config: _config);
    _clientClient = ApiClientFactory.createClientApiClient(config: _config);
  }

  // === Métodos HTTP ===

  Future<Result<dynamic, Exception>> get(
    String endpoint, {
    Map<String, dynamic>? params,
    bool useDevServer = false,
  }) async {
    return _authClient.get(
      endpoint,
      params: params,
      useDevServer: useDevServer,
    );
  }

  Future<Result<dynamic, Exception>> post(
    String endpoint, [
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
    String contentType = 'application/json',
  ]) async {
    return _authClient.post(
      endpoint,
      body: body,
      customHeaders: customHeaders,
      contentType: contentType,
    );
  }

  Future<Result<dynamic, Exception>> postWithCustomHeaders(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    bool formUrlEncoded = false,
  }) async {
    return post(
      endpoint,
      body,
      headers,
      formUrlEncoded ? 'application/x-www-form-urlencoded' : 'application/json',
    );
  }

  Future<Result<dynamic, Exception>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return _authClient.put(endpoint, body: body);
  }

  Future<Result<dynamic, Exception>> delete(String endpoint) async {
    return _authClient.delete(endpoint);
  }

  // === Manejo de tokens y respuestas ===

  Future<void> saveToken(String accessToken, String? refreshToken) async {
    await _authClient.tokenManager.saveToken(accessToken, refreshToken);
  }

  Future<void> clearTokens() async {
    await _authClient.tokenManager.clearTokens();
  }

  Future<String?> getStoredToken() async {
    return await _authClient.tokenManager.getToken();
  }

  // === Métodos específicos de autenticación ===

  Future<Result<Map<String, dynamic>, Exception>> getClientCredentialsToken({
    String endpoint = '/v1/api/token',
    String? basicAuth,
  }) async {
    return _userClient.getClientCredentialsToken(
      endpoint: endpoint,
      basicAuth: basicAuth,
    );
  }

  Future<Result<Map<String, dynamic>, Exception>> authenticateLogin({
    required String username,
    required String password,
    required String token,
    required String ip,
    required String channel,
    String? sessionId,
  }) async {
    return _authClient.login(
      username: username,
      password: password,
      token: token,
      ip: ip,
      channel: channel,
      sessionId: sessionId,
    );
  }

  Future<Result<Map<String, dynamic>, Exception>> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
    String? sessionId,
  }) async {
    return _authClient.changePassword(
      username: username,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
      token: token,
      sessionId: sessionId,
    );
  }

  Future<Result<Map<String, dynamic>, Exception>> logout(
    String userId,
    String channel,
  ) async {
    return _authClient.logout(userId, channel);
  }

  Future<Result<Map<String, dynamic>, Exception>> requestRecoveryCode({
    required String username,
  }) async {
    return _authClient.requestRecoveryCode(username: username);
  }

  Future<Result<Map<String, dynamic>, Exception>> validateRecoveryToken({
    required String token,
    required String ip,
    required String channel,
  }) async {
    return _authClient.validateRecoveryToken(
      token: token,
      ip: ip,
      channel: channel,
    );
  }

  // === Métodos específicos de gestión de usuarios ===

  Future<Result<Map<String, dynamic>, Exception>> changeEmail({
    required int id,
    required String newEmail,
    required String newEmailConfirm,
    required int dynamicPassword,
    required int clientNumber,
  }) async {
    return _authClient.changeEmail(
      id: id,
      newEmail: newEmail,
      newEmailConfirm: newEmailConfirm,
      dynamicPassword: dynamicPassword,
      clientNumber: clientNumber,
    );
  }

  // === Métodos específicos de datos de cliente ===

  Future<Result<Map<String, dynamic>, Exception>> getClientData({
    required String clientNumber,
    required String channel,
  }) async {
    return _clientClient.getClientData(
      clientNumber: clientNumber,
      channel: channel,
    );
  }

  // === Métodos con Bearer Token ===

  Future<Result<Map<String, dynamic>, Exception>> postWithBearerToken({
    required ApiEndpoint endpoint,
    required Map<String, dynamic> body,
  }) async {
    return _userClient.requestWithBearerToken(
      endpoint: endpoint.path,
      body: body,
      method: 'POST',
    );
  }

  Future<Result<Map<String, dynamic>, Exception>> getWithBearerToken({
    required ApiEndpoint endpoint,
    Map<String, dynamic>? params,
  }) async {
    final token = await _authClient.tokenManager.getToken();
    if (token == null) {
      return Failure(Exception('Token no disponible'));
    }

    final uri = _authClient.buildUri(_config.baseUrl, endpoint.path, params);
    final headers = <String, String>{
      'Authorization': 'Bearer $token',
      'Cookie':
          'uzmx=7f90005bb63740-108e-4fbc-b56b-86e0f1eaddb36-17387731900941034661124-7389d4520e18cad3184; __uzma=f6c6a811-5228-44b0-93cd-13e1e2cd64de; __uzmb=1738773190; __uzmc=2098018479080; __uzmd=1739807851; __uzme=9357; __uzmf=7f6000b2751924-5a33-4498-bf01-d51efdfdb0cf17387731900941034661124-1f44f9c4c87eeff5184',
    };

    debugPrint('GET Request with Bearer Token: ${uri.toString()}');

    final result = await _authClient.httpClient.get(
      uri.toString(),
      headers: headers,
    );

    if (result is Success) {
      return Success(result.value as Map<String, dynamic>);
    } else {
      final failure = result as Failure;
      return Failure<Map<String, dynamic>, Exception>(failure.exception);
    }
  }

  // === Método para simular errores (útil para pruebas) ===

  Future<Result<dynamic, Exception>> simulateError(
    String endpoint,
    int statusCode, {
    String message = "Error simulado",
  }) async {
    debugPrint('Simulando error $statusCode para $endpoint');
    final response = http.Response(
      jsonEncode({"message": message}),
      statusCode,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Success(jsonDecode(response.body));
    } else {
      final error = _safeError(response);
      return Failure(Exception('HTTP ${response.statusCode}: $error'));
    }
  }

  String _safeError(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded.containsKey('errors')) {
        return decoded['errors'][0]['message'] ?? 'Error desconocido';
      } else if (decoded is Map && decoded.containsKey('message')) {
        return decoded['message'];
      }
      return 'Error desconocido';
    } catch (_) {
      return response.body.isNotEmpty ? response.body : 'Respuesta vacía';
    }
  }
}
