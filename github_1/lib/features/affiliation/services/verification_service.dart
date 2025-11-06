import 'dart:convert';

import 'package:ciempresas/core/restFull/api_endpoints.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/core/utils/crypto_verisec.dart';
import 'package:flutter/material.dart';
import 'package:hex/hex.dart';

abstract class VerificationService {
  Future<Result<Map<String, dynamic>, Exception>> validateActivationCode({
    required String activationCode,
  });

  Future<Result<Map<String, dynamic>, Exception>> createUser({
    required String username,
  });

  Future<Result<Map<String, dynamic>, Exception>> registerOtpSerial({
    required String username,
    required String nip,
    required String activationCode,
    required String serial,
    required String publicKey,
  });
}

class VerificationServiceImpl implements VerificationService {
  final RestManagerV2 _restManager;
  late final String _channel;
  late final String _applicationName;

  VerificationServiceImpl(this._restManager) {
    _channel = String.fromEnvironment('CN_CHANEL', defaultValue: 'CN105');
    _applicationName = String.fromEnvironment(
      'APPLICATION',
      defaultValue: 'CIEmpresas',
    );
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> validateActivationCode({
    required String activationCode,
  }) async {
    try {
      final result = await _restManager.postWithBearerToken(
        endpoint: ApiEndpoint.validateActivationCode,
        body: {'activation_code': activationCode},
      );

      switch (result) {
        case Success(value: final data):
          return Success(data);
        case Failure(exception: final error):
          return Failure(error);
      }
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> createUser({
    required String username,
  }) async {
    try {
      final result = await _restManager.postWithBearerToken(
        endpoint: ApiEndpoint.createUser,
        body: {
          'username': username,
          'channel': _channel,
          'application_name': _applicationName,
        },
      );

      switch (result) {
        case Success(value: final data):
          return Success(data);
        case Failure(exception: final error):
          return Failure(error);
      }
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> registerOtpSerial({
    required String username,
    required String nip,
    required String activationCode,
    required String serial,
    required String publicKey,
  }) async {
    try {
      final CryptoVerisec crypto = CryptoVerisec();
      // Cifrar el NIP usando la llave pública RSA obtenida del servidor

      final String userClearKey = utf8.decode(HEX.decode(publicKey));
      debugPrint(userClearKey);
      String nipCorrect = nip.padRight(8, '0');

      // Cifrar el NIP usando RSA PKCS1 (equivalente exacto al Swift)
      final String encryptedNip = crypto.rsa(
        key: userClearKey,
        message: nipCorrect,
        operation: RsaOperation.encrypt,
        rsaPadding:
            RsaPaddingScheme.OAEP_SHA256, // ¡Aquí se especifica OAEP_SHA256!
      );

      final result = await _restManager.postWithBearerToken(
        endpoint: ApiEndpoint.registerOtpSerial,
        body: {
          'username': username,
          'channel': _channel,
          'application_name': _applicationName,
          'nip': encryptedNip,
          'activation_code': activationCode,
          'serial': serial,
        },
      );

      switch (result) {
        case Success(value: final data):
          return Success(data);
        case Failure(exception: final error):
          return Failure(error);
      }
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
