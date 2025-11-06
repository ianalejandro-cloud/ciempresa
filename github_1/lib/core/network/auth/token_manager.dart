import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Gestor de tokens de autenticación
class TokenManager {
  final FlutterSecureStorage _storage;
  
  TokenManager({FlutterSecureStorage? storage}) 
      : _storage = storage ?? const FlutterSecureStorage();
  
  /// Obtiene el token de acceso
  Future<String?> getToken() async => await _storage.read(key: 'auth_token');
  
  /// Obtiene el token de refresco
  Future<String?> getRefreshToken() async => 
      await _storage.read(key: 'refresh_token');
  
  /// Guarda los tokens de autenticación
  Future<void> saveToken(String accessToken, String? refreshToken) async {
    await _storage.write(key: 'auth_token', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'refresh_token', value: refreshToken);
    }
  }
  
  /// Elimina los tokens almacenados
  Future<void> clearTokens() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'refresh_token');
  }
  
  /// Verifica si el token ha expirado
  Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) return true;
    return JwtDecoder.isExpired(token);
  }
  
  /// Verifica si hay un token disponible
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null;
  }
}