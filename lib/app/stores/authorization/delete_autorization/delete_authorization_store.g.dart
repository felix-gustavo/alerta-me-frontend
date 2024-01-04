// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_authorization_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeleteAuthorizationStore on DeleteAuthorizationStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'DeleteAuthorizationStoreBase.loading'))
      .value;

  late final _$authorizationIdAtom = Atom(
      name: 'DeleteAuthorizationStoreBase.authorizationId', context: context);

  @override
  String? get authorizationId {
    _$authorizationIdAtom.reportRead();
    return super.authorizationId;
  }

  @override
  set authorizationId(String? value) {
    _$authorizationIdAtom.reportWrite(value, super.authorizationId, () {
      super.authorizationId = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'DeleteAuthorizationStoreBase.errorMessage', context: context);

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

  late final _$_futureAtom =
      Atom(name: 'DeleteAuthorizationStoreBase._future', context: context);

  @override
  ObservableFuture<String?> get _future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  set _future(ObservableFuture<String?> value) {
    _$_futureAtom.reportWrite(value, super._future, () {
      super._future = value;
    });
  }

  late final _$runAsyncAction =
      AsyncAction('DeleteAuthorizationStoreBase.run', context: context);

  @override
  Future<void> run() {
    return _$runAsyncAction.run(() => super.run());
  }

  @override
  String toString() {
    return '''
authorizationId: ${authorizationId},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
