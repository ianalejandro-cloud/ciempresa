import 'package:ciempresas/core/restFull/api_endpoints.dart';
import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/core/utils/Network_info_service.dart';
import 'package:ciempresas/core/utils/random_generator.dart';

abstract class AuthService {
  Future<Result<Map<String, dynamic>, Exception>> login({
    required String username,
    required String password,
  });

  Future<Result<bool, Exception>> checkUserExists(String username);

  Future<Result<Map<String, dynamic>, Exception>> getClientCredentialsToken({
    String? basicAuth,
  });
}

class AuthServiceImpl implements AuthService {
  final RestManagerV2 _restManager;
  late final String _channel;
  late final String _applicationName;

  final NetworkInfoService _networkInfoService = NetworkInfoService();

  AuthServiceImpl(this._restManager) {
    _channel = String.fromEnvironment('CN_CHANEL', defaultValue: 'CN105');
    _applicationName = String.fromEnvironment(
      'APPLICATION',
      defaultValue: 'CIEmpresas',
    );
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> login({
    required String username,
    required String password,
  }) async {
    try {
      String tokenLogin = RandomGenerator.generateEightDigitString();
      String? ipAddress = await _networkInfoService.getIpAddress();

      return await _restManager.authenticateLogin(
        username: username,
        password: password,
        token: tokenLogin,
        ip: ipAddress ?? '127.0.0.1',
        channel: _channel,
        sessionId:
            'CE12CE42A610699E172FB665E22F49E5', // TODO: Generate dynamically
      );
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> checkUserExists(String username) async {
    try {
      final result = await _restManager.postWithBearerToken(
        endpoint: ApiEndpoint.userExists,
        body: {
          'username': username,
          'channel': _channel,
          'application': _applicationName,
        },
      );

      switch (result) {
        case Success(value: final data):
          return Success(data['detail']['exists'] as bool);
        //return Success(true);
        case Failure(exception: final error):
          return Failure(error);
      }
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> getClientCredentialsToken({
    String? basicAuth,
  }) async {
    try {
      return await _restManager.getClientCredentialsToken(basicAuth: basicAuth);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
