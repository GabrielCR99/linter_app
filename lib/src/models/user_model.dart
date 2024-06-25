import 'package:flutter/foundation.dart';

@immutable
final class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => switch (json) {
        {
          'id': final int id,
          'name': final String name,
          'email': final String email,
          'role': final String role,
        } =>
          UserModel(id: id, name: name, email: email, role: role),
        _ => throw FormatException('Invalid JSON format for UserModel $json'),
      };
  final int id;
  final String name;
  final String email;
  final String role;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          role == other.role;

  @override
  int get hashCode => Object.hash(id, name, email, role);
}
