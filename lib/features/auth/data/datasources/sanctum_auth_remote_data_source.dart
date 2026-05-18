import 'package:dio/dio.dart';
import 'package:todo_clean_bloc/core/network/api_client.dart';
import 'package:todo_clean_bloc/features/auth/data/models/sanctum_token_model.dart';
import 'package:todo_clean_bloc/features/auth/data/models/user_model.dart';

/// Client untuk endpoint Sanctum-backed (Laravel) di `/api/v1/*`.
///
/// Auth Flow:
///  - Hybrid: Firebase login terlebih dahulu, lalu [exchangeFirebaseToken]
///    untuk mendapat Sanctum bearer token yang dipakai di seluruh API backend.
abstract interface class SanctumAuthRemoteDataSource {
  /// Exchange Firebase ID token → Sanctum bearer token.
  /// Backend: `POST /auth/firebase-exchange` (perlu ditambahkan di backend).
  Future<SanctumTokenModel> exchangeFirebaseToken({
    required String firebaseIdToken,
    String? name,
    String? email,
    String? photo,
    String? phone,
  });

  /// `POST /logout` — Sanctum revoke current access token.
  Future<void> logout();

  /// `GET /profile`
  Future<UserModel> getProfile();

  /// `POST /profile` (multipart) — partial update.
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? password,
    String? passwordConfirmation,
    String? avatarPath,
  });
}

class SanctumAuthRemoteDataSourceImpl implements SanctumAuthRemoteDataSource {
  final ApiClient _client;

  SanctumAuthRemoteDataSourceImpl({required ApiClient client}) : _client = client;

  @override
  Future<SanctumTokenModel> exchangeFirebaseToken({
    required String firebaseIdToken,
    String? name,
    String? email,
    String? photo,
    String? phone,
  }) =>
      _client.post<SanctumTokenModel>(
        '/auth/firebase-exchange',
        body: {
          'firebase_id_token': firebaseIdToken,
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (photo != null) 'photo': photo,
          if (phone != null) 'phone': phone,
        },
        requiresAuth: false,
        parser: (raw) => SanctumTokenModel.fromJson(raw as Map<String, dynamic>),
      );

  @override
  Future<void> logout() => _client.post<dynamic>('/logout');

  @override
  Future<UserModel> getProfile() => _client.get<UserModel>(
    '/profile',
    parser: (raw) => UserModel.fromJson(raw as Map<String, dynamic>),
  );

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? password,
    String? passwordConfirmation,
    String? avatarPath,
  }) async {
    final form = FormData.fromMap({
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (password != null) 'password': password,
      if (passwordConfirmation != null)
        'password_confirmation': passwordConfirmation,
      if (avatarPath != null)
        'avatar': await MultipartFile.fromFile(avatarPath),
    });
    return _client.post<UserModel>(
      '/profile',
      body: form,
      parser: (raw) => UserModel.fromJson(raw as Map<String, dynamic>),
    );
  }
}
