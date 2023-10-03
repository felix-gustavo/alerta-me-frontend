import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../model/medication_reminder.dart';
import '../../../services/medication_reminder/medication_reminder_service.dart';

part 'load_medication_reminder_store.g.dart';

class LoadMedicationReminderStore = LoadMedicationReminderStoreBase
    with _$LoadMedicationReminderStore;

abstract class LoadMedicationReminderStoreBase with Store {
  late final IMedicationReminderService _service;

  LoadMedicationReminderStoreBase({
    required IMedicationReminderService medicationReminderService,
  }) : _service = medicationReminderService;

  @observable
  List<MedicationReminder> medicationReminders = [];

  @observable
  ObservableFuture<List<MedicationReminder>> _future =
      ObservableFuture.value([]);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run({bool withPast = false}) async {
    try {
      errorMessage = null;

      _future = ObservableFuture(_service.get());
      medicationReminders = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  void addOrUpdateMedicationReminder(MedicationReminder mr) {
    final copy = [...medicationReminders];
    final index = medicationReminders.indexWhere((e) => e.id == mr.id);

    if (index != -1) copy.removeAt(index);

    medicationReminders = [...copy, mr];
  }

  @action
  void removeMedicationReminder(String id) {
    final copy = [...medicationReminders];
    final index = medicationReminders.indexWhere((e) => e.id == id);

    if (index != -1) copy.removeAt(index);

    medicationReminders = [...copy];
  }
}
