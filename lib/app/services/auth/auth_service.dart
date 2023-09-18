import '../../model/auth_user.dart';
import '../../model/users.dart';
import 'providers/login_provider.dart';

abstract interface class IAuthService {
  Future<Users?> getAuthUser();

  Future<AuthUser?> signIn(ILoginProvider loginProvider);
  Future<void> signOut();
}
