import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../exceptions/exceptions_impl.dart';
import '../../../services/users/users_service.dart';
part 'delete_user_store.g.dart';

class DeleteUserStore = DeleteUserStoreBase with _$DeleteUserStore;

abstract class DeleteUserStoreBase with Store {
  late final IUsersService _service;
  late final FirebaseAuth _auth;

  DeleteUserStoreBase({required IUsersService usersService})
      : _service = usersService,
        _auth = FirebaseAuth.instance;

  @observable
  String? userId;

  @observable
  ObservableFuture<String?> _future = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run() async {
    try {
      errorMessage = null;

      final accessToken = await _auth.currentUser?.getIdToken();
      if (accessToken == null) throw SessionExpiredException();

      _future = ObservableFuture(_service.deleteUser(accessToken: accessToken));
      userId = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  clear() {
    errorMessage = null;
    _future = ObservableFuture.value(null);
    userId = null;
  }
}
