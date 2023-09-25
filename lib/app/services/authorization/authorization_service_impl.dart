import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/exceptions_impl.dart';
import '../../model/authorizations.dart';
import '../http/http_client.dart';
import 'authorization_service.dart';

class AuthorizationServiceImpl implements IAuthorizationService {
  final IHttpClient _httpClient;
  final FirebaseAuth _auth;

  AuthorizationServiceImpl({required IHttpClient httpClient})
      : _httpClient = httpClient,
        _auth = FirebaseAuth.instance;

  @override
  Future<Authorizations> createAuthorization(String email) async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final response = await _httpClient.post(
      '/authorizations',
      data: {'elderly': email},
      token: accessToken,
    );

    return Authorizations.fromMap(response.data);
  }

  @override
  Future<Authorizations?> getAuthorization() async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final response = await _httpClient.get(
      '/authorizations/user',
      token: accessToken,
    );

    if (response.data == null) return null;
    return Authorizations.fromMap(response.data);
  }
}
