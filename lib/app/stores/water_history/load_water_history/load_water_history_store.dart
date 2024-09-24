import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../exceptions/base_exception.dart';
import '../../../model/water_history.dart';
import '../../../services/water_history/water_history_service.dart';
part 'load_water_history_store.g.dart';

class LoadWaterHistoryStore = LoadWaterHistoryStoreBase
    with _$LoadWaterHistoryStore;

abstract class LoadWaterHistoryStoreBase with Store {
  late final IWaterHistoryService _service;

  LoadWaterHistoryStoreBase({
    required IWaterHistoryService waterHistoryService,
    this.errorMessage,
  }) : _service = waterHistoryService;

  @observable
  List<WaterHistory> waterHistory = [];

  @observable
  ObservableFuture<List<WaterHistory>> _future = ObservableFuture.value([]);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run({
    required DateTime date,
    bool force = false,
  }) async {
    try {
      errorMessage = null;

      final prefs = await SharedPreferences.getInstance();
      const key = String.fromEnvironment('WATER_HISTORY_KEY');
      final waterHistoryString = prefs.getString(key);

      if (waterHistoryString != null) {
        List<dynamic> listMap = jsonDecode(waterHistoryString);
        waterHistory = listMap.map((e) => WaterHistory.fromJson(e)).toList();
      }

      if (waterHistory.isEmpty || force) {
        _future = ObservableFuture(_service.getAll(date));
        waterHistory = await _future;

        final value = waterHistory.isEmpty ? null : jsonEncode(waterHistory);
        await (value != null ? prefs.setString(key, value) : prefs.remove(key));
      }
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
