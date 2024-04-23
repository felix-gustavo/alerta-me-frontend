// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeleteUserStore on DeleteUserStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'DeleteUserStoreBase.loading'))
      .value;

  late final _$userIdAtom =
      Atom(name: 'DeleteUserStoreBase.userId', context: context);

  @override
  String? get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String? value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'DeleteUserStoreBase._future', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: 'DeleteUserStoreBase.errorMessage', context: context);

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
      AsyncAction('DeleteUserStoreBase.run', context: context);

  @override
  Future<void> run() {
    return _$runAsyncAction.run(() => super.run());
  }

  late final _$DeleteUserStoreBaseActionController =
      ActionController(name: 'DeleteUserStoreBase', context: context);

  @override
  dynamic clear() {
    final _$actionInfo = _$DeleteUserStoreBaseActionController.startAction(
        name: 'DeleteUserStoreBase.clear');
    try {
      return super.clear();
    } finally {
      _$DeleteUserStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userId: ${userId},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
