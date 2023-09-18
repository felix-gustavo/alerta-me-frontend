import '../../model/water_reminder.dart';

abstract interface class IWaterReminderService {
  Future<WaterReminder> createOrUpdate(
    WaterReminder data, {
    required bool update,
  });
  Future<WaterReminder?> get();
}
