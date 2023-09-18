import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../model/authorizations.dart';
import '../../../services/authorization/authorization_service.dart';

part 'create_autorization_store.g.dart';

class CreateAuthorizationStore = CreateAuthorizationStoreBase
    with _$CreateAuthorizationStore;

abstract class CreateAuthorizationStoreBase with Store {
  late final IAuthorizationService _service;

  CreateAuthorizationStoreBase({
    required IAuthorizationService authorizationService,
  }) : _service = authorizationService;

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
      _future = ObservableFuture(_service.createAuthorization(email));
      authorization = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }
}
