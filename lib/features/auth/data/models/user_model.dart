import 'package:todo_clean_bloc/core/common/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.phone,
    super.avatar,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: (map['id'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      phone: map['phone']?.toString(),
      avatar: map['avatar']?.toString(),
      role: (map['role'] ?? 'user').toString(),
    );
  }

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? avatar,
    String? role,
  }) =>
      UserModel(
        id: id ?? this.id,
        email: email ?? this.email,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        role: role ?? this.role,
      );
}
