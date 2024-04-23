import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../exceptions/exceptions_impl.dart';
import '../../../services/users/users_service.dart';
part 'delete_elderly_store.g.dart';

class DeleteElderlyStore = DeleteElderlyStoreBase with _$DeleteElderlyStore;

abstract class DeleteElderlyStoreBase with Store {
  late final IUsersService _service;
  late final FirebaseAuth _auth;

  DeleteElderlyStoreBase({required IUsersService usersService})
      : _service = usersService,
        _auth = FirebaseAuth.instance;

  @observable
  String? elderlyId;

  @observable
  ObservableFuture<String?> _future = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run({required String id}) async {
    try {
      errorMessage = null;

      final accessToken = await _auth.currentUser?.getIdToken();
      if (accessToken == null) throw SessionExpiredException();

      _future = ObservableFuture(
        _service.deleteElderly(id: id, accessToken: accessToken),
      );
      elderlyId = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  void clear() {
    errorMessage = null;
    _future = ObservableFuture.value(null);
    elderlyId = null;
  }
}
