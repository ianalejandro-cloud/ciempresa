import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'result.dart';
import 'api_endpoints.dart';

class RestManager {
  // === Singleton ===
  static final RestManager _instance = RestManager._internal();
  factory RestManager() => _instance;
  RestManager._internal();

  // === Configuración ===
  static const _timeout = Duration(minutes: 2);
  static String get _baseUrl => const String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://apiqa.cibanco.com',
  );
  static String get _authServiceUrl => const String.fromEnvironment(
    'BASE_URL_AUTH',
    defaultValue:
        'https://cibc-mcnet-authenticate-238857314839.us-central1.run.app',
  );
  static String get _managementServiceUrl => const String.fromEnvironment(
    'BASE_URL_MANAGEMENT',
    defaultValue:
        'https://cibc-mcnet-user-management-238857314839.us-central1.run.app',
  );
  static String get _clientServiceUrl => const String.fromEnvironment(
    'BASE_URL_CLIENT',
    defaultValue: 'http://10.1.9.119:7839',
  );
  static const _devBaseUrl = 'http://10.0.2.2:8000';

  final _storage = const FlutterSecureStorage();

  final Set<String> _publicEndpoints = {
    '/auth/login',
    '/auth/register',
    '/auth/forgot',
    '/forgot/login',
    '/v1/api/token',
  };

  // === Utilidades internas ===

  Uri _buildUri(
    String endpoint, [
    Map<String, dynamic>? params,
    bool useDevServer = false,
  ]) {
    final baseUrl = useDevServer ? _devBaseUrl : _baseUrl;
    final uri = Uri.parse('$baseUrl$endpoint');
    return params != null ? uri.replace(queryParameters: params) : uri;
  }

  bool _isPublic(String endpoint) {
    return _publicEndpoints.contains(endpoint) ||
        endpoint.startsWith('/auth') ||
        endpoint.startsWith('/forgot');
  }

  Future<String?> _getToken() async => await _storage.read(key: 'auth_token');
  Future<String?> _getRefreshToken() async =>
      await _storage.read(key: 'refresh_token');

  Future<Map<String, String>> _publicOrAuthHeaders(String endpoint) async {
    if (_isPublic(endpoint)) {
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      };
    } else {
      //await _ensureValidToken();
      final token = await _getToken();
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      };
    }
  }

  Future<void> _ensureValidToken() async {
    final token = await _getToken();
    if (token == null || await _isTokenExpired()) {
      await _obtainClientCredentialsToken();
    }
  }

  Future<void> _obtainClientCredentialsToken() async {
    const basicAuth = String.fromEnvironment('BASIC_AUTH');

    await getClientCredentialsToken(basicAuth: basicAuth);
  }

  // === Métodos HTTP ===

  Future<Result<dynamic, Exception>> get(
    String endpoint, {
    Map<String, dynamic>? params,
    bool useDevServer = false,
  }) async {
    try {
      final uri = _buildUri(endpoint, params, useDevServer);
      final headers = await _publicOrAuthHeaders(endpoint);
      debugPrint('GET Request: ${uri.toString()}');
      final response = await http.get(uri, headers: headers).timeout(_timeout);
      debugPrint('Response status: ${response.statusCode}');
      return _processResponseWithResult(response);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<dynamic, Exception>> post(
    String endpoint, [
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
    String contentType = 'application/json',
  ]) async {
    try {
      final uri = _buildUri(endpoint);

      // Obtener headers base y combinarlos con headers personalizados si existen
      final baseHeaders = await _publicOrAuthHeaders(endpoint);
      final headers = {...baseHeaders};

      // Sobrescribir con headers personalizados si se proporcionan
      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      // Establecer el Content-Type según el parámetro
      headers[HttpHeaders.contentTypeHeader] = contentType;

      // Preparar el body según el Content-Type
      dynamic requestBody;
      if (body != null) {
        if (contentType == 'application/x-www-form-urlencoded') {
          requestBody = body.entries
              .map(
                (e) =>
                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
              )
              .join('&');
        } else {
          requestBody = jsonEncode(body);
        }
      }

      debugPrint('POST Request: ${uri.toString()}');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');

      final response = requestBody != null
          ? await http
                .post(uri, headers: headers, body: requestBody)
                .timeout(_timeout)
          : await http.post(uri, headers: headers).timeout(_timeout);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return _processResponseWithResult(response);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  // Este método se mantiene temporalmente para compatibilidad con código existente
  // pero se recomienda usar el método post con los parámetros adicionales
  @Deprecated(
    'Use post method with customHeaders and contentType parameters instead',
  )
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
    try {
      final uri = _buildUri(endpoint);
      final headers = await _publicOrAuthHeaders(endpoint);
      final response = await http
          .put(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);
      return _processResponseWithResult(response);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<dynamic, Exception>> delete(String endpoint) async {
    try {
      final uri = _buildUri(endpoint);
      final headers = await _publicOrAuthHeaders(endpoint);
      final response = await http
          .delete(uri, headers: headers)
          .timeout(_timeout);
      return _processResponseWithResult(response);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  // === Manejo de solicitud con token automático ===

  Future<dynamic> _sendRequest(
    Future<dynamic> Function() requestFn,
    String endpoint,
  ) async {
    if (!_isPublic(endpoint) && await _isTokenExpired()) {
      final refreshed = await _refreshToken();
      if (!refreshed) {
        throw HttpException('Token expirado y no se pudo renovar.');
      }
    }

    try {
      return await requestFn();
    } on http.Response catch (response) {
      if (response.statusCode == 401 && !_isPublic(endpoint)) {
        final refreshed = await _refreshToken();
        if (refreshed) return await requestFn();
      }
      throw HttpException('Error HTTP: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _isTokenExpired() async {
    final token = await _getToken();
    if (token == null) return true;
    return JwtDecoder.isExpired(token);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return false;

    final uri = _buildUri('/auth/refresh');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };

    final body = jsonEncode({'refresh_token': refreshToken});

    final response = await http
        .post(uri, headers: headers, body: body)
        .timeout(
          _timeout,
          onTimeout: () => throw TimeoutException("Timeout al renovar token."),
        );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['access_token'], data['refresh_token']);
      return true;
    }
    return false;
  }

  // === Manejo de tokens y respuestas ===

  dynamic _processResponse(http.Response response) {
    debugPrint('Processing response: ${response.statusCode}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      final error = _safeError(response);
      debugPrint('Error en respuesta: HTTP ${response.statusCode}: $error');
      throw HttpException('HTTP ${response.statusCode}: $error');
    }
  }

  Result<dynamic, Exception> _processResponseWithResult(
    http.Response response,
  ) {
    debugPrint('Processing response with Result: ${response.statusCode}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Success(jsonDecode(response.body));
    } else {
      final error = _safeError(response);
      debugPrint('Error en respuesta: HTTP ${response.statusCode}: $error');
      return Failure(Exception('HTTP ${response.statusCode}: $error'));
    }
  }

  // Método para simular un error HTTP específico
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

    return _processResponseWithResult(response);
  }

  String _safeError(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      return decoded['errors'][0]['message'] ?? 'Error desconocido';
    } catch (_) {
      return response.body.isNotEmpty ? response.body : 'Respuesta vacía';
    }
  }

  // === Métodos de autenticación ===

  Future<Result<Map<String, dynamic>, Exception>> getClientCredentialsToken({
    String endpoint = '/v1/api/token',
    String? basicAuth,
  }) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      if (basicAuth != null) {
        headers['Authorization'] = 'Basic $basicAuth';
      }

      debugPrint('Token request URL: $_baseUrl$endpoint');
      debugPrint('Token request headers: $headers');
      debugPrint('Token request body: grant_type=client_credentials');

      final result = await post(
        endpoint,
        {'grant_type': 'client_credentials'},
        headers,
        'application/x-www-form-urlencoded',
      );

      if (result is Success) {
        final data = result.value as Map<String, dynamic>;
        debugPrint("Token obtenido: $data");

        if (data['detail'][0].containsKey('access_token')) {
          debugPrint(data['detail'][0]['access_token']);
          await saveToken(
            data['detail'][0]['access_token'],
            data['refresh_token'],
          );
        }

        return Success(data);
      } else {
        return result as Failure<Map<String, dynamic>, Exception>;
      }
    } catch (e) {
      return Failure(Exception('Error obteniendo token: ${e.toString()}'));
    }
  }

  Future<void> saveToken(String accessToken, String? refreshToken) async {
    await _storage.write(key: 'auth_token', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'refresh_token');
  }

  // Método público para obtener el token guardado
  Future<String?> getStoredToken() async {
    return await _getToken();
  }

  Future<Result<Map<String, dynamic>, Exception>> postWithBearerToken({
    required ApiEndpoint endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return Failure(Exception('Token no disponible'));
      }

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      debugPrint('Request URL: $_baseUrl${endpoint.path}');
      debugPrint('Request headers: $headers');
      debugPrint('Request body: $body');

      final result = await post(endpoint.path, body, headers);

      switch (result) {
        case Success(value: final data):
          return Success(data);
        case Failure(exception: final error):
          return Failure(error);
      }
    } catch (e) {
      return Failure(Exception('Error en petición: ${e.toString()}'));
    }
  }

  Future<Result<Map<String, dynamic>, Exception>> getWithBearerToken({
    required ApiEndpoint endpoint,
    Map<String, dynamic>? params,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        return Failure(Exception('Token no disponible'));
      }

      final uri = _buildUri(endpoint.path, params);
      final headers = <String, String>{
        'Authorization': 'Bearer $token',
        'Cookie':
            'uzmx=7f90005bb63740-108e-4fbc-b56b-86e0f1eaddb36-17387731900941034661124-7389d4520e18cad3184; __uzma=f6c6a811-5228-44b0-93cd-13e1e2cd64de; __uzmb=1738773190; __uzmc=2098018479080; __uzmd=1739807851; __uzme=9357; __uzmf=7f6000b2751924-5a33-4498-bf01-d51efdfdb0cf17387731900941034661124-1f44f9c4c87eeff5184',
      };

      debugPrint('GET Request: ${uri.toString()}');
      debugPrint('Request headers: $headers');

      final response = await http.get(uri, headers: headers).timeout(_timeout);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      final result = _processResponseWithResult(response);

      switch (result) {
        case Success(value: final data):
          return Success(data);
        case Failure(exception: final error):
          return Failure(error);
      }
    } catch (e) {
      return Failure(Exception('Error en petición GET: ${e.toString()}'));
    }
  }

  // === Método de login específico ===
  Future<Result<Map<String, dynamic>, Exception>> authenticateLogin({
    required String username,
    required String password,
    required String token,
    required String ip,
    required String channel,
    String? sessionId,
  }) async {
    return _postToAuthService(
      baseUrl: _authServiceUrl,
      endpoint: ApiEndpoint.login.path,
      body: {
        'username': username,
        'password': password,
        'token': token,
        'generalProperties': {'ip': ip, 'channel': channel},
      },
      additionalHeaders: const {
        'FE-Access': 'PM',
      },
      sessionId: sessionId,
      operationName: 'Login',
    );
  }

  // === Método de cambio de contraseña específico ===
  Future<Result<Map<String, dynamic>, Exception>> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
    String? sessionId,
  }) async {
    return _postToAuthService(
      baseUrl: _authServiceUrl,
      endpoint: ApiEndpoint.changePassword.path,
      body: {
        'username': username,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
        'token': token,
      },
      sessionId: sessionId,
      operationName: 'Cambio de contraseña',
    );
  }

  // === Método de cambio de email específico ===
  Future<Result<Map<String, dynamic>, Exception>> changeEmail({
    required int id,
    required String newEmail,
    required String newEmailConfirm,
    required int dynamicPassword,
    required int clientNumber,
  }) async {
    return _patchToUserService(
      endpoint: ApiEndpoint.editEmail.path,
      body: {
        'id': id,
        'newEmail': newEmail,
        'newEmailConfirm': newEmailConfirm,
        'dynamicPassword': dynamicPassword,
        'clientNumber': clientNumber,
      },
      operationName: 'Cambio de email',
    );
  }

  // === Método de logout específico ===
  Future<Result<Map<String, dynamic>, Exception>> logout() async {
    return _postToAuthService(
      baseUrl: _authServiceUrl,
      endpoint: ApiEndpoint.logout.path,
      body: {},
      operationName: 'Logout',
    );
  }

  // === Método para solicitar código de recuperación ===
  Future<Result<Map<String, dynamic>, Exception>> requestRecoveryCode({
    required String username,
  }) async {
    return _postToAuthService(
      baseUrl: _authServiceUrl,
      endpoint: ApiEndpoint.recoveryCode.path,
      body: {'username': username},
      operationName: 'Solicitud de código de recuperación',
    );
  }

  // === Método para validar token de recuperación ===
  Future<Result<Map<String, dynamic>, Exception>> validateRecoveryToken({
    required String token,
    required String ip,
    required String channel,
  }) async {
    final headers = <String, String>{'Content-Type': 'application/json'};

    final body = {'ip': ip, 'channel': channel};

    try {
      final uri = Uri.parse(
        '$_authServiceUrl/api/v1/authenticate/account/validate-token',
      ).replace(queryParameters: {'token': token});

      debugPrint('ValidateRecoveryToken Request: ${uri.toString()}');
      debugPrint('Headers: $headers');
      debugPrint('Body: $body');

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      final result = _processResponseWithResult(response);
      if (result is Success) {
        return Success(result.value as Map<String, dynamic>);
      } else {
        final failure = result as Failure;
        return Failure<Map<String, dynamic>, Exception>(failure.exception);
      }
    } catch (e) {
      return Failure<Map<String, dynamic>, Exception>(
        Exception('Error validando token de recuperación: ${e.toString()}'),
      );
    }
  }

  // === Método para consultar datos del cliente ===
  Future<Result<Map<String, dynamic>, Exception>> getClientData({
    required String clientNumber,
    required String channel,
  }) async {
    var baseUrl = _clientServiceUrl;
    final endpoint = ApiEndpoint.clientData.path;

    final headers = <String, String>{'Content-Type': 'application/json'};

    final body = {'clientNumber': clientNumber, 'channelId': channel};

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('GetClientData Request: ${uri.toString()}');
      debugPrint('Headers: $headers');
      debugPrint('Body: $body');

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      final result = _processResponseWithResult(response);
      if (result is Success) {
        return Success(result.value as Map<String, dynamic>);
      } else {
        final failure = result as Failure;
        return Failure<Map<String, dynamic>, Exception>(failure.exception);
      }
    } catch (e) {
      return Failure<Map<String, dynamic>, Exception>(
        Exception('Error consultando datos del cliente: ${e.toString()}'),
      );
    }
  }

  // === Helper para los servicios de autenticación externos ===
  Future<Result<Map<String, dynamic>, Exception>> _postToAuthService({
    required String baseUrl,
    required String endpoint,
    required Map<String, dynamic> body,
    required String operationName,
    String? sessionId,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (sessionId != null) 'Cookie': 'JSESSIONID=$sessionId',
      if (additionalHeaders != null) ...additionalHeaders,
    };

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('$operationName Request: ${uri.toString()}');
      debugPrint('Headers: $headers');
      debugPrint('Body: $body');

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      final result = _processResponseWithResult(response);
      if (result is Success) {
        return Success(result.value as Map<String, dynamic>);
      } else {
        final failure = result as Failure;
        return Failure<Map<String, dynamic>, Exception>(failure.exception);
      }
    } catch (e) {
      return Failure<Map<String, dynamic>, Exception>(
        Exception('Error en $operationName: ${e.toString()}'),
      );
    }
  }

  // === Helper para el servicio de gestión de usuarios ===
  Future<Result<Map<String, dynamic>, Exception>> _patchToUserService({
    required String endpoint,
    required Map<String, dynamic> body,
    required String operationName,
  }) async {
    String baseUrl = _managementServiceUrl;
    final headers = <String, String>{'Content-Type': 'application/json'};

    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('$operationName Request: ${uri.toString()}');
      debugPrint('Headers: $headers');
      debugPrint('Body: $body');

      final response = await http
          .patch(uri, headers: headers, body: jsonEncode(body))
          .timeout(_timeout);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      final result = _processResponseWithResult(response);
      if (result is Success) {
        return Success(result.value as Map<String, dynamic>);
      } else {
        final failure = result as Failure;
        return Failure<Map<String, dynamic>, Exception>(failure.exception);
      }
    } catch (e) {
      return Failure<Map<String, dynamic>, Exception>(
        Exception('Error en $operationName: ${e.toString()}'),
      );
    }
  }
}
