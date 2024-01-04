import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../exceptions/exceptions_impl.dart';
import '../../../services/authorization/authorization_service.dart';
import '../../auth/auth_store.dart';

part 'delete_authorization_store.g.dart';

class DeleteAuthorizationStore = DeleteAuthorizationStoreBase
    with _$DeleteAuthorizationStore;

abstract class DeleteAuthorizationStoreBase with Store {
  late final IAuthorizationService _service;
  late final AuthStore _authStore;

  DeleteAuthorizationStoreBase({
    required IAuthorizationService authorizationService,
    required AuthStore authStore,
  })  : _service = authorizationService,
        _authStore = authStore;

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

      final accessToken = _authStore.authUser?.accessToken;
      if (accessToken == null) throw SessionExpiredException();

      _future = ObservableFuture(_service.deleteAuthorization(accessToken));
      authorizationId = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
