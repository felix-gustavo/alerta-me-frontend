import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/auth_user.dart';
import '../../../model/users.dart';
import '../../http/http_client.dart';
import '../../http/http_client_dio_impl.dart';
import 'login_provider.dart';

class AnonProviderImpl implements ILoginProvider {
  static AnonProviderImpl? _instance;
  final IHttpClient _httpClient;
  final FirebaseAuth _auth;

  AnonProviderImpl._()
      : _httpClient = HttpClientDioImpl.instance,
        _auth = FirebaseAuth.instance;

  static AnonProviderImpl get instance {
    _instance ??= AnonProviderImpl._();
    return _instance!;
  }

  @override
  Future<AuthUser?> signIn() async {
    const userDemoEmail = String.fromEnvironment('USER_DEMO_EMAIL');
    const userDemoPassword = String.fromEnvironment('USER_DEMO_PASS');

    final userCredential = await _auth.signInWithEmailAndPassword(
      email: userDemoEmail,
      password: userDemoPassword,
    );

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

    return null;
  }
}
