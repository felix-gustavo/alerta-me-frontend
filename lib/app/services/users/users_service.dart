import '../../model/users.dart';

abstract interface class IUsersService {
  Future<Users?> getUserById({
    required String id,
    required String accessToken,
  });

  Future<Users?> getUserByToken(String accessToken);

  Future<String?> deleteUser({
    required String accessToken,
  });

  Future<String?> deleteElderly({
    required String id,
    required String accessToken,
  });
}
