import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../model/authorizations.dart';
import '../../../services/authorization/authorization_service.dart';

part 'load_authorization_store.g.dart';

class LoadAuthorizationStore = AuthorizationStoreBase
    with _$LoadAuthorizationStore;

abstract class AuthorizationStoreBase with Store {
  late final IAuthorizationService _service;

  AuthorizationStoreBase({required IAuthorizationService authorizationService})
      : _service = authorizationService;

  @observable
  Authorizations? authorization;

  @observable
  ObservableFuture<Authorizations?> _authorizationFuture =
      ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _authorizationFuture.status == FutureStatus.pending;

  @action
  Future<void> run() async {
    try {
      errorMessage = null;

      _authorizationFuture = ObservableFuture(_service.getAuthorization());
      authorization = await _authorizationFuture;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  void setAuthorization(Authorizations authorization) {
    this.authorization = authorization;
  }
}
