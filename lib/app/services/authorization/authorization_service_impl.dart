import '../../model/authorizations.dart';
import '../http/http_client.dart';
import 'authorization_service.dart';

class AuthorizationServiceImpl implements IAuthorizationService {
  final IHttpClient _httpClient;

  AuthorizationServiceImpl({required IHttpClient httpClient})
      : _httpClient = httpClient;

  @override
  Future<Authorizations> createAuthorization({
    required String email,
    required String accessToken,
  }) async {
    final response = await _httpClient.post(
      '/authorizations',
      data: {'elderly': email},
      token: accessToken,
    );

    return Authorizations.fromMap(response.data);
  }

  @override
  Future<Authorizations?> getAuthorization(String accessToken) async {
    final response = await _httpClient.get(
      '/authorizations/user',
      token: accessToken,
    );

    if (response.data == null) return null;
    return Authorizations.fromMap(response.data);
  }

  @override
  Future<String?> deleteAuthorization(String accessToken) async {
    final response = await _httpClient.delete(
      '/authorizations',
      token: accessToken,
    );

    if (response.statusCode == 200) return response.data['id'];
    return null;
  }
}
