import 'package:ciempresas/core/restFull/rest_manager_v2.dart';
import 'package:ciempresas/core/restFull/result.dart';

abstract class ChangePasswordService {
  Future<Result<Map<String, dynamic>, Exception>> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  });
}

class ChangePasswordServiceImpl implements ChangePasswordService {
  final RestManagerV2 _restManager;

  ChangePasswordServiceImpl(this._restManager);

  @override
  Future<Result<Map<String, dynamic>, Exception>> changePassword({
    required String username,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      final result = await _restManager.changePassword(
        username: username,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        token: token,
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
