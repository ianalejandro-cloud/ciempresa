import 'dart:io';

import 'package:flutter/material.dart';

import '../../restFull/result.dart';
import '../auth/token_manager.dart';
import '../config/api_config.dart';
import '../http/http_client.dart';

/// Cliente API base con funcionalidad común
class ApiClient {
  final HttpClient httpClient;
  final TokenManager tokenManager;
  final ApiConfig config;
  final Set<String> publicEndpoints;
  
  ApiClient({
    required this.httpClient,
    required this.tokenManager,
    required this.config,
    Set<String>? publicEndpoints,
  }) : publicEndpoints = publicEndpoints ?? {
         '/auth/login',
         '/auth/register',
         '/auth/forgot',
         '/forgot/login',
         '/v1/api/token',
       };
  
  /// Determina si un endpoint es público (no requiere autenticación)
  bool isPublic(String endpoint) {
    return publicEndpoints.contains(endpoint) ||
        endpoint.startsWith('/auth') ||
        endpoint.startsWith('/forgot');
  }
  
  /// Obtiene los headers adecuados según el endpoint
  Future<Map<String, String>> getHeaders(String endpoint) async {
    if (isPublic(endpoint)) {
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      };
    } else {
      final token = await tokenManager.getToken();
      return {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      };
    }
  }
  
  /// Construye una URI completa
  Uri buildUri(String baseUrl, String endpoint, [Map<String, dynamic>? params]) {
    final uri = Uri.parse('$baseUrl$endpoint');
    return params != null ? uri.replace(queryParameters: params) : uri;
  }
  
  /// Realiza una petición GET
  Future<Result<dynamic, Exception>> get(
    String endpoint, {
    Map<String, dynamic>? params,
    String? baseUrl,
    bool useDevServer = false,
  }) async {
    final url = baseUrl ?? (useDevServer ? config.baseUrl : config.baseUrl);
    final headers = await getHeaders(endpoint);
    final uri = buildUri(url, endpoint, params);
    
    debugPrint('GET Request via ApiClient: ${uri.toString()}');
    return httpClient.get(uri.toString(), headers: headers);
  }
  
  /// Realiza una petición POST
  Future<Result<dynamic, Exception>> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? customHeaders,
    String? baseUrl,
    String contentType = 'application/json',
  }) async {
    final url = baseUrl ?? config.baseUrl;
    final baseHeaders = await getHeaders(endpoint);
    final headers = {...baseHeaders};
    
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    
    headers[HttpHeaders.contentTypeHeader] = contentType;
    final uri = buildUri(url, endpoint);
    
    debugPrint('POST Request via ApiClient: ${uri.toString()}');
    return httpClient.post(
      uri.toString(),
      body: body,
      headers: headers,
      contentType: contentType,
    );
  }
  
  /// Realiza una petición PUT
  Future<Result<dynamic, Exception>> put(
    String endpoint, {
    dynamic body,
    String? baseUrl,
  }) async {
    final url = baseUrl ?? config.baseUrl;
    final headers = await getHeaders(endpoint);
    final uri = buildUri(url, endpoint);
    
    debugPrint('PUT Request via ApiClient: ${uri.toString()}');
    return httpClient.put(uri.toString(), body: body, headers: headers);
  }
  
  /// Realiza una petición DELETE
  Future<Result<dynamic, Exception>> delete(
    String endpoint, {
    String? baseUrl,
  }) async {
    final url = baseUrl ?? config.baseUrl;
    final headers = await getHeaders(endpoint);
    final uri = buildUri(url, endpoint);
    
    debugPrint('DELETE Request via ApiClient: ${uri.toString()}');
    return httpClient.delete(uri.toString(), headers: headers);
  }
  
  /// Realiza una petición PATCH
  Future<Result<dynamic, Exception>> patch(
    String endpoint, {
    dynamic body,
    String? baseUrl,
  }) async {
    final url = baseUrl ?? config.baseUrl;
    final headers = await getHeaders(endpoint);
    final uri = buildUri(url, endpoint);
    
    debugPrint('PATCH Request via ApiClient: ${uri.toString()}');
    return httpClient.patch(uri.toString(), body: body, headers: headers);
  }
}