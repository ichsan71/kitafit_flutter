import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStorage {
  Future<void> saveToken(String token);
  Future<String?> readToken();
  Future<void> clearToken();
  Future<bool> hasToken();
}

class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'sanctum_access_token';

  SecureTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  @override
  Future<bool> hasToken() async {
    final token = await readToken();
    return token != null && token.isNotEmpty;
  }
}
