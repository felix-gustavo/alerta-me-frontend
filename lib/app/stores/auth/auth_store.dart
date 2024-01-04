import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../exceptions/base_exception.dart';
import '../../model/auth_user.dart';
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
  AuthUser? authUser;

  @computed
  Users? get user => authUser?.user;

  @observable
  String? error;

  @computed
  ValueNotifier<bool> get isAuthenticated =>
      ValueNotifier<bool>(authUser != null);

  @observable
  bool loading = false;

  @action
  Future<void> signIn(LoginProviders loginProvider) async {
    loading = true;
    try {
      authUser = await _authService.signIn(loginProvider.implementation());
    } on IBaseException catch (error) {
      this.error = error.message;
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> initAuthUser() async {
    loading = true;
    try {
      authUser = await _authService.getAuthUser();
    } on IBaseException catch (_) {
      if (authUser != null) authUser = null;
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> signOut() async {
    loading = true;
    if (authUser != null) await _authService.signOut();
    authUser = null;
    error = null;
    loading = false;
  }
}
