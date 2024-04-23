import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../exceptions/exceptions_impl.dart';
import '../../../model/authorizations.dart';
import '../../../services/authorization/authorization_service.dart';

part 'authorization_store.g.dart';

class AuthorizationStore = AuthorizationStoreBase with _$AuthorizationStore;

abstract class AuthorizationStoreBase with Store {
  late final IAuthorizationService _service;
  late final FirebaseAuth _auth;

  AuthorizationStoreBase({required IAuthorizationService authorizationService})
      : _service = authorizationService,
        _auth = FirebaseAuth.instance;

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

      final accessToken = await _auth.currentUser?.getIdToken();
      print(accessToken);
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
