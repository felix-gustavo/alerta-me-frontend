import '../../model/medication_reminder.dart';

abstract interface class IMedicationReminderService {
  Future<MedicationReminder> createOrUpdate(MedicationReminder data);
  Future<List<MedicationReminder>> get();
  Future<String?> delete(String id);
}
