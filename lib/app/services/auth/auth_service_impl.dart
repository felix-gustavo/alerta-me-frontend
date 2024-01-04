import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/exceptions_impl.dart';
import '../../model/auth_user.dart';
import '../users/users_service.dart';
import 'auth_service.dart';
import 'providers/login_provider.dart';

class AuthServiceImpl implements IAuthService {
  ILoginProvider? _loginProvider;
  final FirebaseAuth _auth;
  final IUsersService _usersService;

  AuthServiceImpl({required IUsersService usersService})
      : _auth = FirebaseAuth.instance,
        _usersService = usersService;

  @override
  Future<AuthUser> getAuthUser() async {
    final currentUser = _auth.currentUser;
    final accessToken = await currentUser?.getIdToken();

    print('token: $accessToken');

    if (accessToken == null) throw SessionExpiredException();

    final user = await _usersService.getUserByToken(accessToken);
    if (user == null) throw SessionExpiredException();

    return AuthUser(user: user, accessToken: accessToken);
  }

  @override
  Future<AuthUser?> signIn(ILoginProvider loginProvider) async {
    _loginProvider = loginProvider;
    return _loginProvider?.signIn();
  }

  @override
  Future<void> signOut() async => _auth.signOut();
}
