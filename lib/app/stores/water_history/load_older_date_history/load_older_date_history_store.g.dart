// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_older_date_history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoadOlderDateHistoryStore on LoadOlderDateHistoryStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'LoadOlderDateHistoryStoreBase.loading'))
      .value;

  late final _$dateAtom =
      Atom(name: 'LoadOlderDateHistoryStoreBase.date', context: context);

  @override
  DateTime? get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(DateTime? value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'LoadOlderDateHistoryStoreBase._future', context: context);

  @override
  ObservableFuture<dynamic> get _future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  set _future(ObservableFuture<dynamic> value) {
    _$_futureAtom.reportWrite(value, super._future, () {
      super._future = value;
    });
  }

  late final _$errorMessageAtom = Atom(
      name: 'LoadOlderDateHistoryStoreBase.errorMessage', context: context);

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
      AsyncAction('LoadOlderDateHistoryStoreBase.run', context: context);

  @override
  Future<void> run() {
    return _$runAsyncAction.run(() => super.run());
  }

  @override
  String toString() {
    return '''
date: ${date},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
