import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../model/medication_reminder.dart';
import '../../../services/medication_reminder/medication_reminder_service.dart';

part 'edit_medication_reminder_store.g.dart';

class EditMedicationReminderStore = EditMedicationReminderStoreBase
    with _$EditMedicationReminderStore;

abstract class EditMedicationReminderStoreBase with Store {
  late final IMedicationReminderService _service;

  EditMedicationReminderStoreBase({
    required IMedicationReminderService medicationReminderService,
  }) : _service = medicationReminderService;

  @observable
  MedicationReminder? medicationReminder;

  @observable
  ObservableFuture<MedicationReminder?> _future = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run({required MedicationReminder data}) async {
    try {
      errorMessage = null;

      _future = ObservableFuture(_service.createOrUpdate(data));
      medicationReminder = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
