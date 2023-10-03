// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_medication_reminder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeleteMedicationReminderStore
    on DeleteMedicationReminderStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'DeleteMedicationReminderStoreBase.loading'))
      .value;

  late final _$medicationIdAtom = Atom(
      name: 'DeleteMedicationReminderStoreBase.medicationId', context: context);

  @override
  String? get medicationId {
    _$medicationIdAtom.reportRead();
    return super.medicationId;
  }

  @override
  set medicationId(String? value) {
    _$medicationIdAtom.reportWrite(value, super.medicationId, () {
      super.medicationId = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'DeleteMedicationReminderStoreBase._future', context: context);

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

  late final _$errorMessageAtom = Atom(
      name: 'DeleteMedicationReminderStoreBase.errorMessage', context: context);

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
      AsyncAction('DeleteMedicationReminderStoreBase.run', context: context);

  @override
  Future<void> run({required String id}) {
    return _$runAsyncAction.run(() => super.run(id: id));
  }

  @override
  String toString() {
    return '''
medicationId: ${medicationId},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
