import 'package:todo_clean_bloc/features/auth/data/models/user_model.dart';

class SanctumTokenModel {
  final String token;
  final UserModel user;

  const SanctumTokenModel({required this.token, required this.user});

  factory SanctumTokenModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    if (user == null) {
      throw const FormatException('Field "user" tidak ditemukan pada response');
    }
    return SanctumTokenModel(
      token: (json['token'] ?? '').toString(),
      user: UserModel.fromJson(user),
    );
  }
}
