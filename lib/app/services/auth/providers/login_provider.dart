import '../../../model/auth_user.dart';
import 'anon_provider_impl.dart';
import 'google_provider_impl.dart';

enum LoginProviders {
  google,
  anon;

  ILoginProvider implementation() {
    switch (this) {
      case google:
        return GoogleProviderImpl.instance;
      case anon:
        return AnonProviderImpl.instance;
    }
  }
}

abstract class ILoginProvider {
  Future<AuthUser?> signIn();
  Future<void> signOut();
}
