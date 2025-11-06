import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../restFull/result.dart';
import 'http_client.dart';

/// Implementación de HttpClient usando el paquete http
class HttpPackageClient implements HttpClient {
  final Duration timeout;
  
  HttpPackageClient({this.timeout = const Duration(minutes: 2)});
  
  @override
  Future<Result<dynamic, Exception>> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      Uri uri = Uri.parse(url);
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }
      
      debugPrint('GET Request: ${uri.toString()}');
      debugPrint('Headers: $headers');
      
      final response = await http.get(uri, headers: headers).timeout(timeout);
      
      debugPrint('Response status: ${response.statusCode}');
      return _processResponse(response);
    } catch (e) {
      debugPrint('Error en GET: ${e.toString()}');
      return Failure(Exception(e.toString()));
    }
  }
  
  @override
  Future<Result<dynamic, Exception>> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    String contentType = 'application/json',
  }) async {
    try {
      final uri = Uri.parse(url);
      final Map<String, String> requestHeaders = headers ?? {};
      requestHeaders[HttpHeaders.contentTypeHeader] = contentType;
      
      // Preparar el body según el Content-Type
      dynamic requestBody;
      if (body != null) {
        if (contentType == 'application/x-www-form-urlencoded') {
          if (body is Map<String, dynamic>) {
            requestBody = body.entries
                .map(
                  (e) =>
                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
                )
                .join('&');
          } else {
            requestBody = body.toString();
          }
        } else {
          requestBody = body is String ? body : jsonEncode(body);
        }
      }
      
      debugPrint('POST Request: ${uri.toString()}');
      debugPrint('Headers: $requestHeaders');
      debugPrint('Body: $requestBody');
      
      final response = requestBody != null
          ? await http
              .post(uri, headers: requestHeaders, body: requestBody)
              .timeout(timeout)
          : await http.post(uri, headers: requestHeaders).timeout(timeout);
      
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      return _processResponse(response);
    } catch (e) {
      debugPrint('Error en POST: ${e.toString()}');
      return Failure(Exception(e.toString()));
    }
  }
  
  @override
  Future<Result<dynamic, Exception>> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final requestBody = body is String ? body : jsonEncode(body);
      
      debugPrint('PUT Request: ${uri.toString()}');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');
      
      final response = await http
          .put(uri, headers: headers, body: requestBody)
          .timeout(timeout);
      
      debugPrint('Response status: ${response.statusCode}');
      return _processResponse(response);
    } catch (e) {
      debugPrint('Error en PUT: ${e.toString()}');
      return Failure(Exception(e.toString()));
    }
  }
  
  @override
  Future<Result<dynamic, Exception>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      
      debugPrint('DELETE Request: ${uri.toString()}');
      debugPrint('Headers: $headers');
      
      final response = await http
          .delete(uri, headers: headers)
          .timeout(timeout);
      
      debugPrint('Response status: ${response.statusCode}');
      return _processResponse(response);
    } catch (e) {
      debugPrint('Error en DELETE: ${e.toString()}');
      return Failure(Exception(e.toString()));
    }
  }
  
  @override
  Future<Result<dynamic, Exception>> patch(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final requestBody = body is String ? body : jsonEncode(body);
      
      debugPrint('PATCH Request: ${uri.toString()}');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');
      
      final response = await http
          .patch(uri, headers: headers, body: requestBody)
          .timeout(timeout);
      
      debugPrint('Response status: ${response.statusCode}');
      return _processResponse(response);
    } catch (e) {
      debugPrint('Error en PATCH: ${e.toString()}');
      return Failure(Exception(e.toString()));
    }
  }
  
  /// Procesa la respuesta HTTP y la convierte en un objeto Result
  Result<dynamic, Exception> _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return Success(jsonDecode(response.body));
      } catch (e) {
        return Success(response.body); // En caso de que no sea JSON
      }
    } else {
      final error = _safeError(response);
      debugPrint('Error en respuesta: HTTP ${response.statusCode}: $error');
      return Failure(Exception('HTTP ${response.statusCode}: $error'));
    }
  }
  
  /// Extrae el mensaje de error de la respuesta HTTP
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