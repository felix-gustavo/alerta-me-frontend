import '../../model/water_history.dart';

abstract class IWaterHistoryService {
  Future<List<WaterHistory>> getAll(DateTime date);
  Future<DateTime> getOlderDateHistory();
}
