import 'dart:io';

import 'package:flutter/material.dart';

import '../../restFull/api_endpoints.dart';
import '../../restFull/result.dart';
import 'api_client.dart';

/// Cliente API específico para operaciones de gestión de usuarios
class UserApiClient extends ApiClient {
  UserApiClient({
    required super.httpClient,
    required super.tokenManager,
    required super.config,
  });

  /// Obtiene la URL base para servicios de gestión de usuarios
  String get baseUrl => config.baseUrl;

  /// Realiza una petición con token Bearer
  Future<Result<Map<String, dynamic>, Exception>> requestWithBearerToken({
    required String endpoint,
    required dynamic body,
    String method = 'POST',
  }) async {
    final token = await tokenManager.getToken();
    if (token == null) {
      return Failure(Exception('Token no disponible'));
    }

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    debugPrint('Request with Bearer Token: $baseUrl$endpoint');

    Result<dynamic, Exception> result;

    switch (method) {
      case 'GET':
        result = await get(endpoint, baseUrl: baseUrl);
        break;
      case 'POST':
        result = await post(
          endpoint,
          body: body,
          customHeaders: headers,
          baseUrl: baseUrl,
        );
        break;
      case 'PUT':
        result = await put(endpoint, body: body, baseUrl: baseUrl);
        break;
      case 'DELETE':
        result = await delete(endpoint, baseUrl: baseUrl);
        break;
      case 'PATCH':
        result = await patch(endpoint, body: body, baseUrl: baseUrl);
        break;
      default:
        return Failure(Exception('Método HTTP no soportado: $method'));
    }

    return _mapResult(result);
  }

  /// Obtiene un token de cliente
  Future<Result<Map<String, dynamic>, Exception>> getClientCredentialsToken({
    String endpoint = '/v1/api/token',
    String? basicAuth,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    if (basicAuth != null) {
      headers['Authorization'] = 'Basic $basicAuth';
    }

    debugPrint('Token request URL: ${config.baseUrl}$endpoint');

    final result = await post(
      endpoint,
      body: {'grant_type': 'client_credentials'},
      customHeaders: headers,
      contentType: 'application/x-www-form-urlencoded',
      baseUrl: baseUrl,
    );

    if (result is Success) {
      final data = result.value as Map<String, dynamic>;
      debugPrint("Token obtenido: $data");

      if (data['detail'] != null &&
          data['detail'][0] != null &&
          data['detail'][0].containsKey('access_token')) {
        await tokenManager.saveToken(
          data['detail'][0]['access_token'],
          data['refresh_token'],
        );
      }

      return Success(data);
    } else {
      return result as Failure<Map<String, dynamic>, Exception>;
    }
  }

  /// Refresca el token de acceso
  Future<bool> refreshToken() async {
    final refreshToken = await tokenManager.getRefreshToken();
    if (refreshToken == null) return false;

    final endpoint = ApiEndpoint.refreshToken.path;
    final body = {'refresh_token': refreshToken};

    final result = await post(endpoint, body: body, baseUrl: config.baseUrl);

    if (result is Success) {
      final data = result.value as Map<String, dynamic>;
      await tokenManager.saveToken(data['access_token'], data['refresh_token']);
      return true;
    }
    return false;
  }

  /// Convierte un Result<dynamic, Exception> en Result<Map<String, dynamic>, Exception>
  Result<Map<String, dynamic>, Exception> _mapResult(
    Result<dynamic, Exception> result,
  ) {
    if (result is Success) {
      return Success(result.value as Map<String, dynamic>);
    } else {
      final failure = result as Failure;
      return Failure<Map<String, dynamic>, Exception>(failure.exception);
    }
  }
}
