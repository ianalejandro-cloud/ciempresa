import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

/// Interfaz para objetos serializables.
/// Cualquier clase que quieras guardar como objeto debe implementar esta interfaz.
abstract class Serializable {
  Map<String, dynamic> toJson();
}

/// Typedef para la función de deserialización.
/// Cada clase serializable necesitará una función estática o factory que tome un Map y devuelva una instancia de la clase.
typedef FromJsonFactory<T extends Serializable> =
    T Function(Map<String, dynamic> json);

/// Clase de servicio para interactuar con flutter_secure_storage.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  // --- Métodos para String (el comportamiento por defecto de flutter_secure_storage) ---

  /// Guarda un valor String asociado a una clave.
  Future<void> saveString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Recupera un valor String asociado a una clave.
  Future<String?> readString(String key) async {
    return await _storage.read(key: key);
  }

  // --- Métodos para objetos genéricos serializables ---

  /// Guarda un objeto serializable asociado a una clave.
  /// El objeto debe implementar `Serializable`.
  Future<void> saveObject<T extends Serializable>(String key, T object) async {
    try {
      final String jsonString = jsonEncode(object.toJson());
      await _storage.write(key: key, value: jsonString);
    } catch (e) {
      rethrow; // Relanza la excepción para manejo externo si es necesario
    }
  }

  /// Recupera un objeto serializable asociado a una clave.
  /// Requiere una `fromJsonFactory` para reconstruir el objeto.
  Future<T?> readObject<T extends Serializable>(
    String key,
    FromJsonFactory<T> fromJsonFactory,
  ) async {
    try {
      final String? jsonString = await _storage.read(key: key);
      if (jsonString == null) {
        return null;
      }
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return fromJsonFactory(jsonMap);
    } catch (e) {
      //print('Error al deserializar y leer objeto $key: $e');
      rethrow; // Relanza la excepción
    }
  }

  // --- Métodos comunes (para String y objetos) ---

  /// Elimina un dato asociado a una clave.
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Elimina todos los datos guardados por la aplicación.
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Verifica si una clave existe.
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}