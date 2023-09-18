import 'dart:convert';
import 'users.dart';

class AuthUser {
  final Users user;
  final String accessToken;

  AuthUser({
    required this.user,
    required this.accessToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'accessToken': accessToken,
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      user: Users.fromMap(map['user'] as Map<String, dynamic>),
      accessToken: map['accessToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthUser.fromJson(String source) =>
      AuthUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
