import 'package:firebase_auth/firebase_auth.dart';

import '../../exceptions/exceptions_impl.dart';
import '../../model/water_history.dart';
import '../../shared/extensions/datetime_extension.dart';
import '../http/http_client.dart';
import 'water_history_service.dart';

class WaterHistoryServiceImpl implements IWaterHistoryService {
  final IHttpClient _httpClient;
  final FirebaseAuth _auth;

  WaterHistoryServiceImpl({required IHttpClient httpClient})
      : _httpClient = httpClient,
        _auth = FirebaseAuth.instance;

  @override
  Future<List<WaterHistory>> getAll(DateTime date) async {
    print('chamou api /water-reminders/history/user');

    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final response = await _httpClient.get(
      '/water-reminders/history/user/${date.toYYYYMMDD}',
      token: accessToken,
    );

    final responseList = (response.data as List);
    if (responseList.isEmpty) return [];

    return responseList.map((e) => WaterHistory.fromMap(e)).toList();
  }

  @override
  Future<DateTime> getOlderDateHistory() async {
    print('chamou api /water-reminders/older-date/history/user');

    final accessToken = await _auth.currentUser?.getIdToken();
    if (accessToken == null) throw SessionExpiredException();

    final response = await _httpClient.get(
      '/water-reminders/older-date/history/user',
      token: accessToken,
    );

    return response.data != null
        ? DateTime.parse(response.data)
        : DateTime.now();
  }
}
