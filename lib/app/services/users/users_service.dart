import '../../model/users.dart';

abstract interface class IUsersService {
  Future<Users?> getUserByToken(String accessToken);

  Future<Users?> getUserByEmail({
    required String email,
    required String accessToken,
  });

  Future<String?> deleteUser({
    required String accessToken,
  });

  Future<String?> deleteElderly({
    required String id,
    required String accessToken,
  });
}
