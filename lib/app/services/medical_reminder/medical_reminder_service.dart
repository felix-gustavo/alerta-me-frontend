import '../../model/medical_reminder.dart';

abstract interface class IMedicalReminderService {
  Future<MedicalReminder> createOrUpdate(MedicalReminder data);
  Future<List<MedicalReminder>> get({required bool withPast});
}
