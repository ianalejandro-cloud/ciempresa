import 'package:flutter/material.dart';
import 'package:ciempresas/core/restFull/api_endpoints.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';

class OrganizationProvider with ChangeNotifier {
  final _restManager = RestManagerV2();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _organizationData;
  String? _organizationId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get organizationData => _organizationData;
  String? get organizationId => _organizationId;

  Future<bool> getOrganizationId() async {
    _isLoading = true;
    _errorMessage = null;
    _organizationData = null;
    _organizationId = null;
    notifyListeners();

    try {
      final result = await _restManager.getWithBearerToken(
        endpoint: ApiEndpoint.organizationId,
      );

      switch (result) {
        case Success(value: final data):
          debugPrint('Organización obtenida: $data');
          _organizationData = data;
          if (data['detail'] is Map && data['detail']['id'] != null) {
            _organizationId = data['detail']['id'];
          }
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

  void clearData() {
    _organizationData = null;
    _errorMessage = null;
    _organizationId = null;
    notifyListeners();
  }
}
