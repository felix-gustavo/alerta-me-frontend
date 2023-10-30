import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/auth_user.dart';
import 'login_provider.dart';

class SkillProviderImpl implements ILoginProvider {
  static SkillProviderImpl? _instance;
  final FirebaseAuth _auth;

  SkillProviderImpl._() : _auth = FirebaseAuth.instance;

  static SkillProviderImpl get instance {
    _instance ??= SkillProviderImpl._();
    return _instance!;
  }

  @override
  Future<AuthUser?> signIn() async {
    const elderlyDemoEmail = String.fromEnvironment('ELDERLY_DEMO_EMAIL');
    const elderlyDemoPassword = String.fromEnvironment('ELDERLY_DEMO_PASS');

    final userCredential = await _auth.signInWithEmailAndPassword(
      email: elderlyDemoEmail,
      password: elderlyDemoPassword,
    );

    final user = userCredential.user;

    if (user != null) {
      final uri = Uri.parse(window.location.href);
      Map<String, dynamic> queryParameters = Map.from(uri.queryParameters);
      final state = queryParameters['state'];
      final redirectUri = queryParameters['redirect_uri'];
      final idToken = await user.getIdToken();

      final redirectTo =
          '$redirectUri#state=$state&access_token=$idToken&token_type=Bearer';

      window.location.assign(redirectTo);
    }

    return null;
  }
}
