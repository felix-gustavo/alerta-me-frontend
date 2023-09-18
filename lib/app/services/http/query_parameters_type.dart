class QueryParametersType {
  final int page;
  final String? search;
  final int limit;

  QueryParametersType({
    this.page = 0,
    this.search,
    this.limit = 9,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'search': search,
      'limit': limit,
    };
  }
}
