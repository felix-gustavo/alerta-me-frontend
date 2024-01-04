// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on AuthStoreBase, Store {
  Computed<Users?>? _$userComputed;

  @override
  Users? get user => (_$userComputed ??=
          Computed<Users?>(() => super.user, name: 'AuthStoreBase.user'))
      .value;
  Computed<ValueNotifier<bool>>? _$isAuthenticatedComputed;

  @override
  ValueNotifier<bool> get isAuthenticated => (_$isAuthenticatedComputed ??=
          Computed<ValueNotifier<bool>>(() => super.isAuthenticated,
              name: 'AuthStoreBase.isAuthenticated'))
      .value;

  late final _$authUserAtom =
      Atom(name: 'AuthStoreBase.authUser', context: context);

  @override
  AuthUser? get authUser {
    _$authUserAtom.reportRead();
    return super.authUser;
  }

  @override
  set authUser(AuthUser? value) {
    _$authUserAtom.reportWrite(value, super.authUser, () {
      super.authUser = value;
    });
  }

  late final _$errorAtom = Atom(name: 'AuthStoreBase.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: 'AuthStoreBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$signInAsyncAction =
      AsyncAction('AuthStoreBase.signIn', context: context);

  @override
  Future<void> signIn(LoginProviders loginProvider) {
    return _$signInAsyncAction.run(() => super.signIn(loginProvider));
  }

  late final _$initAuthUserAsyncAction =
      AsyncAction('AuthStoreBase.initAuthUser', context: context);

  @override
  Future<void> initAuthUser() {
    return _$initAuthUserAsyncAction.run(() => super.initAuthUser());
  }

  late final _$signOutAsyncAction =
      AsyncAction('AuthStoreBase.signOut', context: context);

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  @override
  String toString() {
    return '''
authUser: ${authUser},
error: ${error},
loading: ${loading},
user: ${user},
isAuthenticated: ${isAuthenticated}
    ''';
  }
}
