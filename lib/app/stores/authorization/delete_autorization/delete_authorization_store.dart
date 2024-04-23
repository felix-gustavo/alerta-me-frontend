import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../exceptions/exceptions_impl.dart';
import '../../../services/authorization/authorization_service.dart';

part 'delete_authorization_store.g.dart';

class DeleteAuthorizationStore = DeleteAuthorizationStoreBase
    with _$DeleteAuthorizationStore;

abstract class DeleteAuthorizationStoreBase with Store {
  late final IAuthorizationService _service;
  late final FirebaseAuth _auth;

  DeleteAuthorizationStoreBase(
      {required IAuthorizationService authorizationService})
      : _service = authorizationService,
        _auth = FirebaseAuth.instance;

  @observable
  String? authorizationId;

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @observable
  ObservableFuture<String?> _future = ObservableFuture.value(null);

  @action
  Future<void> run() async {
    try {
      errorMessage = null;

      final accessToken = await _auth.currentUser?.getIdToken();
      if (accessToken == null) throw SessionExpiredException();

      _future = ObservableFuture(_service.deleteAuthorization(accessToken));
      authorizationId = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  void clear() {
    errorMessage = null;
    _future = ObservableFuture.value(null);
    authorizationId = null;
  }
}
