import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/exceptions_impl.dart';
import '../../model/water_reminder.dart';

import '../http/http_client.dart';
import 'water_reminder_service.dart';

class WaterReminderServiceImpl implements IWaterReminderService {
  final IHttpClient _httpClient;
  final FirebaseAuth _auth;

  WaterReminderServiceImpl({required IHttpClient httpClient})
      : _httpClient = httpClient,
        _auth = FirebaseAuth.instance;

  @override
  Future<WaterReminder?> get() async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final response = await _httpClient.get(
      '/water-reminders',
      token: accessToken,
    );

    if (response.data == null) return null;
    return WaterReminder.fromMap(response.data);
  }

  @override
  Future<WaterReminder> createOrUpdate(
    WaterReminder data, {
    required bool update,
  }) async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final request = update
        ? _httpClient.put(
            '/water-reminders',
            token: accessToken,
            data: data.toMap(),
          )
        : _httpClient.post(
            '/water-reminders',
            token: accessToken,
            data: data.toMap(),
          );

    final response = await request;

    return WaterReminder.fromMap(response.data);
  }
}
