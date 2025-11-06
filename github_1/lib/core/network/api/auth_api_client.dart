import 'dart:io';

import 'package:flutter/material.dart';

import '../../restFull/api_endpoints.dart';
import '../../restFull/result.dart';
import 'api_client.dart';

/// Cliente API específico para operaciones de autenticación
class AuthApiClient extends ApiClient {
  AuthApiClient({
    required super.httpClient,
    required super.tokenManager,
    required super.config,
  });

  /// Obtiene la URL base para servicios de autenticación
  String get baseUrl => config.authServiceUrl;

  /// Realiza el proceso de login
  Future<Result<Map<String, dynamic>, Exception>> login({
    required String username,
    required String password,
    required String token,
    required String ip,
    required String channel,
    String? sessionId,
  }) async {
    final endpoint = ApiEndpoint.login.path;
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      // Header requerido solo para login
      'FE-Access': 'PM',
      if (sessionId != null) 'Cookie': 'JSESSIONID=$sessionId',
    };

    final body = {
      'username': username,
      'password': password,
      'token': token,
      'generalProperties': {'ip': ip, 'channel': channel},
    };

    debugPrint('Login Request: $baseUrl$endpoint');

    final result = await post(
      endpoint,
      body: body,
      customHeaders: headers,
      baseUrl: baseUrl,
    );

    return _mapResult(result);
  }

  /// Realiza el proceso de logout
  Future<Result<Map<String, dynamic>, Exception>> logout(
    String userId,
    String channel,
  ) async {
    final endpoint = ApiEndpoint.logout.path;
    int id = int.parse(userId);

    debugPrint('Logout Request: $baseUrl$endpoint');
    final body = {'userId': id, 'channel': channel};

    final result = await post(endpoint, body: body, baseUrl: baseUrl);

    return _mapResult(result);
  }

  /// Cambia la contraseña del usuario
  Future<Result<Map<String, dynamic>, Exception>> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
    String? sessionId,
  }) async {
    final endpoint = ApiEndpoint.changePassword.path;
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      if (sessionId != null) 'Cookie': 'JSESSIONID=$sessionId',
    };

    final body = {
      'username': username,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
      'token': token,
    };

    debugPrint('ChangePassword Request: $baseUrl$endpoint');

    final result = await post(
      endpoint,
      body: body,
      customHeaders: headers,
      baseUrl: baseUrl,
    );

    return _mapResult(result);
  }

  /// Solicita un código de recuperación
  Future<Result<Map<String, dynamic>, Exception>> requestRecoveryCode({
    required String username,
  }) async {
    final endpoint = ApiEndpoint.recoveryCode.path;

    final body = {'username': username};

    debugPrint('RequestRecoveryCode Request: $baseUrl$endpoint');

    final result = await post(endpoint, body: body, baseUrl: baseUrl);

    return _mapResult(result);
  }

  /// Valida un token de recuperación
  Future<Result<Map<String, dynamic>, Exception>> validateRecoveryToken({
    required String token,
    required String ip,
    required String channel,
  }) async {
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final body = {'ip': ip, 'channel': channel};

    final uri = Uri.parse(
      '$baseUrl/api/v1/authenticate/account/validate-token',
    ).replace(queryParameters: {'token': token});

    debugPrint('ValidateRecoveryToken Request: ${uri.toString()}');

    final result = await httpClient.post(
      uri.toString(),
      body: body,
      headers: headers,
    );

    return _mapResult(result);
  }

  /// Cambia el email del usuario
  Future<Result<Map<String, dynamic>, Exception>> changeEmail({
    required int id,
    required String newEmail,
    required String newEmailConfirm,
    required int dynamicPassword,
    required int clientNumber,
  }) async {
    final endpoint = ApiEndpoint.editEmail.path;

    final body = {
      'id': id,
      'newEmail': newEmail,
      'newEmailConfirm': newEmailConfirm,
      'dynamicPassword': dynamicPassword,
      'clientNumber': clientNumber,
    };

    debugPrint('ChangeEmail Request: $baseUrl$endpoint');

    final result = await patch(endpoint, body: body, baseUrl: baseUrl);

    return _mapResult(result);
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
