import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:flutter/material.dart';

class SoftTokenProvider with ChangeNotifier {
  final SecureStorageService _storageService;

  SoftTokenProvider(this._storageService);

  bool _isSoftTokenAvailable = false;
  bool get isSoftTokenAvailable => _isSoftTokenAvailable;

  static const _softTokenActivatedKey = 'soft_token_activated';

  /// Carga el estado inicial desde el almacenamiento seguro.
  /// Se debe llamar al iniciar la app.
  Future<void> loadSoftTokenAvailability() async {
    _isSoftTokenAvailable =
        await _storageService.readString(_softTokenActivatedKey) == 'true';
    notifyListeners();
  }

  /// Activa la disponibilidad del soft token y lo persiste.
  Future<void> activateSoftToken() async {
    if (_isSoftTokenAvailable) return; // Ya está activo, no hacer nada.
    _isSoftTokenAvailable = true;
    await _storageService.saveString(
      _softTokenActivatedKey,
      _isSoftTokenAvailable.toString(),
    );
    notifyListeners();
  }
}
