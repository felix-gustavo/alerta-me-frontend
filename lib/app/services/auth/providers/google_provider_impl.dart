import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/auth_user.dart';
import '../../../model/users.dart';
import '../../http/http_client.dart';
import '../../http/http_client_dio_impl.dart';
import 'login_provider.dart';

class GoogleProviderImpl implements ILoginProvider {
  final IHttpClient _httpClient;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleProviderImpl._() : _httpClient = HttpClientDioImpl.instance;

  static GoogleProviderImpl? _instance;

  static GoogleProviderImpl get instance {
    _instance ??= GoogleProviderImpl._();
    return _instance!;
  }

  @override
  Future<AuthUser?> signIn() async {
    try {
      final userCredential = await _auth.signInWithPopup(GoogleAuthProvider());

      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();

        if (idToken != null) {
          final response = await _httpClient.post(
            '/auth/sign-in',
            data: {
              'idToken': idToken,
            },
          );

          return AuthUser(
            user: Users.fromMap(response.data),
            accessToken: idToken,
          );
        }
      }
    } on FirebaseException catch (_) {}
    return null;
  }
}
