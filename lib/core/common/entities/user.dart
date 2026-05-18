import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? avatar;
  final String role;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.avatar,
    this.role = 'user',
  });

  bool get isAdmin => role == 'admin';

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatar,
    String? role,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        role: role ?? this.role,
      );

  @override
  List<Object?> get props => [id, email, name, phone, avatar, role];
}
