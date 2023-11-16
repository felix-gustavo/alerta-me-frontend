import 'dart:html';

import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart';

import '../../../model/auth_user.dart';
import 'login_provider.dart';

class SkillProviderImpl implements ILoginProvider {
  static SkillProviderImpl? _instance;
  SkillProviderImpl._();

  static SkillProviderImpl get instance {
    _instance ??= SkillProviderImpl._();
    return _instance!;
  }

  @override
  Future<AuthUser?> signIn() async {
    const secretKey = String.fromEnvironment('SECRET_KEY');

    const elderlyDemoEmail = String.fromEnvironment('ELDERLY_DEMO_EMAIL');
    const elderlyDemoPassword = String.fromEnvironment('ELDERLY_DEMO_PASS');

    const payload = '$elderlyDemoEmail:$elderlyDemoPassword';

    final uri = Uri.parse(window.location.href);
    Map<String, dynamic> queryParameters = Map.from(uri.queryParameters);
    final state = queryParameters['state'];
    final redirectUri = queryParameters['redirect_uri'];

    final key = Key.fromUtf8(secretKey);
    final iv = IV.fromLength(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encrypt(payload, iv: iv);
    final accessToken = hex.encode(iv.bytes) + hex.encode(encrypted.bytes);

    if (accessToken.isNotEmpty) {
      final redirectTo =
          '$redirectUri#state=$state&access_token=$accessToken&token_type=Bearer';

      window.location.assign(redirectTo);
    }

    return null;
  }
}
