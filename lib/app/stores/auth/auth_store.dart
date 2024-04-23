import 'package:mobx/mobx.dart';

import '../../exceptions/base_exception.dart';
import '../../model/user_min.dart';
import '../../services/auth/auth_service.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  late final IAuthService _authService;

  AuthStoreBase({required IAuthService authService})
      : _authService = authService;

  @observable
  UserMin? userMin;

  @observable
  String? errorMessage;

  @observable
  bool loading = false;

  @action
  Future<void> signIn() async {
    loading = true;
    try {
      await _authService.signIn();
    } on IBaseException catch (error) {
      errorMessage = error.message;
    } finally {
      loading = false;
    }
  }

  @action
  void initAuthUser() {
    loading = true;
    try {
      userMin ??= _authService.getAuthUser();
    } on IBaseException catch (_) {
      if (userMin != null) userMin = null;
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> signOut() async {
    loading = true;
    if (userMin != null) await _authService.signOut();
    userMin = null;
    errorMessage = null;
    loading = false;
  }
}
