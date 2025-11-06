import 'package:flutter/material.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/features/login/services/change_password_service.dart';

enum ChangePasswordState { idle, loading, success, error }

class ChangePasswordProvider with ChangeNotifier {
  final ChangePasswordService _changePasswordService;
  final SecureStorageService _storageService;

  ChangePasswordProvider(this._changePasswordService, this._storageService);

  ChangePasswordState _state = ChangePasswordState.idle;
  ChangePasswordState get state => _state;

  bool _isFormValid = false;
  String _errorMessage = '';
  String _currentUsername = '';

  bool get isLoading => _state == ChangePasswordState.loading;
  bool get isFormValid => _isFormValid;
  String get errorMessage => _errorMessage;
  String get currentUsername => _currentUsername;

  void updateFormValidity(bool isValid) {
    _isFormValid = isValid;
    notifyListeners();
  }

  Future<void> loadCurrentUsername() async {
    _currentUsername = await _storageService.readString('username') ?? '';
    notifyListeners();
  }

  Future<bool> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    _state = ChangePasswordState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _changePasswordService.changePassword(
        username: username,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        token: token,
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Contraseña cambiada exitosamente: $data');
          _state = ChangePasswordState.success;
          notifyListeners();
          return true;
        case Failure(exception: final error):
          _errorMessage = error.toString();
          debugPrint('Error: ${error.toString()}');
          _state = ChangePasswordState.error;
          notifyListeners();
          return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = ChangePasswordState.error;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_state == ChangePasswordState.error) {
      _state = ChangePasswordState.idle;
      _errorMessage = '';
      notifyListeners();
    }
  }
}
