import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/features/affiliation/services/verification_service.dart';
import 'package:ciempresas/services/verisec_service.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:ciempresas/custom_code/actions/perform_affiliation.dart' as actions;
import 'package:ciempresas/features/affiliation/providers/organization_provider.dart';
import 'package:ciempresas/features/affiliation/providers/send_activation_code_provider.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';

enum VerificationState {
  idle,
  loading,
  validatingCode,
  creatingUser,
  performingLogin,
  registeringSerial,
  resendingCode,
  success,
  error,
}

class VerificationProvider extends ChangeNotifier {
  final VerificationService _verificationService;
  final SecureStorageService _storageService;

  VerificationProvider(this._verificationService, this._storageService);

  VerificationState _state = VerificationState.idle;
  VerificationState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _performLoginResult = '';
  String get performLoginResult => _performLoginResult;
  String username = '';

  bool get isLoading =>
      _state == VerificationState.loading ||
      _state == VerificationState.validatingCode ||
      _state == VerificationState.creatingUser ||
      _state == VerificationState.performingLogin ||
      _state == VerificationState.registeringSerial ||
      _state == VerificationState.resendingCode;
  bool get showVerificationError => _state == VerificationState.error;
  String get messageError => _errorMessage;

  void clearVerificationError() {
    if (_state == VerificationState.error) {
      _state = VerificationState.idle;
      _errorMessage = '';
      notifyListeners();
    }
  }

