import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../services/medication_reminder/medication_reminder_service.dart';

part 'delete_medication_reminder_store.g.dart';

class DeleteMedicationReminderStore = DeleteMedicationReminderStoreBase
    with _$DeleteMedicationReminderStore;

abstract class DeleteMedicationReminderStoreBase with Store {
  late final IMedicationReminderService _service;

  DeleteMedicationReminderStoreBase({
    required IMedicationReminderService medicationReminderService,
  }) : _service = medicationReminderService;

  @observable
  String? medicationId;

  @observable
  ObservableFuture<String?> _future = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run({required String id}) async {
    try {
      errorMessage = null;

      _future = ObservableFuture(_service.delete(id));
      medicationId = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
