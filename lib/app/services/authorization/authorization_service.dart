import '../../model/authorizations.dart';

abstract interface class IAuthorizationService {
  Future<Authorizations> createAuthorization(String email);
  Future<Authorizations?> getAuthorization();
}
