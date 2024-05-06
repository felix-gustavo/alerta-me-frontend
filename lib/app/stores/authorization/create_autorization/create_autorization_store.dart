import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../exceptions/exceptions_impl.dart';
import '../../../model/authorizations.dart';
import '../../../services/authorization/authorization_service.dart';
part 'create_autorization_store.g.dart';

class CreateAuthorizationStore = CreateAuthorizationStoreBase
    with _$CreateAuthorizationStore;

abstract class CreateAuthorizationStoreBase with Store {
  late final IAuthorizationService _service;
  late final FirebaseAuth _auth;

  CreateAuthorizationStoreBase({
    required IAuthorizationService authorizationService,
  })  : _service = authorizationService,
        _auth = FirebaseAuth.instance;

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

      final accessToken = await _auth.currentUser?.getIdToken();
      if (accessToken == null) throw SessionExpiredException();

      _future = ObservableFuture(
          _service.createAuthorization(email: email, accessToken: accessToken));
      authorization = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  void clear() {
    errorMessage = null;
    _future = ObservableFuture.value(null);
    authorization = null;
  }
}
