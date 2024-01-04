import '../../model/auth_user.dart';
import 'providers/login_provider.dart';

abstract interface class IAuthService {
  Future<AuthUser> getAuthUser();

  Future<AuthUser?> signIn(ILoginProvider loginProvider);
  Future<void> signOut();
}
