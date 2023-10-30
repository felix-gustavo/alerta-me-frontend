import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/exceptions_impl.dart';
import '../../model/auth_user.dart';
import '../../model/users.dart';
import '../users/users_service.dart';
import 'auth_service.dart';
import 'providers/login_provider.dart';

class AuthServiceImpl implements IAuthService {
  ILoginProvider? _loginProvider;
  final FirebaseAuth _auth;
  final IUsersService _usersService;

  AuthServiceImpl(IUsersService usersService)
      : _auth = FirebaseAuth.instance,
        _usersService = usersService;

  @override
  Future<Users> getAuthUser() async {
    final currentUser = _auth.currentUser;
    final email = currentUser?.email;
    final token = await currentUser?.getIdToken();

    print('token: $token');

    if (email == null || token == null) throw SessionExpiredException();

    final user = await _usersService.getUserByEmail(email: email, token: token);
    if (user == null) throw SessionExpiredException();

    return user;
  }

  @override
  Future<AuthUser?> signIn(ILoginProvider loginProvider) async {
    _loginProvider = loginProvider;
    return _loginProvider?.signIn();
  }

  @override
  Future<void> signOut() async => _auth.signOut();
}
