import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../exceptions/exceptions_impl.dart';
import '../../../model/authorizations.dart';
import '../../../services/authorization/authorization_service.dart';
import '../../auth/auth_store.dart';

part 'create_autorization_store.g.dart';

class CreateAuthorizationStore = CreateAuthorizationStoreBase
    with _$CreateAuthorizationStore;

abstract class CreateAuthorizationStoreBase with Store {
  late final IAuthorizationService _service;
  late final AuthStore _authStore;

  CreateAuthorizationStoreBase({
    required IAuthorizationService authorizationService,
    required AuthStore authStore,
  })  : _service = authorizationService,
        _authStore = authStore;

  @observable
  Authorizations? authorization;

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @observable
  ObservableFuture<Authorizations?> _future = ObservableFuture.value(null);

  @action
  Future<void> run({required String email}) async {
    try {
      errorMessage = null;

      final accessToken = _authStore.authUser?.accessToken;
      if (accessToken == null) throw SessionExpiredException();

      _future = ObservableFuture(
          _service.createAuthorization(email: email, accessToken: accessToken));
      authorization = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
