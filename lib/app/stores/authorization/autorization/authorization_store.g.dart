// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorization_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthorizationStore on AuthorizationStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'AuthorizationStoreBase.loading'))
      .value;

  late final _$authorizationAtom =
      Atom(name: 'AuthorizationStoreBase.authorization', context: context);

  @override
  Authorizations? get authorization {
    _$authorizationAtom.reportRead();
    return super.authorization;
  }

  @override
  set authorization(Authorizations? value) {
    _$authorizationAtom.reportWrite(value, super.authorization, () {
      super.authorization = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'AuthorizationStoreBase._future', context: context);

  @override
  ObservableFuture<Authorizations?> get _future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  set _future(ObservableFuture<Authorizations?> value) {
    _$_futureAtom.reportWrite(value, super._future, () {
      super._future = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'AuthorizationStoreBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$runAsyncAction =
      AsyncAction('AuthorizationStoreBase.run', context: context);

  @override
  Future<void> run() {
    return _$runAsyncAction.run(() => super.run());
  }

  late final _$AuthorizationStoreBaseActionController =
      ActionController(name: 'AuthorizationStoreBase', context: context);

  @override
  void setAuthorization(Authorizations? authorization) {
    final _$actionInfo = _$AuthorizationStoreBaseActionController.startAction(
        name: 'AuthorizationStoreBase.setAuthorization');
    try {
      return super.setAuthorization(authorization);
    } finally {
      _$AuthorizationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$AuthorizationStoreBaseActionController.startAction(
        name: 'AuthorizationStoreBase.clear');
    try {
      return super.clear();
    } finally {
      _$AuthorizationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
authorization: ${authorization},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
