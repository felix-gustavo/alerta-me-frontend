import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../exceptions/base_exception.dart';
import '../../exceptions/exceptions_impl.dart';
import '../../model/users.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/providers/login_provider.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  late final IAuthService _authService;

  AuthStoreBase({required IAuthService authService})
      : _authService = authService;

  @observable
  Users? user;

  @observable
  String? error;

  @computed
  ValueNotifier<bool> get isAuthenticated => ValueNotifier<bool>(user != null);

  @observable
  bool loading = false;

  @action
  Future<void> signIn(LoginProviders loginProvider) async {
    loading = true;
    try {
      final authUser = await _authService.signIn(
        loginProvider.implementation(),
      );
      user = authUser?.user;
    } on IBaseException catch (error) {
      this.error = error.message;
    } on SessionExpiredException catch (_) {
      await signOut();
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> initAuthUser() async {
    loading = true;
    try {
      user = await _authService.getAuthUser();
    } on IBaseException catch (error) {
      this.error = error.message;
    } on SessionExpiredException catch (_) {
      await signOut();
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> signOut() async {
    loading = true;
    if (user != null) await _authService.signOut();
    user = null;
    error = null;
    loading = false;
  }
}
