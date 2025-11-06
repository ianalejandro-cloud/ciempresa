import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/features/affiliation/services/client_service.dart';
import 'package:flutter/material.dart';

enum CompanyDetailsState { idle, loading, success, error }

class CompanyDetailsProvider extends ChangeNotifier {
  final ClientService _clientService;

  CompanyDetailsProvider(this._clientService);

  CompanyDetailsState _state = CompanyDetailsState.idle;
  CompanyDetailsState get state => _state;

  String _clientName = '';
  String get clientName => _clientName;

  String _clientRFC = '';
  String get clientRFC => _clientRFC;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == CompanyDetailsState.loading;
  bool get hasError => _state == CompanyDetailsState.error;

  Future<void> loadClientData() async {
    _state = CompanyDetailsState.loading;
    notifyListeners();

    try {
      final result = await _clientService.getClientData();

      switch (result) {
        case Success(value: final data):
          final detail = data['detail'] as Map<String, dynamic>;
          _clientName = detail['clientName'] ?? '';
          _clientRFC = detail['clientRFC'] ?? '';
          _state = CompanyDetailsState.success;
          break;
        case Failure(exception: final error):
          _errorMessage = error.toString();
          _state = CompanyDetailsState.error;
          break;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = CompanyDetailsState.error;
    }

    notifyListeners();
  }

  void clearError() {
    if (_state == CompanyDetailsState.error) {
      _state = CompanyDetailsState.idle;
      _errorMessage = '';
      notifyListeners();
    }
  }
}
