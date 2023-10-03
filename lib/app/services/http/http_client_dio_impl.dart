import 'dart:io';

import 'package:dio/dio.dart';

import '../../exceptions/exceptions_impl.dart';
import 'dto/http_response_dto.dart';
import 'http_client.dart';

class HttpClientDioImpl implements IHttpClient {
  late final Dio _dio;

  HttpClientDioImpl._() {
    const backendUrl = String.fromEnvironment('BACKEND_URL');

    _dio = Dio(
      BaseOptions(
        baseUrl: backendUrl,
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      ),
    );

    _addInterceptors();
  }

  static final HttpClientDioImpl _instance = HttpClientDioImpl._();
  static HttpClientDioImpl get instance => _instance;

  @override
  Future<HttpResponseDto> post(
    String url, {
    dynamic data,
    String? token,
  }) async {
    try {
      Options? options;
      if (token != null) {
        options = Options(headers: {'Authorization': 'Bearer $token'});
      }

      final response = await _dio.post(
        url,
        data: data,
        options: options,
      );

      return HttpResponseDto(
        statusCode: response.statusCode ?? 500,
        data: response.data,
      );
    } on DioException catch (e) {
      throw e.error!;
    }
  }

  @override
  Future<HttpResponseDto> put(
    String url, {
    dynamic data,
    String? token,
  }) async {
    try {
      Options? options;
      if (token != null) {
        options = Options(headers: {'Authorization': 'Bearer $token'});
      }

      final response = await _dio.put(
        url,
        data: data,
        options: options,
      );

      return HttpResponseDto(
        statusCode: response.statusCode ?? 500,
        data: response.data,
      );
    } on DioException catch (e) {
      throw e.error!;
    }
  }

  @override
  Future<HttpResponseDto> delete(
    String url, {
    String? token,
  }) async {
    try {
      Options? options;
      if (token != null) {
        options = Options(headers: {'Authorization': 'Bearer $token'});
      }

      final response = await _dio.delete(
        url,
        options: options,
      );

      return HttpResponseDto(
        statusCode: response.statusCode ?? 500,
        data: response.data,
      );
    } on DioException catch (e) {
      throw e.error!;
    }
  }

  @override
  Future<HttpResponseDto> get(
    String url, {
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Options? options;
      if (token != null) {
        options = Options(headers: {'Authorization': 'Bearer $token'});
      }

      final response = await _dio.get(
        url,
        options: options,
        queryParameters: queryParameters,
      );

      return HttpResponseDto(
        statusCode: response.statusCode ?? 500,
        data: response.data,
      );
    } on DioException catch (e) {
      throw e.error!;
    }
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          switch (e.response?.statusCode) {
            case HttpStatus.unprocessableEntity:
              throw UnprocessableEntityException(message: e.response?.data);
            case HttpStatus.badRequest:
              throw BadRequest();
            case HttpStatus.unauthorized:
              throw UnauthorizedException();
            case HttpStatus.forbidden:
              throw ForbiddenResourceException(message: e.response?.data);
            case HttpStatus.notFound:
              throw NotFoundException(message: e.response?.data);
            case 440:
              throw SessionExpiredException();
            default:
              throw InternalServerException();
          }
        },
      ),
    );
  }
}
