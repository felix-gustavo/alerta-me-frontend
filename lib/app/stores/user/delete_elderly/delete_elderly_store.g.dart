// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_elderly_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeleteElderlyStore on DeleteElderlyStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'DeleteElderlyStoreBase.loading'))
      .value;

  late final _$elderlyIdAtom =
      Atom(name: 'DeleteElderlyStoreBase.elderlyId', context: context);

  @override
  String? get elderlyId {
    _$elderlyIdAtom.reportRead();
    return super.elderlyId;
  }

  @override
  set elderlyId(String? value) {
    _$elderlyIdAtom.reportWrite(value, super.elderlyId, () {
      super.elderlyId = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'DeleteElderlyStoreBase._future', context: context);

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
      Atom(name: 'DeleteElderlyStoreBase.errorMessage', context: context);

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
      AsyncAction('DeleteElderlyStoreBase.run', context: context);

  @override
  Future<void> run({required String id}) {
    return _$runAsyncAction.run(() => super.run(id: id));
  }

  late final _$DeleteElderlyStoreBaseActionController =
      ActionController(name: 'DeleteElderlyStoreBase', context: context);

  @override
  void clear() {
    final _$actionInfo = _$DeleteElderlyStoreBaseActionController.startAction(
        name: 'DeleteElderlyStoreBase.clear');
    try {
      return super.clear();
    } finally {
      _$DeleteElderlyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
elderlyId: ${elderlyId},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
