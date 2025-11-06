import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';

abstract class ChangeEmailService {
  Future<Result<Map<String, dynamic>, Exception>> changeEmail({
    required int id,
    required String newEmail,
    required String newEmailConfirm,
    required int dynamicPassword,
    required int clientNumber,
  });
}

class ChangeEmailServiceImpl implements ChangeEmailService {
  final RestManagerV2 _restManager;

  ChangeEmailServiceImpl(this._restManager);

  @override
  Future<Result<Map<String, dynamic>, Exception>> changeEmail({
    required int id,
    required String newEmail,
    required String newEmailConfirm,
    required int dynamicPassword,
    required int clientNumber,
  }) async {
    try {
      final result = await _restManager.changeEmail(
        id: id,
        newEmail: newEmail,
        newEmailConfirm: newEmailConfirm,
        dynamicPassword: dynamicPassword,
        clientNumber: clientNumber,
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
