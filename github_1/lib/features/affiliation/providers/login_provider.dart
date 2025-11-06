import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:ciempresas/features/affiliation/services/auth_service.dart';
import 'package:flutter/material.dart';

enum LoginState { idle, loading, success, error, locked }

enum LoginResult { none, newUser, existingUser }

class LoginProvider extends ChangeNotifier {
  final AuthService _authService;
  final SecureStorageService _storageService;

  LoginProvider(this._authService, this._storageService);

  LoginState _state = LoginState.idle;
  LoginState get state => _state;

  LoginResult _result = LoginResult.none;
  LoginResult get result => _result;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  int _loginAttempts = 0;
  static const int _maxLoginAttempts = 3;

  bool get isLoading => _state == LoginState.loading;
  bool get showLoginError => _state == LoginState.error;
  bool get isLoginLocked => _state == LoginState.locked;
  String get messageError => _errorMessage;

  void clearLoginError() {
    if (_state == LoginState.error) {
      _state = LoginState.idle;
      _errorMessage = '';
      notifyListeners();
    }
  }

  void clearResult() {
    _result = LoginResult.none;
  }

  Future<Result<Map<String, dynamic>, Exception>> getClientCredentialsToken({
    String? basicAuth,
  }) async {
    try {
      return await _authService.getClientCredentialsToken(basicAuth: basicAuth);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<void> login({
    required String username,
    required String password,
    required String errorTemplate,
    required String lastAttemptTemplate,
    required String lockedTemplate,
  }) async {
    if (_state == LoginState.locked) return;

    _state = LoginState.loading;
    notifyListeners();

    try {
      final loginResult = await _authService.login(
        username: username,
        password: password,
      );

      switch (loginResult) {
        case Success(value: final data):
          debugPrint('Login exitoso: $data');

          // Guardar todos los datos importantes de la respuesta
          final userData = data['data'];

          // Datos básicos del usuario
          String email = userData['email'].toString().trim();
          String phone = userData['phone'].toString().trim();
          String clientNumber = userData['clientNumber'].toString().trim();
          String fullName = userData['fullName'].toString().trim();
          String userId = userData['userId'].toString().trim();
          String clientType = userData['clientType'].toString().trim();
          String contractNumber = userData['contractNumber'].toString().trim();

          // Token de autenticación
          String token = userData['token'].toString().trim();
          String expiresIn = userData['expiresIn'].toString().trim();

          // Fecha del último login
          String lastLoginDate = userData['lastLoginDate'].toString().trim();

          // Guardar todos los datos en el almacenamiento seguro
          await _storageService.saveString('email', email);
          await _storageService.saveString('phone', phone);
          await _storageService.saveString('username', username);
          await _storageService.saveString('clientNumber', clientNumber);
          await _storageService.saveString('fullName', fullName);
          await _storageService.saveString('userId', userId);
          await _storageService.saveString('clientType', clientType);
          await _storageService.saveString('contractNumber', contractNumber);
          await _storageService.saveString('token', token);
          await _storageService.saveString('expiresIn', expiresIn);
          await _storageService.saveString('lastLoginDate', lastLoginDate);

          debugPrint('📱 Datos guardados en almacenamiento seguro:');
          debugPrint('📧 Email: $email');
          debugPrint('📞 Teléfono: $phone');
          debugPrint('👤 Usuario: $username');
          debugPrint('🏢 Cliente: $clientNumber');
          debugPrint('👨‍💼 Nombre completo: $fullName');
          debugPrint('🔑 Token guardado: ${token.substring(0, 20)}...');

          _state = LoginState.success;
          _loginAttempts = 0;

          // Obtener token de credenciales antes de verificar usuario
          await _getTokenAndCheckUser(username, errorTemplate);
          break;
        case Failure(exception: final error):
          debugPrint('Error en login: $error');
          errorTemplate = error.toString().split(':').last.trim();
          _handleLoginError(errorTemplate, lastAttemptTemplate, lockedTemplate);
          break;
      }
    } catch (e) {
      _handleLoginError(errorTemplate, lastAttemptTemplate, lockedTemplate);
    }
  }

  void _handleLoginError(
    String errorTemplate,
    String lastAttemptTemplate,
    String lockedTemplate,
  ) {
    _loginAttempts++;
    if (_loginAttempts >= _maxLoginAttempts) {
      _state = LoginState.locked;
      _errorMessage = lockedTemplate;
    } else {
      _state = LoginState.error;
      if (_loginAttempts == _maxLoginAttempts - 1) {
        _errorMessage = '$errorTemplate. $lastAttemptTemplate';
      } else {
        final remaining = _maxLoginAttempts - _loginAttempts;
        _errorMessage = '$errorTemplate Le quedan $remaining intento(s).';
      }
    }
    notifyListeners();
  }

  Future<void> _getTokenAndCheckUser(
    String username,
    String errorTemplate,
  ) async {
    // Primero obtener token de credenciales
    final tokenResult = await getClientCredentialsToken(
      basicAuth:
          'UnNQVGZzd2NOY3dQOVZLQVBRWW82OTB2SElya2pyejJ4SVRYNGxwaGs0NUhwMWx0OmFPeHRkUk9vN2llcUlWeFI3SndlaHpLc1d5Rk1rMXRhY3V6Y212R3BudVZBZlo4NjViV3dDYWZsVEVGeUczeWQ=',
    );

    switch (tokenResult) {
      case Success(value: final tokenData):
        debugPrint('Token de credenciales obtenido: $tokenData');
        // Ahora verificar si el usuario existe
        await _checkUserExists(username, errorTemplate);
        break;
      case Failure(exception: final error):
        debugPrint('Error obteniendo token: $error');
        _state = LoginState.error;
        _errorMessage = 'Error de autenticación';
        notifyListeners();
        break;
    }
  }

  Future<void> _checkUserExists(String username, String errorTemplate) async {
    final result = await _authService.checkUserExists(username);

    switch (result) {
      case Success(value: final userExists):
        debugPrint('User exists?: $userExists');
        _state = LoginState.success;
        _result = userExists ? LoginResult.existingUser : LoginResult.newUser;
        break;
      case Failure(exception: final error):
        _state = LoginState.error;
        _errorMessage = errorTemplate;
        break;
    }
    notifyListeners();
  }
}
