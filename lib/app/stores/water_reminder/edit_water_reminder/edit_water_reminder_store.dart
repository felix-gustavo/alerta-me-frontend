import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../model/water_reminder.dart';
import '../../../services/water_reminder/water_reminder_service.dart';

part 'edit_water_reminder_store.g.dart';

class EditWaterReminderStore = EditWaterReminderStoreBase
    with _$EditWaterReminderStore;

abstract class EditWaterReminderStoreBase with Store {
  late final IWaterReminderService _service;

  EditWaterReminderStoreBase({
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
  Future<void> run({
    required int amount,
    required int interval,
    required TimeOfDay start,
    required TimeOfDay end,
    required bool update,
  }) async {
    try {
      final data = WaterReminder(
        amount: amount,
        interval: interval,
        start: start,
        end: end,
      );

      errorMessage = null;

      _future = ObservableFuture(_service.createOrUpdate(data, update: update));
      waterReminder = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
