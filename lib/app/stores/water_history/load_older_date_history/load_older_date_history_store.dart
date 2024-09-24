import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../services/water_history/water_history_service.dart';
part 'load_older_date_history_store.g.dart';

class LoadOlderDateHistoryStore = LoadOlderDateHistoryStoreBase
    with _$LoadOlderDateHistoryStore;

abstract class LoadOlderDateHistoryStoreBase with Store {
  late final IWaterHistoryService _service;

  LoadOlderDateHistoryStoreBase({
    required IWaterHistoryService waterHistoryService,
    this.errorMessage,
  }) : _service = waterHistoryService;

  @observable
  DateTime? date;

  @observable
  ObservableFuture _future = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run() async {
    try {
      errorMessage = null;

      _future = ObservableFuture(_service.getOlderDateHistory());
      date = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
