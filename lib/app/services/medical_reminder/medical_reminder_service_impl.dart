import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/exceptions_impl.dart';
import '../../model/medical_reminder.dart';

import '../http/http_client.dart';
import 'medical_reminder_service.dart';

class MedicalReminderServiceImpl implements IMedicalReminderService {
  final IHttpClient _httpClient;
  final FirebaseAuth _auth;

  MedicalReminderServiceImpl({required IHttpClient httpClient})
      : _httpClient = httpClient,
        _auth = FirebaseAuth.instance;

  @override
  Future<List<MedicalReminder>> get({required bool isPast}) async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final response = await _httpClient.get(
      '/medical-reminders',
      token: accessToken,
      queryParameters: isPast ? {'isPast': true} : null,
    );

    final responseList = (response.data as List);
    if (responseList.isEmpty) return [];

    return responseList
        .map((medical) => MedicalReminder.fromMap(medical))
        .toList();
  }

  @override
  Future<MedicalReminder> createOrUpdate(MedicalReminder data) async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    if (data.dateTime.isBefore(DateTime.now())) {
      throw BadRequest(
        message: 'Data/hora inválida, selecione data e hora no futuro',
      );
    }

    final dataToSave = data.toMap();

    final request = data.id?.isNotEmpty ?? false
        ? _httpClient.put(
            '/medical-reminders/${data.id}',
            token: accessToken,
            data: dataToSave,
          )
        : _httpClient.post(
            '/medical-reminders',
            token: accessToken,
            data: dataToSave,
          );

    final response = await request;

    return MedicalReminder.fromMap(response.data);
  }

  @override
  Future<String?> delete(String id) async {
    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final request = _httpClient.delete(
      '/medical-reminders/$id',
      token: accessToken,
    );

    final httpResponseDto = await request;
    final response = httpResponseDto.statusCode == 204 ? id : null;
    return response;
  }
}
