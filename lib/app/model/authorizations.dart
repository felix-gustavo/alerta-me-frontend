import '../shared/extensions/datetime_extension.dart';
import '../shared/extensions/string_extension.dart';

enum AuthorizationStatus {
  aprovado,
  aguardando;
}

class Authorizations {
  final String id;
  final String elderly;
  final String user;
  final AuthorizationStatus status;
  final DateTime datetime;

  Authorizations({
    required this.id,
    required this.elderly,
    required this.user,
    required this.status,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'elderly': elderly,
      'user': user,
      'status': status.name,
      'datetime': datetime.toUtcDateTime,
    };
  }

  factory Authorizations.fromMap(Map<String, dynamic> map) {
    return Authorizations(
      id: map['id'] as String,
      elderly: map['elderly'] as String,
      user: map['user'] as String,
      status: AuthorizationStatus.values.byName(map['status'] as String),
      datetime: (map['datetime'] as String).stringUTCtoDateTime,
    );
  }
}
