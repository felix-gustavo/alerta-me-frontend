import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../model/medical_reminder.dart';
import '../../../services/medical_reminder/medical_reminder_service.dart';

part 'edit_medical_reminder_store.g.dart';

class EditMedicalReminderStore = EditMedicalReminderStoreBase
    with _$EditMedicalReminderStore;

abstract class EditMedicalReminderStoreBase with Store {
  late final IMedicalReminderService _service;

  EditMedicalReminderStoreBase({
    required IMedicalReminderService medicalReminderService,
  }) : _service = medicalReminderService;

  @observable
  MedicalReminder? medicalReminder;

  @observable
  ObservableFuture<MedicalReminder?> _future = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run({required MedicalReminder data}) async {
    try {
      errorMessage = null;

      _future = ObservableFuture(_service.createOrUpdate(data));
      medicalReminder = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
