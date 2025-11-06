import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/features/home/services/main_screen_service.dart';

enum MainScreenState { idle, loading, success, error }

class MainScreenProvider with ChangeNotifier {
  final MainScreenService _mainScreenService;
  final SecureStorageService _storageService;
  late final String _channel;

  MainScreenProvider(this._mainScreenService, this._storageService) {
    _channel = String.fromEnvironment('CN_CHANEL', defaultValue: 'CN105');
  }

  MainScreenState _state = MainScreenState.idle;
  MainScreenState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == MainScreenState.loading;

  Future<bool> logout() async {
    _state = MainScreenState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final userId = await _storageService.readString('userId') ?? '0';
      final result = await _mainScreenService.logout(userId, _channel);

      switch (result) {
        case Success(value: final data):
          debugPrint('✅ Logout exitoso: $data');
          _state = MainScreenState.success;
          notifyListeners();
          return true;
        case Failure(exception: final error):
          _errorMessage = error.toString();
          debugPrint('❌ Error en logout: $error');
          _state = MainScreenState.error;
          notifyListeners();
          return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = MainScreenState.error;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_state == MainScreenState.error) {
      _state = MainScreenState.idle;
      _errorMessage = '';
      notifyListeners();
    }
  }
}
