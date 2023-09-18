import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../model/water_reminder.dart';
import '../../../services/water_reminder/water_reminder_service.dart';

part 'load_water_reminder_store.g.dart';

class LoadWaterReminderStore = LoadWaterReminderStoreBase
    with _$LoadWaterReminderStore;

abstract class LoadWaterReminderStoreBase with Store {
  late final IWaterReminderService _service;

  LoadWaterReminderStoreBase({
    required IWaterReminderService waterReminderService,
  }) : _service = waterReminderService;

  @observable
  WaterReminder? waterReminder;

  @observable
  ObservableFuture<WaterReminder?> _future = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run() async {
    try {
      errorMessage = null;

      _future = ObservableFuture(_service.get());
      waterReminder = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  void setWaterReminder(WaterReminder waterReminder) {
    this.waterReminder = waterReminder;
  }
}
