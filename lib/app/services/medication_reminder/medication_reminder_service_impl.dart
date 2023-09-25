import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/exceptions_impl.dart';
import '../../model/medication_reminder.dart';

import '../auth/auth_service.dart';
import '../http/http_client.dart';
import 'medication_reminder_service.dart';

class MedicationReminderServiceImpl implements IMedicationReminderService {
  final IHttpClient _httpClient;
  final FirebaseAuth _auth;

  MedicationReminderServiceImpl({
    required IHttpClient httpClient,
    required IAuthService authService,
  })  : _httpClient = httpClient,
        _auth = FirebaseAuth.instance;

  @override
  Future<List<MedicationReminder>> get() async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final response = await _httpClient.get(
      '/medication-reminders',
      token: accessToken,
    );

    if (response.data == null) return [];
    final responseList = (response.data as List);

    return responseList
        .map((medication) => MedicationReminder.fromMap(medication))
        .toList()
      ..sort((m1, m2) => m1.name.compareTo(m2.name));
  }

  @override
  Future<MedicationReminder> createOrUpdate(MedicationReminder data) async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final dataToSave = data.toMap();

    final request = data.id?.isNotEmpty ?? false
        ? _httpClient.put(
            '/medication-reminders/${data.id}',
            token: accessToken,
            data: dataToSave,
          )
        : _httpClient.post(
            '/medication-reminders',
            token: accessToken,
            data: dataToSave,
          );

    final response = await request;

    return MedicationReminder.fromMap(response.data);
  }
}
