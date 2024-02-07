import 'package:uuid/uuid.dart';

class User {
  final int? id;
  final String username;
  final String email;
  final String password;

  User({
    int? id,
    required this.username,
    required this.email,
    required this.password,
  }) : id = id ?? _generateUniqueId();

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  static int _generateUniqueId() {
    return int.parse(Uuid().v4().split('-').first, radix: 16);
  }
}
