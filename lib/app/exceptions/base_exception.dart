abstract class IBaseException implements Exception {
  int get statusCode;
  String get message;
}
