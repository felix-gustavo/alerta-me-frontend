import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

import '../../../exceptions/base_exception.dart';
import '../../../exceptions/exceptions_impl.dart';
import '../../../model/users.dart';
import '../../../services/users/users_service.dart';
import '../../authorization/autorization/authorization_store.dart';
part 'load_elderly_store.g.dart';

class LoadElderlyStore = LoadElderlyBase with _$LoadElderlyStore;

abstract class LoadElderlyBase with Store {
  late final AuthorizationStore _authorizationStore;
  late final IUsersService _service;
  late final FirebaseAuth _auth;

  LoadElderlyBase({
    required AuthorizationStore authorizationStore,
    required IUsersService service,
  })  : _authorizationStore = authorizationStore,
        _service = service,
        _auth = FirebaseAuth.instance;

  @observable
  Users? elderly;

  ObservableFuture<Users?> _future = ObservableFuture.value(null);

  @observable
  String? errorMessage;

  @computed
  bool get loading => _future.status == FutureStatus.pending;

  @action
  Future<void> run() async {
    try {
      errorMessage = null;

      final elderlyId = _authorizationStore.authorization?.elderly;
      if (elderlyId == null) {
        throw NotFoundException(message: 'Usuário idoso não encontrado');
      }

      final accessToken = await _auth.currentUser?.getIdToken();
      if (accessToken == null) throw SessionExpiredException();

      _future = ObservableFuture(
        _service.getUserById(id: elderlyId, accessToken: accessToken),
      );
      elderly = await _future;
    } on IBaseException catch (e) {
      errorMessage = e.message;
    }
  }

  @action
  void clear() {
    errorMessage = null;
    _future = ObservableFuture.value(null);
    elderly = null;
  }
}
