class HttpResponseDto {
  final int statusCode;
  final dynamic data;

  HttpResponseDto({
    required this.statusCode,
    required this.data,
  });
}
