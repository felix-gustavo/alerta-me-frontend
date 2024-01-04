import '../../model/authorizations.dart';

abstract interface class IAuthorizationService {
  Future<Authorizations> createAuthorization({
    required String email,
    required String accessToken,
  });
  Future<Authorizations?> getAuthorization(String accessToken);
  Future<String?> deleteAuthorization(String accessToken);
}
