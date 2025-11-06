import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:flutter/material.dart';
import 'package:ciempresas/core/restFull/api_endpoints.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/core/utils/Network_info_service.dart';

enum UserAvailabilityError { userExists, serverError }

class CredentialSetupProvider with ChangeNotifier {
  final _restManager = RestManagerV2();
  final _networkInfoService = NetworkInfoService();
  late final String _channel;

  bool _isLoading = false;
  bool _isFormValid = false;
  String? _errorMessage;
  UserAvailabilityError? _errorType;

  CredentialSetupProvider() {
    _channel = String.fromEnvironment('CN_CHANEL', defaultValue: 'CN105');
  }

  bool get isLoading => _isLoading;
  bool get isFormValid => _isFormValid;
  String? get errorMessage => _errorMessage;
  UserAvailabilityError? get errorType => _errorType;

  void updateFormValidity(bool isValid) {
    _isFormValid = isValid;
    notifyListeners();
  }

  Future<bool> checkUserAvailability(String username) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      final result = await _restManager.postWithBearerToken(
        endpoint: ApiEndpoint.checkUserAvailability,
        body: {
          'username': username.trim(),
          //'username': 'NUFO1023',
          'application_name': '@CIBANCO',
          'channel': 'CN008',
        },
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Usuario disponible: $data');
          _isLoading = false;
          notifyListeners();
          return true;
        case Failure(exception: final error):
          final errorMessage = error.toString();
          debugPrint('Error: $errorMessage');

          // Verificar si el error es específicamente de usuario existente
          if (errorMessage.contains(
            'El nombre de usuario no es válido o ya existe',
          )) {
            _errorType = UserAvailabilityError.userExists;
            _errorMessage = 'Usuario no disponible';
          } else {
            _errorType = UserAvailabilityError.serverError;
            _errorMessage = errorMessage;
          }

          _isLoading = false;
          notifyListeners();
          return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _errorType = UserAvailabilityError.serverError;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> requestRecoveryCode(String username) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      final result = await _restManager.requestRecoveryCode(
        username: username.trim(),
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Código de recuperación enviado: $data');
          _isLoading = false;
          notifyListeners();
          return true;

        case Failure(exception: final exception):
          debugPrint('Error al solicitar código de recuperación: $exception');
          // Extraer el mensaje específico del error del servicio
          String errorMessage = exception.toString();
          if (errorMessage.contains('HTTP')) {
            // Extraer solo el mensaje después de "HTTP XXX: "
            final parts = errorMessage.split('HTTP ');
            if (parts.length > 1) {
              final messagePart = parts[1];
              final colonIndex = messagePart.indexOf(': ');
              if (colonIndex != -1 && colonIndex < messagePart.length - 1) {
                errorMessage = messagePart.substring(colonIndex + 2);
              }
            }
          }
          _errorMessage = errorMessage;
          _errorType = UserAvailabilityError.serverError;
          _isLoading = false;
          notifyListeners();
          return false;
      }
    } catch (e) {
      debugPrint('Error inesperado al solicitar código de recuperación: $e');
      _errorMessage = 'Error inesperado. Intenta nuevamente.';
      _errorType = UserAvailabilityError.serverError;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> validateRecoveryToken(String token) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      final String? ipAddress = await _networkInfoService.getIpAddress();

      final result = await _restManager.validateRecoveryToken(
        token: token.trim(),
        ip: ipAddress ?? '127.0.0.1',
        channel: _channel,
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Token de recuperación válido: $data');
          _isLoading = false;
          notifyListeners();
          return true;

        case Failure(exception: final exception):
          debugPrint('Error al validar token de recuperación: $exception');
          // Extraer el mensaje específico del error del servicio
          String errorMessage = exception.toString();
          if (errorMessage.contains('HTTP')) {
            // Extraer solo el mensaje después de "HTTP XXX: "
            final parts = errorMessage.split('HTTP ');
            if (parts.length > 1) {
              final messagePart = parts[1];
              final colonIndex = messagePart.indexOf(': ');
              if (colonIndex != -1 && colonIndex < messagePart.length - 1) {
                errorMessage = messagePart.substring(colonIndex + 2);
              }
            }
          }
          _errorMessage = errorMessage;
          _errorType = UserAvailabilityError.serverError;
          _isLoading = false;
          notifyListeners();
          return false;
      }
    } catch (e) {
      debugPrint('Error inesperado al validar token de recuperación: $e');
      _errorMessage = 'Error inesperado. Intenta nuevamente.';
      _errorType = UserAvailabilityError.serverError;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      final result = await _restManager.changePassword(
        username: username.trim(),
        currentPassword: currentPassword.trim(),
        newPassword: newPassword.trim(),
        confirmPassword: confirmPassword.trim(),
        token: token.trim(),
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Contraseña cambiada exitosamente: $data');
          _isLoading = false;
          notifyListeners();
          return true;

        case Failure(exception: final exception):
          debugPrint('Error al cambiar contraseña: $exception');
          // Extraer el mensaje específico del error del servicio
          String errorMessage = exception.toString();
          if (errorMessage.contains('HTTP')) {
            // Extraer solo el mensaje después de "HTTP XXX: "
            final parts = errorMessage.split('HTTP ');
            if (parts.length > 1) {
              final messagePart = parts[1];
              final colonIndex = messagePart.indexOf(': ');
              if (colonIndex != -1 && colonIndex < messagePart.length - 1) {
                errorMessage = messagePart.substring(colonIndex + 2);
              }
            }
          }
          _errorMessage = errorMessage;
          _errorType = UserAvailabilityError.serverError;
          _isLoading = false;
          notifyListeners();
          return false;
      }
    } catch (e) {
      debugPrint('Error inesperado al cambiar contraseña: $e');
      _errorMessage = 'Error inesperado. Intenta nuevamente.';
      _errorType = UserAvailabilityError.serverError;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    _errorType = null;
    notifyListeners();
  }
}
