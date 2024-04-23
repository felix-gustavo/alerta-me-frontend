import '../../model/user_min.dart';

abstract interface class IAuthService {
  UserMin? getAuthUser();
  Future<void> signIn();
  Future<void> signOut();
}
