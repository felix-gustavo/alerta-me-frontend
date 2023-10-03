import 'dto/http_response_dto.dart';

abstract class IHttpClient {
  Future<HttpResponseDto> post(
    String url, {
    dynamic data,
    String? token,
  });

  Future<HttpResponseDto> put(
    String url, {
    dynamic data,
    String? token,
  });

  Future<HttpResponseDto> delete(
    String url, {
    String? token,
  });

  Future<HttpResponseDto> get(
    String url, {
    String? token,
    Map<String, dynamic>? queryParameters,
  });
}
