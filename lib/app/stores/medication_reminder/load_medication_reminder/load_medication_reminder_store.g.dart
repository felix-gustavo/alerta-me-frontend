// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_medication_reminder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoadMedicationReminderStore on LoadMedicationReminderStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'LoadMedicationReminderStoreBase.loading'))
      .value;

  late final _$medicationRemindersAtom = Atom(
      name: 'LoadMedicationReminderStoreBase.medicationReminders',
      context: context);

  @override
  List<MedicationReminder> get medicationReminders {
    _$medicationRemindersAtom.reportRead();
    return super.medicationReminders;
  }

  @override
  set medicationReminders(List<MedicationReminder> value) {
    _$medicationRemindersAtom.reportWrite(value, super.medicationReminders, () {
      super.medicationReminders = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'LoadMedicationReminderStoreBase._future', context: context);

  @override
  ObservableFuture<List<MedicationReminder>> get _future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  set _future(ObservableFuture<List<MedicationReminder>> value) {
    _$_futureAtom.reportWrite(value, super._future, () {
      super._future = value;
    });
  }

  late final _$errorMessageAtom = Atom(
      name: 'LoadMedicationReminderStoreBase.errorMessage', context: context);

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
      AsyncAction('LoadMedicationReminderStoreBase.run', context: context);

  @override
  Future<void> run({bool withPast = false}) {
    return _$runAsyncAction.run(() => super.run(withPast: withPast));
  }

  late final _$LoadMedicationReminderStoreBaseActionController =
      ActionController(
          name: 'LoadMedicationReminderStoreBase', context: context);

  @override
  void addOrUpdateMedicationReminder(MedicationReminder mr) {
    final _$actionInfo =
        _$LoadMedicationReminderStoreBaseActionController.startAction(
            name:
                'LoadMedicationReminderStoreBase.addOrUpdateMedicationReminder');
    try {
      return super.addOrUpdateMedicationReminder(mr);
    } finally {
      _$LoadMedicationReminderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
medicationReminders: ${medicationReminders},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