  /// Maneja el reenvío del código de activación
  Future<bool> resendActivationCode() async {
    debugPrint('🔄 Iniciando reenvío de código de activación...');
    _state = VerificationState.resendingCode;
    _errorMessage = '';
    notifyListeners();

    try {
      // Obtener el organizationId
      final organizationProvider = OrganizationProvider();
      final success = await organizationProvider.getOrganizationId();
      
      if (!success) {
        debugPrint('❌ Error al obtener organizationId');
        _state = VerificationState.error;
        _errorMessage = 'Error al obtener información de la organización';
        notifyListeners();
        return false;
      }

      final organizationId = organizationProvider.organizationId;
      if (organizationId == null) {
        debugPrint('❌ OrganizationId es null');
        _state = VerificationState.error;
        _errorMessage = 'No se pudo obtener el ID de la organización';
        notifyListeners();
        return false;
      }

      // Generar nuevo código de activación usando performAffiliation
      debugPrint('📋 Generando nuevo código de activación...');
      String activationCode = await actions.performAffiliation(organizationId);

      if (activationCode.isEmpty || activationCode.startsWith('ERROR')) {
        debugPrint('❌ Error al generar código de activación: $activationCode');
        _state = VerificationState.error;
        _errorMessage = 'Error al generar nuevo código de activación';
        notifyListeners();
        return false;
      }

      debugPrint('✅ Nuevo código de activación generado: $activationCode');

      // Enviar el código usando el servicio send
      final sendCodeProvider = SendActivationCodeProvider();
      
      // Obtener email y phone del almacenamiento seguro
      final email = await _storageService.readString('email');
      final phone = await _storageService.readString('phone');

      final sendSuccess = await sendCodeProvider.sendCode(
        email: email ?? "",
        phone: phone ?? "",
        activationCode: activationCode,
      );

      if (sendSuccess) {
        debugPrint('✅ Código de activación enviado exitosamente');
        _state = VerificationState.idle;
        _errorMessage = '';
        notifyListeners();
        return true;
      } else {
        debugPrint('❌ Error al enviar código de activación');
        _state = VerificationState.error;
        _errorMessage = 'Error al enviar el código: ${sendCodeProvider.errorMessage}';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('❌ Excepción durante el reenvío: $e');
      _state = VerificationState.error;
      _errorMessage = 'Error inesperado: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> validateActivationCode({
    required String activationCode,
    required String seletedPIN,
    String errorTemplate = 'Código de activación inválido',
  }) async {
    debugPrint('🔄 Iniciando proceso de verificación completo...');

    // Guardar el código de activación para usarlo posteriormente
    await _storageService.saveString('activation_code', activationCode);

    // PASO 1: Validar código de activación
    _state = VerificationState.validatingCode;
    notifyListeners();

    try {
      debugPrint('📋 PASO 1: Validando código de activación: $activationCode');
      final validationResult = await _verificationService
          .validateActivationCode(activationCode: activationCode);

      switch (validationResult) {
        case Success(value: final data):
          debugPrint('✅ PASO 1 EXITOSO: Código de activación válido');
          debugPrint('📄 Respuesta del servidor: $data');

          // PASO 2: Crear usuario en el sistema
          await _createUser(seletedPIN);
          break;

        case Failure(exception: final error):
          debugPrint('❌ PASO 1 FALLIDO: Error en validación del código');
          debugPrint('📄 Error del servidor: $error');
          _state = VerificationState.error;
          // Extraer el mensaje de error del servidor o usar el template por defecto
          String errorMsg = error.toString();
          if (errorMsg.contains(':')) {
            errorMsg = errorMsg.split(':').last.trim();
          }
          _errorMessage = errorMsg.isNotEmpty ? errorMsg : errorTemplate;
          break;
      }
    } catch (e) {
      debugPrint('🚨 EXCEPCIÓN en PASO 1: $e');
      _state = VerificationState.error;
      _errorMessage = errorTemplate;
    }

    notifyListeners();
  }

  Future<void> _createUser(String seletedPIN) async {
    debugPrint('🔄 PASO 2: Iniciando creación de usuario...');
    _state = VerificationState.creatingUser;
    notifyListeners();

    try {
      // Obtener el username del almacenamiento seguro
      //final generator = RandomWordGenerator();
      //username = generator.generateRandomWord();
      username = await _storageService.readString('username') ?? '';

      // // Genera una palabra totalmente aleatoria de 8 caracteres
      // Ejemplo: "aB5fG9kL"
      debugPrint('📋 Llamando createUser con username: $username');
      final createUserResult = await _verificationService.createUser(
        username: username,
      );

      switch (createUserResult) {
        case Success(value: final data):
          debugPrint('✅ PASO 2 EXITOSO: Usuario creado correctamente');
          debugPrint('📄 Respuesta del servidor: $data');

          // Extraer y almacenar la clave pública de la respuesta
          if (data['detail'] != null && data['detail']['public_key'] != null) {
            final publicKey = data['detail']['public_key'].toString();
            await _storageService.saveString('rsa_public_key', publicKey);
            debugPrint('🔑 Clave pública almacenada correctamente');
          } else {
            debugPrint(
              '⚠️ ADVERTENCIA: No se encontró clave pública en la respuesta',
            );
          }

          // PASO 3: Ejecutar performLogin con el código como NIP
          debugPrint('✅  PIN enviado correctamente: $seletedPIN');
          await _executePerformLogin(seletedPIN);
          break;

        case Failure(exception: final error):
          debugPrint('❌ PASO 2 FALLIDO: Error al crear el usuario');
          debugPrint('📄 Error del servidor: $error');
          _state = VerificationState.error;
          String errorMsg = error.toString();
          if (errorMsg.contains(':')) {
            errorMsg = errorMsg.split(':').last.trim();
          }
          _errorMessage = errorMsg.isNotEmpty
              ? errorMsg
              : 'Error al crear el usuario';
          break;
      }
    } catch (e) {
      debugPrint('🚨 EXCEPCIÓN en PASO 2 (createUser): $e');
      _state = VerificationState.error;
      _errorMessage = 'Error de conexión al crear el usuario: ${e.toString()}';
    }

    notifyListeners();
  }

  Future<void> _executePerformLogin(String nip) async {
    debugPrint('🔄 PASO 3: Iniciando performLogin con NIP...');
    _state = VerificationState.performingLogin;
    notifyListeners();

    try {
      debugPrint('📋 Llamando VerisecService.performLogin con NIP: $nip');
      final loginResult = await VerisecService.performLogin(nip);

      debugPrint('📄 Respuesta de performLogin: $loginResult');

      if (loginResult.isNotEmpty && !loginResult.startsWith('ERROR')) {
        debugPrint('✅ PASO 3 EXITOSO: performLogin completado');
        debugPrint('🔑 Token Serial obtenido: $loginResult');

        _performLoginResult = loginResult;

        // PASO 4: Registrar el serial del OTP
        await _registerOtpSerial(nip, loginResult);

        debugPrint('🎉 PROCESO COMPLETO: Verificación y login exitosos');
      } else {
        debugPrint('❌ PASO 3 FALLIDO: performLogin retornó error');
        debugPrint('📄 Resultado: $loginResult');

        _state = VerificationState.error;
        _errorMessage =
            'Error en el proceso de autenticación Verisec: $loginResult';
      }
    } catch (e) {
      debugPrint('🚨 EXCEPCIÓN en PASO 3 (performLogin): $e');
      _state = VerificationState.error;
      _errorMessage = 'Error de conexión con Verisec: ${e.toString()}';
    }

    notifyListeners();
  }

  Future<void> _registerOtpSerial(String nip, String serial) async {
    debugPrint('🔄 PASO 4: Iniciando registro del serial del OTP...');
    _state = VerificationState.registeringSerial;
    notifyListeners();

    try {
      // Obtener datos del usuario desde el almacenamiento seguro
      //final username = await _storageService.readString('username');
      final activationCode = await _storageService.readString(
        'activation_code',
      );
      final publicKey = await _storageService.readString('rsa_public_key');

      if (publicKey == null) {
        debugPrint('❌ PASO 4 FALLIDO: No se encontró la clave pública RSA');
        _state = VerificationState.error;
        _errorMessage =
            'Error: No se encontró la clave pública para encriptar el NIP';
        notifyListeners();
        return;
      }

      debugPrint('📋 Llamando registerOtpSerial con:');
      debugPrint('  - Username: $username');
      debugPrint('  - NIP: [CIFRADO]');
      debugPrint('  - Código de activación: $activationCode');
      debugPrint('  - Serial: $serial');
      debugPrint('  - Clave pública: [ALMACENADA]');

      final registrationResult = await _verificationService.registerOtpSerial(
        username: username,
        nip: nip,
        activationCode: activationCode ?? '',
        serial: serial,
        publicKey: publicKey,
      );

      switch (registrationResult) {
        case Success(value: final data):
          debugPrint(
            '✅ PASO 4 EXITOSO: Serial del OTP registrado correctamente',
          );
          debugPrint('📄 Respuesta del servidor: $data');

          _state = VerificationState.success;
          _errorMessage = '';

          break;

        case Failure(exception: final error):
          debugPrint('❌ PASO 4 FALLIDO: Error al registrar el serial del OTP');
          debugPrint('📄 Error del servidor: $error');

          _state = VerificationState.error;
          String errorMsg = error.toString();
          if (errorMsg.contains(':')) {
            errorMsg = errorMsg.split(':').last.trim();
          }
          _errorMessage = errorMsg.isNotEmpty
              ? errorMsg
              : 'Error al registrar el serial del OTP';

          break;
      }
    } catch (e) {
      debugPrint('🚨 EXCEPCIÓN en PASO 4 (registerOtpSerial): $e');
      _state = VerificationState.error;
      _errorMessage =
          'Error de conexión al registrar el serial: ${e.toString()}';
    }

    notifyListeners();
  }
}
