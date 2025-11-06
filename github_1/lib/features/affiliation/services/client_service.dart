import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';
import 'package:ciempresas/core/utils/secure_storage_service.dart';

abstract class ClientService {
  Future<Result<Map<String, dynamic>, Exception>> getClientData();
}

class ClientServiceImpl implements ClientService {
  final RestManagerV2 _restManager;
  final SecureStorageService _secureStorage;
  late final String _channel;

  ClientServiceImpl(this._restManager, this._secureStorage) {
    _channel = String.fromEnvironment('CN_CHANEL', defaultValue: 'CN105');
  }

  @override
  Future<Result<Map<String, dynamic>, Exception>> getClientData() async {
    try {
      final clientNumber = await _secureStorage.readString('clientNumber');
      if (clientNumber == null) {
        return Failure<Map<String, dynamic>, Exception>(
          Exception('Número de cliente no encontrado'),
        );
      }

      return await _restManager.getClientData(
        clientNumber: clientNumber,
        channel: _channel,
      );
    } catch (e) {
      return Failure<Map<String, dynamic>, Exception>(Exception(e.toString()));
    }
  }
}
