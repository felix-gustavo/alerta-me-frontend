// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_medical_reminder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditMedicalReminderStore on EditMedicalReminderStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'EditMedicalReminderStoreBase.loading'))
      .value;

  late final _$medicalReminderAtom = Atom(
      name: 'EditMedicalReminderStoreBase.medicalReminder', context: context);

  @override
  MedicalReminder? get medicalReminder {
    _$medicalReminderAtom.reportRead();
    return super.medicalReminder;
  }

  @override
  set medicalReminder(MedicalReminder? value) {
    _$medicalReminderAtom.reportWrite(value, super.medicalReminder, () {
      super.medicalReminder = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'EditMedicalReminderStoreBase._future', context: context);

  @override
  ObservableFuture<MedicalReminder?> get _future {
    _$_futureAtom.reportRead();
    return super._future;
  }

  @override
  set _future(ObservableFuture<MedicalReminder?> value) {
    _$_futureAtom.reportWrite(value, super._future, () {
      super._future = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: 'EditMedicalReminderStoreBase.errorMessage', context: context);

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
      AsyncAction('EditMedicalReminderStoreBase.run', context: context);

  @override
  Future<void> run({required MedicalReminder data}) {
    return _$runAsyncAction.run(() => super.run(data: data));
  }

  @override
  String toString() {
    return '''
medicalReminder: ${medicalReminder},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
