import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String accessToken;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? accessToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'access_token': accessToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      accessToken: map['access_token'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, accessToken: $accessToken}';
  }
}
