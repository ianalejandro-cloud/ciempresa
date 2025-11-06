import 'package:ciempresas/core/restFull/api_endpoints.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:flutter/material.dart';

class SendActivationCodeProvider with ChangeNotifier {
  final _restManager = RestManagerV2();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> sendCode({
    required String email,
    required String phone,
    required String activationCode,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _restManager.postWithBearerToken(
        endpoint: ApiEndpoint.sendActivationCode,
        body: {
          'email': email,
          'phone': phone,
          'activation_code': activationCode,
        },
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Código de activación enviado: $data');
          _isLoading = false;
          notifyListeners();
          return true;
        case Failure(exception: final error):
          _errorMessage = error.toString();
          debugPrint('Error al enviar código: ${error.toString()}');
          _isLoading = false;
          notifyListeners();
          return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
