import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../services/medical_reminder/medical_reminder_service.dart';

part 'delete_medical_reminder_store.g.dart';

class DeleteMedicalReminderStore = DeleteMedicalReminderStoreBase
    with _$DeleteMedicalReminderStore;

abstract class DeleteMedicalReminderStoreBase with Store {
  late final IMedicalReminderService _service;

  DeleteMedicalReminderStoreBase({
    required IMedicalReminderService medicalReminderService,
  }) : _service = medicalReminderService;

  @observable
  String? medicalId;

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
      medicalId = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
