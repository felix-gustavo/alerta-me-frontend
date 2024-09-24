import '../../model/users.dart';
import '../http/http_client.dart';
import 'users_service.dart';

class UsersServiceImpl implements IUsersService {
  final IHttpClient _httpClient;

  UsersServiceImpl({required IHttpClient httpClient})
      : _httpClient = httpClient;

  @override
  Future<Users?> getUserByToken(String accessToken) async {
    Users? user;

    final response = await _httpClient.get(
      '/users',
      token: accessToken,
      queryParameters: {'isElderly': false},
    );
    if (response.data != null) user = Users.fromMap(response.data);

    return user;
  }

  @override
  Future<Users?> getUserById({
    required String id,
    required String accessToken,
  }) async {
    Users? user;

    final response =
        await _httpClient.get('/users/elderly/id/$id', token: accessToken);
    if (response.data != null) user = Users.fromMap(response.data);

    return user;
  }

  @override
  Future<String?> deleteUser({required String accessToken}) async {
    final response = await _httpClient.delete('/users', token: accessToken);

    if (response.statusCode == 200) return response.data['id'];
    return null;
  }

  @override
  Future<String?> deleteElderly({
    required String id,
    required String accessToken,
  }) async {
    final response = await _httpClient.delete(
      '/users/elderly/$id',
      token: accessToken,
    );

    if (response.statusCode == 200) return response.data['id'];
    return null;
  }
}
