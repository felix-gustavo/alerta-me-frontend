// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_medical_reminder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeleteMedicalReminderStore on DeleteMedicalReminderStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: 'DeleteMedicalReminderStoreBase.loading'))
      .value;

  late final _$medicalIdAtom =
      Atom(name: 'DeleteMedicalReminderStoreBase.medicalId', context: context);

  @override
  String? get medicalId {
    _$medicalIdAtom.reportRead();
    return super.medicalId;
  }

  @override
  set medicalId(String? value) {
    _$medicalIdAtom.reportWrite(value, super.medicalId, () {
      super.medicalId = value;
    });
  }

  late final _$_futureAtom =
      Atom(name: 'DeleteMedicalReminderStoreBase._future', context: context);

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
      name: 'DeleteMedicalReminderStoreBase.errorMessage', context: context);

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
      AsyncAction('DeleteMedicalReminderStoreBase.run', context: context);

  @override
  Future<void> run({required String id}) {
    return _$runAsyncAction.run(() => super.run(id: id));
  }

  @override
  String toString() {
    return '''
medicalId: ${medicalId},
errorMessage: ${errorMessage},
loading: ${loading}
    ''';
  }
}
