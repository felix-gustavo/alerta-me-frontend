import '../../../model/auth_user.dart';
import 'anon_provider_impl.dart';
import 'google_provider_impl.dart';
import 'skill_provider_impl.dart';

enum LoginProviders {
  google,
  anon,
  skill;

  ILoginProvider implementation() {
    switch (this) {
      case google:
        return GoogleProviderImpl.instance;
      case anon:
        return AnonProviderImpl.instance;
      case skill:
        return SkillProviderImpl.instance;
    }
  }
}

abstract class ILoginProvider {
  Future<AuthUser?> signIn();
}
