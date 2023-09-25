// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_medication_reminder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditMedicationReminderStore on EditMedicationReminderStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'EditMedicationReminderStoreBase.loading'))
      .value;

  late final _$medicationReminderAtom = Atom(
      name: 'EditMedicationReminderStoreBase.medicationReminder',
      context: context);

  @override
  MedicationReminder? get medicationReminder {
    _$medicationReminderAtom.reportRead();
    return super.medicationReminder;
  }

  @override
  set medicationReminder(MedicationReminder? value) {
    _$medicationReminderAtom.reportWrite(value, super.medicationReminder, () {
      super.medicationReminder = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'EditMedicationReminderStoreBase._future', context: context);

  @override
  ObservableFuture<MedicationReminder?> get _future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  set _future(ObservableFuture<MedicationReminder?> value) {
    _$_futureAtom.reportWrite(value, super._future, () {
      super._future = value;
    });
  }

  late final _$errorMessageAtom = Atom(
      name: 'EditMedicationReminderStoreBase.errorMessage', context: context);

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
      AsyncAction('EditMedicationReminderStoreBase.run', context: context);

  @override
  Future<void> run({required MedicationReminder data}) {
    return _$runAsyncAction.run(() => super.run(data: data));
  }

  @override
  String toString() {
    return '''
medicationReminder: ${medicationReminder},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
