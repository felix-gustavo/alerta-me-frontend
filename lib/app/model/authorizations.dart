import 'users.dart';

enum AuthorizationStatus {
  aprovado,
  aguardando,
  negado,
}

class Authorizations {
  final String id;
  final Users elderly;
  final Users user;
  final AuthorizationStatus status;

  Authorizations({
    required this.id,
    required this.elderly,
    required this.user,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': elderly.id,
      'elderly': elderly.toMap(),
      'user': user.toMap(),
      'status': status.name,
    };
  }

  factory Authorizations.fromMap(Map<String, dynamic> map) {
    final statusString = map['status'] as String;
    final status =
        AuthorizationStatus.values.firstWhere((e) => e.name == statusString);

    return Authorizations(
      id: map['id'] as String,
      elderly: Users.fromMap(map['elderly'] as Map<String, dynamic>),
      user: Users.fromMap(map['user'] as Map<String, dynamic>),
      status: status,
    );
  }
}
