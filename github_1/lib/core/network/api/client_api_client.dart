import 'dart:io';

import 'package:flutter/material.dart';

import '../../restFull/api_endpoints.dart';
import '../../restFull/result.dart';
import 'api_client.dart';

/// Cliente API específico para operaciones relacionadas con datos de cliente
class ClientApiClient extends ApiClient {
  ClientApiClient({
    required super.httpClient,
    required super.tokenManager,
    required super.config,
  });

  /// Obtiene la URL base para servicios de datos de cliente
  String get baseUrl => config.clientServiceUrl;

  /// Obtiene los datos del cliente
  Future<Result<Map<String, dynamic>, Exception>> getClientData({
    required String clientNumber,
    required String channel,
  }) async {
    final endpoint = ApiEndpoint.clientData.path;

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final body = {'clientNumber': clientNumber, 'channelId': channel};

    debugPrint('GetClientData Request: $baseUrl$endpoint');

    final uri = buildUri(baseUrl, endpoint);

    final result = await httpClient.post(
      uri.toString(),
      body: body,
      headers: headers,
    );

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
