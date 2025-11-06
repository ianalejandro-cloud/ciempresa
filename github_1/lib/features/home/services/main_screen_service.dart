import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';

abstract class MainScreenService {
  Future<Result<Map<String, dynamic>, Exception>> logout(
    String userId,
    String channel,
  );
}

class MainScreenServiceImpl implements MainScreenService {
  final RestManagerV2 _restManager;

  MainScreenServiceImpl(this._restManager);

  @override
  Future<Result<Map<String, dynamic>, Exception>> logout(
    String userId,
    String channel,
  ) async {
    try {
      final result = await _restManager.logout(userId, channel);

      switch (result) {
        case Success(value: final data):
          // Limpiar tokens después del logout exitoso
          await _restManager.clearTokens();
          return Success(data);
        case Failure(exception: final error):
          return Failure(error);
      }
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
