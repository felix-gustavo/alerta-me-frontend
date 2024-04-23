class UserMin {
  final String name;
  final String email;

  UserMin({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
    };
  }

  factory UserMin.fromMap(Map<String, dynamic> map) {
    return UserMin(
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
