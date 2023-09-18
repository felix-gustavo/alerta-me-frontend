import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/exceptions_impl.dart';
import '../../model/medical_reminder.dart';

import '../auth/auth_service.dart';
import '../http/http_client.dart';
import 'medical_reminder_service.dart';

class MedicalReminderServiceImpl implements IMedicalReminderService {
  final IHttpClient _httpClient;
  final FirebaseAuth _auth;

  MedicalReminderServiceImpl({
    required IHttpClient httpClient,
    required IAuthService authService,
  })  : _httpClient = httpClient,
        _auth = FirebaseAuth.instance;

  @override
  Future<List<MedicalReminder>> get({required bool withPast}) async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final Map<String, dynamic> queryParameters = {
      'withPast': true,
    };

    final response = await _httpClient.get(
      '/medical-reminders',
      token: accessToken,
      queryParameters: withPast ? queryParameters : null,
    );

    if (response.data == null) return [];
    final responseList = (response.data as List);

    return responseList
        .map((medical) => MedicalReminder.fromMap(medical))
        .toList();
  }

  @override
  Future<MedicalReminder> createOrUpdate(MedicalReminder data) async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final dataToSave = data.toMap();

    final request = data.id?.isNotEmpty ?? false
        ? _httpClient.put(
            '/medical-reminder/${data.id}',
            token: accessToken,
            data: dataToSave,
          )
        : _httpClient.post(
            '/medical-reminder',
            token: accessToken,
            data: dataToSave,
          );

    final response = await request;

    return MedicalReminder.fromMap(response.data);
  }
}
