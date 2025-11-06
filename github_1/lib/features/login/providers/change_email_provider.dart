import 'package:flutter/material.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/features/login/services/change_email_service.dart';

enum ChangeEmailState { idle, loading, success, error }

class ChangeEmailProvider with ChangeNotifier {
  final ChangeEmailService _changeEmailService;
  final SecureStorageService _storageService;

  ChangeEmailProvider(this._changeEmailService, this._storageService);

  ChangeEmailState _state = ChangeEmailState.idle;
  ChangeEmailState get state => _state;

  bool _isFormValid = false;
  String _errorMessage = '';
  String _currentEmail = '';

  bool get isLoading => _state == ChangeEmailState.loading;
  bool get isFormValid => _isFormValid;
  String get errorMessage => _errorMessage;
  String get currentEmail => _currentEmail;

  void updateFormValidity(bool isValid) {
    _isFormValid = isValid;
    notifyListeners();
  }

  Future<void> loadCurrentEmail() async {
    _currentEmail =
        await _storageService.readString('email') ?? 'a@cibanco.com';
    notifyListeners();
  }

  Future<bool> changeEmail({
    required String newEmail,
    required String confirmEmail,
    required String dynamicPassword,
  }) async {
    _state = ChangeEmailState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final userId = await _storageService.readString('userId') ?? '0';
      final clientNumber =
          await _storageService.readString('clientNumber') ?? '';

      final result = await _changeEmailService.changeEmail(
        id: int.parse(userId),
        newEmail: newEmail,
        newEmailConfirm: confirmEmail,
        dynamicPassword: int.parse(dynamicPassword),
        clientNumber: int.parse(clientNumber),
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Email cambiado exitosamente: $data');
          await _storageService.saveString('email', newEmail);
          _state = ChangeEmailState.success;
          notifyListeners();
          return true;
        case Failure(exception: final error):
          _errorMessage = error.toString();
          debugPrint('Error: ${error.toString()}');
          _state = ChangeEmailState.error;
          notifyListeners();
          return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = ChangeEmailState.error;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    if (_state == ChangeEmailState.error) {
      _state = ChangeEmailState.idle;
      _errorMessage = '';
      notifyListeners();
    }
  }
}
