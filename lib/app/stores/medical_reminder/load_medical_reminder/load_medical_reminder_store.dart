import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../model/medical_reminder.dart';
import '../../../services/medical_reminder/medical_reminder_service.dart';

part 'load_medical_reminder_store.g.dart';

class LoadMedicalReminderStore = LoadMedicalReminderStoreBase
    with _$LoadMedicalReminderStore;

abstract class LoadMedicalReminderStoreBase with Store {
  late final IMedicalReminderService _service;

  LoadMedicalReminderStoreBase({
    required IMedicalReminderService medicalReminderService,
  }) : _service = medicalReminderService;

  @observable
  List<MedicalReminder> medicalReminders = [];

  @observable
  ObservableFuture<List<MedicalReminder>> _future = ObservableFuture.value([]);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run({bool withPast = false}) async {
    try {
      errorMessage = null;

      _future = ObservableFuture(_service.get(withPast: withPast));
      medicalReminders = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  void addOrUpdateMedicalReminder(MedicalReminder mr) {
    final copy = [...medicalReminders];
    final index = medicalReminders.indexWhere((e) => e.id == mr.id);

    if (index != -1) copy.removeAt(index);

    medicalReminders = [...copy, mr];
  }

  @action
  void removeMedicalReminder(String id) {
    final copy = [...medicalReminders];
    final index = medicalReminders.indexWhere((e) => e.id == id);

    if (index != -1) copy.removeAt(index);

    medicalReminders = [...copy];
  }

  @action
  setMedicalReminders(List<MedicalReminder> medicalReminders) {
    if (this.medicalReminders != medicalReminders) {
      this.medicalReminders = medicalReminders;
    }
  }

  @action
  void clear() {
    errorMessage = null;
    _future = ObservableFuture.value([]);
    medicalReminders = [];
  }
}
