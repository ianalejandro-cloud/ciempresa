import 'package:flutter/material.dart';
import 'package:ciempresas/core/restFull/api_endpoints.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';

class ValidateClientProvider with ChangeNotifier {
  final _restManager = RestManagerV2();

  bool _isLoading = false;
  bool _isFormValid = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isFormValid => _isFormValid;
  String? get errorMessage => _errorMessage;

  void updateFormValidity(bool isValid) {
    _isFormValid = isValid;
    notifyListeners();
  }

  Future<bool> validateClient(String clientNumber) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _restManager.postWithBearerToken(
        endpoint: ApiEndpoint.validateClient,
        body: {'client_number': clientNumber.trim(), 'channel': 'CN101'},
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Cliente válido: $data');
          _isLoading = false;
          notifyListeners();
          return true;
        case Failure(exception: final error):
          _errorMessage = error.toString();
          debugPrint('Error: ${error.toString()}');
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
