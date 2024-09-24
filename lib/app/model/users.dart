import 'dart:convert';

class Users {
  final String id;
  final String name;
  final String email;
  final String? askUserId;

  Users({
    required this.id,
    required this.name,
    required this.email,
    this.askUserId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'ask_user_id': askUserId,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      askUserId: map['ask_user_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) =>
      Users.fromMap(json.decode(source) as Map<String, dynamic>);
}
