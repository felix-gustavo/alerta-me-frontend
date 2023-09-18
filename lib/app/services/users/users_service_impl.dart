import '../../model/users.dart';
import '../http/http_client.dart';
import 'users_service.dart';

class UsersServiceImpl implements IUsersService {
  final IHttpClient _httpClient;

  UsersServiceImpl({required IHttpClient httpClient})
      : _httpClient = httpClient;

  @override
  Future<Users?> getUserByEmail({
    required String email,
    required String token,
  }) async {
    Users? user;

    final response = await _httpClient.get(
      '/users/email/$email',
      token: token,
    );
    if (response.data != null) user = Users.fromMap(response.data);

    return user;
  }

  @override
  Future<bool> isElderly({
    required String email,
    required String token,
  }) async {
    final response = await _httpClient.get(
      '/users/is-elderly/$email',
      token: token,
    );

    if (response.data == null) return false;
    return response.data;
  }
}
