// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_medical_reminder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoadMedicalReminderStore on LoadMedicalReminderStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'LoadMedicalReminderStoreBase.loading'))
      .value;

  late final _$medicalRemindersAtom = Atom(
      name: 'LoadMedicalReminderStoreBase.medicalReminders', context: context);

  @override
  List<MedicalReminder> get medicalReminders {
    _$medicalRemindersAtom.reportRead();
    return super.medicalReminders;
  }

  @override
  set medicalReminders(List<MedicalReminder> value) {
    _$medicalRemindersAtom.reportWrite(value, super.medicalReminders, () {
      super.medicalReminders = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'LoadMedicalReminderStoreBase._future', context: context);

  @override
  ObservableFuture<List<MedicalReminder>> get _future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  set _future(ObservableFuture<List<MedicalReminder>> value) {
    _$_futureAtom.reportWrite(value, super._future, () {
      super._future = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'LoadMedicalReminderStoreBase.errorMessage', context: context);

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
      AsyncAction('LoadMedicalReminderStoreBase.run', context: context);

  @override
  Future<void> run({bool isPast = false}) {
    return _$runAsyncAction.run(() => super.run(isPast: isPast));
  }

  late final _$LoadMedicalReminderStoreBaseActionController =
      ActionController(name: 'LoadMedicalReminderStoreBase', context: context);

  @override
  void addOrUpdateMedicalReminder(MedicalReminder mr) {
    final _$actionInfo =
        _$LoadMedicalReminderStoreBaseActionController.startAction(
            name: 'LoadMedicalReminderStoreBase.addOrUpdateMedicalReminder');
    try {
      return super.addOrUpdateMedicalReminder(mr);
    } finally {
      _$LoadMedicalReminderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeMedicalReminder(String id) {
    final _$actionInfo =
        _$LoadMedicalReminderStoreBaseActionController.startAction(
            name: 'LoadMedicalReminderStoreBase.removeMedicalReminder');
    try {
      return super.removeMedicalReminder(id);
    } finally {
      _$LoadMedicalReminderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setMedicalReminders(List<MedicalReminder> medicalReminders) {
    final _$actionInfo = _$LoadMedicalReminderStoreBaseActionController
        .startAction(name: 'LoadMedicalReminderStoreBase.setMedicalReminders');
    try {
      return super.setMedicalReminders(medicalReminders);
    } finally {
      _$LoadMedicalReminderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$LoadMedicalReminderStoreBaseActionController
        .startAction(name: 'LoadMedicalReminderStoreBase.clear');
    try {
      return super.clear();
    } finally {
      _$LoadMedicalReminderStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
medicalReminders: ${medicalReminders},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
