import '../../model/users.dart';

abstract interface class IUsersService {
  Future<Users?> getUserByEmail({
    required String email,
    required String token,
  });
  Future<bool> isElderly({
    required String email,
    required String token,
  });
}
