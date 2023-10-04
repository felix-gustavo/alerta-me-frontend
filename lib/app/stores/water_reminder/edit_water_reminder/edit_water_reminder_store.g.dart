// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_water_reminder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditWaterReminderStore on EditWaterReminderStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'EditWaterReminderStoreBase.loading'))
      .value;

  late final _$waterReminderAtom =
      Atom(name: 'EditWaterReminderStoreBase.waterReminder', context: context);

  @override
  WaterReminder? get waterReminder {
    _$waterReminderAtom.reportRead();
    return super.waterReminder;
  }

  @override
  set waterReminder(WaterReminder? value) {
    _$waterReminderAtom.reportWrite(value, super.waterReminder, () {
      super.waterReminder = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'EditWaterReminderStoreBase._future', context: context);

  @override
  ObservableFuture<WaterReminder?> get _future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  set _future(ObservableFuture<WaterReminder?> value) {
    _$_futureAtom.reportWrite(value, super._future, () {
      super._future = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'EditWaterReminderStoreBase.errorMessage', context: context);

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
      AsyncAction('EditWaterReminderStoreBase.run', context: context);

  @override
  Future<void> run(
      {required WaterReminder waterReminder, required bool update}) {
    return _$runAsyncAction
        .run(() => super.run(waterReminder: waterReminder, update: update));
  }

  @override
  String toString() {
    return '''
waterReminder: ${waterReminder},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
