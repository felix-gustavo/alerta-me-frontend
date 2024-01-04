import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../exceptions/exceptions_impl.dart';
import '../../../model/authorizations.dart';
import '../../../services/authorization/authorization_service.dart';
import '../../auth/auth_store.dart';

part 'authorization_store.g.dart';

class AuthorizationStore = AuthorizationStoreBase with _$AuthorizationStore;

abstract class AuthorizationStoreBase with Store {
  late final IAuthorizationService _service;
  late final AuthStore _authStore;

  AuthorizationStoreBase({
    required IAuthorizationService authorizationService,
    required AuthStore authStore,
  })  : _service = authorizationService,
        _authStore = authStore;

  @observable
  Authorizations? authorization;

  @observable
  ObservableFuture<Authorizations?> _future = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run() async {
    try {
      errorMessage = null;

      final accessToken = _authStore.authUser?.accessToken;
      if (accessToken == null) throw SessionExpiredException();

      _future = ObservableFuture(_service.getAuthorization(accessToken));
      authorization = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  void setAuthorization(Authorizations? authorization) {
    if (this.authorization?.id != authorization?.id) {
      this.authorization = authorization;
    }
  }

  @action
  void clear() {
    errorMessage = null;
    _future = ObservableFuture.value(null);
    authorization = null;
  }
}
