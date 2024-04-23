enum AuthorizationStatus {
  aprovado,
  aguardando,
  negado;
}

class Authorizations {
  final String id;
  final String elderly;
  final String user;
  final AuthorizationStatus status;

  Authorizations({
    required this.id,
    required this.elderly,
    required this.user,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'elderly': elderly,
      'user': user,
      'status': status.name,
    };
  }

  factory Authorizations.fromMap(Map<String, dynamic> map) {
    return Authorizations(
      id: map['id'] as String,
      elderly: map['elderly'] as String,
      user: map['user'] as String,
      status: AuthorizationStatus.values.byName(map['status'] as String),
    );
  }
}
