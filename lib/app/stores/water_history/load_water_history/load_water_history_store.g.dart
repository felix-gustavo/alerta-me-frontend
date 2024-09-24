// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_water_history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoadWaterHistoryStore on LoadWaterHistoryStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'LoadWaterHistoryStoreBase.loading'))
      .value;

  late final _$waterHistoryAtom =
      Atom(name: 'LoadWaterHistoryStoreBase.waterHistory', context: context);

  @override
  List<WaterHistory> get waterHistory {
    _$waterHistoryAtom.reportRead();
    return super.waterHistory;
  }

  @override
  set waterHistory(List<WaterHistory> value) {
    _$waterHistoryAtom.reportWrite(value, super.waterHistory, () {
      super.waterHistory = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'LoadWaterHistoryStoreBase._future', context: context);

  @override
  ObservableFuture<List<WaterHistory>> get _future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  set _future(ObservableFuture<List<WaterHistory>> value) {
    _$_futureAtom.reportWrite(value, super._future, () {
      super._future = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'LoadWaterHistoryStoreBase.errorMessage', context: context);

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
      AsyncAction('LoadWaterHistoryStoreBase.run', context: context);

  @override
  Future<void> run({required DateTime date, bool force = false}) {
    return _$runAsyncAction.run(() => super.run(date: date, force: force));
  }

  @override
  String toString() {
    return '''
waterHistory: ${waterHistory},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
